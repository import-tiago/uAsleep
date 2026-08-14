# Changelog

All notable changes to uAsleep are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- Optional consumption projection for user-selected periods in hours, days,
  or weeks, including charge usage in mAh and battery-capacity percentage.
- Monitoring-period values in calculation history and exported reports.

## [2.1.0+7] - 2026-07-30

### Added

- Persistent on-device history for the 50 most recent calculations.
- Localized result export through the native system share sheet.
- One-tap restoration of a historical calculation into the editable form.

### Changed

- New installations default to simple result precision and disabled sleep mode.
- Calculation actions stack vertically when large accessibility fonts or
  narrow screens would make button labels wrap.
- Reworked the complete visual identity around a navy-blue, electric-blue, and
  cyan palette.
- Replaced the app icon, native launch screens, in-app iconography, and
  repository header artwork.
- Made the neutral light theme the default, reserving navy and blue for brand
  accents while keeping the navy dark theme optional.
- Switched the native Android and iOS launch screens to a neutral light
  background with a compact navy brand mark.
- Standardized the native Android and iOS splash on a light background because
  app-specific Flutter theme preferences are unavailable before the first
  Flutter frame.

## [2.0.0+6] - 2026-07-30

### Added

- Feature-first architecture with `flutter_bloc` Cubits and constructor
  injection.
- Pure Dart battery-life calculation, typed units, and explicit domain errors.
- Validation for missing, non-finite, negative, zero-current, and impossible
  duty-cycle inputs.
- Responsive Material 3 interface with light, dark, and system themes.
- ARB-based English and Portuguese localization.
- Structured preferences with one-time migration from the 1.x format.
- Unit, Cubit, widget, persistence, and integration test suites.
- GitHub Actions checks for formatting, analysis, tests, coverage, and Android
  debug builds.

### Changed

- Migrated to Flutter 3.44.8, Dart 3.12.2, and sound null safety.
- Replaced legacy global state, RxDart, `bloc_pattern`, and Singleton usage.
- Replaced direct email sending with an explicit `mailto:` flow.
- Regenerated Android and iOS scaffolding and standardized application
  identifiers as `br.uasleep`.
- Raised the Android minimum to API 24 and the iOS deployment target to 13.0.

### Removed

- Legacy JSON-in-JavaScript translations and obsolete dependencies.
- Silent email permissions and unused generated build artifacts.
