# Troubleshooting

- **`dotnet: not found`**: install the .NET 10 SDK. Do not retarget the project to another framework.
- **Home shows "Unreachable"**: backend not running or wrong host. Emulator uses `10.0.2.2` automatically; a physical device needs `API_HOST_OVERRIDE` in `mobile/src/constants/config.ts`.
- **"Request timed out"**: firewall or wrong host/port.
- **Browser CORS error**: add the origin to the backend's allowed development origins.
- **Gradle "SDK location not found"**: set `ANDROID_HOME`.
- **Stale Metro cache**: `npx react-native start --reset-cache`.
- **Jest syntax error in a node_module**: add the package to `transformIgnorePatterns` in `mobile/jest.config.js`.
- More: `DEBUGGING.md`, `NATIVE_DEVELOPMENT.md`.
