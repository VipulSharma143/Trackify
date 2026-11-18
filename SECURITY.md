# Security Policy

## Supported versions
Only the latest release (the newest `vMAJOR.MINOR.PATCH` tag on `main`) receives security fixes. No release exists until the first production release is created.

## Reporting a vulnerability
**Do not open a public issue or pull request for a security problem.**

Report it privately by email to Vipul Sharma (repository owner): **vipulxharma@gmail.com**. You can also use GitHub's "Report a vulnerability" button on the repository's **Security** tab once private vulnerability reporting is enabled (Settings > Code security).

Please include: what is affected, steps to reproduce, the impact you expect, and any suggested fix. Do not include real credentials or personal data.

## What to expect
Maintainers aim to acknowledge reports promptly, confirm the issue, prepare a fix on a private branch when needed, release it through the normal production process ([RELEASE_PROCESS.md](RELEASE_PROCESS.md)) and credit the reporter if they wish. No response-time guarantee is promised.

## Security practices in this repository
- Secrets are never committed. Local secrets use `dotnet user-secrets` or environment variables; CI/production secrets use GitHub Secrets and the `production` Environment. `scripts/validate-config.sh` fails CI if a database username/password or connection string is committed.
- `.env.example` lists every backend environment variable without values.
- GitHub Actions use minimal `permissions`, and third-party actions are pinned to full commit SHAs.
- Automated checks: `npm audit` (high/critical fail), `dotnet list package --vulnerable`, CodeQL (TypeScript and C#), Dependabot updates.
- Swagger is enabled only in the Development environment. Production CORS allows only configured origins.
- API errors never return stack traces, connection strings or exception messages.

## Repository settings the owner must enable (not set by code)
Secret scanning and push protection, Dependabot alerts, private vulnerability reporting, and the rulesets in [docs/github/GITHUB_SETUP.md](docs/github/GITHUB_SETUP.md).
