# Development Setup

## Prerequisites
- Node.js >= 22.11 and npm
- .NET 10 SDK (backend)
- PostgreSQL (database)
- Android Studio + JDK 17+ (Android); Xcode + CocoaPods on macOS (iOS)

Run `bash scripts/check-environment.sh` to see what is installed.

## Helper scripts
`scripts/build.sh`, `start-dev.sh`, `start-app.sh`, `clean.sh` (see README). `clean.sh` removes only generated folders, so the project can be shared as source.

## Mobile
```
npm install --prefix mobile
npm run typecheck
npm test
npm run dev            # browser preview, http://localhost:5173
npm run android        # needs emulator/device + Android SDK
npm run ios            # macOS only (run `cd mobile/ios && pod install` first)
```

## Backend
```
cd backend
dotnet restore
dotnet user-secrets set "Database:Password" "<your local password>"
dotnet user-secrets set "Database:Username" "<your local user>"
dotnet watch run       # http://localhost:5000/swagger
```
Or from the repo root: `npm run dev:api`, `npm run build:api`.

## Database
Create the database with `docs/database/sql/001_create_database.sql`, verify with `002_verify_database.sql`.
Secrets only via user-secrets or environment variables (`Database__Password`).

## EF Core migrations
Install once: `dotnet tool install --global dotnet-ef`. After adding entities: `dotnet ef migrations add <Name> --project backend`, review the generated SQL, then `dotnet ef database update --project backend`. Never apply destructive migrations without approval. No entities exist yet, so no migration exists.
