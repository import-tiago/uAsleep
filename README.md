<p align="center">
  <img src="lib/assets/ic_launcher.png" alt="uAsleep app icon" width="112">
</p>

<h1 align="center">uAsleep</h1>

<p align="center">
  A focused battery-life estimator for embedded systems and IoT devices.
</p>

<p align="center">
  <a href="https://github.com/import-tiago/uAsleep/actions/workflows/ci.yml"><img src="https://github.com/import-tiago/uAsleep/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
  <img src="https://img.shields.io/badge/Flutter-3.44.8-02569B?logo=flutter" alt="Flutter 3.44.8">
  <img src="https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart" alt="Dart 3.12.2">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-CC%20BY--SA%204.0-8A2BE2" alt="CC BY-SA 4.0 license"></a>
</p>

uAsleep estimates the theoretical runtime of a battery-powered device from its
capacity, active current, sleep current, wake duration, and wake frequency. It
is designed for quick engineering estimates while keeping assumptions and
limitations explicit.

## Highlights

- Battery capacity in `mAh` or `Ah`.
- Active and sleep current in `nA`, `µA`, `mA`, or `A`.
- Active duration in `µs`, `ms`, `s`, `min`, or `h`.
- Optional sleep-mode duty-cycle calculation.
- Average current, active duty cycle, and human-readable battery life.
- Localized validation with both comma and dot decimal separators.
- English, Brazilian Portuguese, and system-language modes.
- Light, dark, and system themes.
- Persistent language, theme, and precision preferences.
- No analytics, tracking, accounts, or network-based calculation.

## How the estimate works

Internally, values are normalized to milliampere-hours, milliamperes, and
hours. When sleep mode is enabled:

```text
cycleDuration = 1 hour / wakeupsPerHour
sleepDuration = cycleDuration - activeDuration

averageCurrent =
  ((activeCurrent × activeDuration) +
   (sleepCurrent × sleepDuration)) /
  cycleDuration

batteryLifeHours = batteryCapacityMah / averageCurrentMa
```

Without sleep mode, active current is treated as continuous.

> [!IMPORTANT]
> This is an idealized estimate. Real battery life also depends on
> self-discharge, temperature, aging, discharge curves, regulator efficiency,
> and load transients.

## Requirements

| Tool | Version |
| --- | --- |
| Flutter | `3.44.8` stable |
| Dart | `3.12.2` |
| Java | `17` or newer |
| Android | SDK `36`, min SDK `24` |
| iOS | `13.0` or newer |

Verify your local setup:

```shell
flutter doctor -v
```

## Getting started

```shell
git clone https://github.com/import-tiago/uAsleep.git
cd uAsleep
flutter pub get
flutter run
```

Use `flutter devices` to list available targets. Android development works on
Windows, macOS, and Linux. Building for iOS requires macOS and Xcode.

## Quality checks

Run the same checks used by CI before opening a pull request:

```shell
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
```

To generate a local coverage report:

```shell
flutter test --coverage
```

## Project structure

```text
lib/
├── app/                    # Bootstrap, routing, MaterialApp, and theme
├── core/                   # Shared validation and platform adapters
├── features/
│   ├── calculator/
│   │   ├── domain/         # Pure Dart entities, units, and calculation rules
│   │   └── presentation/   # Cubit, page, and reusable widgets
│   └── settings/
│       ├── data/           # Local persistence and legacy migration
│       ├── domain/         # Settings entity and repository contract
│       └── presentation/   # Cubit and settings page
├── l10n/                   # ARB sources and generated localization classes
└── main.dart               # Application entry point

test/                       # Unit, state, widget, and adapter tests
integration_test/           # End-to-end application flow
docs/                       # Architecture and migration notes
.github/                    # CI, Dependabot, and collaboration templates
```

The codebase follows a feature-first structure. UI widgets delegate state to
Cubits, while calculation rules remain in a Flutter-independent domain layer.
See [Architecture](docs/architecture.md) for the dependency model and
[Migration notes](docs/migration.md) for the 1.x to 2.0 modernization.

## Localization

Source messages live in `lib/l10n/*.arb`. To add a locale:

1. Copy `app_en.arb` to `app_<locale>.arb`.
2. Translate every message while preserving placeholders.
3. Run `flutter gen-l10n`.
4. Add the locale to the settings UI when explicit selection is required.
5. Add localization tests.

English is the fallback locale. Portuguese uses a generic `pt` base with a
`pt_BR` specialization.

## Building releases

Android:

```shell
flutter build appbundle
```

Release signing is read from `android/key.properties` when available. That
file, keystores, credentials, and environment files are intentionally ignored
and must never be committed.

iOS, on macOS:

```shell
flutter build ios --no-codesign
```

## Contributing and security

Contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) and the
[Code of Conduct](CODE_OF_CONDUCT.md) before opening a pull request. Please
report vulnerabilities according to [SECURITY.md](SECURITY.md), not through a
public issue.

## License

uAsleep is licensed under the
[Creative Commons Attribution-ShareAlike 4.0 International License](LICENSE).
