# AGENTS.md — Root instructions for all AI coding agents

**Read this file in full before changing any code.** Also read the nearest nested `AGENTS.md` (`mobile/AGENTS.md`, `backend/AGENTS.md`) for the area you touch.

## Fixed technology decisions
| Layer | Choice |
|---|---|
| Mobile | React Native (community CLI, **no Expo**) + TypeScript; browser preview via React Native Web + Vite |
| Backend | ASP.NET Core Web API, C#, .NET 10 LTS |
| Database | PostgreSQL only, via EF Core + Npgsql |
| Communication | REST + JSON (HTTPS in production) |
| Repository | Single monorepo (mobile, backend, docs, scripts) |

If the .NET 10 SDK is unavailable, stop and report it. Never silently downgrade the target framework or change a fixed technology.

## Language rules
- Mobile application source is **TypeScript only**: UI in `.tsx`, logic in `.ts`. No `.js`/`.jsx` app source. Tool-required config files may be JS.
- Backend application code is **C#**. SQL scripts are `.sql`. Docs are Markdown.
- No MongoDB, SQLite, MySQL, SQL Server. No second database.

## Architecture boundaries
- Backend is a modular monolith. No microservices.
- Controllers are thin; business logic lives in services.
- API contracts use DTOs; never return EF Core entities.
- Use async I/O and `CancellationToken`.
- Do not create empty folders/classes just to match a diagram.

## Dependency discipline
- Add a dependency only if the current phase requires it, and explain why in the phase report.
- Forbidden unless requested: Redux, Zustand, TanStack Query, Firebase, auth libraries, UI kits, analytics.
- Do not invent versions; let the package manager resolve and write lockfiles.

## Security and secrets
- Never commit secrets, passwords, tokens, signing keys or real connection strings.
- Use environment variables or .NET user-secrets locally.
- Nothing secret in `EXPO_PUBLIC_*` variables.
- CORS: explicit known origins only; no unrestricted production CORS.
- Never expose internal exception details to API clients or UI.

## Testing and honesty
- Run the relevant build/typecheck/test before reporting.
- Never claim a build or test passed unless it was executed and passed. Mark unrun items **Not Verified** or **Blocked**.
- A created file is not a completed task.

## Documentation
After each phase: update `README.md` status and `CHANGELOG.md`; update docs affected by the change. Phase report lists files created/modified, packages added and why, commands run, actual results, limitations.

## Git and collaboration
- Work phase by phase, in order; do not start the next phase until acceptance criteria are met or blockers are documented.
- Commit only if the user has authorized it.
- Branches: `master` is development, `main` is production (maintainers only). Never push to either directly; use `feature/*`, `bugfix/*`, `hotfix/*`, `refactor/*`, `docs/*` branches and pull requests with Conventional Commit titles. See `DEVELOPMENT_WORKFLOW.md`.
- Never weaken CI to make it pass: do not disable tests, lint rules or type checks, and do not change GitHub rulesets or workflow permissions without explicit approval.
- Multiple agents: assign non-overlapping files; no concurrent edits to the same file.
- Do not delete files or reset databases without explicit approval. Do not overwrite existing user work.

## Out of scope (do not implement)
Authentication, registration, user management, payments, chat, push notifications, file uploads, analytics, business modules, cloud hosting configuration, microservices. (CI/CD workflows and release automation exist in `.github/`; change them only as part of a CI/CD task.)
