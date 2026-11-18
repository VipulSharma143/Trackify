# Getting Started

From zero to a running app. Helper scripts are described in [SCRIPTS.md](SCRIPTS.md); configuration details in the sections below.

## Prerequisites
Node.js >= 22.11 and npm, .NET 10 SDK, PostgreSQL, Java 17+ (Android), Android Studio (Android), Xcode + CocoaPods (iOS, macOS only), `jq` and `curl` (for `scripts/validate-config.sh` and `scripts/api-smoke-test.sh`). Check your machine: `bash scripts/check-environment.sh`.

## Installation
```
git clone https://github.com/VipulSharma143/Trackify.git
cd Trackify
bash scripts/build.sh        # npm install, type-check, dotnet restore + build
```

## Local development setup
1. Create the database: `sudo -u postgres psql -d postgres -f docs/database/sql/001_create_database.sql`
2. Give the API its database login (stored outside the repo):
   ```
   cd backend
   dotnet user-secrets set "Database:Username" "<user>"
   dotnet user-secrets set "Database:Password" "<password>"
   ```
3. Verify with `psql -U <user> -d my_app_dev -f docs/database/sql/002_verify_database.sql`.

## Environment variables
The backend reads configuration from `appsettings*.json`, user-secrets and environment variables. All variables are listed in [`.env.example`](../../.env.example) (no values): `Database__Host`, `Database__Port`, `Database__Database`, `Database__Username`, `Database__Password`, `Cors__AllowedOrigins__N`, `ASPNETCORE_ENVIRONMENT`, `ASPNETCORE_URLS`. The mobile app has no environment variables; its API address is in `mobile/src/constants/config.ts` (set `API_HOST_OVERRIDE` for a physical device). Never commit real values.

## Running the application
```
bash scripts/start-dev.sh    # API (http://localhost:5000/swagger) + browser app (http://localhost:5173)
bash scripts/start-app.sh    # Android app (needs the Android SDK)
npm run ios                  # iOS, macOS only (cd mobile/ios && pod install first)
```

Next: [Development workflow](../../DEVELOPMENT_WORKFLOW.md) · [Troubleshooting](TROUBLESHOOTING.md)
