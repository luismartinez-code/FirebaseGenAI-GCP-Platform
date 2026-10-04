resource "google_project_service" "enabled_services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "run.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudfunctions2.googleapis.com",
    "pubsub.googleapis.com",
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "aiplatform.googleapis.com",
    "firebaserules.googleapis.com",
    "firebase.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "composer.googleapis.com"
  ])

  service = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "raw_zone" {
  name          = "${var.project_id}-raw-${var.environment}"
  location      = var.region
  force_destroy = var.environment != "prod"

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "curated_zone" {
  name          = "${var.project_id}-curated-${var.environment}"
  location      = var.region
  force_destroy = var.environment != "prod"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "google_pubsub_topic" "genai_events" {
  name = "genai-events-${var.environment}"
}

resource "google_pubsub_topic" "recommendations" {
  name = "recommendations-${var.environment}"
}

resource "google_bigquery_dataset" "platform_dataset" {
  dataset_id                 = var.dataset_name
  location                  = var.region
  delete_contents_on_destroy = var.environment != "prod"

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "google_service_account" "pipeline_sa" {
  account_id   = "genai-pipeline-${var.environment}"
  display_name = "Service account for GenAI pipelines"
}

resource "google_project_iam_member" "pipeline_sa_roles" {
  for_each = toset([
    "roles/bigquery.dataEditor",
    "roles/storage.objectViewer",
    "roles/pubsub.publisher",
    "roles/aiplatform.user",
    "roles/logging.logWriter"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.pipeline_sa.email}"
}

resource "google_cloudfunctions2_function" "genai_ingest_function" {
  name        = "genai-ingest-${var.environment}"
  location    = var.region
  description = "GenAI event ingestion function for Firebase and GCP app workloads"

  build_config {
    runtime = "python311"
    entry_point = "process_event"
    environment_variables = {
      ENVIRONMENT = var.environment
    }

    source {
      storage_source {
        bucket = google_storage_bucket.raw_zone.name
        object = "functions/genai-ingest-source.zip"
      }
    }
  }

  service_config {
    max_instance_count = 5
    min_instance_count = 0
    available_memory   = "1Gi"
    timeout_seconds    = 540
    ingress_settings   = "ALLOW_ALL"
    environment_variables = {
      PROJECT_ID = var.project_id,
      ENVIRONMENT = var.environment
    }
  }
}

resource "google_bigquery_table" "event_table" {
  dataset_id = google_bigquery_dataset.platform_dataset.dataset_id
  table_id   = "user_events_${var.environment}"

  schema = <<EOF
[
  {"name":"event_id","type":"STRING","mode":"NULLABLE"},
  {"name":"user_id","type":"STRING","mode":"NULLABLE"},
  {"name":"session_id","type":"STRING","mode":"NULLABLE"},
  {"name":"event_name","type":"STRING","mode":"NULLABLE"},
  {"name":"event_ts","type":"TIMESTAMP","mode":"NULLABLE"},
  {"name":"properties","type":"JSON","mode":"NULLABLE"},
  {"name":"platform","type":"STRING","mode":"NULLABLE"}
]
EOF
}

resource "google_bigquery_table" "recommendation_table" {
  dataset_id = google_bigquery_dataset.platform_dataset.dataset_id
  table_id   = "recommendations_${var.environment}"

  schema = <<EOF
[
  {"name":"recommendation_id","type":"STRING","mode":"NULLABLE"},
  {"name":"user_id","type":"STRING","mode":"NULLABLE"},
  {"name":"dashboard_id","type":"STRING","mode":"NULLABLE"},
  {"name":"score","type":"FLOAT","mode":"NULLABLE"},
  {"name":"created_at","type":"TIMESTAMP","mode":"NULLABLE"},
  {"name":"metadata","type":"JSON","mode":"NULLABLE"}
]
EOF
}
