# CI/CD Pipeline

Workflows live in `.github/workflows/`. **They are written but have not yet been run on GitHub**, and repository rulesets/permissions still have to be configured by the owner ([docs/github/GITHUB_SETUP.md](../github/GITHUB_SETUP.md)).

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

Related: [Release process](../../RELEASE_PROCESS.md) · [Deployment](../../DEPLOYMENT.md) · [GitHub setup](../github/GITHUB_SETUP.md)
