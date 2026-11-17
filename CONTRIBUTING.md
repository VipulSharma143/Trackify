# Contributing

Thank you for contributing. Read [AGENTS.md](AGENTS.md) first; it also applies to AI coding agents. By participating you agree to the [Code of Conduct](CODE_OF_CONDUCT.md).

## Ground rules
- Work on a branch and open a pull request. Never push to `master` or `main` directly.
- Keep each PR focused. Do not mix unrelated changes.
- Do not add dependencies, features or files that are not needed for the task.
- Never commit secrets, credentials, real connection strings or `.env` files. See [SECURITY.md](SECURITY.md).

## Branch names
`<type>/<short-kebab-description>` with type `feature`, `bugfix`, `hotfix`, `refactor` or `docs`. Example: `feature/login-system`.

## Commit messages and PR titles (Conventional Commits)
`<type>(<scope>): <summary>` in the imperative, at most 72 characters.
- Types: `feat`, `fix`, `perf`, `security`, `deps`, `docs`, `refactor`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
- Scopes: `mobile`, `backend`, `db`, `docs`, `scripts`, `ci`, `repo`.
- Breaking change: add `!` after the type or a `BREAKING CHANGE:` footer.
- The PR title is checked by CI because it becomes the squash commit and decides the next version ([RELEASE_PROCESS.md](RELEASE_PROCESS.md)).

## Pull requests
1. Fill in the PR template.
2. All required checks must pass before merging into `master`. Fix failures; do not disable tests, relax lint rules or suppress type errors to get a green build.
3. Resolve review conversations. You may merge your own PR into `master` after CI passes (Squash and merge).
4. Only maintainers promote `master` to `main`.

## Testing before you push
```
npm ci --prefix mobile && npm run typecheck && npm run lint --prefix mobile && npm run format:check --prefix mobile && npm test
dotnet build backend
bash scripts/validate-config.sh
```
Add or update tests for the behavior you change. The current automated tests are small: 3 Jest tests for the mobile app and an API smoke script; there are no backend unit tests, integration test suite or end-to-end tests yet.

## Avoiding conflicts
Rebase or merge `master` into your branch before opening a PR, keep PRs short-lived, and agree on file ownership when several people (or agents) work in the same area. Never force-push shared branches.

## Documentation
Update the README and relevant docs in the same PR when behavior, setup or configuration changes. Update `.env.example` for any new environment variable. `CHANGELOG.md` is generated at release time; do not edit it by hand.

More: [DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md), [docs/development/CODING_STANDARDS.md](docs/development/CODING_STANDARDS.md).
