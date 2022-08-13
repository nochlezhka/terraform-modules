resource "vkcs_keymanager_secret" "main" {
  algorithm                = var.algorithm
  bit_length               = var.bit_length
  mode                     = var.mode
  name                     = var.name
  payload                  = var.payload
  payload_content_type     = var.payload_content_type
  payload_content_encoding = var.payload_content_encoding
  secret_type              = var.secret_type

  metadata = var.metadata
}
