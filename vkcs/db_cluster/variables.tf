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
  default = "galera_mysql"
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
variable "cluster_size" {
  type    = number
  default = 3
}
variable "flavor" {
  type    = string
  default = "Basic-1-2-20"
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
  type    = bool
  default = false
}
variable "root_password" {
  type    = string
  default = null
}
