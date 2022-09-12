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
  name = var.subnets["name"]

  network_id      = vkcs_networking_network.main.id
  cidr            = var.subnets["cidr_block"]
  ip_version      = var.subnets["ip_version"]
  dns_nameservers = var.subnets["dns_nameservers"]
}

resource "vkcs_networking_router_interface" "main" {
  router_id = var.router_id[0]
  subnet_id = vkcs_networking_subnet.main.id
}
