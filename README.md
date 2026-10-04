# FirebaseGenAI-GCP-Platform

A production-ready reference architecture for a GenAI platform that combines Firebase, Google Cloud Platform, Terraform, Looker embedded dashboards, BigQuery data lakehouse patterns, real-time event pipelines, and AI orchestration.

This repository is structured to support:
- Firebase app configuration for Android and web
- Terraform-based GCP project provisioning and service enablement
- Real-time data pipelines and GenAI ingestion patterns
- Dev / staging / production environments
- Looker embedded dashboards over lakehouse and AI features
- ML serving and orchestration with Vertex AI and optional Data Agent Kit integrations

## Architecture at a glance

- Client Access: Android app + web app via Firebase Auth + Remote Config
- App Layer: Firebase Hosting, Firebase Functions, Firestore, Firebase Auth, Remote Config
- Event Streaming: Pub/Sub + Dataflow / Cloud Run / Cloud Functions
- Data Platform: GCS + BigQuery + BigLake + Dataform / dbt patterns
- AI Platform: Vertex AI + Model Garden + custom serving
- Business Intelligence: Looker embedded dashboards + LookML + semantic layer
- Governance: IAM, VPC Service Controls, Organization policies, Secret Manager
- orchestration: Cloud Composer / Workflows / dlt pipelines

## Repository layout

- `infra/terraform/` — Terraform for GCP services and project setup
- `firebase/` — Firebase project configuration and app backend
- `apps/web/` — web frontend skeleton using Firebase Remote Config
- `data/` — dlt ingestion examples and AI data flow documentation
- `docs/` — architecture and Android backend blueprints

## Quickstart

### 1. GCP bootstrap

```bash
cd infra/terraform
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

### 2. Firebase setup

```bash
cd firebase
firebase login
firebase init
firebase use dev
firebase deploy
```

### 3. Web app

Open the web app from `apps/web/index.html` or deploy it with Firebase Hosting.

### 4. Data ingestion

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r data/requirements.txt
python data/dlt_pipeline.py
```

## Environment strategy

- `dev`: isolated sandbox, low-cost, debug enabled
- `staging`: production-like, load and integration regression coverage
- `prod`: locked-down IAM, monitored infrastructure, disaster recovery patterns

## Recommended stack summary

- GCP: BigQuery, Cloud Storage, Pub/Sub, Vertex AI, Cloud Run, Cloud Functions, Secret Manager, Firestore, IAM
- Firebase: Authentication, Remote Config, Hosting, Cloud Functions
- BI: Looker Embedded + Explore/LookML connections
- Data pipeline: dlt + Pub/Sub + Dataflow / Cloud Run
- Model serving: Vertex AI endpoints + custom inference pipelines

## Notes

This repository provides a reference implementation skeleton and production architecture blueprint. For real deployment, add secrets, real service account keys, and environment-specific project IDs before applying the infrastructure.
