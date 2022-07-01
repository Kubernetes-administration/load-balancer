## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.27.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_instance.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [template_file.instance_startup_script](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | The project scope | `string` | `"gcp-terraform-env"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region | `string` | `"us-west1"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | zone | `string` | `"us-west1-a"` | no |

## Outputs

No outputs.
