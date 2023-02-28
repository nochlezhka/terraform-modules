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

variable "seggroups" {
  default = {
    "vms" = {
      ingress_rules = {
        "ssh2internet" = {
          protocol       = "tcp"
          port           = 22
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
        "http2internet" = {
          protocol       = "tcp"
          port           = 8080
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
        "https2internet" = {
          protocol       = "tcp"
          port           = 443
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
        "http2self" = {
          protocol          = "tcp"
          port              = 8080
          predefined_target = "self_security_group"
        }
        "http2balancer" = {
          protocol          = "tcp"
          port              = 8080
          predefined_target = "loadbalancer_healthchecks"
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
    "gw" = {
      ingress_rules = {}
      egress_rules  = {}
    }
  }
}

#
# IAM
#
variable "iam" {
  default = {
    "app01" = {
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
    "app01-data" = {
      enabled           = true
      storage_class     = "STANDARD"
      max_size          = 5368709120
      enable_versioning = false
    }
    "app01-backup" = {
      enabled           = true
      storage_class     = "COLD"
      max_size          = 5368709120
      enable_versioning = false
    }
  }
}

#
# workloads
#
variable "vm_clients" {
  default = {
    "app01" = {
      enabled = true

      enabled_nlb = false
      enabled_alb = true

      extra_labels = {}
      image_family = "container-optimized-image"

      platform_id   = "standard-v3"
      cores         = 2
      memory        = 2
      core_fraction = 100
      preemptible   = true

      log_group = {
        enabled          = true
        retention_period = "72h"
      }

      enable_nat       = true
      generate_ssh_key = true
      ssh_user         = "ubuntu"

      boot_disk_initialize_params = {
        size = 30
        type = "network-hdd"
      }
    }
  }
}

#
# loadbalancer
#
variable "alb_domain" {
  type    = string
  default = null
}

variable "alb_cert_id" {
  type    = string
  default = null
}

#
# MKS options
#
variable "mks_options" {
  default = {
    "app01" = {
      app_version = "rc-0.29.0"

      timezone      = "Etc/GMT-3"
      symfony_debug = 1
      nginx_https   = "on"

      external_db = false

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
}

variable "mks_secrets" {
  default = {
    "app01" = {
      admin_password = "password"
      db_host        = "db"
      db_port        = 3306
      db_name        = "homeless"
      db_user        = "homeless"
      db_password    = "homeless"
    }
  }
}