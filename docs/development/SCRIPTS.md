# Scripts reference

All scripts live in `scripts/`, are Bash scripts for Linux and macOS (Windows: Git Bash or WSL), and work from any directory because they locate the project root themselves. Run them with `bash scripts/<name>.sh` from the project root (or `./<name>.sh` from inside `scripts/`). Paths containing spaces are supported.

Recommended order for a new developer: `check-environment.sh` -> `build.sh` -> `start-dev.sh` (browser + API) or `start-app.sh` (Android). Use `clean.sh` before sharing the project.

| Script | Purpose | Changes files? |
|---|---|---|
| `check-environment.sh` | Report which required tools are installed | No (read-only) |
| `build.sh` | Install packages and build everything | Yes (creates `node_modules`, `bin`, `obj`) |
| `start-dev.sh` | Run the API and browser app, open the browser | No |
| `start-app.sh` | Run the Android app on a device or emulator | Builds the Android app |
| `build-android-debug.sh` | Build a debug APK | Yes (Gradle output) |
| `clean.sh` | Delete generated folders before sharing | Yes (deletes) |

## `check-environment.sh` — check the system
Usage: `bash scripts/check-environment.sh`

Reports, for each tool, `OK` with its version or `MISSING`: Node.js, npm, .NET SDK, Java, PostgreSQL (`psql`), `adb`, the Android SDK (looks for `ANDROID_HOME` / `ANDROID_SDK_ROOT`), and Xcode tools (macOS only; shows `N/A` elsewhere). It installs nothing and changes no settings, so it is safe to run at any time. Run it first and fix anything marked `MISSING` that you need:
- Node.js/npm and Java are needed for the mobile app (Java 17+ for Android).
- .NET 10 SDK is needed for the backend.
- PostgreSQL is needed for the database health endpoint.
- `adb` and the Android SDK are needed only for Android.

## `build.sh` — install packages and build
Usage: `bash scripts/build.sh` or `bash scripts/build.sh --android`

What it does, in order:
1. Checks that Node.js and npm exist (stops with an error if not).
2. Runs `npm install` in `mobile/` (installs `node_modules`).
3. Runs the TypeScript type-check.
4. If `dotnet` exists: `dotnet restore backend`, then `dotnet build backend`. If not, it prints a warning, skips the backend and lists it as skipped at the end.
5. On macOS with CocoaPods installed: runs `pod install` in `mobile/ios`.
6. With `--android`: also builds the Android debug APK (see `build-android-debug.sh`).

It stops at the first real failure. Re-running it is safe.

## `start-dev.sh` — API + browser app
Usage: `bash scripts/start-dev.sh` or `bash scripts/start-dev.sh --no-api`

What it does:
1. Runs `npm install` first only if `mobile/node_modules` is missing.
2. Starts the backend with `dotnet watch run` in Development mode at `http://localhost:5000` (Swagger at `http://localhost:5000/swagger`). If `dotnet` is missing it warns and continues without the API; `--no-api` skips the API on purpose.
3. Starts the browser app (React Native Web + Vite) at `http://localhost:5173`.
4. Waits until the browser app answers, then opens it in your default browser (`xdg-open` on Linux, `open` on macOS). If no opener exists it prints the URL.

Press `Ctrl+C` to stop; both the API and the browser app are shut down. The database needs a login first (see Database below), otherwise the Home screen shows the database as unavailable while the API itself stays healthy.

## `start-app.sh` — Android app
Usage: `bash scripts/start-app.sh`

Requirements: `ANDROID_HOME` set, `adb` and Java available. What it does:
1. Stops with a clear message if the Android SDK, `adb` or Java is missing.
2. Runs `npm install` first only if `mobile/node_modules` is missing.
3. Uses a connected device or running emulator. If none is found it starts the first emulator (AVD) it can find and waits for it to boot; if there is no AVD it stops with an error.
4. Sets up `adb reverse` for port 8081 so the app can reach Metro.
5. Starts Metro (the JavaScript bundler), then builds, installs and launches the app (`react-native run-android`).

Metro keeps running so the app can load code; press `Ctrl+C` to stop it. The emulator reaches your computer's API through `10.0.2.2` automatically; for a physical phone set `API_HOST_OVERRIDE` in `mobile/src/constants/config.ts`. The API is not started by this script; run `start-dev.sh` in another terminal (or `dotnet watch run` in `backend/`) if you want live API status in the app.

## `build-android-debug.sh` — debug APK
Usage: `bash scripts/build-android-debug.sh` (also `npm run build:android`)

Checks that `mobile/android/gradlew`, the Android SDK and Java exist (clear error if not), runs `./gradlew assembleDebug`, and confirms the file exists. Output: `mobile/android/app/build/outputs/apk/debug/app-debug.apk`. This is a development/testing APK, not a Play Store release; no signing keys are created.

## `clean.sh` — clean before sharing
Usage: `bash scripts/clean.sh` or `bash scripts/clean.sh -y`

Lists and then deletes (after you confirm; `-y` skips the question) only generated folders that exist: root and `mobile/` `node_modules`, `mobile/dist-web`, Android build folders (`mobile/android/build`, `app/build`, `.gradle`, `.cxx`), iOS `Pods` and `build`, and backend `bin` and `obj`. It never deletes source code, `.env` files, `local.properties` or `dotnet user-secrets`. Afterwards zip the folder to share it; the receiver runs `build.sh` to restore everything.

## Database setup (used by the backend)
```
sudo -u postgres psql -d postgres -f docs/database/sql/001_create_database.sql
cd backend
dotnet user-secrets set "Database:Username" "<user>"
dotnet user-secrets set "Database:Password" "<password>"
```
Verify with `psql -U <user> -d my_app_dev -f docs/database/sql/002_verify_database.sql`.

## npm shortcuts (project root)
`npm run dev`, `start`, `android`, `ios`, `dev:api`, `build:api`, `typecheck`, `test`, `build:android` call the same underlying tools; the scripts above add checks and the multi-step flows.
