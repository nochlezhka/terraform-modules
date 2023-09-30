#
# yandex
#
variable "azs" {
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

#
# naming
#
variable "env_abbr" {}
variable "labels" {
  default = {
    data_classification : "internal"
    organization : "nochlezhka"
  }
}

#
# network
#
variable "subnets" {
  default = {
    public  = [["10.1.0.0/24"], ["10.2.0.0/24"], ["10.3.0.0/24"]]
    private = [["10.4.0.0/24"], ["10.5.0.0/24"], ["10.6.0.0/24"]]
  }
}

variable "security_groups" {
  default = {
    mks = {
      ingress_rules = {
        "ssh_to_internet" = {
          protocol       = "tcp"
          port           = 22
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
        "8080_to_self" = {
          protocol          = "tcp"
          port              = 8080
          predefined_target = "self_security_group"
        }
        "8080_to_gw" = {
          protocol       = "tcp"
          port           = 8080
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
        "8443_to_self" = {
          protocol          = "tcp"
          port              = 8443
          predefined_target = "self_security_group"
        }
        "8443_to_gw" = {
          protocol       = "tcp"
          port           = 8443
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
      }
      egress_rules = {
        "all" = {
          protocol       = "tcp"
          from_port      = 0
          to_port        = 65535
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}

#
# IAM
#
variable "iam" {
  default = {
    mks = {
      enabled                  = true
      folder_roles             = ["editor", "lockbox.payloadViewer", "lockbox.viewer"]
      cloud_roles              = ["editor"]
      enable_static_access_key = true
      enable_api_key           = false
      enable_account_key       = false
    }
  }
}

#
# storage buckets
#
variable "buckets" {
  default = {
    data = {
      enabled           = true
      storage_class     = "STANDARD"
      max_size          = 5368709120
      enable_versioning = false
    }
    backup = {
      enabled           = true
      storage_class     = "COLD"
      max_size          = 10737418240
      enable_versioning = false
    }
  }
}


#
# feature flags
#
variable "nlb_enabled" {
  type    = bool
  default = true
}


#
# MKS options
#
variable "mks_logging" {
  default = {
    enabled          = true
    retention_period = "72h"
  }
}

variable "mks_vm_options" {
  default = {
    extra_labels = {}
    image_family = "container-optimized-image"

    platform_id   = "standard-v3"
    cores         = 2
    memory        = 2
    core_fraction = 100
    preemptible   = true

    enable_nat       = true
    generate_ssh_key = true
    ssh_user         = "ubuntu"

    boot_disk_initialize_params = {
      size = 30
      type = "network-hdd"
    }

    secondary_disks = {
      mysql = {
        enabled     = true
        size        = 15
        type        = "network-hdd"
        device_name = "mysql_data"
      }
    }
  }
}

variable "mks_options" {
  default = {
    app_version = "rc-0.34.0"

    trusted_hosts = "^your\\.domain$"
    domain        = "mydomain.com"
    support_email = "support@mydomain.com"
    nginx_mode    = "http"

    timezone      = "Etc/GMT-3"
    symfony_debug = 1

    external_db = false

    logo_path     = ""
    big_logo_path = ""

    org_name              = "test_long"
    org_name_short        = "test"
    org_description       = "org_test_dsc"
    org_description_short = "org_test_dsc_short"
    org_city              = ""
    org_contacts_full     = ""
    dispensary_name       = ""
    dispensary_address    = ""
    dispensary_phone      = ""
    employment_name       = ""
    employment_address    = ""
    employment_inspection = ""
    sanitation_name       = ""
    sanitation_address    = ""
    sanitation_time       = ""
  }
}

variable "mks_secrets" {
  default = {
    admin_password = "password"
    app_secret     = "b47298724d7715b851fbb108dcae9897"
    db_host        = "db"
    db_port        = 3306
    db_name        = "homeless"
    db_user        = "homeless"
    db_password    = "homeless"
  }
}