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

variable "delete_default_rules" {
  default = false
}

variable "ingress_rules" {
  type = map(object({
    ethertype        = string
    protocol         = string
    port_range_min   = number
    port_range_max   = number
    remote_ip_prefix = string
  }))
  default = {}
}
variable "egress_rules" {
  type = map(object({
    ethertype        = string
    protocol         = string
    port_range_min   = number
    port_range_max   = number
    remote_ip_prefix = string
  }))
  default = {}
}