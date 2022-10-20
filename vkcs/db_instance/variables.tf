variable "blank_name" {
  description = "Blank name which will be used for db instance name"
  type        = string
}

variable "availability_zone" {
  type    = string
  default = "MS1"
}

variable "datastore_type" {
  type    = string
  default = "mysql"
}
variable "datastore_version" {
  type    = string
  default = "8.0"
}

variable "keypair" {
  description = " Name of the keypair to be attached to instance"
  type        = string
  default     = null
}

#
# instance sizes
#
variable "flavor" {
  type    = string
  default = "Standard-2-8-50"
}
variable "volume_type" {
  type    = string
  default = "ceph-ssd"
}
variable "volume_size" {
  type    = number
  default = 20
}
variable "volume_autoexpand_enabled" {
  type    = bool
  default = false
}
variable "volume_max_size" {
  type    = number
  default = 30
}

#
# network
#
variable "network_id" {
  type = string
}
variable "floating_ip_enabled" {
  type    = bool
  default = false
}

#
# misc
#
variable "root_enabled" {
  type    = string
  default = null
}
variable "root_password" {
  type    = string
  default = null
}
variable "replica_of" {
  description = "ID of the instance, that current instance is replica of."
  type        = string
  default     = null
}
