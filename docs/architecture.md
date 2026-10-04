# Architecture blueprint

This repository implements a reference architecture for an AI-powered application platform that uses Firebase as the app layer and GCP as the data platform, ML serving platform, and BI layer.

## Core system

1. User experience layer
   - Web app via Firebase hosting
   - Android app via Firebase services and REST endpoints
   - Firebase Auth and Remote Config drive personalization and rollout

2. Application and backend layer
   - Firebase Functions for sync, async, and event-driven logic
   - Firestore or Realtime Database for user state, recommendations, and app metadata
   - Cloud Run / Functions for backend services

3. Real-time data and generation layer
   - Event intake from app actions and external systems through Pub/Sub
   - Stream processing through Dataflow or Cloud Run services
   - BigQuery for analytics; BigQuery ML for feature generation and ranking
   - Vertex AI for LLM inference, embedding generation, and RAG orchestration

4. Lakehouse and semantic layer
   - Raw storage bucket in GCS
   - Curated zone in BigQuery / BigLake
   - Looker semantic layer and LookML for embedded dashboards
   - Feature store for user, product, and recommendation features

5. Governance and security
   - IAM policy separation by environment
   - Secret Manager for API keys and service credentials
   - VPC SC / private connectivity patterns for prod
   - Audit logs and data classification policies

## Data flow for GenAI

User or app event
  -> Firebase Client / Web / Android
  -> Firebase Auth / Remote Config / API Gateway
  -> HTTP Event -> Pub/Sub / Cloud Function / Cloud Run
  -> Streaming validation and enrichment
  -> Real-time feature assembly
  -> LLM prompt orchestration via Vertex AI
  -> Context retrieval from BigQuery / vector search / document corpus
  -> Generated response or insight
  -> Firestore / BigQuery / Looker / mobile/web UI

## Data architecture

- Raw zone: Business events, user events, file uploads, external partners
- Curated zone: Normalized tables, metrics, feature sets, embeddings
- Serving zone: Recommendation endpoints, model inference outputs, dashboard views
- Analytics zone: BigQuery usage analysis, cohort modeling, KPI reporting

## Environment model

### Dev
- Firebase project alias: `dev`
- Lower cost compute and smaller datasets
- Debug logging enabled
- Less strict retry thresholds

### Staging
- Production-like configuration and security controls
- Synthetic data or masked production snapshots
- Integration and performance validation

### Production
- Highest security and reliability standards
- Strict IaC and approvals
- Monitoring, alerts, rollback workflows

## Recommended stack

- Firebase: Auth, Hosting, Remote Config, Cloud Functions, Firestore
- GCP: BigQuery, GCS, Pub/Sub, Cloud Run, Cloud Functions, Secret Manager
- AI: Vertex AI, Gemini / other Model Garden models, embeddings
- BI: Looker embedded dashboards
- Orchestration: dlt, Airflow / Cloud Composer, optional Data Agent Kit

## Key design principles

- Keep user interactions and app logic in Firebase for fast iteration
- Keep heavy analytical workloads in GCP lakehouse and data warehouse services
- Keep GenAI orchestration event-driven and observable
- Layer security at service accounts, IAM, and network boundaries
- Use environment separation for reliable production rollout
