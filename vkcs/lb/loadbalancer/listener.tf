resource "vkcs_lb_listener" "main" {
  for_each = var.listeners

  admin_state_up = true
  description    = "ttt"

  loadbalancer_id = vkcs_lb_loadbalancer.main.id
  default_pool_id = each.value["pool_id"]
  protocol        = each.value["protocol"]
  protocol_port   = each.value["protocol_port"]

  allowed_cidrs    = lookup(each.value, "allowed_cidrs", null)
  connection_limit = lookup(each.value, "connection_limit", null)

  # todo: A reference to a Keymanager Secrets container which stores TLS information
  default_tls_container_ref = null
  sni_container_refs        = null

  timeout_client_data    = lookup(each.value, "timeout_client_data", null)
  timeout_member_connect = lookup(each.value, "timeout_member_connect", null)
  timeout_member_data    = lookup(each.value, "timeout_member_data", null)
  timeout_tcp_inspect    = lookup(each.value, "timeout_tcp_inspect", null)

  insert_headers = lookup(each.value, "insert_headers", null)
}
