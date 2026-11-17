# Database Schema

**Database:** PostgreSQL (only). Access via EF Core + Npgsql.

## Current state
**No product or business tables exist yet.** The only objects are those EF Core creates itself if/when a migration is applied (`__EFMigrationsHistory`).

## Naming conventions
- Tables and columns: `snake_case`; tables plural (e.g. `order_items`).
- Primary key: `id`. Foreign key: `<referenced_singular>_id`.
- Indexes: `ix_<table>_<columns>`; unique: `ux_<table>_<columns>`.
- Timestamps: `timestamptz`, stored in UTC (`created_at`, `updated_at`).

## Keys and indexes
Choose keys deliberately per table (surrogate `uuid` or `bigint identity`). Index every foreign key and every frequently filtered column; document why.

## Migrations
Workflow is in `docs/development/DEVELOPMENT_SETUP.md` (EF Core migrations section). Connection settings: `Database:Host/Port/Database` in `backend/appsettings.json`; `Database:Username/Password` via user-secrets or `Database__*` environment variables. Never apply destructive migrations or drop/reset a database without explicit approval.

## Documenting future changes
Every schema change must, in the same PR: add the migration, update this file and `DATABASE_RELATIONS.md`, and add a CHANGELOG entry.
