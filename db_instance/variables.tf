variable "db_instance_flavor" {
  type    = string
  default = "Basic-1-2-20"
}

variable "db_instance_net" {
  type = string
}

variable "db_instance_name" {
  type = string
}

variable "db_instance_keypair" {
  type = string
}

variable "datastore_ver" {
  type    = string
  default = "8.0"
}

variable "datastore_size" {
  default = 20
}
