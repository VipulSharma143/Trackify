# Trackify

Cross-platform mobile app (Android, iOS, browser) with an ASP.NET Core API and PostgreSQL.
**Foundation stage: no product features yet.**

## Quick start
```bash
git clone https://github.com/VipulSharma143/Trackify.git
cd Trackify
bash scripts/check-environment.sh   # see which tools are installed
bash scripts/build.sh               # install packages, type-check, build the API
bash scripts/start-dev.sh           # API http://localhost:5000/swagger + app http://localhost:5173
```
Database login and other first-time setup: [Getting started](docs/development/GETTING_STARTED.md).

## About
**Purpose:** a clean, runnable, verifiable base to build features on. **Includes:** one React Native codebase for Android, iOS and the browser, sample screens, a REST API with health/system endpoints and Swagger, PostgreSQL via EF Core, helper scripts, CI/CD and release automation.
**Not included yet:** authentication, payments, chat, notifications, analytics, file uploads ([planned features](FUTURE_FEATURES.md)).

## Getting started
[Prerequisites](docs/development/GETTING_STARTED.md#prerequisites) · [Installation](docs/development/GETTING_STARTED.md#installation) · [Local setup](docs/development/GETTING_STARTED.md#local-development-setup) · [Environment variables](docs/development/GETTING_STARTED.md#environment-variables) · [Running the app](docs/development/GETTING_STARTED.md#running-the-application) · [Scripts](docs/development/SCRIPTS.md) · [Troubleshooting](docs/development/TROUBLESHOOTING.md)

## Technology and architecture
React Native + TypeScript (React Native Web + Vite for the browser) · ASP.NET Core Web API (C#, .NET 10) · PostgreSQL, EF Core, Npgsql · REST/JSON · GitHub Actions.

```
.github/   workflows, rulesets, templates      mobile/    React Native app (+ android/, ios/, web/)
backend/   ASP.NET Core API                    docs/      all detailed documentation
scripts/   build, start, clean, release, ...
```
[Architecture and versions](docs/architecture/SYSTEM_ARCHITECTURE.md) · [Project structure](docs/architecture/PROJECT_STRUCTURE.md) · [Design decisions](docs/decisions/ARCHITECTURE_DECISIONS.md) · [API](docs/api/API_DOCUMENTATION.md) · [Database](docs/database/DATABASE_SCHEMA.md)

## Development workflow
Two branches: `master` (development, merge by pull request after CI) and `main` (production, maintainers only).
[Branch strategy](DEVELOPMENT_WORKFLOW.md#branches) · [Git workflow](DEVELOPMENT_WORKFLOW.md#step-by-step) · [Pull requests](CONTRIBUTING.md#pull-requests) · [Code review](DEVELOPMENT_WORKFLOW.md#code-review-policy) · [Contributing](CONTRIBUTING.md) · [Native development](docs/development/NATIVE_DEVELOPMENT.md)

## Quality, testing and CI/CD
[Coding standards](docs/development/CODING_STANDARDS.md) · [Testing guide](docs/development/TESTING_GUIDE.md) · [CI/CD pipeline](docs/development/CI_CD.md) · [GitHub setup](docs/github/GITHUB_SETUP.md)

## Releases and deployment
Versions follow [Semantic Versioning](RELEASE_PROCESS.md#versioning) and are created automatically from Conventional Commits.
[Release process](RELEASE_PROCESS.md) · [Changelog](CHANGELOG.md) · [Deployment](DEPLOYMENT.md) · [Rollback](docs/deployment/ROLLBACK_PROCEDURE.md)

## Security and community
[Security policy](SECURITY.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · [Contributing](CONTRIBUTING.md) · [AI agent rules](AGENTS.md)

## Status and support
Mobile app checks pass; the backend, the GitHub workflows and the GitHub settings are written but not yet verified. Details: [Project status](docs/PROJECT_STATUS.md) · [All documentation](docs/README.md).
Questions and bugs: open a GitHub issue (templates provided). Contact: Vipul Sharma, vipulxharma@gmail.com. Security issues: [SECURITY.md](SECURITY.md).
