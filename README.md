# Dataflow PubSub to BigQuery

Dataflow job subscriber to PubSub subscription. It takes message from subscription and push it into BigQuery table.

## Before you do anything in this module

Install pre-commit hooks by running following commands:

```shell script
brew install pre-commit terraform-docs
pre-commit install
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_dataflow_flex_template_job.pubsub_to_bq_job](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dataflow_flex_template_job) | resource |
| [google_storage_bucket.provisioning_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.pubsub_subscription_to_bq](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bigquery_schema"></a> [bigquery\_schema](#input\_bigquery\_schema) | Schema of target bigquery table | `string` | n/a | yes |
| <a name="input_bigquery_table"></a> [bigquery\_table](#input\_bigquery\_table) | table\_id of target table | `string` | n/a | yes |
| <a name="input_input_subscription"></a> [input\_subscription](#input\_input\_subscription) | Name of input subscription | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to deploy dataflow job to | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
