<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_vkcs"></a> [vkcs](#provider\_vkcs) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_string.ssh_postfix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [vkcs_blockstorage_volume.main](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/blockstorage_volume) | resource |
| [vkcs_compute_floatingip_associate.main](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/compute_floatingip_associate) | resource |
| [vkcs_compute_instance.main](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/compute_instance) | resource |
| [vkcs_compute_keypair.main](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/compute_keypair) | resource |
| [vkcs_compute_volume_attach.main](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/compute_volume_attach) | resource |
| [vkcs_networking_floatingip.fip](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_floatingip) | resource |
| [vkcs_networking_port.main](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_port) | resource |
| [vkcs_compute_flavor.main](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/data-sources/compute_flavor) | data source |
| [vkcs_images_image.compute](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/data-sources/images_image) | data source |
| [vkcs_networking_network.current](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/data-sources/networking_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_fip"></a> [add\_fip](#input\_add\_fip) | n/a | `bool` | `false` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | n/a | `string` | `"MS1"` | no |
| <a name="input_blank_name"></a> [blank\_name](#input\_blank\_name) | Blank name which will be used for network & route name | `string` | n/a | yes |
| <a name="input_block_device_enabled"></a> [block\_device\_enabled](#input\_block\_device\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_ext_volume_enabled"></a> [ext\_volume\_enabled](#input\_ext\_volume\_enabled) | storage | `bool` | `false` | no |
| <a name="input_ext_volume_size"></a> [ext\_volume\_size](#input\_ext\_volume\_size) | n/a | `number` | `5` | no |
| <a name="input_ext_volume_type"></a> [ext\_volume\_type](#input\_ext\_volume\_type) | n/a | `string` | `"ceph-hdd"` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | n/a | `map(any)` | `{}` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | n/a | `list(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_ssh_existing_keypair_name"></a> [ssh\_existing\_keypair\_name](#input\_ssh\_existing\_keypair\_name) | n/a | `string` | `null` | no |
| <a name="input_ssh_generate_keypair"></a> [ssh\_generate\_keypair](#input\_ssh\_generate\_keypair) | ssh key | `bool` | `false` | no |
| <a name="input_ssh_use_existing_keypair"></a> [ssh\_use\_existing\_keypair](#input\_ssh\_use\_existing\_keypair) | n/a | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `list(any)` | `[]` | no |
| <a name="input_vm_disk_delete_on_termination"></a> [vm\_disk\_delete\_on\_termination](#input\_vm\_disk\_delete\_on\_termination) | n/a | `bool` | `true` | no |
| <a name="input_vm_flavor"></a> [vm\_flavor](#input\_vm\_flavor) | n/a | `string` | `"Basic-1-1-10"` | no |
| <a name="input_vm_image"></a> [vm\_image](#input\_vm\_image) | n/a | `string` | `"Ubuntu-22.04-202208"` | no |
| <a name="input_vm_image_id"></a> [vm\_image\_id](#input\_vm\_image\_id) | vm configuration | `string` | `"d853edd0-27b3-4385-a380-248ac8e40956"` | no |
| <a name="input_vm_network_name"></a> [vm\_network\_name](#input\_vm\_network\_name) | network | `string` | n/a | yes |
| <a name="input_vm_subnet_id"></a> [vm\_subnet\_id](#input\_vm\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_vm_volume_size"></a> [vm\_volume\_size](#input\_vm\_volume\_size) | n/a | `number` | `20` | no |
| <a name="input_vm_volume_type"></a> [vm\_volume\_type](#input\_vm\_volume\_type) | n/a | `string` | `"ceph-ssd"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_addr"></a> [addr](#output\_addr) | n/a |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | n/a |
<!-- END_TF_DOCS -->