resource "vkcs_lb_member" "main" {
  name          = var.lb_member_name
  address       = var.lb_member_address
  protocol_port = var.lb_protocol_port
  weight        = 10
  pool_id       = vkcs_lb_pool.main.id
  subnet_id     = var.subnet_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "vkcs_lb_pool" "main" {
  name            = var.lb_pool_name
  description     = var.lb_pool_description
  protocol        = var.lb_pool_protocol
  lb_method       = var.lb_pool_method
  loadbalancer_id = var.lb_id
}

resource "vkcs_lb_monitor" "main" {
  count = var.lb_monitor_enabled ? 1 : 0

  name        = var.lb_monitor_name
  type        = "TCP"
  delay       = 5
  max_retries = 3
  timeout     = 3
  pool_id     = vkcs_lb_pool.main.id
}
