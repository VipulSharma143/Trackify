# Changelog

All notable changes to this project are documented here.

Release entries are generated from Conventional Commits by the release workflow and added through a pull request (see [RELEASE_PROCESS.md](RELEASE_PROCESS.md)). Historical entries are kept; do not rewrite them. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

## [Unreleased]

No production release has been created yet. The first release will be `v1.0.0`.

<!-- release-entries -->

## Pre-release foundation work (before v1.0.0)

### Added
- Documentation set, AGENTS.md/CONTRIBUTING.md, `.gitignore`, `.editorconfig`.
- `mobile/`: plain React Native 0.88 (community CLI) TypeScript app with committed `android/` and `ios/` projects (`com.example.myapp`, portrait), no Expo.
- Browser preview with react-native-web + Vite (`mobile/web/`).
- Theme tokens, shared components, Home/Settings/About screens, React Navigation (native-stack) with web deep links.
- API client (`fetch` with timeout), health/system services, `useApiHealth` hook, live status on Home.
- Platform-specific files: `platform/apiHost.android.ts`, `assets/*/index.web.ts`; PNG logo and status icons.
- Jest tests (`__tests__/`).
- `backend/`: ASP.NET Core (.NET 10) API source with `/api/health`, `/api/health/database`, `/api/system/info`, EF Core + Npgsql context, CORS, Swagger, exception middleware. **Not compiled or run.**
- `docs/database/sql/` create/verify scripts (not run).
- `scripts/build.sh`, `clean.sh`, `start-dev.sh`, `start-app.sh`.
- Root `package.json` scripts, `scripts/check-environment.sh`, `scripts/build-android-debug.sh`.

### Changed
- Browser preview port is now 5173 (Metro keeps 8081); backend CORS origin updated.
- Replaced the earlier Expo-based mobile project with plain React Native.

### Added (CI/CD and repository workflow)
- GitHub Actions: reusable quality gate, `ci.yml`, `master-checks.yml`, `production-checks.yml`, `deploy-production.yml`, `release.yml`, `codeql.yml`; Dependabot; CODEOWNERS; PR and issue templates.
- Importable ruleset definitions for `master` and `main` in `.github/rulesets/`.
- `scripts/release.sh`, `scripts/validate-config.sh`, `scripts/api-smoke-test.sh`; `.env.example`.
- Documentation: CODE_OF_CONDUCT, SECURITY, DEVELOPMENT_WORKFLOW, RELEASE_PROCESS, DEPLOYMENT, docs/github/GITHUB_SETUP, docs/deployment/ROLLBACK_PROCEDURE.
- Mobile `lint`, `format`, `format:check` scripts; ESLint ignores generated folders.

### Changed
- Mobile source formatted with Prettier.
