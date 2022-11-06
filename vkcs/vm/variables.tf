#
# common
#
variable "blank_name" {
  description = "Blank name which will be used for network & route name"
  type        = string
}
variable "tags" {
  type    = list(any)
  default = []
}
variable "metadata" {
  type    = map(any)
  default = {}
}

#
# vm configuration
#
variable "vm_image_id" {
  type = string
  # NOTE: Ubuntu-20.04.1-202008
  default = "d853edd0-27b3-4385-a380-248ac8e40956"
}
variable "vm_flavor" {
  type    = string
  default = "Basic-1-1-10"
}
variable "availability_zone" {
  type    = string
  default = "MS1"
}
variable "vm_volume_type" {
  type    = string
  default = "ceph-ssd"
}
variable "vm_volume_size" {
  type    = number
  default = 20
}
variable "vm_disk_delete_on_termination" {
  type    = bool
  default = true
}
variable "block_device_enabled" {
  type    = bool
  default = false
}

#
# network
#
variable "vm_network_name" {
  type = string
}
variable "vm_subnet_id" {
  type = string
}
variable "security_groups" {
  type    = list(string)
  default = ["default"]
}
variable "add_fip" {
  type    = bool
  default = false
}
#
# ssh key
#
variable "ssh_generate_keypair" {
  type    = bool
  default = false
}
variable "ssh_use_existing_keypair" {
  type    = bool
  default = false
}
variable "ssh_existing_keypair_name" {
  type    = string
  default = null
}

#
# storage
#
variable "ext_volume_enabled" {
  type    = bool
  default = false
}
variable "ext_volume_type" {
  type    = string
  default = "ceph-hdd"
}
variable "ext_volume_size" {
  type    = number
  default = 5
}
variable "vm_image" {
  type    = string
  default = "Ubuntu-22.04-202208"
}
