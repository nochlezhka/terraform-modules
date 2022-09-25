output "cluster_id" {
  value = vkcs_db_cluster.main.id
}

output "flavor" {
  value = data.vkcs_compute_flavor.main
}
