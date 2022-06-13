variable "subnet_name" {
  type = string
}

variable "net_name" {
  type = string
}

variable "dns_nameservers" {
  type = list(any)
}

variable "cidr" {
  type = string
}

variable "router_name" {
  type = string
}
