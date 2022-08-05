terraform {
  required_version = ">= 1.0.4"
  required_providers {
    mcs = {
      source = "MailRuCloudSolutions/mcs"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

