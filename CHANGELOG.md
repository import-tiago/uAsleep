# Changelog

All notable changes to uAsleep are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project follows [Semantic Versioning](https://semver.org/).

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
