#
# common
#
variable "blank_name" {
  description = "Blank name which will be used for network & route name"
  type        = string
}
variable "tags" {
  default = []
}

#
# vm configuration
#
variable "vm_image_id" {
  type    = string
  # NOTE: Ubuntu-20.04.1-202008
  default = "d853edd0-27b3-4385-a380-248ac8e40956"
}
variable "vm_size" {
  type    = string
  default = "Basic-1-1-10"
}
variable "vm_network_name" {
  type = string
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
  default = "ssd"
}
variable "ext_volume_availability_zone" {
  type    = string
  default = "MS1"
}
variable "ext_volume_size" {
  type    = number
  default = 1
}
