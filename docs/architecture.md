# Architecture

## Overview

uAsleep uses a feature-first structure. Dependencies point from the user
interface and infrastructure adapters toward contracts and business rules:

```text
Widgets → Cubits → domain
                   ↑
Widgets → SettingsCubit → SettingsRepository ← local adapters
```

There is no service locator, Singleton, mutable global state, or navigation
inside the domain layer. Dependencies are provided through constructors.

## Application startup

- `main.dart` calls `bootstrap()`.
- `bootstrap.dart` creates local adapters and injects the settings repository.
- `app.dart` keeps `SettingsCubit` above `MaterialApp`, enabling immediate
  locale and theme changes.
- `app_router.dart` centralizes application routes and unknown-route handling.

## Calculator

### Domain

- `BatteryUsageProfile` contains typed calculation inputs.
- `BatteryCapacityUnit`, `CurrentUnit`, and `TimeUnit` normalize measurements.
- `BatteryLifeCalculator` owns the formula, assumptions, and invariants.
- `BatteryLifeResult` exposes runtime, average current, and active duty cycle.
- `BatteryLifeFormatter` selects an appropriate hour, day, month, or year
  representation.
- `BatteryLifeException` represents enumerated domain failures.

The domain does not import Flutter. It uses mAh, mA, and hours internally. Wake
frequency is expressed as wake-ups per hour, preserving the 1.x product model.

### State and presentation

`CalculatorCubit` owns textual values, selected units, typed errors, notices,
and results. The UI sends events and renders state; it does not implement
calculation rules. The parser accepts comma or dot decimal separators, and the
domain rejects invalid values explicitly.

Widgets are responsive, have a maximum width on large displays, use Material
components with standard touch targets, and do not rely on color alone to
communicate errors.

## Settings

`SettingsRepository` is the domain contract. `LocalSettingsRepository` uses a
key-value abstraction implemented with `SharedPreferencesAsync`.

On the first run after an upgrade, `FileLegacySettingsSource` attempts to read
`DataPersistence.txt`, converts language and precision preferences, and stores
a migration marker. The legacy file is never modified and is not required
after migration. Missing or invalid data falls back to safe defaults.

## Localization

Flutter `gen_l10n` generates localization classes from ARB files under
`lib/l10n`. Interface labels, errors, and feedback messages are localized.
Unsupported locales fall back to English; an absent explicit selection follows
the operating system.

## Security and privacy

- No network-based calculation, analytics, tracking, or embedded credentials.
- No production Android or iOS permissions.
- Non-sensitive preferences use standard local storage.
- Feedback opens an external email client and requires explicit user action.
- Signing files and local release configuration are ignored by Git.

## Testability

The domain is synchronous and deterministic. Cubits receive services and
repositories through constructors. Platform adapters remain at the application
boundary and are replaced by fakes in tests. Integration tests use the real
pages, Cubits, routes, and localization without accessing external services.
