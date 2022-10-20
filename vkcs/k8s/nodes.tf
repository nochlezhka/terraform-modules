resource "vkcs_kubernetes_node_group" "main" {
  for_each = {
    for k, v in var.node_pools : k => v if v["enabled"]
  }

  cluster_id = vkcs_kubernetes_cluster.main.id

  name = each.key

  autoscaling_enabled = each.value["autoscaling_enabled"]
  availability_zones  = each.value["availability_zones"]
  flavor_id           = data.vkcs_compute_flavor.nodes[each.key].id

  node_count           = each.value["node_count"]
  max_nodes            = each.value["max_nodes"]
  min_nodes            = each.value["min_nodes"]
  max_node_unavailable = each.value["max_node_unavailable"]

  volume_size = each.value["volume_size"]
  volume_type = each.value["volume_type"]

  dynamic "labels" {
    for_each = each.value["labels"]
    content {
      key   = labels.key
      value = labels.value
    }
  }

  dynamic "taints" {
    for_each = each.value["taints"]
    content {
      key    = taints.key
      value  = taints.value["value"]
      effect = taints.value["effect"]
    }
  }
}