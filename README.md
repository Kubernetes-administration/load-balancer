## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.53, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.27.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_service.backend_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_firewall.load_balancer_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_forwarding_rule.global_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_health_check.health_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_instance_group.instance_group](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group) | resource |
| [google_compute_target_http_proxy.target_http_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_url_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| [google_compute_instance.compute_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | value | `list(any)` | n/a | yes |
| <a name="input_balancing_mode"></a> [balancing\_mode](#input\_balancing\_mode) | value | `string` | n/a | yes |
| <a name="input_compute_instance"></a> [compute\_instance](#input\_compute\_instance) | Exiting instance | `string` | n/a | yes |
| <a name="input_disable_health_check"></a> [disable\_health\_check](#input\_disable\_health\_check) | Disables the health check on the target pool. | `bool` | n/a | yes |
| <a name="input_enable_cdn"></a> [enable\_cdn](#input\_enable\_cdn) | value | `bool` | n/a | yes |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check to determine whether instances are responsive and able to do work | <pre>object({<br>    check_interval_sec  = number<br>    healthy_threshold   = number<br>    timeout_sec         = number<br>    unhealthy_threshold = number<br>    port                = number<br>    request_path        = string<br>    host                = string<br>  })</pre> | <pre>{<br>  "check_interval_sec": null,<br>  "healthy_threshold": null,<br>  "host": null,<br>  "port": null,<br>  "request_path": null,<br>  "timeout_sec": null,<br>  "unhealthy_threshold": null<br>}</pre> | no |
| <a name="input_ip_protocol"></a> [ip\_protocol](#input\_ip\_protocol) | value | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to attach to resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_load_balancing_scheme"></a> [load\_balancing\_scheme](#input\_load\_balancing\_scheme) | value | `string` | n/a | yes |
| <a name="input_max_rate_per_instance"></a> [max\_rate\_per\_instance](#input\_max\_rate\_per\_instance) | value | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | value | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project to deploy to, if not set the default provider project is used. | `string` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | value | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region used for GCP resources. | `string` | n/a | yes |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | TCP port your service is listening on. | `number` | n/a | yes |
| <a name="input_target_tags"></a> [target\_tags](#input\_target\_tags) | value | `list(string)` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_service"></a> [backend\_service](#output\_backend\_service) | The `self_link` to the backend service resource created. |
| <a name="output_external_ip"></a> [external\_ip](#output\_external\_ip) | The external ip address of the forwarding rule. |
