# Android Debug APK

A **debug APK** is for development/testing only, not a Play Store release. No release signing or store upload is configured (the project uses the standard React Native `debug.keystore`).

```
npm install --prefix mobile
npm run build:android          # runs scripts/build-android-debug.sh
```
Manual equivalent: `cd mobile/android && ./gradlew assembleDebug`

Output: `mobile/android/app/build/outputs/apk/debug/app-debug.apk`

The script exits with a clear message if `mobile/android/gradlew`, the Android SDK (`ANDROID_HOME`) or Java is missing. A debug build loads JavaScript from Metro (`npm run start`), so keep Metro running (and use `adb reverse tcp:8081 tcp:8081` on a device) when launching it.
