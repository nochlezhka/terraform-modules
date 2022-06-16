resource "mcs_db_instance" "main" {
  name = var.db_instance_name

  keypair = var.db_instance_keypair

  datastore {
    type    = "mysql"
    version = var.datastore_ver
  }

  flavor_id = data.openstack_compute_flavor_v2.main.id

  size        = var.datastore_size
  volume_type = "ceph-ssd"

  network {
    uuid = var.db_instance_net
  }
}
