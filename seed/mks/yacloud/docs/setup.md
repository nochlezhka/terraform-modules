## Initial setup
1. Login to YC cli
2. Execute `scripts/00_setup.sh ${ENV_NAME}` and save output; This step will create object storage bucket on Yandex Cloud. This bucket will be used for keeping Terraform state.
3. Make the initial deployment via `terraform init`, `terraform apply`. Pay attention, that after the first deployment service won't start due to issues with disk, because disk does not contain filesystem out of box. To fix it, login to VM and execture the following steps:

* sudo fdisk /dev/vdb -> n -> p -> Enter -> Enter -> Enter -> quit
* sudo mkfs.ext4 /dev/vdb

4. Restart VM, service should works as expected

## Regular upgrade
1. Execute `scripts/01_init.sh ${ENV_NAME} ${YC_TOKEN} ${YC_CLOUD_ID} ${YC_FOLDER_ID} ${IAM_ACCESS_KEY_ID} ${IAM_ACCESS_KEY_SECRET}` for getting `versions.tf` file
2. Run `terraform init`, `terraform apply`