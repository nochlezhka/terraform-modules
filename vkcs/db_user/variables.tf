variable "name" {
  type    = string
  default = null
}

variable "password" {
  type = string
}

variable "dbms_id" {
  type = string
}

variable "databases" {
  type = list(any)
}
