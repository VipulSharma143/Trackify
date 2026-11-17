# Rollback Procedure

No production environment exists yet, so this procedure has never been exercised. Adapt it once the hosting is chosen ([DEPLOYMENT.md](../../DEPLOYMENT.md)).

## 1. Decide
If a release is broken, roll back first, investigate afterwards. Confirm with `/api/health` (API) and `/api/health/database` (database).

## 2. Application rollback
1. Find the last good release tag on the GitHub Releases page (for example `v1.2.0`).
2. Redeploy that version: re-run the deployment with the artifact of that commit (workflow artifacts `production-<sha>` are kept 30 days), or check out the tag and build it.
3. Verify the health endpoints and the main user flows.
4. Do **not** delete or move release tags. Fix forward by merging a `fix:` commit through `master` and `main`; the next release gets a new patch version.

## 3. Reverting code
If the broken change is still in `main`, create a revert commit on `master` (`git revert <commit>`), merge it by PR, then promote `master` to `main` normally. Never force-push `main`.

## 4. Database rollback
- Before every production migration: `pg_dump -Fc -h <host> -U <user> -d <database> -f backup-<date>.dump` and store it safely.
- Prefer backward-compatible migrations so rolling the application back does not require a database rollback.
- If a migration must be undone: restore into a new database with `pg_restore`, or apply a reviewed reverse script. Test the restore on a copy first. Never run destructive scripts against production without approval.

## 5. Afterwards
Write down what happened, add a test or check that would have caught it, and update this document.
