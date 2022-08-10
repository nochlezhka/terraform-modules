resource "vkcs_lb_member" "example_http_member" {
  count         = var.node_count
  name          = "example_http_member-${count.index}"
  address       = vkcs_compute_instance.instance.*.access_ip_v4[count.index]
  protocol_port = 80
  weight        = 10
  pool_id       = vkcs_lb_pool.example_http_pool.id
  subnet_id     = vkcs_networking_subnet.example_routed_private_subnet.id

  lifecycle {
    create_before_destroy = true
  }
}
resource "vkcs_lb_pool" "example_http_pool" {
  name        = var.blank_name
  description = "A load balancer pool of backends with Round-Robin algorithm to distribute traffic to pool's members"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  # TODO
  #listener_id = vkcs_lb_listener.example_http_listener.id
}
resource "vkcs_lb_monitor" example_http_monitor {
  name           = "example_http_monitor"
  delay          = 5
  max_retries    = 3
  timeout        = 5
  type           = "HTTP"
  url_path       = "/"
  http_method    = "GET"
  expected_codes = "200"
  pool_id        = vkcs_lb_pool.example_http_pool.id
}
