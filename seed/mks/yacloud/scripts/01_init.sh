#!/bin/bash

ENV_NAME="${1}"
OUTPUT_DIR=${2}
YC_TOKEN="${3}"
YC_CLOUD_ID="${4}"
YC_FOLDER_ID="${5}"

ACCESS_KEY="${6}"
SECRET_KEY="${7}"

YC_REGION="${8:-ru-central1}"
YC_ZONE="${9:-ru-central1-a}"

cat <<EOT > "${OUTPUT_DIR}/versions.tf"
terraform {
  required_version = ">= 1.3"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.85.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "${ENV_NAME}-tfstate"
    region     = "${YC_REGION}"

    key        = "env.tfstate"
    access_key = "${ACCESS_KEY}"
    secret_key = "${SECRET_KEY}"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = "${YC_TOKEN}"
  cloud_id  = "${YC_CLOUD_ID}"
  folder_id = "${YC_FOLDER_ID}"
  zone      = "${YC_ZONE}"
}
EOT

cat <<EOT >> ~/.terraformrc
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOT