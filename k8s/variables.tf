variable "k8s-flavor" {
  type    = string
  default = "Standard-2-4-50"
}

variable "k8s_subnet_name" {
  type = string
}

variable "k8s_net_name" {
  type = string
}

variable "k8s_keypair" {
  type = string
}

variable "k8s_cluster_name" {
  type = string
}

variable "insecure_registries" {
  type    = list(string)
  default = []
}

variable "master_count" {
  default = 1
}
