# HelloApp

Minimal Android app (Kotlin + Jetpack Compose): a counter with a button.
It is a starting point you can build on your phone.

## Build it on your phone

Use an on-device IDE. Open this `helloapp` folder as a project, let it sync,
then build the APK.

- **Code on the Go (CoGo)** — recommended. Android 9+, supports 32-bit and
  64-bit ARM, AGP 7.3→9.3. Get it only from https://appdevforall.org
- **AndroidIDE** — alternative, but archived (no more updates). Supports
  32-bit ARM, up to AGP 8.2.x. Get it only from https://androidide.com or its
  GitHub releases / F-Droid.

Expected output path:

```
app/build/outputs/apk/debug/app-debug.apk
```

On the phone's 2.9 GB of free storage, run a `clean` between builds and keep
the Gradle cache to one version.

## Toolchain versions

- Android Gradle Plugin **8.2.2** (fits both on-device IDEs; also works in
  Android Studio).
- Gradle **8.5**, Kotlin **1.9.24**, Compose Compiler **1.5.14**, compileSdk 34,
  minSdk 24.
- Build without the Gradle wrapper is easiest on-device (the IDE uses its own
  Gradle). On a desktop, `gradle wrapper` then `./gradlew assembleDebug`.

## Desktop alternative

Open the folder in Android Studio and press Run, or on the command line with
JDK 17 + Android SDK:

```bash
gradle wrapper --gradle-version 8.5
./gradlew assembleDebug
```

## Security defaults already applied

- `android:allowBackup="false"` in the manifest.
- `res/xml/backup_rules.xml` and `res/xml/data_extraction_rules.xml` exclude
  SharedPreferences from cloud backup and device transfer.

When the app stores API keys, use `androidx.security:security-crypto`
(`EncryptedSharedPreferences`) instead of plain `SharedPreferences`.
