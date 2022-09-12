#
# router
#
resource "vkcs_networking_router" "main" {
  name = var.blank_name
  tags = var.tags

  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}
