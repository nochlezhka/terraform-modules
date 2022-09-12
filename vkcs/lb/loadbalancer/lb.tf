resource "vkcs_lb_loadbalancer" "main" {
  name        = var.blank_name
  description = var.description
  tags        = var.tags

  admin_state_up = true

  security_group_ids = var.security_group_ids
  vip_network_id     = var.vip_network_id
  vip_subnet_id      = var.vip_subnet_id
  vip_port_id        = var.vip_port_id
  vip_address        = var.vip_address
}

resource "vkcs_networking_floatingip" "main" {
  pool = "ext-net"
  # TODO
  port_id = vkcs_lb_loadbalancer.main.vip_port_id
}
