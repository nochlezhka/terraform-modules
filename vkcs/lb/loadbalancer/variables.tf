variable "blank_name" {
  description = "The blank name"
  type        = string
}
variable "description" {
  type    = string
  default = null
}
variable "tags" {
  default = []
}

#
# network
#
variable "security_group_ids" {
  type    = list(string)
  default = null
}

variable "vip_network_id" {
  type    = string
  default = null
}
variable "vip_subnet_id" {
  type    = string
  default = null
}
variable "vip_port_id" {
  type    = string
  default = null
}
variable "vip_address" {
  type    = string
  default = null
}

#
# listeners
#
variable "listeners" {
  type    = any
  default = []
}
