#!/bin/bash
set -x

home="/home/ubuntu"
lockbox_secret_name="${lockbox_secret_name}"
domain
certbot_email=""
certbot_domain=""

#
# MKS folders
#
app_root_folder="/opt/homeless/mks"
source_folder="$${app_root_folder}/sources"
deploy_folder="$${app_root_folder}/deploy"
mysql_folder="$${deploy_folder}/storage/mysql_data"
s3_data_folder="$${deploy_folder}/storage/data"
s3_backup_folder="$${deploy_folder}/storage/backup"

#
# Install VM software
#
sudo apt-get update -y
sudo apt-get install -y tree s3fs
export HOME="$${home}"
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
source "$${home}/.bashrc"
"$${home}/yandex-cloud/bin/yc" config profile create default
sudo chown -R ubuntu:ubuntu "$${home}/.config/"

#
# Prepare filesystem
#
sudo mkdir -p "$${app_root_folder}" "$${source_folder}" "$${deploy_folder}" "$${mysql_folder}" "$${s3_data_folder}" "$${s3_backup_folder}"
sudo mkdir -p "$${s3_data_folder}/uploads" "$${s3_data_folder}/certbot" "$${s3_data_folder}/letsencrypt"
sudo chown -R ubuntu:ubuntu "$${app_root_folder}"

#
# Copy MKS sources
#
tag=$(echo ${app_version} | sed 's/-/\//g')
# TODO
tag="feat/add-certbot"
git clone --depth 1 -b "$${tag}" https://github.com/nochlezhka/mks.git "$${source_folder}"
cp "$${source_folder}/deploy/docker-compose.yml" "$${deploy_folder}/docker-compose.yml"

#
# Mount S3 buckets
#
$${home}/yandex-cloud/bin/yc iam key create --service-account-name "${sa_name}"
iam_access_key=$($${home}/yandex-cloud/bin/yc iam access-key create --service-account-name "${sa_name}" --format json)
iam_access_key_id=$(echo "$${iam_access_key}" | jq -r '.access_key.key_id')
iam_access_key_secret=$(echo "$${iam_access_key}" | jq -r '.secret')

s3fs_passwd_path="$${home}/.passwd-s3fs"
echo "$${iam_access_key_id}:$${iam_access_key_secret}" > "$${s3fs_passwd_path}"
chmod 600 "$${s3fs_passwd_path}"

s3fs ${s3_backup} "$${s3_backup_folder}" \
    -o passwd_file="$${s3fs_passwd_path}" \
    -o url=https://storage.yandexcloud.net \
    -o use_path_request_style \
    -o allow_other

s3fs ${s3_data} "$${s3_data_folder}" \
    -o passwd_file="$${s3fs_passwd_path}" \
    -o url=https://storage.yandexcloud.net \
    -o use_path_request_style \
    -o allow_other

if [[ "${s3_mysql}" != "" ]]; then
    s3fs ${s3_mysql} "$${mysql_folder}" \
        -o passwd_file="$${s3fs_passwd_path}" \
        -o url=https://storage.yandexcloud.net \
        -o use_path_request_style \
        -o allow_other
fi

#
# Create MKS configuration file
#
db_name="$($${home}/yandex-cloud/bin/yc lockbox payload get --name $${lockbox_secret_name} --format json | jq -r '.entries[] | select(.key=="db_name").text_value')"
db_user="$($${home}/yandex-cloud/bin/yc lockbox payload get --name $${lockbox_secret_name} --format json | jq -r '.entries[] | select(.key=="db_user").text_value')"
db_password="$($${home}/yandex-cloud/bin/yc lockbox payload get --name $${lockbox_secret_name} --format json | jq -r '.entries[] | select(.key=="db_password").text_value')"

cat <<EOF > $${deploy_folder}/.env
TZ="${timezone}"

SYMFONY_DEBUG="${symfony_debug}"
APP_VER="${app_version}"

LOGO_PATH="${logo_path}"
BIG_LOGO_PATH="${big_logo_path}"

DB_HOST="$($${home}/yandex-cloud/bin/yc lockbox payload get --name $${lockbox_secret_name} --format json | jq -r '.entries[] | select(.key=="db_host").text_value')"
DB_PORT="$($${home}/yandex-cloud/bin/yc lockbox payload get --name $${lockbox_secret_name} --format json | jq -r '.entries[] | select(.key=="db_port").text_value')"
DB_NAME="$${db_name}"
DB_USER="$${db_user}"
DB_PASSWORD="$${db_password}"

MYSQL_DATABASE="$${db_name}"
MYSQL_USER="$${db_user}"
MYSQL_PASSWORD="$${db_password}"
MYSQL_ROOT_PASSWORD="$${db_password}"

ORG_NAME_SHORT="${org_name_short}"
ORG_NAME="${org_name}"
ORG_DESCRIPTION="${org_description}"
ORG_DESCRIPTION_SHORT="${org_description_short}"
ORG_CITY="${org_city}"
ORG_CONTACTS_FULL="${org_contacts_full}"
DISPENSARY_NAME="${dispensary_name}"
DISPENSARY_ADDRESS="${dispensary_address}"
DISPENSARY_PHONE="${dispensary_phone}"
EMPLOYMENT_NAME="${employment_name}"
EMPLOYMENT_ADDRESS="${employment_address}"
EMPLOYMENT_INSPECTION="${employment_inspection}"
SANITATION_NAME="${sanitation_name}"
SANITATION_ADDRESS="${sanitation_address}"
SANITATION_TIME="${sanitation_time}"
EOF

#
# Configure FluentBit log forwarding
#
if [[ "${log_group_enabled}" == "true" ]]; then
    sudo mkdir -p /etc/fluentbit
    cat <<EOF > /etc/fluentbit/fluentbit.conf
[SERVICE]
  Flush         1
  Log_File      /var/log/fluentbit.log
  Log_Level     error
  Daemon        off
  Parsers_File  /fluent-bit/etc/parsers.conf

[FILTER]
  Name parser
  Match app.logs
  Key_Name log
  Parser app_log_parser
  Reserve_Data On

[INPUT]
  Name              forward
  Listen            0.0.0.0
  Port              24224
  Buffer_Chunk_Size 1M
  Buffer_Max_Size   6M

[OUTPUT]
  Name            yc-logging
  Match           *
  group_id        ${log_group_id}
  message_key     log
  level_key       severity
  default_level   INFO
  authorization   instance-service-account
EOF

    cat <<EOF > /etc/fluentbit/parsers.conf
[PARSER]
  Name   app_log_parser
  Format regex
  Regex  ^\[req_id=(?<req_id>[0-9a-fA-F\-]+)\] \[(?<severity>.*)\] (?<code>\d+) (?<text>.*)$
  Types  code:integer
EOF

    cat <<EOF > /etc/docker/daemon.json
{
  "log-driver": "fluentd",
  "log-opts": {
    "fluentd-address": "localhost:24224",
    "tag": "app.logs"
  }
}
EOF
    sudo systemctl restart docker

cat <<EOF >> "$${deploy_folder}/docker-compose.yml"

  fluentbit:
    container_name: fluentbit
    image: cr.yandex/yc/fluent-bit-plugin-yandex:v1.0.3-fluent-bit-1.8.6
    ports:
      - "24224:24224"
      - "24224:24224/udp"
    restart: always
    volumes:
      - /etc/fluentbit/fluentbit.conf:/fluent-bit/etc/fluent-bit.conf
      - /etc/fluentbit/parsers.conf:/fluent-bit/etc/parsers.conf
    logging:
      driver: "local"
EOF
fi


#
# Configure cron jobs
#
cat <<EOF > "$${deploy_folder}/s3_backup.sh"
#!/bin/bash
cp -R "$${s3_data_folder}" "$${s3_backup_folder}/\$(date +%Y%m%d_%H%M%S)"
ls -tr $${s3_backup_folder} | head -n -5 | xargs --no-run-if-empty rm -r
EOF

sudo chmod 755 "$${deploy_folder}/s3_backup.sh"
sudo chown ubuntu:ubuntu "$${deploy_folder}/s3_backup.sh"
echo "0 0 * * 0  $${deploy_folder}/s3_backup.sh" >> /etc/crontab

cat <<EOF > "$${deploy_folder}/certbot_renew.sh"
#!/bin/bash
EXITED_CONTAINERS=\$(docker ps -a | grep Exited | awk '{ print \$1 }')
[ -z "\$${EXITED_CONTAINERS}" ] && echo "No exited containers to clean" || docker rm \$${EXITED_CONTAINERS}
docker-compose -f "$${deploy_folder}/docker-compose.yml" run --rm certbot renew
docker-compose -f "$${deploy_folder}/docker-compose.yml" exec nginx nginx -s reload
EOF

sudo chmod 755 "$${deploy_folder}/certbot_renew.sh"
sudo chown ubuntu:ubuntu "$${deploy_folder}/certbot_renew.sh"
echo "0 0 * * 0  $${deploy_folder}/certbot_renew.sh" >> /etc/crontab

#
# Run MKS
#
cd $${deploy_folder}
#export MKS_VERSION="${app_version}"

export MKS_VERSION="20230311-223152-14b206015538e71939893bf1e1acc0801a7c"
export MKS_DOMAIN="mks.dev.referrs.me"
export MKS_SUPPORT_EMAIL="kvendingoldo@gmail.com"
export NGINX_MODE=https_init

docker-compose up fluentbit -d
sleep 5
docker-compose up nginx -d
docker-compose --profile certbot up -d
sleep 60

export NGINX_MODE=https
if [[ "${external_db}" == true ]]; then
  docker-compose --profile certbot up -d
else
  docker-compose --profile certbot --profile=local up -d
fi

docker exec mks-app ./app/console doctrine:migrations:migrate --no-interaction --env=prod

admin_password="$($${home}/yandex-cloud/bin/yc lockbox payload get --name $${lockbox_secret_name} --format json | jq -r '.entries[] | select(.key=="admin_password").text_value')"
docker exec mks-app ./app/console fos:user:change-password admin "$${admin_password}" --env=prod