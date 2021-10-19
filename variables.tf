variable "input_subscription" {
  type        = string
  description = "Name of input subscription"
}

variable "bigquery_table" {
  type        = string
  description = "table_id of target table"
}

variable "bigquery_schema" {
  type        = string
  description = "Schema of target bigquery table"
}

variable "region" {
  type        = string
  description = "Region to deploy dataflow job to"
}
