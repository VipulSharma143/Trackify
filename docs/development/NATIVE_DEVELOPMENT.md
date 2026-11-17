# Native Development (Android and iOS)

`mobile/android` and `mobile/ios` are standard React Native community-CLI projects and are committed. Edit them directly when native changes are needed. Identifiers: Android `com.example.myapp`, iOS bundle id `com.example.myapp` (placeholders: change before any release). Android is locked to portrait; the iPhone is portrait only.

## Android
- Install Android Studio; in SDK Manager install an SDK Platform and Build-Tools; use JDK 17+.
- Set `ANDROID_HOME` (Linux `~/Android/Sdk`, macOS `~/Library/Android/sdk`) and add `platform-tools` to `PATH`.
- Emulator: Device Manager -> Create Device -> start it, then `npm run android`.
- Physical device: enable Developer options and **USB debugging**, connect, accept the prompt, check `adb devices`, then `adb reverse tcp:8081 tcp:8081`. For the API set `API_HOST_OVERRIDE` in `mobile/src/constants/config.ts` to your computer's LAN IP.
- The emulator reaches the host as `10.0.2.2` (handled by `src/platform/apiHost.android.ts`).

## iOS (macOS only)
- Install Xcode, open it once, accept the license, install a simulator runtime.
- `cd mobile && bundle install && cd ios && bundle exec pod install` (or `pod install`).
- `npm run ios`, or open `mobile/ios/MyApp.xcworkspace`.
- The simulator reaches the Mac as `localhost` (default `apiHost.ts`). A physical iPhone needs the LAN IP and an App Transport Security exception for plain HTTP in development.

## Platform-specific code
Metro and Vite pick `Name.android.ts`, `Name.ios.ts` or `Name.web.ts` before `Name.ts`. Current uses: `platform/apiHost.android.ts`, `assets/*/index.web.ts`.

## Troubleshooting
- "SDK location not found": set `ANDROID_HOME`.
- Stale cache: `npx react-native start --reset-cache`; Android clean: `cd mobile/android && ./gradlew clean`.
- Pods problems: `cd mobile/ios && pod install --repo-update`.
