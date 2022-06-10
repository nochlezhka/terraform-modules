resource "openstack_networking_network_v2" "main" {
  name           = var.net_name
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "main" {
  name            = var.subnet_name
  network_id      = openstack_networking_network_v2.main.id
  cidr            = var.cidr
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_router_v2" "main" {
  name                = var.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.extnet.id
}

resource "openstack_networking_router_interface_v2" "main" {
  router_id = openstack_networking_router_v2.main.id
  subnet_id = openstack_networking_subnet_v2.main.id
}
