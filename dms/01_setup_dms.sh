#!/usr/bin/env bash
# Database Migration Service: PostgreSQL -> Cloud SQL (continuous).
set -euo pipefail
: "${GCP_PROJECT:?}"; : "${GCP_REGION:?}"

gcloud services enable datamigration.googleapis.com sqladmin.googleapis.com \
  --project "$GCP_PROJECT"

# 1) SOURCE connection profile (self-managed PostgreSQL).
gcloud database-migration connection-profiles create postgresql src-postgres \
  --project="$GCP_PROJECT" --region="$GCP_REGION" \
  --host="$SRC_HOST" --port=5432 \
  --username="$SRC_USER" --password="$SRC_PASSWORD" \
  --ssl-type=SERVER_ONLY

# 2) DESTINATION: create/target a Cloud SQL for PostgreSQL instance.
gcloud database-migration connection-profiles create cloudsql dst-cloudsql \
  --project="$GCP_PROJECT" --region="$GCP_REGION" \
  --database-version=POSTGRES_15 \
  --tier=db-custom-2-8192 --storage-auto-resize \
  --root-password="$TGT_PASSWORD"

# 3) MIGRATION JOB - continuous = full dump THEN CDC.
gcloud database-migration migration-jobs create pg-to-cloudsql \
  --project="$GCP_PROJECT" --region="$GCP_REGION" \
  --type=CONTINUOUS \
  --source=src-postgres --destination=dst-cloudsql \
  --peer-vpc="projects/${GCP_PROJECT}/global/networks/default"

# 4) Verify prerequisites, then start.
gcloud database-migration migration-jobs verify pg-to-cloudsql --region="$GCP_REGION"
gcloud database-migration migration-jobs start  pg-to-cloudsql --region="$GCP_REGION"