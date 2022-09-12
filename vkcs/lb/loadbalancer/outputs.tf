output "name" {
  value = vkcs_lb_loadbalancer.main.name
}

output "listener_id" {
  value = toset([
    for listener_id in vkcs_lb_listener.main : listener_id.id
  ])
}

output "id" {
  value = vkcs_lb_loadbalancer.main.id
}
