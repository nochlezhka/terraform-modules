variable "algorithm" {
  type    = string
  default = null
}

variable "bit_length" {
  type    = number
  default = null
}

variable "mode" {
  type    = string
  default = null
}

variable "name" {
  type    = string
  default = null
}

variable "payload" {
  type    = string
  default = ""
}

variable "payload_content_type" {
  type    = string
  default = "text/plain"
}

variable "secret_type" {
  type    = string
  default = "passphrase"
}

variable "metadata" {
  type    = map(any)
  default = {}
}

variable "payload_content_encoding" {
  type    = string
  default = null
}
