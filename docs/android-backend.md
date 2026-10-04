# Android backend pattern

This document defines the backend contract for Android and web clients that interact with the Firebase + GCP GenAI platform.

## Core app services

- `auth/login` — Firebase Auth sign-in
- `recommendations/list` — returns personalized recommendation payloads
- `insights/search` — generates or retrieves AI summary for a dataset or KPI
- `dashboards/embed` — returns signed or managed Looker embedding details
- `events/ingest` — mobile app or SDK event streaming endpoint

## Example service contract

### Recommend endpoint

Request:

```json
{
  "userId": "abc123",
  "context": {
    "device": "android",
    "locale": "en-US",
    "segment": "executive"
  },
  "limit": 5
}
```

Response:

```json
{
  "items": [
    {
      "id": "r1",
      "title": "Revenue trend overview",
      "type": "dashboard",
      "score": 0.94,
      "url": "https://looker.example.com/embed/analytics"
    }
  ]
}
```

## Firebase and GCP integration

- Android app authenticates against Firebase Auth
- Firebase Functions handles secure API mediation to GCP
- Cloud Run / Functions call BigQuery or Vertex AI depending on the request
- Firebase Remote Config controls feature flags and experiment variants

## Security

- Require Firebase ID token validation on all callable functions
- Use service accounts for internal service-to-service calls
- Do not expose any model or secret values to client apps
- Use IAM and VPC boundary restrictions in prod

## Suggested mobile stack

- Kotlin / Android app with Firebase SDK
- Firebase Remote Config for app-rollout and dynamic prompts
- Analytics events routed to Pub/Sub and BigQuery
- Secure generation flows executed server-side
