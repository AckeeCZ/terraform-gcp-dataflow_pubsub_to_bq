resource "google_pubsub_topic" "example" {
  name = "pubsub_to_bq_example_topic"
}

resource "google_pubsub_subscription" "example" {
  name  = "pubsub_to_bq_example_topic_subscription"
  topic = google_pubsub_topic.example.name
  ack_deadline_seconds = 60
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "pubsub_to_bq_example_dataset"
  location                    = "EU"

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bqowner.email
  }
}

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}