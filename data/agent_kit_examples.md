# Data Agent Kit orchestration notes

The repository is designed to support a data-agent or agentic orchestration layer on top of the GCP data platform.

## Recommended pattern

- Use dlt for ingestion and pipeline semantics
- Use Pub/Sub for streaming event distribution
- Use Dataflow or Cloud Run for event enrichment and validation
- Use Vertex AI for summarization and reasoning over structured and unstructured datasets
- Use Looker embedded dashboards to present curated insights to users

## Example agentic flow

1. User asks: "Which customers are at risk of churn this quarter?"
2. Agent resolves available datasets and joins them in BigQuery
3. Data agent calls feature logic and model endpoints
4. The agent summarizes risk factors and returns a dashboard or answer
5. Recommendations are persisted and surfaced to the app layer

## Optional integration

- Data Agent Kit can sit in front of domain-specific tools and model calls
- Use an LLM or rule engine to decide which dataset, metric, and visualization should be returned
- Keep all model calls behind Cloud Run or Vertex AI to avoid exposing protected endpoints directly to client apps
