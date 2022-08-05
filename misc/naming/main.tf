resource "random_string" "main" {
  length  = 60
  special = false
  upper   = false
  number  = true
}

resource "random_string" "first_letter" {
  length  = 1
  special = false
  upper   = false
  number  = false
}

locals {
  random = substr(join("", [random_string.first_letter.result, random_string.main.result]), 0, 4)

  common_name       = format("homeless-%s", var.env_abbr)
  common_name_short = format("hl%s", var.env_abbr)
}