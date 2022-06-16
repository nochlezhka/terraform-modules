data "openstack_compute_flavor_v2" "main" {
  name = var.db_instance_flavor
}

data "openstack_networking_network_v2" "extnet" {
  name = "ext-net"
}
