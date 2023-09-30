#
# naming
#
module "naming" {
  source = "git@github.com:nochlezhka/terraform-modules.git//misc/naming/?ref=main"

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

module "security_groups" {
  for_each = local.security_groups

  source  = "terraform-yacloud-modules/security-group/yandex"
  version = "0.5.0"

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
  for k, v in local.buckets : k => v if v["enabled"]
  }

  source  = "terraform-yacloud-modules/kms/yandex"
  version = "0.1.0"

  name   = format("%s-%s", module.naming.common_name, each.key)
  labels = var.labels
}

module "storage_buckets" {
  for_each = {
  for k, v in local.buckets : k => v if v["enabled"]
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
resource "yandex_logging_group" "mks" {
  count = var.mks_logging["enabled"] ? 1 : 0

  name   = format("%s-mks", module.naming.common_name)
  labels = var.labels

  retention_period = var.mks_logging["retention_period"]
}

module "mks_vm" {
  source  = "terraform-yacloud-modules/instance-group/yandex"
  version = "0.8.0"

  # NOTE: we use the one AZ instead of var.azs to reduce cloud price
  zones = ["ru-central1-a"]

  name   = format("%s-mks", module.naming.common_name)
  labels = merge(var.labels, var.mks_vm_options["extra_labels"])

  # NOTE: we use the 1st subnet to reduce traffic price
  network_id         = module.network.vpc_id
  subnet_ids         = [module.network.public_subnets[0].id]
  enable_nat         = var.mks_vm_options["enable_nat"]
  security_group_ids = [
    module.security_groups["mks"].id
  ]

  enable_nlb_integration = var.nlb_enabled
  enable_alb_integration = false

  platform_id   = var.mks_vm_options["platform_id"]
  cores         = var.mks_vm_options["cores"]
  memory        = var.mks_vm_options["memory"]
  core_fraction = var.mks_vm_options["core_fraction"]
  preemptible   = var.mks_vm_options["preemptible"]

  image_family = var.mks_vm_options["image_family"]

  service_account_id = module.iam_accounts["mks"].id

  user_data = templatefile(
    "${path.module}/files/cloud-init.sh.tpl",
    {
      log_group_enabled = var.mks_logging["enabled"],
      log_group_id      = var.mks_logging["enabled"] ? yandex_logging_group.mks[0].id : "",

      trusted_hosts = var.mks_options["trusted_hosts"],
      domain        = var.mks_options["domain"],
      support_email = var.mks_options["support_email"],
      nginx_mode    = var.mks_options["nginx_mode"],

      lockbox_secret_name = module.mks_secrets.name,
      sa_name             = module.iam_accounts["mks"].name,
      s3_data             = lookup(local.buckets, "data") != null ? (local.buckets["data"].enabled ? module.storage_buckets["data"].name : "") : "",
      s3_backup           = lookup(local.buckets, "backup") != null ? (local.buckets["backup"].enabled ? module.storage_buckets["backup"].name : "") : "",

      env_abbr    = var.env_abbr,
      app_version = var.mks_options["app_version"],

      timezone                 = var.mks_options["timezone"],
      symfony_debug            = var.mks_options["symfony_debug"],
      mailer_dsn               = var.mks_options["mailer_dsn"],
      sonata_resetting_address = var.mks_options["sonata_resetting_address"],
      sonata_resetting_sender  = var.mks_options["sonata_resetting_sender"],

      external_db   = var.mks_options["external_db"],
      initial_setup = var.mks_options["initial_setup"],

      logo_path     = var.mks_options["logo_path"],
      big_logo_path = var.mks_options["big_logo_path"],

      org_name_short        = var.mks_options["org_name_short"],
      org_name              = var.mks_options["org_name"],
      org_description       = var.mks_options["org_description"],
      org_description_short = var.mks_options["org_description_short"],
      org_city              = var.mks_options["org_city"],
      org_contacts_full     = var.mks_options["org_contacts_full"],
      dispensary_name       = var.mks_options["dispensary_name"],
      dispensary_address    = var.mks_options["dispensary_address"],
      dispensary_phone      = var.mks_options["dispensary_phone"],
      employment_name       = var.mks_options["employment_name"],
      employment_address    = var.mks_options["employment_address"],
      employment_inspection = var.mks_options["employment_inspection"],
      sanitation_name       = var.mks_options["sanitation_name"],
      sanitation_address    = var.mks_options["sanitation_address"],
      sanitation_time       = var.mks_options["sanitation_time"]
    }
  )

  generate_ssh_key            = var.mks_vm_options["generate_ssh_key"]
  ssh_user                    = var.mks_vm_options["ssh_user"]
  boot_disk_initialize_params = var.mks_vm_options["boot_disk_initialize_params"]
  secondary_disks             = var.mks_vm_options["secondary_disks"]

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
    module.security_groups
  ]
}

#
# Secrets
#
module "mks_secrets" {
  source  = "terraform-yacloud-modules/lockbox/yandex"
  version = "0.2.0"

  name   = format("%s-mks", module.naming.common_name)
  labels = var.labels

  entries = var.mks_vm_options["generate_ssh_key"] ? merge(
    var.mks_secrets,
    {
      "ssh-prv" : module.mks_vm.ssh_key_prv
      "ssh-pub" : module.mks_vm.ssh_key_pub
    }
  ) : var.mks_secrets

  deletion_protection = false
}

#
# loadbalancer
#
module "lb" {
  count = var.nlb_enabled ? 1 : 0

  source  = "terraform-yacloud-modules/nlb/yandex"
  version = "0.6.0"

  name   = format("%s-mks", module.naming.common_name)
  labels = var.labels

  region_id = "ru-central1"
  # NOTE: we use the 1st subnet to reduce traffic price
  subnet_id = module.network.private_subnets[0].id
  type      = "external"

  listeners = [
    {
      name        = "http"
      port        = 80
      target_port = 8080
      is_public   = true
    },
    {
      name        = "https"
      port        = 443
      target_port = 8443
      is_public   = true
    }
  ]

  target_group_ids = [module.mks_vm.target_group_id]

  health_check = {
    name                = "app"
    enabled             = true
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 10
    tcp_options         = {
      port = 8080
    }
  }

  depends_on = [
    module.network,
    module.mks_vm
  ]
}