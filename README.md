# my-app

Foundation for a cross-platform mobile app (Android, iOS, browser preview) with an ASP.NET Core API and PostgreSQL. **No product features exist yet.**

> Quick links: [Contributing](CONTRIBUTING.md) · [Development workflow](DEVELOPMENT_WORKFLOW.md) · [Release process](RELEASE_PROCESS.md) · [Deployment](DEPLOYMENT.md) · [Security](SECURITY.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · [Changelog](CHANGELOG.md) · [GitHub setup](docs/github/GITHUB_SETUP.md)

## Project Overview
A monorepo containing a React Native app (`mobile/`), an ASP.NET Core Web API (`backend/`), PostgreSQL scripts and documentation. The mobile app shows a sample UI (Home, Settings, About) and live API/database status from the backend.

## Project Purpose
Provide a clean, runnable and verifiable technical foundation to build product features on. It deliberately contains no authentication, payments, chat, orders, notifications, analytics or file uploads.

## Key Features
- Same React Native code on Android, iOS and the browser (React Native Web + Vite).
- Sample screens with navigation, shared components and theme tokens.
- REST API with three endpoints: `GET /api/health`, `GET /api/health/database`, `GET /api/system/info`, Swagger in Development.
- PostgreSQL via EF Core + Npgsql (no business tables yet).
- Helper scripts, CI/CD workflows and release automation (see below).

Planned, not implemented: see [FUTURE_FEATURES.md](FUTURE_FEATURES.md).

## Technology Stack
React Native (community CLI, no Expo) + TypeScript · React Native Web + Vite · ASP.NET Core Web API (C#, .NET 10) · PostgreSQL, EF Core, Npgsql · REST/JSON · GitHub Actions.

Installed mobile versions (from `mobile/package.json`): React Native 0.88.1, React 19.3.0, TypeScript ^6.0.3, react-native-web ^0.21.4, Vite ^8.3.8, React Navigation ^7, Jest ^29.

## Application Architecture
Mobile client -> REST/JSON -> ASP.NET Core (controllers -> services) -> EF Core/Npgsql -> PostgreSQL. Details: [docs/architecture/SYSTEM_ARCHITECTURE.md](docs/architecture/SYSTEM_ARCHITECTURE.md), [decisions](docs/decisions/ARCHITECTURE_DECISIONS.md).

## Repository Structure
```
.github/     workflows, rulesets (importable JSON), CODEOWNERS, templates, dependabot.yml
docs/        architecture, database (+ sql/), api, development, decisions, deployment, github
scripts/     check-environment, build, start-dev, start-app, clean, build-android-debug,
             release, validate-config, api-smoke-test
mobile/      React Native app: App.tsx, index.js, android/, ios/, web/, __tests__/, src/
backend/     ASP.NET Core API: Controllers, Services, DTOs, Data, Configuration, Extensions, Middleware
```
Per-folder description: [docs/architecture/PROJECT_STRUCTURE.md](docs/architecture/PROJECT_STRUCTURE.md).

## Prerequisites
Node.js >= 22.11 and npm, .NET 10 SDK, PostgreSQL, Java 17+ (Android), Android Studio (Android), Xcode + CocoaPods (iOS, macOS only), `jq` and `curl` (for `scripts/validate-config.sh` and `scripts/api-smoke-test.sh`). Check your machine: `bash scripts/check-environment.sh`.

## Installation Instructions
```
git clone <repository-url>
cd <repository-folder>
bash scripts/build.sh        # npm install, type-check, dotnet restore + build
```

## Local Development Setup
1. Create the database: `sudo -u postgres psql -d postgres -f docs/database/sql/001_create_database.sql`
2. Give the API its database login (stored outside the repo):
   ```
   cd backend
   dotnet user-secrets set "Database:Username" "<user>"
   dotnet user-secrets set "Database:Password" "<password>"
   ```
3. Verify with `psql -U <user> -d my_app_dev -f docs/database/sql/002_verify_database.sql`.

## Environment Variables
The backend reads configuration from `appsettings*.json`, user-secrets and environment variables. All variables are listed in [`.env.example`](.env.example) (no values): `Database__Host`, `Database__Port`, `Database__Database`, `Database__Username`, `Database__Password`, `Cors__AllowedOrigins__N`, `ASPNETCORE_ENVIRONMENT`, `ASPNETCORE_URLS`. The mobile app has no environment variables; its API address is in `mobile/src/constants/config.ts` (set `API_HOST_OVERRIDE` for a physical device). Never commit real values.

## Running the Application
```
bash scripts/start-dev.sh    # API (http://localhost:5000/swagger) + browser app (http://localhost:5173)
bash scripts/start-app.sh    # Android app (needs the Android SDK)
npm run ios                  # iOS, macOS only (cd mobile/ios && pod install first)
```

## Scripts reference

All scripts live in `scripts/`, are Bash scripts for Linux and macOS (Windows: Git Bash or WSL), and work from any directory because they locate the project root themselves. Run them with `bash scripts/<name>.sh` from the project root (or `./<name>.sh` from inside `scripts/`). Paths containing spaces are supported.

Recommended order for a new developer: `check-environment.sh` -> `build.sh` -> `start-dev.sh` (browser + API) or `start-app.sh` (Android). Use `clean.sh` before sharing the project.

| Script | Purpose | Changes files? |
|---|---|---|
| `check-environment.sh` | Report which required tools are installed | No (read-only) |
| `build.sh` | Install packages and build everything | Yes (creates `node_modules`, `bin`, `obj`) |
| `start-dev.sh` | Run the API and browser app, open the browser | No |
| `start-app.sh` | Run the Android app on a device or emulator | Builds the Android app |
| `build-android-debug.sh` | Build a debug APK | Yes (Gradle output) |
| `clean.sh` | Delete generated folders before sharing | Yes (deletes) |

### `check-environment.sh` — check the system
Usage: `bash scripts/check-environment.sh`

Reports, for each tool, `OK` with its version or `MISSING`: Node.js, npm, .NET SDK, Java, PostgreSQL (`psql`), `adb`, the Android SDK (looks for `ANDROID_HOME` / `ANDROID_SDK_ROOT`), and Xcode tools (macOS only; shows `N/A` elsewhere). It installs nothing and changes no settings, so it is safe to run at any time. Run it first and fix anything marked `MISSING` that you need:
- Node.js/npm and Java are needed for the mobile app (Java 17+ for Android).
- .NET 10 SDK is needed for the backend.
- PostgreSQL is needed for the database health endpoint.
- `adb` and the Android SDK are needed only for Android.

### `build.sh` — install packages and build
Usage: `bash scripts/build.sh` or `bash scripts/build.sh --android`

What it does, in order:
1. Checks that Node.js and npm exist (stops with an error if not).
2. Runs `npm install` in `mobile/` (installs `node_modules`).
3. Runs the TypeScript type-check.
4. If `dotnet` exists: `dotnet restore backend`, then `dotnet build backend`. If not, it prints a warning, skips the backend and lists it as skipped at the end.
5. On macOS with CocoaPods installed: runs `pod install` in `mobile/ios`.
6. With `--android`: also builds the Android debug APK (see `build-android-debug.sh`).

It stops at the first real failure. Re-running it is safe.

### `start-dev.sh` — API + browser app
Usage: `bash scripts/start-dev.sh` or `bash scripts/start-dev.sh --no-api`

What it does:
1. Runs `npm install` first only if `mobile/node_modules` is missing.
2. Starts the backend with `dotnet watch run` in Development mode at `http://localhost:5000` (Swagger at `http://localhost:5000/swagger`). If `dotnet` is missing it warns and continues without the API; `--no-api` skips the API on purpose.
3. Starts the browser app (React Native Web + Vite) at `http://localhost:5173`.
4. Waits until the browser app answers, then opens it in your default browser (`xdg-open` on Linux, `open` on macOS). If no opener exists it prints the URL.

Press `Ctrl+C` to stop; both the API and the browser app are shut down. The database needs a login first (see Database below), otherwise the Home screen shows the database as unavailable while the API itself stays healthy.

### `start-app.sh` — Android app
Usage: `bash scripts/start-app.sh`

Requirements: `ANDROID_HOME` set, `adb` and Java available. What it does:
1. Stops with a clear message if the Android SDK, `adb` or Java is missing.
2. Runs `npm install` first only if `mobile/node_modules` is missing.
3. Uses a connected device or running emulator. If none is found it starts the first emulator (AVD) it can find and waits for it to boot; if there is no AVD it stops with an error.
4. Sets up `adb reverse` for port 8081 so the app can reach Metro.
5. Starts Metro (the JavaScript bundler), then builds, installs and launches the app (`react-native run-android`).

Metro keeps running so the app can load code; press `Ctrl+C` to stop it. The emulator reaches your computer's API through `10.0.2.2` automatically; for a physical phone set `API_HOST_OVERRIDE` in `mobile/src/constants/config.ts`. The API is not started by this script; run `start-dev.sh` in another terminal (or `dotnet watch run` in `backend/`) if you want live API status in the app.

### `build-android-debug.sh` — debug APK
Usage: `bash scripts/build-android-debug.sh` (also `npm run build:android`)

Checks that `mobile/android/gradlew`, the Android SDK and Java exist (clear error if not), runs `./gradlew assembleDebug`, and confirms the file exists. Output: `mobile/android/app/build/outputs/apk/debug/app-debug.apk`. This is a development/testing APK, not a Play Store release; no signing keys are created.

### `clean.sh` — clean before sharing
Usage: `bash scripts/clean.sh` or `bash scripts/clean.sh -y`

Lists and then deletes (after you confirm; `-y` skips the question) only generated folders that exist: root and `mobile/` `node_modules`, `mobile/dist-web`, Android build folders (`mobile/android/build`, `app/build`, `.gradle`, `.cxx`), iOS `Pods` and `build`, and backend `bin` and `obj`. It never deletes source code, `.env` files, `local.properties` or `dotnet user-secrets`. Afterwards zip the folder to share it; the receiver runs `build.sh` to restore everything.

### Database setup (used by the backend)
```
sudo -u postgres psql -d postgres -f docs/database/sql/001_create_database.sql
cd backend
dotnet user-secrets set "Database:Username" "<user>"
dotnet user-secrets set "Database:Password" "<password>"
```
Verify with `psql -U <user> -d my_app_dev -f docs/database/sql/002_verify_database.sql`.

### npm shortcuts (project root)
`npm run dev`, `start`, `android`, `ios`, `dev:api`, `build:api`, `typecheck`, `test`, `build:android` call the same underlying tools; the scripts above add checks and the multi-step flows.

## Development Branch Strategy
Two permanent branches: **`master`** (development/integration; everyone merges here by PR after CI passes) and **`main`** (production; only the owner and authorized maintainers merge here). Work happens on `feature/*`, `bugfix/*`, `hotfix/*`, `refactor/*`, `docs/*` branches. Full rules: [DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md).

## Git Workflow
`git switch master && git pull` -> `git switch -c feature/<name>` -> commit with Conventional Commits -> push -> open a PR into `master`. See [DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md) and [docs/development/GIT_WORKFLOW.md](docs/development/GIT_WORKFLOW.md).

## Pull Request Process
1. Title in Conventional Commit form (checked by CI). 2. Fill in the PR template. 3. All required checks green. 4. Squash-merge into `master` (you may merge your own PR). 5. Maintainers promote `master` -> `main` with a merge commit. Details: [CONTRIBUTING.md](CONTRIBUTING.md).

## Code Review Policy
- PRs to `master`: CI must pass; a review is encouraged but not required.
- PRs to `main`: one approval from a code owner/maintainer, all conversations resolved, all production checks passing, merge restricted to maintainers by the ruleset.

## Automated CI/CD Pipeline
Workflows live in `.github/workflows/`. **They are written but have not yet been run on GitHub**, and repository rulesets/permissions still have to be configured by the owner ([docs/github/GITHUB_SETUP.md](docs/github/GITHUB_SETUP.md)).

| Workflow | Trigger | Purpose / result |
|---|---|---|
| `_quality.yml` (reusable) | called by the others | Mobile: `npm ci`, lockfile unchanged, typecheck, ESLint, Prettier, Jest, web build, `npm audit` (high+). Backend: restore, Release build, NuGet vulnerability check, EF migration validation (only when migrations exist). Config: `scripts/validate-config.sh`. API smoke: starts the API against a PostgreSQL service container and checks the three endpoints, then repeats with PostgreSQL unreachable to prove `/api/health` stays up and the database endpoint reports 503. |
| `ci.yml` | push to `feature/**`, `bugfix/**`, `hotfix/**`, `refactor/**`, `docs/**`; PRs to `master` | Quality gate plus PR-title check. PR runs validate the PR merged into `master`. |
| `master-checks.yml` | push to `master` | Re-validates the integrated code after every merge. |
| `production-checks.yml` | PRs to `main` | Rejects PRs not from `master`; full quality gate; release readiness (versions, changelog marker) and a release preview in the run summary. |
| `deploy-production.yml` | push to `main` | Quality gate, build artifacts, deploy job (skipped unless `DEPLOY_ENABLED=true`; fails on purpose until a real deploy step exists), then release. |
| `release.yml` | called by deploy-production; manual on `main` | Tag, GitHub Release, notes, changelog PR. Idempotent. |
| `codeql.yml` | push/PR on `master`/`main`, weekly | CodeQL for TypeScript and C#. |

Also: `dependabot.yml` (weekly updates for npm, NuGet, Actions), minimal workflow permissions, actions pinned to commit SHAs. Notes: the "End-to-end tests", backend unit tests and Android/iOS builds are **not** part of CI because they do not exist/are not configured yet.

## Code Quality Standards
TypeScript `strict`, ESLint (`@react-native` config), Prettier (`mobile/.prettierrc.js`), no `any`, no suppressed compiler errors. Backend: nullable reference types, async with `CancellationToken`, DTO contracts. See [docs/development/CODING_STANDARDS.md](docs/development/CODING_STANDARDS.md).

## Testing Instructions
```
npm test                                   # Jest (3 tests)
npm run typecheck && npm run lint --prefix mobile && npm run format:check --prefix mobile
dotnet build backend
bash scripts/api-smoke-test.sh http://localhost:5000 up   # with the API and PostgreSQL running
```
Current coverage is minimal: no backend unit tests, no authentication tests (no authentication exists), no end-to-end tests. See [docs/development/TESTING_GUIDE.md](docs/development/TESTING_GUIDE.md).

## Production Release Process
Merge `master` -> `main` -> pipeline builds, optionally deploys, then tags and publishes a GitHub Release. See [RELEASE_PROCESS.md](RELEASE_PROCESS.md).

## Semantic Versioning
`MAJOR.MINOR.PATCH`, computed from Conventional Commits (`feat` minor, `fix`/`perf`/`security`/`deps` patch, breaking major). First release `v1.0.0`. No release exists yet.

## Changelog
[CHANGELOG.md](CHANGELOG.md), updated through generated pull requests at release time.

## Deployment Instructions
No hosting target is configured yet. Current behavior and the owner tasks to enable deployment: [DEPLOYMENT.md](DEPLOYMENT.md).

## Rollback Procedure
[docs/deployment/ROLLBACK_PROCEDURE.md](docs/deployment/ROLLBACK_PROCEDURE.md) (not yet exercised: no production environment exists).

## Security Guidelines
No secrets in the repository, user-secrets/environment variables locally, GitHub Environments for production, Swagger only in Development. Reporting vulnerabilities: [SECURITY.md](SECURITY.md).

## Contribution Guidelines
[CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md).

## Code of Conduct
[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) (Contributor Covenant 2.1). The reporting contact is a placeholder the owner must fill in.

## Troubleshooting
[docs/development/TROUBLESHOOTING.md](docs/development/TROUBLESHOOTING.md), [docs/development/DEBUGGING.md](docs/development/DEBUGGING.md), [docs/development/NATIVE_DEVELOPMENT.md](docs/development/NATIVE_DEVELOPMENT.md).

## Support and Contact
Open a GitHub issue (bug report or feature request templates). Security issues: see [SECURITY.md](SECURITY.md). No other official contact has been supplied; the owner should add one here.

## Project status
**Completed and verified (actually run)**
- Mobile: `npm install`, typecheck, ESLint, Prettier check, 3 Jest tests, `npm run build:web`, `npm audit --audit-level=high` all pass; Vite dev server serves the app.
- Scripts: `release.sh` (version and notes logic, tested in temporary git repositories including duplicate-tag protection), `validate-config.sh` (pass and fail cases), `api-smoke-test.sh` (against mock servers), `clean.sh`, `build.sh`, `start-dev.sh`.
- Workflow files pass `actionlint` (syntax and expression checks).

**Written but Not Verified**
- Backend C# (never compiled in the authoring environment; a local `dotnet build` on a machine with .NET 10 has to confirm it) and the `.sql` scripts.
- GitHub Actions behavior on GitHub (no workflow has run), the ruleset JSON imports, and the release/changelog automation end to end.
- Browser rendering, Android emulator/APK, iOS.

**Pending manual GitHub configuration**: rulesets, roles, Environments, secrets/variables, security features, CODEOWNERS confirmation, Code of Conduct and Security contacts: see [docs/github/GITHUB_SETUP.md](docs/github/GITHUB_SETUP.md).

## Documentation
[docs/](docs/) holds setup, coding standards, git workflow, testing guide, troubleshooting, debugging, native development, APK build, browser development, API, database, decisions, deployment, rollback and GitHub setup.
