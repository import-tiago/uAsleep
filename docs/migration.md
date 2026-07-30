# Migration from 1.x to 2.0

## Starting point

The legacy state remains available in Git history at commit `1489f45`. Before
the migration, the Dart sources, translations, manifests, Gradle and Xcode
projects, assets, permissions, identifiers, and lockfile were audited.
Legacy interface captures are retained under `docs/images/legacy/`.

The original project used:

- Flutter 1.5.4-hotfix.2 and Dart 2.3.0;
- Dart `>=2.1.0 <3.0.0` without null safety;
- `bloc_pattern`, RxDart, Singleton, and mutable global state;
- persistence in `DataPersistence.txt`;
- JSON translations stored in files with a `.js` extension;
- Android API 21/28, Gradle 4.10.2, and AGP 3.2.1;
- iOS 8.0 and the placeholder bundle ID `com.example.uasleep`;
- the default counter test, unrelated to the product.

The legacy source cannot run on the current toolchain because Dart 3 requires
null safety. Its calculation behavior was characterized before refactoring.

## Formula and corrections

Version 1.x calculated over a 3,600,000 ms window:

```text
activeTimePerHour = wakeupsPerHour × activeDuration
sleepTimePerHour = oneHour - activeTimePerHour
averageCurrent =
  (activeCurrent × activeTimePerHour +
   sleepCurrent × sleepTimePerHour) / oneHour
batteryLifeHours = batteryCapacityMah / averageCurrentMa
```

Version 2.0 expresses the same relationship per cycle. It also:

- rejects active durations longer than a complete cycle instead of producing
  negative sleep time;
- rejects zero or negative capacity, negative current, non-positive frequency
  or duration, NaN, infinity, and zero average current;
- displays valid estimates of one hour or less;
- separates calculation from presentation formatting;
- removes the dead `ns` duration option while retaining `nA` current support.

Tests document equivalence for a manually verified 60-second duty cycle.

## Dependencies

Removed:

- `bloc_pattern`
- `rxdart`
- `flutter_email_sender`
- `cupertino_icons`

Added or updated:

- `flutter_bloc` and `bloc_test`
- `equatable`
- `shared_preferences`
- `url_launcher`
- `package_info_plus`
- `intl` and `flutter_localizations`
- `path_provider`, limited to one-time migration of 1.x data
- `flutter_lints`, `flutter_launcher_icons`, and `integration_test`

Runtime packages now live under `dependencies`.

## Persistence

Language, precision, and theme preferences use `SharedPreferencesAsync`
through `SettingsRepository`. On first startup, the old file is read
tolerantly, imported, and marked as migrated. A missing or corrupt legacy file
does not prevent startup, and the source file is never deleted.

## Android

- Scaffolding regenerated with Flutter 3.44.8.
- `namespace` and `applicationId` standardized as `br.uasleep`.
- Compile/target SDK 36 and minimum SDK 24.
- Gradle 9.1.0, AGP 9.0.1, and Kotlin 2.3.20.
- Java/Kotlin bytecode target 17.
- Current Flutter embedding with a Kotlin `MainActivity`.
- Product name and icon preserved.
- No production permissions added.
- Release signing reads `key.properties` only when it exists.

The minimum SDK was raised because API 24 is the minimum supported by the
current Flutter template.

## iOS

- Current Swift scaffolding with `AppDelegate` and `SceneDelegate`.
- Bundle identifier corrected to `br.uasleep`.
- Deployment target raised to iOS 13.0.
- Product name and icon preserved.
- No unnecessary permission descriptions.

The project was modernized on Windows. iOS compilation, signing, and runtime
validation still require macOS and Xcode.

## UI, accessibility, and localization

The interface was rebuilt with Material 3, centralized theme and spacing
tokens, constrained widths, adaptive layouts, `SafeArea`, scrolling, light and
dark themes, large-text support, textual validation, and semantic result
announcements.

Legacy translation files were replaced with ARB and `gen_l10n`. English is the
fallback locale; Portuguese has a generic `pt` base and an explicit `pt_BR`
selection. Locale changes apply immediately.

## Versioning

Version `2.0.0+6` represents visual, architectural, persistence, and minimum
platform changes. Build number 6 is greater than the version code 5 forced by
the old Android configuration, preventing store-update regression.

## Migration validation

The migration host validated:

- formatting and static analysis;
- unit, Cubit, widget, persistence, and integration tests;
- coverage for calculation, formatting, conversion, and state logic;
- an Android API 36 emulator flow;
- Android debug APK and release app bundle builds.

The release app bundle was intentionally unsigned because no local publishing
credentials were supplied. iOS could not be compiled without macOS/Xcode. Web
is not a target platform for this project.
