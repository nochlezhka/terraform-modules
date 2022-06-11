data "openstack_compute_flavor_v2" "main" {
  name = var.k8s-flavor
}

data "mcs_kubernetes_clustertemplate" "ct" {
  version = "1.21.4"
}
