# Debugging

| Topic | How |
|---|---|
| Browser (Vite) | Browser DevTools console and network tab; app at `http://localhost:5173`. |
| Metro logs | Printed in the terminal running `npm run start`; press `r` to reload. |
| React Native logs | `console.log` appears in the Metro terminal; open React Native DevTools with `j`. |
| Android Logcat | `adb logcat *:E` or `adb logcat | grep ReactNativeJS`; or Android Studio Logcat. |
| Gradle build errors | Re-run `cd mobile/android && ./gradlew assembleDebug --stacktrace`; check SDK/JDK versions. |
| .NET logs / breakpoints | Console output of `npm run dev:api`; attach a debugger in VS / Rider / VS Code C# Dev Kit. |
| Swagger testing | `http://localhost:5000/swagger` in Development. |
| PostgreSQL connection errors | Check the server is running, host/port, credentials from user-secrets/env vars, `psql` login. Run `docs/database/sql/002_verify_database.sql`. |
| CORS issues | Browser console shows blocked origin; add the web origin to the backend's configured development origins. |
| Android emulator networking | The host is `10.0.2.2`, not `localhost`. |
| Physical device networking | Use the computer's LAN IP; same network; allow the port in the firewall. |
| iOS simulator / Xcode | Simulator reaches the Mac via `localhost`; use Xcode's console and debug navigator for native logs. |
