resource "vkcs_kubernetes_cluster" "main" {
  name                = var.blank_name
  cluster_template_id = data.vkcs_kubernetes_clustertemplate.main.id
  master_flavor       = data.vkcs_compute_flavor.master.id

  master_count = var.master_count

  network_id             = var.master_network_id
  subnet_id              = var.master_subnet_id
  loadbalancer_subnet_id = var.loadbalancer_subnet_id
  dns_domain             = var.dns_domain
  pods_network_cidr      = var.pods_network_cidr
  api_lb_vip             = var.api_lb_vip
  api_lb_fip             = var.api_lb_fip

  keypair = var.master_keypair_name

  labels = {
    docker_registry_enabled = var.feature_registry_enabled
    prometheus_monitoring   = var.feature_monitoring_enabled
    ingress_controller      = var.feature_ingress_enabled ? "nginx" : null
  }

  registry_auth_password = var.feature_registry_enabled ? var.feature_registry_auth_password : null

  floating_ip_enabled = var.floating_ip_enabled
  availability_zone   = var.master_availability_zones
  insecure_registries = var.insecure_registries
}
