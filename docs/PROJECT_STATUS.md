# Project Status

**Completed and verified (actually run)**
- Mobile: `npm install`, typecheck, ESLint, Prettier check, 3 Jest tests, `npm run build:web`, `npm audit --audit-level=high` all pass; Vite dev server serves the app.
- Scripts: `release.sh` (version and notes logic, tested in temporary git repositories including duplicate-tag protection), `validate-config.sh` (pass and fail cases), `api-smoke-test.sh` (against mock servers), `clean.sh`, `build.sh`, `start-dev.sh`.
- Workflow files pass `actionlint` (syntax and expression checks).

**Written but Not Verified**
- Android Java shell (`MainActivity.java`, `MainApplication.java`): converted from Kotlin; never compiled (no Android SDK or Maven access in the authoring environment). Run `bash scripts/build.sh --android` and report any errors.
- Backend C# (never compiled in the authoring environment; a local `dotnet build` on a machine with .NET 10 has to confirm it) and the `.sql` scripts.
- GitHub Actions behavior on GitHub (no workflow has run), the ruleset JSON imports, and the release/changelog automation end to end.
- Browser rendering, Android emulator/APK, iOS.

**Pending manual GitHub configuration**: rulesets, roles, Environments, secrets/variables, security features and adding any further maintainers to CODEOWNERS: see [docs/github/GITHUB_SETUP.md](github/GITHUB_SETUP.md).
