# Testing Guide

Automated tests: `npm test` (Jest: utility tests plus an App render test). Further verification is by the checks below.

## Mobile
1. `npm install --prefix mobile`
2. `npm run typecheck` — must print no errors.
3. `npm run dev` — open `http://localhost:5173`; check Home, Settings, About, navigation and narrow/wide window layouts.
4. Stop the backend and confirm Home shows error states; start it and confirm statuses turn green.
5. Optional web bundle check: `npm run build:web --prefix mobile`.

## Backend (needs .NET 10 SDK)
`dotnet restore`, `dotnet build`, `dotnet run`; open Swagger; call the three endpoints; stop PostgreSQL and confirm `/api/health` stays 200 while `/api/health/database` reports an outage.

## Database
Run `docs/database/sql/002_verify_database.sql` with `psql`.

## Android / iOS
Emulator/simulator launch and APK build per `NATIVE_DEVELOPMENT.md` and `ANDROID_APK_BUILD.md`.
