resource "vkcs_db_user" "main" {
  name     = var.name
  password = var.password

  dbms_id = var.dbms_id

  databases = var.databases
}
