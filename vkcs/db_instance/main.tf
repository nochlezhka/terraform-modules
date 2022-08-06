resource "vkcs_db_instance" "main" {
  name = var.blank_name

  datastore {
    type    = var.datastore_type
    version = var.datastore_version
  }

  keypair           = var.keypair
  flavor_id         = data.vkcs_compute_flavor.main.id
  availability_zone = var.availability_zone

  # TODO: make a change to TF provider to change it to volume_size
  size        = var.volume_size
  volume_type = var.volume_type

  disk_autoexpand {
    autoexpand    = var.volume_autoexpand_enabled
    max_disk_size = var.volume_max_size
  }

  floating_ip_enabled = var.floating_ip_enabled

  network {
    uuid = var.network_id
  }

  root_enabled  = var.root_enabled
  root_password = var.root_enabled ? var.root_password : null
}
