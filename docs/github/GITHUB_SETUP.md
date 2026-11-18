# GitHub Setup (manual configuration)

**Nothing in this document is configured by the repository files.** Workflow YAML runs automatically once pushed, but repository settings, rulesets, roles and secrets exist only in GitHub and must be set by the repository owner. Status of every item is tracked in the checklist at the end.

## 1. Branches
1. Make sure both permanent branches exist: `master` (development) and `main` (production). If `main` does not exist, create it from the currently approved production-ready commit: `git push origin <commit>:refs/heads/main`.
2. Settings > General > Default branch: keep `master` so contributors land on the development branch (workflows in this repository work whichever default branch is chosen).
3. Settings > General > Pull Requests: allow **squash merging** and **merge commits**, disable rebase merging, enable "Automatically delete head branches". The rulesets below force squash on `master` and merge commits on `main`.
4. Settings > Actions > General: Workflow permissions = *Read repository contents permission*; enable "Allow GitHub Actions to create and approve pull requests" (needed for the changelog PR).

## 2. Rulesets (Settings > Rules > Rulesets > New ruleset > Import a ruleset)
Import the two files from `.github/rulesets/`:

| File | Name | Target | Key rules |
|---|---|---|---|
| `development-master.json` | Development Master Protection | `master` | PR required (0 approvals, squash only), required checks, no force push, no deletion, no bypass |
| `production-main.json` | Production Main Protection | `main` | PR required, 1 code-owner approval, stale approvals dismissed, conversations resolved, merge commits only, required checks (branch must be up to date), no force push, no deletion, **restrict updates** (only bypass actors can update `main`) |

Required status check names (they appear after the workflows have run once; if a name differs in the dropdown, edit the ruleset to match):
- `master`: `PR title`, `CI / Mobile`, `CI / Backend`, `CI / Config`, `CI / API smoke`
- `main`: `Source branch`, `Production / Mobile`, `Production / Backend`, `Production / Config`, `Production / API smoke`, `Release readiness`

### How production access is enforced
Approval count alone does not control who can merge. `main` is protected by the **Restrict updates** rule, so only actors on the ruleset's *bypass list* can update `main`, and the bypass mode is *pull request* (they can only act through a PR). Developers with Write access are not on the list and therefore cannot push to or merge into `main`. The imported file lists the **Admin** repository role. Notes:
- Personal (non-organization) repositories only have the Admin role available for this list. Add a maintainer by inviting them as a collaborator with **Admin**, which also gives them settings access; use an **organization** with a team (for example `production-maintainers`) as the bypass actor to separate production rights from admin rights.
- A PR author cannot approve their own PR. With a single maintainer, the owner merges their own production PR using the ruleset bypass ("Merge without waiting for requirements"); with two or more maintainers, one approves the other's PR.
- Add every maintainer to `.github/CODEOWNERS`, because `main` requires a code-owner approval.

## 3. Roles (permission matrix)
| Operation | Owner | Authorized maintainer | Developer |
|---|---|---|---|
| Create/push feature branch, open PR to master, merge into master | Yes | Yes | Yes (Write role) |
| Open PR to main | Yes | Yes | Yes |
| Approve production PR, merge into main | Yes | Yes (bypass list + CODEOWNERS) | No |
| Edit rulesets, add maintainers | Yes | Only if Admin | No |

Developers: invite as collaborators with the **Write** role. Never grant them Admin.

## 4. Security settings
Settings > Code security: enable Dependabot alerts and security updates, secret scanning with push protection, private vulnerability reporting, and code scanning (CodeQL runs from `.github/workflows/codeql.yml`; private repositories need GitHub Code Security).

## 5. Environments, secrets and variables
| Item | Where | Needed for |
|---|---|---|
| Environment `production` (required reviewers, branch `main` only) | Settings > Environments | Manual approval before deployment |
| Variable `DEPLOY_ENABLED` | Actions variables | Turns the deploy job on (leave unset until deployment is implemented) |
| Variable `PRODUCTION_HEALTH_URL` | Actions variables | Post-deploy health check |
| Hosting credentials (names depend on the hosting) | `production` environment secrets | Deployment |
| Secret `RELEASE_PR_TOKEN` (optional) | Actions secrets | Lets the changelog PR trigger CI |

No other secrets are needed. CI uses a throwaway PostgreSQL service container with no password.

## 6. Verification checklist (to be executed by the owner with a second test account)
Status: **NOT DONE**. These cannot be tested from the repository alone.

Permissions
- [ ] Developer account can create and push `feature/test-permissions`
- [ ] Developer can open a PR to `master` and merge it once checks pass
- [ ] Developer cannot push directly to `main` or `master`
- [ ] Developer cannot merge a `master` -> `main` PR and has no bypass option
- [ ] Owner can approve/merge `master` -> `main`
- [ ] Add a second maintainer (Admin or org team) and confirm they can merge production PRs
- [ ] Remove a maintainer and confirm access is gone

CI/CD
- [ ] A clean PR passes all checks; introduce a type error, a failing test and a build error in three throwaway PRs, each must block merging
- [ ] Pushing a commit to a PR starts new checks
- [ ] Merging to `master` starts "Master integration checks"
- [ ] Opening `master` -> `main` starts "Production checks"; a PR from another branch is rejected by "Source branch"
- [ ] Merging to `main` starts "Deploy production" and "Release"
- [ ] Merges to `master` never start "Deploy production"

Release
- [ ] First release creates `v1.0.0` and a GitHub Release pointing at the merge commit
- [ ] Re-running "Release" creates no duplicate tag
- [ ] With `DEPLOY_ENABLED=true` and the not-yet-implemented deploy step, the pipeline fails and no release is created
