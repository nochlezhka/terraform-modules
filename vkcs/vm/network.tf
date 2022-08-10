resource "vkcs_networking_floatingip" "fip" {
  count = var.add_fip ? 1 : 0

  pool = "ext-net"
  tags = var.tags
}

resource "vkcs_compute_floatingip_associate" "main" {
  count = var.add_fip ? 1 : 0

  floating_ip = vkcs_networking_floatingip.fip[0].address
  instance_id = vkcs_compute_instance.main.id
}