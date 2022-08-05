output "network_id" {
  value = vkcs_networking_network.main.id
}

output "subnets_ids" {
  value = vkcs_networking_subnet.main
}