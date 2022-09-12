resource "vkcs_networking_floatingip" "fip" {
  count = var.add_fip ? 1 : 0

  pool = "ext-net"
}

resource "vkcs_compute_floatingip_associate" "main" {
  count = var.add_fip ? 1 : 0

  floating_ip = vkcs_networking_floatingip.fip[0].address
  instance_id = vkcs_compute_instance.main.id
}

resource "vkcs_networking_port" "main" {
  name           = var.blank_name
  network_id     = data.vkcs_networking_network.current.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = var.vm_subnet_id
  }
}
