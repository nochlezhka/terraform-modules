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

  dynamic "backup_schedule" {
    for_each = var.bk_enabled ? [1] : []

    content {
      name           = var.bk_schedule_name
      start_hours    = var.bk_start_hours
      start_minutes  = var.bk_start_minutes
      interval_hours = var.bk_interval_hours
      keep_count     = var.bk_keep_count
    }
  }
}

resource "vkcs_db_backup" "main" {
  name        = "db-backup"
  dbms_id     = vkcs_db_instance.main.id
  description = "tf-backup"
}
