resource "vkcs_lb_listener" "main" {
  for_each = var.listeners

  admin_state_up = true

  loadbalancer_id = vkcs_lb_listener.main.id
  protocol        = each.value["protocol"]
  protocol_port   = each.value["protocol_port"]

  allowed_cidrs    = each.value["allowed_cidrs"]
  connection_limit = each.value["connection_limit"]
  #default_pool_id           = each.value["protocol"]

  # todo: A reference to a Keymanager Secrets container which stores TLS information
  default_tls_container_ref = null
  sni_container_refs        = null

  timeout_client_data    = each.value["timeout_client_data"]
  timeout_member_connect = each.value["timeout_member_connect"]
  timeout_member_data    = each.value["timeout_member_data"]
  timeout_tcp_inspect    = each.value["timeout_tcp_inspect"]

  insert_headers = each.value["insert_headers"]
}