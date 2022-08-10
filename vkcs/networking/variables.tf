variable "blank_name" {
  description = "Blank name which will be used for network & route name"
  type        = string
}
variable "tags" {
  default = []
}

variable "subnets" {
  description = "List and specification of network's subnets"
  type        = list(object(
    {
      name            = string
      cidr_block      = string
      ip_version      = string
      dns_nameservers = list(any)
    }
  ))
}

variable "external" {
  description = "The external routing facility of the network"
  type        = bool
  default     = false
}

variable "vkcs_services_access" {
  description = "Whether VKCS services access is enabled"
  type        = bool
  default     = true
}
