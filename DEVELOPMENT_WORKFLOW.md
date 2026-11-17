# Development Workflow

This is the day-to-day guide for contributing code. See [CONTRIBUTING.md](CONTRIBUTING.md) for rules and [RELEASE_PROCESS.md](RELEASE_PROCESS.md) for how code reaches production.

## Branches
| Branch | Purpose | Who can change it |
|---|---|---|
| `master` | Shared development/integration branch | Everyone with Write access, **through pull requests only**, after CI passes |
| `main` | Production branch | Repository owner and authorized maintainers only, through a `master` -> `main` PR |
| `feature/<name>`, `bugfix/<name>`, `hotfix/<name>`, `refactor/<name>`, `docs/<name>` | Short-lived work branches | Their author |

No other permanent branches exist. Delete work branches after merging.

## Step by step
1. Update master: `git switch master && git pull`
2. Create a branch: `git switch -c feature/<name>`
3. Work in small commits using Conventional Commits, for example `feat(mobile): add settings screen`, `fix(backend): return 503 when the database is down`.
4. Run the checks locally before pushing (same as CI):
   ```
   npm ci --prefix mobile
   npm run typecheck
   npm run lint --prefix mobile
   npm run format:check --prefix mobile      # fix with: npm run format --prefix mobile
   npm test
   npm run build:web --prefix mobile
   dotnet build backend
   bash scripts/validate-config.sh
   ```
5. Push the branch: `git push -u origin feature/<name>` (CI runs on every push).
6. Open a pull request into `master`. **The PR title must follow Conventional Commits** because it becomes the squash-merge commit message and drives versioning.
7. When all required checks pass, you may merge your own PR into `master` using **Squash and merge**. Fix failures instead of bypassing them.
8. After the merge, "Master integration checks" run again on `master`.

## Commit types and versions
| Type | Release effect |
|---|---|
| `feat` | minor version |
| `fix`, `perf`, `security`, `deps` | patch version |
| `type!:` or a `BREAKING CHANGE:` footer | major version |
| `docs`, `refactor`, `test`, `build`, `ci`, `chore`, `style` | no release by themselves |

## Promoting to production
Only authorized maintainers do this: open a PR from `master` to `main` (merge method **Create a merge commit**, never squash). See [RELEASE_PROCESS.md](RELEASE_PROCESS.md).

## Hotfixes
Branch from `master` (`hotfix/<name>`), fix, merge to `master` through the normal PR, then promote to `main` as above. There is no separate fast path to production.

## Required checks at a glance
| Where | Checks |
|---|---|
| PR to `master` | PR title, CI / Mobile, CI / Backend, CI / Config, CI / API smoke |
| PR `master` -> `main` | Source branch, Production / Mobile, Backend, Config, API smoke, Release readiness |

Details of each workflow: [README](README.md#automated-cicd-pipeline).
