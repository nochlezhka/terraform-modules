output "secret_name" {
  value = vkcs_keymanager_secret.main.name
}

output "secret_payload" {
  value     = vkcs_keymanager_secret.main.payload
  sensitive = true
}

output "secret_payload_content_type" {
  value = vkcs_keymanager_secret.main.payload_content_type
}

output "secret_type" {
  value = vkcs_keymanager_secret.main.secret_type
}
