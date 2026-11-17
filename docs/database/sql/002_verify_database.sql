-- 002_verify_database.sql
-- Read-only checks. NOT VERIFIED against a live server (no PostgreSQL available when written).
-- Run: psql -U <role> -d my_app_dev -f 002_verify_database.sql

SELECT current_database() AS database_name;
SELECT version() AS server_version;
SELECT current_schema() AS current_schema;

-- Tables in the current schema (expected: none, or only __EFMigrationsHistory)
SELECT table_name
FROM information_schema.tables
WHERE table_schema = current_schema()
ORDER BY table_name;

-- Basic connectivity check (returns 1)
SELECT 1 AS connectivity_ok;
