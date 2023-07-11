#
# naming
#
module "naming" {
  source = "git@github.com:nochlezhka/terraform-modules.git//misc/naming/?ref=rc/0.29.0"

  env_abbr = var.env_abbr
}

#
# networks
#

module "router" {
  source = "git@github.com:nochlezhka/terraform-modules.git///vkcs/router?ref=rc/0.29.0"

  blank_name = format("%s-%s", module.naming.common_name, random_string.vm_postfix.result)
}

module "network" {
  for_each = var.net_subnets

  source = "git@github.com:nochlezhka/terraform-modules.git///vkcs/networking?ref=rc/0.29.0"

  blank_name = format("%s-%s-%s", module.naming.common_name, each.key, random_string.vm_postfix.result)
  subnets    = each.value
  router_id  = module.router.router_id
}

module "seggroups" {
  for_each = var.seggroups

  source = "git@github.com:nochlezhka/terraform-modules.git///vkcs/secgroup?ref=rc/0.29.0"

  blank_name = format("%s-%s-%s", module.naming.common_name, each.key, random_string.vm_postfix.result)
  tags       = var.tags

  ingress_rules = each.value["ingress_rules"]
  egress_rules  = each.value["egress_rules"]
}

#
# Load Balancer
#

module "lb" {
  source = "git@github.com:nochlezhka/terraform-modules.git///vkcs/lb/loadbalancer?ref=rc/0.29.0"

  blank_name = format("%s-%s", module.naming.common_name, "lb")

  vip_network_id = module.network["gateway"].network_id
  vip_subnet_id  = module.network["gateway"].subnet_id

  listeners = {
    https = {
      protocol      = "TCP"
      protocol_port = 443
      pool_id       = module.lb_member["8443"].pool_id
    }
    http = {
      protocol      = "TCP"
      protocol_port = 80
      pool_id       = module.lb_member["8080"].pool_id
    }
  }

  tags = var.tags
}

module "lb_member" {
  for_each = toset(var.mks_vm_options["lb_protocol_port"])
  source   = "git@github.com:nochlezhka/terraform-modules.git///vkcs/lb/member?ref=rc/0.29.0"

  lb_member_name     = format("%s-mks", module.naming.common_name)
  lb_member_address  = module.mks_vm.addr
  lb_monitor_enabled = true

  subnet_id = module.network["vms"].subnet_id

  lb_pool_name     = format("%s-%s", module.naming.common_name, "lb_pool")
  lb_monitor_name  = format("%s-%s", module.naming.common_name, "monitor")
  lb_pool_protocol = "TCP"
  lb_protocol_port = each.value

  lb_id = module.lb.id
}

#
# clients
#
resource "vkcs_compute_keypair" "mks_vm_keypair" {
  count = var.mks_vm_options["ssh_use_existing_keypair"] ? 1 : 0

  name = format("%s-mks-%s", module.naming.common_name, random_string.vm_postfix.result)
}

resource "random_string" "vm_postfix" {
  length  = 2
  special = false
  upper   = false
  numeric = true

  # TODO: Add "keepers" flag

}

module "mks_vm" {
  source = "git@github.com:nochlezhka/terraform-modules.git///vkcs/vm?ref=rc/0.29.0"

  blank_name = format("%s-mks", module.naming.common_name)
  tags       = concat(var.tags, lookup(var.mks_vm_options, "additional_tags", []))

  vm_flavor          = var.mks_vm_options["vm_flavor"]
  ext_volume_enabled = var.mks_vm_options["ext_volume_enabled"]

  ssh_use_existing_keypair  = var.mks_vm_options["ssh_use_existing_keypair"]
  ssh_existing_keypair_name = vkcs_compute_keypair.mks_vm_keypair[0].name

  vm_network_name = module.network["vms"].network_name
  vm_subnet_id    = module.network["vms"].subnet_id
  add_fip         = var.mks_vm_options["add_fip"]
  security_groups = [
    module.seggroups["vms"].name
  ]

  # TODO: Switch to user_data

  depends_on = [
    module.seggroups
  ]
}

module "keymanager_mks_ssh_prv_key" {
  count = var.mks_vm_options["ssh_use_existing_keypair"] ? 1 : 0

  source = "git@github.com:nochlezhka/terraform-modules.git///vkcs/keymanager?ref=rc/0.29.0"

  payload     = vkcs_compute_keypair.mks_vm_keypair[0].private_key
  secret_type = "private"
  name        = format("%s-%s", module.naming.common_name, "private_key")
}

module "keymanager_mks_ssh_pub_key" {
  count = var.mks_vm_options["ssh_use_existing_keypair"] ? 1 : 0

  source = "git@github.com:nochlezhka/terraform-modules.git///vkcs/keymanager?ref=rc/0.29.0"

  payload     = vkcs_compute_keypair.mks_vm_keypair[0].public_key
  secret_type = "public"
  name        = format("%s-%s", module.naming.common_name, "public_key")
}
