#
# lb_member
#
variable "lb_member_name" {
  description = "The blank name"
  type        = string
}

variable "lb_member_address" {
  type = string
}

variable "subnet_id" {
  type = string
}


#
# lb_pool
#
variable "lb_pool_name" {
  description = "The blank name"
  type        = string
}

variable "lb_id" {
  type = string
}

variable "lb_pool_description" {
  type    = string
  default = "A load balancer pool of backends with Round-Robin algorithm to distribute traffic to pool's members"
}

variable "lb_pool_method" {
  type    = string
  default = "ROUND_ROBIN"
}

variable "lb_pool_protocol" {
  type    = string
  default = "HTTP"
}

#
# lb_monitor
#
variable "lb_monitor_name" {
  description = "The blank name"
  default     = null
  type        = string
}

variable "listener_id" {
  type    = string
  default = null
}

variable "lb_protocol_port" {
  type    = number
  default = 80
}

variable "lb_monitor_enabled" {
  type    = bool
  default = false
}
