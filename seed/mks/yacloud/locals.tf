locals {
  security_groups = {
  for k, v in var.security_groups : k => {

    ingress_rules = {
    for ing_k, ing_v in v["ingress_rules"] : ing_k => {
      protocol            = lookup(ing_v, "protocol", null)
      description         = lookup(ing_v, "description", null)
      labels              = lookup(ing_v, "labels", null)
      port                = lookup(ing_v, "port", null)
      from_port           = lookup(ing_v, "from_port", null)
      to_port             = lookup(ing_v, "to_port", null)
      security_group_name = lookup(ing_v, "security_group_name", null) != null ? format("%s-%s", module.naming.common_name, ing_v["security_group_name"]) : null
      security_group_id   = lookup(ing_v, "security_group_id", null)
      predefined_target   = lookup(ing_v, "predefined_target", null)
      v4_cidr_blocks      = lookup(ing_v, "v4_cidr_blocks", null)
      v6_cidr_blocks      = lookup(ing_v, "v6_cidr_blocks", null)
    }
    }

    egress_rules = {
    for eg_k, eg_v in v["egress_rules"] : eg_k => {
      protocol            = lookup(eg_v, "protocol", null)
      description         = lookup(eg_v, "description", null)
      labels              = lookup(eg_v, "labels", null)
      port                = lookup(eg_v, "port", null)
      from_port           = lookup(eg_v, "from_port", null)
      to_port             = lookup(eg_v, "to_port", null)
      security_group_name = lookup(eg_v, "security_group_name", null) != null ? format("%s-%s", module.naming.common_name, eg_v["security_group_name"]) : null
      security_group_id   = lookup(eg_v, "security_group_id", null)
      predefined_target   = lookup(eg_v, "predefined_target", null)
      v4_cidr_blocks      = lookup(eg_v, "v4_cidr_blocks", null)
      v6_cidr_blocks      = lookup(eg_v, "v6_cidr_blocks", null)
    }
    }
  }
  }

  buckets = {
  for k, v in var.buckets : k => v if v["enabled"]
  }
}