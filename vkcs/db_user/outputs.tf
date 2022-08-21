output "password" {
  value     = vkcs_db_user.main.password
  sensitive = true
}
