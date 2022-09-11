output "network_id" {
  value = vkcs_networking_network.main.id
}

output "network_name" {
  value = vkcs_networking_network.main.name
}

# TODO: make output "name"="id"
output "subnet_ids" {
  value = vkcs_networking_subnet.main
}
