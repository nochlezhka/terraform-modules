#
# virtual network
#
resource "vkcs_networking_network" "main" {
  name = var.blank_name
  tags = var.tags

  admin_state_up       = true
  vkcs_services_access = var.vkcs_services_access
}

#
# subnets
#
resource "vkcs_networking_subnet" "main" {
  for_each = {for subnet in var.subnets :  subnet.name => subnet}

  name = each.key
  tags = var.tags

  network_id      = vkcs_networking_network.main.id
  cidr            = each.value["cidr_block"]
  ip_version      = each.value["ip_version"]
  dns_nameservers = each.value["dns_nameservers"]
}

#
# router
#
resource "vkcs_networking_router" "main" {
  name = var.blank_name
  tags = var.tags

  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "main" {
  for_each = {for subnet in var.subnets :  subnet.name => subnet}

  router_id = vkcs_networking_router.main.id
  subnet_id = vkcs_networking_subnet.main[each.key].id
}
