resource "google_dataflow_flex_template_job" "pubsub_to_bq_job" {
  provider                = google-beta
  name                    = "${replace(split("/", var.input_subscription)[3], "_", "-")}-to-${replace(split(".", var.bigquery_table)[1], "_", "-")}-${lower(random_string.random.result)}"
  container_spec_gcs_path = "${google_storage_bucket.provisioning_bucket.url}/${google_storage_bucket_object.pubsub_subscription_to_bq.name}"
  parameters = {
    input_subscription = var.input_subscription
    output_table       = var.bigquery_table
    output_schema      = var.bigquery_schema
  }
  region = var.region
}
