variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Default Google Cloud region"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "Default Google Cloud zone"
}

variable "environment" {
  type        = string
  description = "Deployment environment: dev, staging, or prod"
}

variable "billing_account" {
  type        = string
  description = "GCP billing account ID"
}

variable "org_id" {
  type        = string
  description = "GCP organization ID"
}

variable "firebase_project_id" {
  type        = string
  description = "Matching Firebase project ID"
}

variable "dataset_name" {
  type        = string
  default     = "genai_platform"
  description = "BigQuery dataset used for analytics and AI feature generation"
}
