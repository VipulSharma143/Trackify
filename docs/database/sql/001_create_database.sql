-- 001_create_database.sql
-- Development database creation. NOT VERIFIED against a live server (no PostgreSQL available when written).
-- Run as a role allowed to create databases (e.g. a superuser or a role with CREATEDB).
-- No passwords here. Never DROP an existing database.
-- Run from psql connected to the 'postgres' maintenance database:
--   psql -U <admin_role> -d postgres -f 001_create_database.sql
-- CREATE DATABASE fails (safely) if the database already exists.

CREATE DATABASE my_app_dev
    ENCODING 'UTF8';
