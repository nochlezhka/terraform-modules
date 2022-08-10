resource "vkcs_db_database" "main" {
  name    = var.blank_name
  dbms_id = var.dbms_id
  charset = var.charset
  collate = var.collate
}
