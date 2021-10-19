resource "random_string" "random" {
  length  = 16
  special = false
}

resource "google_storage_bucket" "provisioning_bucket" {
  name          = "dataflow-provisiong-function-${lower(random_string.random.result)}"
  storage_class = "REGIONAL"
  location      = "EUROPE-WEST3"
  force_destroy = true
}

resource "google_storage_bucket_object" "pubsub_subscription_to_bq" {
  name    = "dataflow_pipeline/pubsub_to_bq.json"
  content = file("${path.module}/pipeline/template.json")
  bucket  = google_storage_bucket.provisioning_bucket.name
}
