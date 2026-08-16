# GCP Database Migration & Modernization

Production-oriented database migration and modernization project on Google Cloud Platform, covering PostgreSQL and Oracle migration scenarios, continuous replication, data reconciliation, controlled cutover, rollback, and heterogeneous schema conversion.

## Business Problem

Organizations migrating legacy transactional databases to Google Cloud need to move data with minimal downtime while maintaining correctness, consistency, security, and operational control.

This project models an enterprise migration workflow from source databases such as PostgreSQL and Oracle to Google Cloud targets including Cloud SQL and AlloyDB.

The migration process includes:

- Source database assessment
- Schema and compatibility analysis
- Target platform selection
- Initial full-load migration
- Continuous Change Data Capture (CDC)
- Replication monitoring
- Schema and data reconciliation
- Controlled cutover
- Rollback planning
- Oracle-to-PostgreSQL heterogeneous migration

## Architecture

```text
             SOURCE DATABASES
          ┌─────────────────────┐
          │ PostgreSQL / Oracle  │
          └──────────┬──────────┘
                     │
                     │ Assessment
                     ▼
          ┌─────────────────────┐
          │ Assessment Tooling  │
          │                     │
          │ • Profiler          │
          │ • Compatibility     │
          │ • Type Mapping      │
          └──────────┬──────────┘
                     │
                     │ Full Load + CDC
                     ▼
          ┌─────────────────────┐
          │ Database Migration  │
          │ Service (DMS)       │
          └──────────┬──────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │ Cloud SQL / AlloyDB │
          └──────────┬──────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │ Reconciliation      │
          │                     │
          │ • Schema            │
          │ • Row Counts        │
          │ • Checksums         │
          │ • Samples           │
          └──────────┬──────────┘
                     │
                PASS / FAIL
                     │
                     ▼
          ┌─────────────────────┐
          │ Controlled Cutover  │
          │ & Rollback          │
          └─────────────────────┘



1. Assess
   ├── Profile source database
   └── Check compatibility

2. Select Target
   └── Cloud SQL / AlloyDB

3. Provision Migration
   └── Configure Database Migration Service

4. Migrate
   ├── Initial full load
   └── Continuous CDC

5. Validate
   ├── Schema comparison
   ├── Row-count reconciliation
   ├── Checksum validation
   └── Representative-record comparison

6. Cutover
   ├── Freeze writes
   ├── Wait for replication lag ≈ 0
   ├── Require reconciliation PASS
   ├── Promote target
   └── Repoint application

7. Rollback
   └── Retain source for controlled recovery


.
├── dms/
│   ├── 01_setup_dms.sh
│   ├── 02_source_prep.sql
│   └── oracle_to_postgres/
│       └── schema_conversion.md
│
├── docs/
│   ├── 01-assessment.md
│   ├── 02-target-selection.md
│   ├── 03-runbook-cdc.md
│   ├── 04-cutover-rollback.md
│   └── architecture.md
│
├── sql/
│   ├── source/
│   │   ├── 01_schema.sql
│   │   └── 02_seed_data.sql
│   └── checks/
│       └── assessment_queries.sql
│
├── src/
│   ├── assess/
│   │   ├── profiler.py
│   │   ├── compat.py
│   │   └── oracle_typemap.py
│   ├── recon/
│   │   ├── schema_diff.py
│   │   ├── rowcounts.py
│   │   ├── sample_diff.py
│   │   └── report.py
│   ├── config.py
│   └── db.py
│
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md


