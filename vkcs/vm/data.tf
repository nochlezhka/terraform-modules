data "vkcs_compute_flavor" "main" {
  name = var.vm_flavor
}
data "vkcs_images_image" "compute" {
  name = var.vm_image
}
data "vkcs_networking_network" "current" {
  name = var.vm_network_name
}
