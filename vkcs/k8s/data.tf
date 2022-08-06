data "vkcs_kubernetes_clustertemplate" "main" {
  version = var.master_version
}

data "vkcs_compute_flavor" "master" {
  name = var.master_flavor
}

data "vkcs_compute_flavor" "nodes" {
  for_each = var.node_pools
  name     = each.value["flavor"]
}