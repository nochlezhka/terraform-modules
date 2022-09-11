variable "blank_name" {
  description = "Blank name which will be used for network & route name"
  type        = string
}
variable "tags" {
  default = []
}

variable "subnets" {
  description = "List and specification of network's subnets"
  type = object(
    {
      name            = string
      cidr_block      = string
      ip_version      = string
      dns_nameservers = list(any)
      public          = bool
    }
  )
}

variable "vkcs_services_access" {
  description = "Whether VKCS services access is enabled"
  type        = bool
  default     = true
}

variable "router_id" {
  type    = list(any)
  default = null
}
