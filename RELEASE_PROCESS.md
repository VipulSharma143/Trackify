# Release Process

## Versioning
Semantic Versioning `MAJOR.MINOR.PATCH` with tags `vMAJOR.MINOR.PATCH`:
- `MAJOR` breaking changes, `MINOR` new features, `PATCH` fixes.
- The first release is `v1.0.0`. Versions are computed automatically from Conventional Commits by `scripts/release.sh`; nobody picks a version by hand.
- Only `feat`, `fix`, `perf`, `security`, `deps` and breaking commits create a release. If none exist since the last tag, no release is made.

## How a release happens
1. Maintainers open a PR `master` -> `main`. The **Production checks** workflow runs the full quality gate and shows a *release preview* (next version and notes) in the run summary.
2. An authorized maintainer approves and merges it using **Create a merge commit** (squashing would hide the individual commit types from the version calculation).
3. The merge to `main` starts **Deploy production**: quality gate, build artifacts, deploy (only if `DEPLOY_ENABLED` is `true`, see [DEPLOYMENT.md](DEPLOYMENT.md)), then the **Release** workflow.
4. **Release** (`.github/workflows/release.yml`):
   - computes the version and notes with `scripts/release.sh`,
   - creates the git tag and the GitHub Release (notes grouped: Breaking Changes, Added, Fixed, Security, Performance, Dependencies, Changed, Documentation, with commit and PR references),
   - opens a PR into `master` that adds the entry to `CHANGELOG.md` (branch `docs/changelog-vX.Y.Z`).
5. Merge the changelog PR into `master` (if its checks did not start, close and reopen it; see below).

## Safety guarantees
- Tags are created only from `main` and never twice: the workflow does nothing if the commit already has a release tag, errors if the computed tag exists elsewhere, and skips an existing GitHub Release. Re-running it is safe.
- A release is **not** created if the quality gate, the build or an enabled deployment fails.
- Feature branches and `master` never create releases or deployments.

## Manual run
Actions > Release > Run workflow on `main` (for example after fixing a failed run).

## Changelog PR note
Pull requests opened by the default `GITHUB_TOKEN` do not start other workflows. Either close and reopen the changelog PR, or create a fine-grained personal access token with *Contents* and *Pull requests* write access and save it as the repository secret `RELEASE_PR_TOKEN`.

## Commit and label conventions
Release categories come from Conventional Commit types (squash-merged PR titles are checked by CI). Suggested PR labels for triage: `feature`, `bugfix`, `breaking-change`, `documentation`, `security`, `performance`, `refactor`, `dependencies`.

## Rollback
See [docs/deployment/ROLLBACK_PROCEDURE.md](docs/deployment/ROLLBACK_PROCEDURE.md).
