variable "blank_name" {
  description = "The name of the database"
  type        = string
}
variable "dbms_id" {
  description = "ID of the instance or cluster that database is created for"
  type        = string
}
variable "charset" {
  description = "Type of charset used for the database"
  type        = string
  default     = "utf8"
}
variable "collate" {
  description = "Collate option of the database"
  type        = string
  default     = "utf8_general_ci"
}
