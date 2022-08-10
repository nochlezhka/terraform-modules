#
# virtual machine
#
resource "vkcs_compute_instance" "main" {
  name = var.blank_name
  tags = var.tags

  image_id    = var.vm_image_id
  flavor_name = var.vm_size

  user_data = file("${path.module}/files/cloud_init.cfg")

  key_pair        = var.ssh_generate_keypair ? vkcs_compute_keypair.main.name : (var.ssh_use_existing_keypair ? var.ssh_existing_keypair_name : null )
  # TODO: we may configure it later
  security_groups = ["default"]

  stop_before_destroy = true

  network {
    name = var.vm_network_name
  }

  metadata = {
    this = "that"
  }
}

#
# network
#
#resource "vkcs_compute_interface_attach" "main" {
#  instance_id = vkcs_compute_instance.main.id
#  network_id  = var.vm_network_id
#}

#
# additional volume
#
resource "vkcs_blockstorage_volume" "main" {
  count = var.ext_volume_enabled ? 1 : 0

  name              = var.blank_name
  volume_type       = var.ext_volume_type
  availability_zone = var.ext_volume_availability_zone
  size              = var.ext_volume_size

  metadata = {
    this = "that"
  }
}

resource "vkcs_compute_volume_attach" "main" {
  count = var.ext_volume_enabled ? 1 : 0

  instance_id = vkcs_compute_instance.main.id
  volume_id   = vkcs_blockstorage_volume.main[0].id
}

#
# keypair
#
resource "random_string" "ssh_postfix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}
resource "vkcs_compute_keypair" "main" {
  name = format("%s-%s", var.blank_name, random_string.ssh_postfix.result)
}