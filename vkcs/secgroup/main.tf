resource "vkcs_networking_secgroup" "main" {
  name        = var.blank_name
  description = var.description
  tags        = var.tags

  delete_default_rules = var.delete_default_rules
}

resource "vkcs_networking_secgroup_rule" "ingress" {
  for_each = var.ingress_rules

  direction         = "ingress"
  ethertype         = each.value["ethertype"]
  protocol          = each.value["protocol"]
  port_range_min    = each.value["port_range_min"]
  port_range_max    = each.value["port_range_max"]
  remote_ip_prefix  = each.value["remote_ip_prefix"]
  security_group_id = vkcs_networking_secgroup.main.id
}

resource "vkcs_networking_secgroup_rule" "egress" {
  for_each = var.egress_rules

  direction         = "egress"
  ethertype         = each.value["ethertype"]
  protocol          = each.value["protocol"]
  port_range_min    = each.value["port_range_min"]
  port_range_max    = each.value["port_range_max"]
  remote_ip_prefix  = each.value["remote_ip_prefix"]
  security_group_id = vkcs_networking_secgroup.main.id
}