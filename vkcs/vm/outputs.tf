output "vm_id" {
  value = vkcs_compute_instance.main.id
}

output "addr" {
  value = vkcs_compute_instance.main.access_ip_v4
}
