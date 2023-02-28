#!/bin/bash

name="${1}"

#
# Create YC folder
#
yc resource-manager folder create "${name}"
FOLDER_ID=$(yc resource-manager folder get "${name}" --format json | jq -r .'id')

#
# Create service account
#
sa_name="${name}-r-terraform"
yc iam service-account create --name "${sa_name}" --folder-id "${FOLDER_ID}"
sa_id=$(yc iam service-account get --name "${sa_name}" --folder-id "${FOLDER_ID}" --format json | jq -r .'id')

IAM_ACCESS_KEY=$(yc iam access-key create --service-account-name "${sa_name}" --format json --folder-id "${FOLDER_ID}")
IAM_ACCESS_KEY_ID=$(echo "${IAM_ACCESS_KEY}" | jq -r '.access_key.key_id')
IAM_ACCESS_KEY_SECRET=$(echo "${IAM_ACCESS_KEY}" | jq -r '.secret')

#
# Create Terraform state bucket
#
bucket_name="${name}-tfstate"
yc storage bucket create --name "${bucket_name}" --folder-name "${name}"

yc storage bucket update --name "${bucket_name}" \
  --grants "grant-type=grant-type-account,grantee-id=${sa_id},permission=permission-full-control"

cat << EOF
=========
Please, save these credentials, otherwise you will need to run script one more time!

YC_FOLDER_ID: ${FOLDER_ID}
IAM_ACCESS_KEY_ID: ${IAM_ACCESS_KEY_ID}
IAM_ACCESS_KEY_SECRET: ${IAM_ACCESS_KEY_SECRET}
EOF