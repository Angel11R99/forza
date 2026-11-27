# Issue #145: HealthKit and Health Connect audit

## Evaluation (2026-11-27)

The `health` Flutter plugin 14.0.0 is compatible with the checked-in Flutter 3.50.1/Dart 3.14 toolchain. Its documented minimum is Flutter 3.44.0; it requires Android compile SDK 37, AGP 9.1+, Gradle 9.3.1+, Android min SDK 26, and iOS 15+. The repository already uses AGP 9.1.1 and Gradle 9.5; SDK 37.1 is installed in this workspace. The app now compiles Android with SDK 37 and min SDK 26. Health Connect itself is available on Android 9+ (API 28+) with its provider; older supported app devices can continue using FORZA without the connection.

HealthKit and Health Connect APIs have no per-call fee. The `health` package is distributed through pub.dev under the MIT license. Apple and Google platform review/privacy declarations still apply; these are not a substitute for an SDK license.

Sources:
- [health package README](https://pub.dev/packages/health)
- [Health Connect availability](https://developer.android.com/health-and-fitness/health-connect/availability)
- [Health Connect permissions and rationale](https://developer.android.com/health-and-fitness/health-connect/get-started)
- [Apple HealthKit privacy](https://developer.apple.com/documentation/healthkit/protecting-user-privacy)
- [Apple HealthKit authorization](https://developer.apple.com/documentation/healthkit/authorizing-access-to-health-data)

## Implemented in this branch

- Optional Profile > Connections > Health connections screen, Spanish and English, light and dark themes through the existing tokens/components. Until the iOS Runner is configured, iOS shows an explicit unavailable state and does not invoke HealthKit.
- Separate read-only selection for steps, weight, sleep sessions, and workouts; an in-app explanation precedes the platform permission prompt. No HealthKit/Health Connect write permissions, calorie permissions, workout routes, historical access, or background access are requested.
- Android Health Connect manifest permissions are limited to the selected record types. Steps also use Android Activity Recognition runtime permission. Health Connect SDK availability and each Android read permission are checked separately. On iOS, the UI explains that Apple does not disclose denied read permissions.
- Local Drift v13 storage, records and settings partitioned by guest/account scope, idempotent upsert keyed by platform/source/record identifier, timestamps normalized to UTC for ordering, and source platform/name shown in the UI. Import uses a rolling maximum of 30 days and overlaps the previous import by one day to pick up changes.
- Disconnect deletes the local records and preferences for the active account and invokes Health Connect permission revocation where supported. Apple Health permissions must be revoked in Apple Health settings.
- Health records are not included in Firestore or JSON backup exports. No health data is sent to analytics or third parties.
- Health connection settings use a dedicated table outside the Firestore watcher and all backup exports, so toggling a health option cannot trigger an unrelated cloud upload.
- Unit tests cover idempotent re-import, owner isolation, and per-owner deletion.
- The Android 16 emulator installed and launched the app. Health Connect onboarding and the Steps/Activity Recognition read permissions were granted; import returned zero records because the emulator has no health samples. The screen was inspected at 320 dp with 2x system text in light/en and dark/en+es; content remained scrollable and no Flutter overflow/crash appeared. Captures: [permission granted and empty import](evidence-145/android-health-connect-granted-empty.png), [light English top](evidence-145/android-320dp-2x-light-en-top.png), [light English scroll](evidence-145/android-320dp-2x-light-en-scroll.png), [dark English top](evidence-145/android-320dp-2x-dark-en-top.png), and [dark Spanish top](evidence-145/android-320dp-2x-dark-es-top.png).

## Remaining acceptance blockers

- iOS HealthKit cannot be enabled or validated here: this workspace is Windows and has no Swift or Xcode. The app's `Info.plist` usage descriptions and Runner HealthKit entitlement/capability have not been added. The project setup skill requires a Swift toolchain before any Xcode project configuration. Do not mark iOS as supported until this is configured on macOS and verified with an iOS device/simulator.
- The repository has no published privacy policy URL. Google Health Connect review requires the app to provide a privacy policy and a permission-usage rationale that routes to it; the native activity currently opens the app but no public policy destination exists. Publish/review that policy and complete the Play Console Health Connect declaration before production distribution.
- The emulator flow used an empty Health Connect store. It does not prove importing real health samples, multiple wearable sources, partial permission denial/revocation, or behavior across device vendors. Complete those manual cases and TalkBack validation before closing the issue.
- Imported records are currently stored and shown with provenance but are not yet consumed by nutrition/progress calculations or reconciled against manual entries. Integrate only when #138/#141 define the destination and conflict rules; manual entries remain untouched. Writing food/water data is not implemented.
- iOS behavior, VoiceOver, and store data declarations remain unverified. The issue must remain open/approved until these are addressed.
