import os
from typing import Iterable, Dict, Any

import dlt


@dlt.resource(table_name="user_events")
def user_events() -> Iterable[Dict[str, Any]]:
    sample_events = [
        {
            "event_id": "evt_001",
            "user_id": "u_101",
            "session_id": "s_1001",
            "event_name": "dashboard_view",
            "event_ts": "2026-10-04T12:00:00Z",
            "properties": {"dashboard": "revenue_overview", "country": "US"},
            "platform": "web"
        },
        {
            "event_id": "evt_002",
            "user_id": "u_101",
            "session_id": "s_1001",
            "event_name": "genai_prompt",
            "event_ts": "2026-10-04T12:05:00Z",
            "properties": {"query": "show customer churn anomalies", "model": "gemini"},
            "platform": "android"
        }
    ]

    for event in sample_events:
        yield event


def run_pipeline() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="genai_platform_events",
        destination="bigquery",
        dataset_name=os.getenv("BIGQUERY_DATASET", "genai_platform_dev")
    )

    load_info = pipeline.run(user_events())
    print(load_info)


if __name__ == "__main__":
    run_pipeline()
