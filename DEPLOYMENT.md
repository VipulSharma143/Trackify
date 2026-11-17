# Deployment

## Current state (read first)
**No hosting target exists yet.** The repository contains no cloud configuration, server address or deployment credentials, and none has been invented. The production pipeline (`.github/workflows/deploy-production.yml`) therefore does the following today:

1. runs the full quality gate on `main`,
2. builds the production artifacts (API publish output and web build) and stores them as a workflow artifact for 30 days,
3. **skips the deploy job** because the repository variable `DEPLOY_ENABLED` is not `true`,
4. creates the release (tag and GitHub Release) as described in [RELEASE_PROCESS.md](RELEASE_PROCESS.md).

Setting `DEPLOY_ENABLED=true` before the deploy step is implemented makes the pipeline **fail on purpose**, so a deployment can never be reported as successful when nothing was deployed.

## To enable deployment (owner tasks)
1. Decide and document the hosting for the API, the web build, PostgreSQL and HTTPS (see the TBD list in [docs/deployment/DEPLOYMENT_GUIDE.md](docs/deployment/DEPLOYMENT_GUIDE.md)).
2. Create the GitHub Environment `production` (Settings > Environments) with **required reviewers** for manual approval, and restrict it to the `main` branch.
3. Add the needed secrets to that environment (names depend on the hosting choice; never commit them).
4. Replace the `Deploy` step in `deploy-production.yml` with the real deployment commands, using the artifact `production-<sha>`.
5. Set repository variables: `PRODUCTION_HEALTH_URL` (public URL of `/api/health`) and finally `DEPLOY_ENABLED=true`.
6. Confirm the health-check step passes and a failed deployment shows as failed.

## Backend runtime configuration
Environment variables are listed in [`.env.example`](.env.example): `Database__Host`, `Database__Port`, `Database__Database`, `Database__Username`, `Database__Password`, `Cors__AllowedOrigins__N`, plus `ASPNETCORE_ENVIRONMENT` and `ASPNETCORE_URLS`. In production, Swagger is off and HTTPS redirection is on; set `Cors__AllowedOrigins__0` to the real web origin.

## Database in production
- CI never runs migrations against production. No EF Core migrations exist yet.
- Before any production migration: take a backup (`pg_dump -Fc`), generate a reviewed script with `dotnet ef migrations script --idempotent`, apply it in a controlled step, and prefer backward-compatible (expand/contract) changes so the previous release keeps working.
- Backup and restore steps: [docs/deployment/ROLLBACK_PROCEDURE.md](docs/deployment/ROLLBACK_PROCEDURE.md).

## Environments
Only development (local) and production are defined. Add a staging environment (a second GitHub Environment and variable set) when a staging target exists.

## Mobile app distribution
Store releases (Play Store / App Store) and release signing are not configured. The debug APK workflow is for development only ([docs/development/ANDROID_APK_BUILD.md](docs/development/ANDROID_APK_BUILD.md)).
