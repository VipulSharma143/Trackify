# Git Workflow

The complete workflow is in [DEVELOPMENT_WORKFLOW.md](../../DEVELOPMENT_WORKFLOW.md). Summary:

- `master` is the development/integration branch; `main` is production only.
- Work on `feature/*`, `bugfix/*`, `hotfix/*`, `refactor/*`, `docs/*` branches and merge to `master` by pull request (squash) after CI passes.
- Only maintainers merge `master` into `main` (merge commit). Production releases are created automatically from `main`.
- Conventional Commits; no force-push; never commit secrets or build output.
