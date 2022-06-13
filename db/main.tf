resource "mcs_db_database" "main" {
  name    = var.db_name
  dbms_id = var.db_instance_id
  charset = "utf8"
  collate = "utf8_general_ci"
}
