# Contributing to uAsleep

Thank you for helping improve uAsleep. Bug reports, focused feature proposals,
documentation improvements, and tested code changes are welcome.

Participation is governed by [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Before you start

- Search existing issues before opening a new one.
- Use the provided issue forms for bugs and feature requests.
- For a substantial change, open an issue first so the design can be discussed.
- Never publish credentials, signing files, personal data, or security details.

Security vulnerabilities must follow [SECURITY.md](SECURITY.md).

## Development workflow

1. Fork the repository and create a short branch from `main`.
2. Install the Flutter version documented in [README.md](README.md).
3. Run `flutter pub get`.
4. Make one focused change and add tests for observable behavior.
5. Run all relevant quality checks.
6. Open a pull request using the repository template.

Suggested branch names:

```text
fix/mailto-encoding
feat/export-estimate
docs/update-architecture
```

## Architecture guidelines

- Keep calculation rules and measurement conversions in pure Dart domain code.
- Keep widgets focused on rendering and user interaction.
- Use Cubits for presentation state and constructor injection for dependencies.
- Keep platform-specific adapters at the edges of the application.
- Add localized user-facing text to ARB files instead of hard-coding strings.
- Preserve accessibility, responsive layouts, and light/dark theme support.

See [docs/architecture.md](docs/architecture.md) for more detail.

## Required checks

```shell
flutter pub get
flutter gen-l10n
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
```

iOS-related changes should also be validated on macOS with:

```shell
flutter build ios --no-codesign
```

## Pull requests

Keep pull requests small enough to review. Describe:

- the problem and motivation;
- the previous and new behavior;
- tests added or updated;
- platforms and devices validated;
- screenshots for visible UI changes.

By contributing, you agree that your contribution is distributed under the
project license.
