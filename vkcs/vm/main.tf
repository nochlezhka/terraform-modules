#
# virtual machine
#
resource "vkcs_compute_instance" "main" {
  name     = var.blank_name
  tags     = var.tags
  metadata = var.metadata

  image_id  = var.vm_image_id
  flavor_id = data.vkcs_compute_flavor.main.id

  availability_zone = var.availability_zone

  user_data = file("${path.module}/files/cloud_init.cfg")

  key_pair        = var.ssh_generate_keypair ? vkcs_compute_keypair.main[0].name : (var.ssh_use_existing_keypair ? var.ssh_existing_keypair_name : null)
  security_groups = var.security_groups

  stop_before_destroy = true

  dynamic "block_device" {
    for_each = var.block_device_enabled ? ["1"] : []

    content {
      uuid                  = data.vkcs_images_image.compute.id
      source_type           = "image"
      destination_type      = "volume"
      volume_type           = var.vm_volume_type
      volume_size           = var.vm_volume_size
      boot_index            = 0
      delete_on_termination = var.vm_disk_delete_on_termination
    }
  }

  network {
    name = var.vm_network_name
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
  availability_zone = var.availability_zone
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
  count = var.ssh_generate_keypair ? 1 : 0

  name = format("%s-%s", var.blank_name, random_string.ssh_postfix.result)
}
