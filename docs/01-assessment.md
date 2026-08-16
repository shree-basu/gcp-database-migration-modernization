# Phase 1 - Source Assessment

## Goal
Produce a factual inventory + compatibility verdict BEFORE provisioning any target.

## What we measure
| Dimension        | Why it matters |
|------------------|----------------|
| Database size    | Target sizing + full-load duration estimate |
| Row counts/table | Baseline for post-migration reconciliation |
| Object inventory | Tables, views, sequences, indexes must all land |
| Feature usage    | Extensions / untrusted languages may be unsupported |
| CDC readiness    | Continuous mode needs logical replication prereqs |

## CDC prerequisites (PostgreSQL source)
1. wal_level = logical
2. max_replication_slots and max_wal_senders > 0
3. A user with REPLICATION privilege
4. Every table has a PRIMARY KEY or REPLICA IDENTITY FULL