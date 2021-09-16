resource "random_string" "random" {
  length           = 16
  special          = false
}

resource "google_storage_bucket" "provisioning_bucket" {
  name          = "dataflow_provisiong_function_${random_string.random.result}"
  storage_class = "REGIONAL"
  location      = "EUROPE-WEST3"
  force_destroy = true
}

resource "google_storage_bucket_object" "pubsub_subscription_to_bq" {
  name    = "pipeline.py"
  content = file("${path.module}/pipeline/main.py")
  bucket  = google_storage_bucket.provisioning_bucket.name
}

resource "google_storage_object_access_control" "public_rule" {
  object     = google_storage_bucket_object.pubsub_subscription_to_bq.output_name
  bucket     = google_storage_bucket.provisioning_bucket.name
  role       = "READER"
  entity     = "allUsers"
  depends_on = [google_storage_bucket_object.pubsub_subscription_to_bq]
}