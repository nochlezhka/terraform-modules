resource "mcs_kubernetes_cluster" "k8s-cluster" {
  name                = var.k8s_cluster_name
  cluster_template_id = data.mcs_kubernetes_clustertemplate.ct.id
  master_flavor       = data.openstack_compute_flavor_v2.main.id
  master_count        = 1

  keypair             = var.k8s_keypair
  network_id          = var.k8s_net_name
  subnet_id           = var.k8s_subnet_name
  floating_ip_enabled = true
  availability_zone   = "MS1"
  insecure_registries = ["1.2.3.4"]
}
