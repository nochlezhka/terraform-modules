variable "blank_name" {
  description = "Blank name which will be used for K8S cluster"
  type        = string
}

#
# K8S master
#
variable "master_version" {
  type    = string
  default = "1.21.4"
}
variable "master_flavor" {
  type    = string
  default = "Standard-2-4-40"
}
variable "master_count" {
  default = 1
}

variable "master_keypair_name" {
  type    = string
  default = null
}
variable "master_availability_zones" {
  type    = string
  default = "MS1"
}

#
# network configuration
#
variable "master_network_id" {
  type = string
}
variable "master_subnet_id" {
  type = string
}
variable "loadbalancer_subnet_id" {
  type    = string
  default = null
}
variable "floating_ip_enabled" {
  type    = bool
  default = true
}

#
# Basic cluster configuration
#
variable "dns_domain" {
  type    = string
  default = null
}
variable "pods_network_cidr" {
  type    = string
  default = null
}
variable "api_lb_vip" {
  type    = string
  default = null
}
variable "api_lb_fip" {
  type    = string
  default = null
}
variable "insecure_registries" {
  type    = list(string)
  default = []
}

#
# K8S master features
#
variable "feature_registry_enabled" {
  default = false
}
variable "feature_registry_auth_password" {
  type    = string
  default = null
}

variable "feature_monitoring_enabled" {
  default = false
}
variable "feature_ingress_enabled" {
  default = false
}

#
# K8S nodes
#
variable "node_pools" {
  default = {
    uno = {
      enabled             = false
      autoscaling_enabled = false
      availability_zones  = ["MS1"]

      node_count           = 1
      max_nodes            = 1
      min_nodes            = 1
      max_node_unavailable = 5

      flavor      = "Basic-1-2-20"
      volume_size = 5
      volume_type = "ssd"

      labels = {
        "env" = "test"
      }
      taints = {
        taintkey1 = {
          value  = "taintvalue1"
          effect = "PreferNoSchedule"
        }
      }
    }
  }
}