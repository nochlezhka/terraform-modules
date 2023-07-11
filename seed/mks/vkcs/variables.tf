#
# common variables
#
variable "env_abbr" {}
variable "tags" {}

#
# networks
#

variable "net_subnets" {
  default = {
    vms = {
      name            = "vms",
      cidr_block      = "10.0.0.0/24",
      ip_version      = 4,
      dns_nameservers = ["8.8.8.8", "8.8.4.4"],
      public          = false
    },
    gateway = {
      name            = "gateway",
      cidr_block      = "10.0.12.0/24",
      ip_version      = 4,
      dns_nameservers = ["8.8.8.8", "8.8.4.4"],
      public          = true
    }
  }
}


#
# seggroups
#
variable "seggroups" {
  default = {
    "vms" = {
      ingress_rules = {
        "ssh" = {
          ethertype        = "IPv4"
          protocol         = "tcp"
          port_range_min   = 22
          port_range_max   = 22
          remote_ip_prefix = "0.0.0.0/0"
        }
        "http" = {
          ethertype        = "IPv4"
          protocol         = "tcp"
          port_range_min   = 8080
          port_range_max   = 8080
          remote_ip_prefix = "0.0.0.0/0"
        }
        "https" = {
          ethertype        = "IPv4"
          protocol         = "tcp"
          port_range_min   = 8443
          port_range_max   = 8443
          remote_ip_prefix = "0.0.0.0/0"
        }
      }
      egress_rules = {}
    }
    "gw" = {
      ingress_rules = {}
      egress_rules  = {}
    }
  }
}

#
# clients' VMs
#
variable "mks_vm_options" {
  default = {
    add_fip                  = true
    vm_flavor                = "Basic-1-1-10"
    lb_protocol_port         = ["8443", "8080"]
    ext_volume_enabled       = true
    ssh_use_existing_keypair = true
  }
}
variable "vm_clients_generate_ssh_key" {
  default = true
}
