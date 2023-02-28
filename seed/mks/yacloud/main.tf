#
# naming
#
module "naming" {
  source = "git@github.com:nochlezhka/terraform-modules.git//misc/naming/?ref=rc/0.31.0"

  env_abbr = var.env_abbr
}

#
# network
#
module "network" {
  source  = "terraform-yacloud-modules/vpc/yandex"
  version = "0.2.0"

  blank_name = module.naming.common_name
  labels     = var.labels

  azs = var.azs

  public_subnets  = var.subnets["public"]
  private_subnets = var.subnets["private"]
}

module "seggroups" {
  for_each = var.seggroups

  source  = "terraform-yacloud-modules/security-group/yandex"
  version = "0.2.0"

  blank_name = format("%s-%s", module.naming.common_name, each.key)
  labels     = var.labels

  vpc_id = module.network.vpc_id

  ingress_rules = each.value["ingress_rules"]
  egress_rules  = each.value["egress_rules"]

  depends_on = [
    module.network
  ]
}

#
# IAM
#
module "iam_accounts" {
  for_each = {
  for k, v in var.iam : k => v if v["enabled"]
  }

  source  = "terraform-yacloud-modules/iam/yandex//modules/iam-account"
  version = "0.2.0"

  name = format("%s-%s", module.naming.common_name, each.key)

  folder_roles = each.value["folder_roles"]
  cloud_roles  = each.value["cloud_roles"]

  enable_static_access_key = each.value["enable_static_access_key"]
  enable_api_key           = each.value["enable_api_key"]
  enable_account_key       = each.value["enable_account_key"]
}

#
# storage buckets
#
module "kms_bucket_master_key" {
  for_each = {
  for k, v in var.buckets : k => v if v["enabled"]
  }

  source  = "terraform-yacloud-modules/kms/yandex"
  version = "0.1.0"

  name   = format("%s-%s", module.naming.common_name, each.key)
  labels = var.labels
}

module "storage_buckets" {
  for_each = {
  for k, v in var.buckets : k => v if v["enabled"]
  }

  source  = "terraform-yacloud-modules/storage-bucket/yandex"
  version = "0.1.0"

  name = format("%s-%s", module.naming.common_name, each.key)

  storage_class                            = each.value["storage_class"]
  max_size                                 = each.value["max_size"]
  enable_versioning                        = each.value["enable_versioning"]
  enable_server_side_encryption            = true
  server_side_encryption_kms_master_key_id = module.kms_bucket_master_key[each.key].id
}

#
# workloads
#
resource "yandex_logging_group" "vm_clients" {
  for_each = {
  for k, v in var.vm_clients : k => v if v["enabled"] && v["log_group"]["enabled"]
  }

  name   = format("%s-%s", module.naming.common_name, each.key)
  labels = var.labels

  retention_period = each.value["log_group"]["retention_period"]
}

module "vm_clients" {
  for_each = {
  for k, v in var.vm_clients : k => v if v["enabled"]
  }

  source  = "terraform-yacloud-modules/instance-group/yandex"
  version = "0.3.0"

  # NOTE: we use the one AZ instead of var.azs to reduce cloud price
  zones = ["ru-central1-a"]

  name   = format("%s-%s", module.naming.common_name, each.key)
  labels = merge(var.labels, each.value["extra_labels"])

  # NOTE: we use the 1st subnet to reduce traffic price
  network_id         = module.network.vpc_id
  subnet_ids         = [module.network.public_subnets[0].id]
  enable_nat         = each.value["enable_nat"]
  security_group_ids = [
    module.seggroups["vms"].id
  ]

  enable_nlb_integration = false
  enable_alb_integration = true

  platform_id   = each.value["platform_id"]
  cores         = each.value["cores"]
  memory        = each.value["memory"]
  core_fraction = each.value["core_fraction"]
  preemptible   = each.value["preemptible"]

  image_family = each.value["image_family"]

  service_account_id = module.iam_accounts[each.key].id

  user_data = templatefile(
    "${path.module}/files/cloud-init.sh.tpl",
    {
      log_group_enabled = each.value["log_group"]["enabled"],
      log_group_id      = each.value["log_group"]["enabled"] ? yandex_logging_group.vm_clients[each.key].id : "",

      lockbox_secret_name = module.client_secrets[each.key].name,
      sa_name             = module.iam_accounts[each.key].name,
      s3_data             = lookup(var.buckets, format("%s-%s", each.key, "data")) != null ? (var.buckets[format("%s-%s", each.key, "data")].enabled ? module.storage_buckets[format("%s-%s", each.key, "data")].name : "") : "",
      s3_backup           = lookup(var.buckets, format("%s-%s", each.key, "backup")) != null ? (var.buckets[format("%s-%s", each.key, "backup")].enabled ? module.storage_buckets[format("%s-%s", each.key, "backup")].name : "") : "",

      env_abbr    = var.env_abbr,
      app_version = var.mks_options[each.key]["app_version"],

      timezone      = var.mks_options[each.key]["timezone"],
      symfony_debug = var.mks_options[each.key]["symfony_debug"],
      nginx_https   = var.mks_options[each.key]["nginx_https"],
      external_db   = var.mks_options[each.key]["external_db"],

      org_name_short        = var.mks_options[each.key]["org_name_short"],
      org_name              = var.mks_options[each.key]["org_name"],
      org_description       = var.mks_options[each.key]["org_description"],
      org_description_short = var.mks_options[each.key]["org_description_short"],
      org_city              = var.mks_options[each.key]["org_city"],
      org_contacts_full     = var.mks_options[each.key]["org_contacts_full"],
      dispensary_name       = var.mks_options[each.key]["dispensary_name"],
      dispensary_address    = var.mks_options[each.key]["dispensary_address"],
      dispensary_phone      = var.mks_options[each.key]["dispensary_phone"],
      employment_name       = var.mks_options[each.key]["employment_name"],
      employment_address    = var.mks_options[each.key]["employment_address"],
      employment_inspection = var.mks_options[each.key]["employment_inspection"],
      sanitation_name       = var.mks_options[each.key]["sanitation_name"],
      sanitation_address    = var.mks_options[each.key]["sanitation_address"],
      sanitation_time       = var.mks_options[each.key]["sanitation_time"]
    }
  )

  generate_ssh_key            = each.value["generate_ssh_key"]
  ssh_user                    = each.value["ssh_user"]
  boot_disk_initialize_params = each.value["boot_disk_initialize_params"]

  max_checking_health_duration = null
  health_check                 = {
    enabled             = false
    interval            = 15
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    tcp_options         = {
      port = 8080
    }
  }

  depends_on = [
    module.network,
    module.seggroups
  ]
}

#
# Secrets
#
module "vm_ssh_keys" {
  for_each = {
  for k, v in var.vm_clients : k => v if v["enabled"] && v["generate_ssh_key"]
  }

  source  = "terraform-yacloud-modules/lockbox/yandex"
  version = "0.2.0"

  name   = format("%s-%s-ssh", module.naming.common_name, each.key)
  labels = var.labels

  entries = {
    "ssh-prv" : module.vm_clients[each.key].ssh_key_prv
    "ssh-pub" : module.vm_clients[each.key].ssh_key_pub
  }

  deletion_protection = false
}

module "client_secrets" {
  for_each = {
  for k, v in var.mks_secrets : k => v
  }

  source  = "terraform-yacloud-modules/lockbox/yandex"
  version = "0.2.0"

  name   = format("%s-%s-mks", module.naming.common_name, each.key)
  labels = var.labels

  entries = each.value

  deletion_protection = false
}

#
# loadbalancer
#
module "vm_clients_nlb" {
  for_each = {
  for k, v in var.vm_clients : k => v if v["enabled_nlb"]
  }

  source  = "terraform-yacloud-modules/nlb/yandex"
  version = "0.2.0"

  name   = format("%s-%s", module.naming.common_name, each.key)
  labels = var.labels

  region_id = "ru-central1"
  # NOTE: we use the 1st subnet to reduce traffic price
  subnet_id = module.network.private_subnets[0].id
  type      = "external"

  listeners = [
    {
      name                  = "app"
      port                  = 8080
      target_port           = 8080
      external_address_spec = {
        allocate_pip = true
        pip_zone_id  = module.network.public_subnets[0].zone
      }
    }
  ]

  target_group_ids = [module.vm_clients[each.key].target_group_id]

  health_check = {
    name                = "app"
    enabled             = true
    interval            = 15
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    tcp_options         = {
      port = 8080
    }
  }

  depends_on = [
    module.network,
    module.vm_clients
  ]
}

module "vm_clients_alb" {
  for_each = {
  for k, v in var.vm_clients : k => v if v["enabled_alb"]
  }

  source  = "terraform-yacloud-modules/alb/yandex"
  version = "0.1.0"

  name   = format("%s-%s", module.naming.common_name, each.key)
  labels = var.labels

  region_id = "ru-central1"

  network_id         = module.network.vpc_id
  security_group_ids = [
    module.seggroups["vms"].id
  ]

  subnets = [
    {
      zone_id         = module.network.public_subnets[0].zone
      id              = module.network.public_subnets[0].id
      disable_traffic = false
    }
  ]

  listeners = {
    https2 = {
      address = "ipv4pub"
      zone_id = "ru-central1-a"
      ports   = ["443"]
      type    = "http2"
      tls     = true
      cert    = {
        type      = "existing"
        ids       = [var.alb_cert_id]
        domain    = var.alb_domain
      }
      backend = {
        name             = "app"
        port             = 8080
        weight           = 100
        http2            = true
        target_group_ids = [
          module.vm_clients[each.key].target_group_id
        ]
        health_check = {
          timeout                 = "30s"
          interval                = "60s"
          interval_jitter_percent = 0
          healthy_threshold       = 1
          unhealthy_threshold     = 1
          healthcheck_port        = 8080
          http                    = {
            path = "/"
          }
        }
      }
    }

  }

  depends_on = [
    module.network,
    module.vm_clients
  ]
}