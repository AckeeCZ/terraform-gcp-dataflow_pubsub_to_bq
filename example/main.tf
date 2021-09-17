variable "project" {}

variable "region" {
  default = "europe-west3"
}

variable "zone" {
  default = "europe-west3-c"
}

resource "google_project_service" "project" {
  project                    = var.project
  service                    = "dataflow.googleapis.com"
  disable_dependent_services = false
}

locals {
  schema = [
    {
      name : "i",
      type : "INTEGER",
      mode : "NULLABLE",
    },
  ]
  schema_oneline = join(",", [for i in local.schema : "${i["name"]}:${i["type"]}"])
}

resource "google_pubsub_topic" "example" {
  name = "pubsub_to_bq_example_topic"
}

resource "google_cloud_scheduler_job" "job" {
  name        = "test-job"
  description = "test job"
  schedule    = "* * * * *"
  region      = "us-central1"

  pubsub_target {
    topic_name = google_pubsub_topic.example.id
    data       = base64encode("{\"i\": 1}")
  }
}

resource "google_pubsub_subscription" "example" {
  name                 = "pubsub_to_bq_example_topic_subscription"
  topic                = google_pubsub_topic.example.name
  ack_deadline_seconds = 60
}

resource "google_service_account" "sa" {
  account_id = "pubsubtobq-example-sa"
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "pubsub_to_bq_example_dataset"
  location   = "EU"
}

resource "google_bigquery_table" "table" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "test_table"

  schema = jsonencode(local.schema)
}

resource "google_pubsub_topic_iam_member" "sa_publishers" {
  topic  = google_pubsub_topic.example.name
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_pubsub_subscription_iam_member" "sa_subscribers" {
  subscription = google_pubsub_subscription.example.name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${google_service_account.sa.email}"
}

module "pubsub_to_bq" {
  source             = "../"
  bigquery_schema    = local.schema_oneline
  bigquery_table     = "${var.project}:${google_bigquery_table.table.dataset_id}.${google_bigquery_table.table.table_id}"
  input_subscription = "projects/${var.project}/subscriptions/${google_pubsub_subscription.example.name}"
  region             = var.region
}
