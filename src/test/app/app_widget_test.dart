import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/app/app.dart';
import 'package:uasleep/features/settings/domain/entities/app_settings.dart';
import 'package:uasleep/features/settings/presentation/pages/settings_page.dart';

import '../helpers/fakes.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    MemorySettingsRepository? repository,
    FakeFeedbackLauncher? feedbackLauncher,
    MemoryCalculationHistoryRepository? historyRepository,
    FakeResultExporter? resultExporter,
  }) async {
    await tester.pumpWidget(
      UAsleepApp(
        settingsRepository: repository ?? MemorySettingsRepository(),
        historyRepository:
            historyRepository ?? MemoryCalculationHistoryRepository(),
        feedbackLauncher: feedbackLauncher ?? FakeFeedbackLauncher(),
        appInfoProvider: const FakeAppInfoProvider(),
        resultExporter: resultExporter ?? FakeResultExporter(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, Key key, String value) async {
    final Finder finder = find.byKey(key);
    await tester.ensureVisible(finder);
    await tester.enterText(finder, value);
    await tester.pump();
  }

  testWidgets('renders the calculator without the introductory header', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Battery life estimator'), findsNothing);
    expect(find.byKey(const Key('capacityField')), findsOneWidget);
    expect(find.byKey(const Key('sleepModeSwitch')), findsOneWidget);
    expect(find.byKey(const Key('sleepCurrentField')), findsNothing);
    expect(find.text('Ready to calculate'), findsOneWidget);
  });

  testWidgets('calculates a complete sleep profile', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('sleepModeSwitch')));
    await tester.pumpAndSettle();
    await enter(tester, const Key('capacityField'), '2000');
    await enter(tester, const Key('activeCurrentField'), '20');
    await enter(tester, const Key('sleepCurrentField'), '10');
    await enter(tester, const Key('activeDurationField'), '1');
    await enter(tester, const Key('wakeupsField'), '60');

    final Finder calculate = find.byKey(const Key('calculateButton'));
    await tester.ensureVisible(calculate);
    await tester.tap(calculate);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('resultDuration')), findsOneWidget);
    expect(find.text('Estimated autonomy'), findsOneWidget);
    expect(find.text('Average current'), findsOneWidget);
  });

  testWidgets('shows localized validation errors', (WidgetTester tester) async {
    await pumpApp(tester);

    final Finder calculate = find.byKey(const Key('calculateButton'));
    await tester.ensureVisible(calculate);
    await tester.tap(calculate);
    await tester.pumpAndSettle();

    expect(find.text('Enter a value.'), findsNWidgets(2));
    expect(find.byKey(const Key('resultDuration')), findsNothing);
  });

  testWidgets('projects consumption over an eight-hour period', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await enter(tester, const Key('capacityField'), '1000');
    await enter(tester, const Key('activeCurrentField'), '100');
    await tester.ensureVisible(find.byKey(const Key('monitoringModeSwitch')));
    await tester.tap(find.byKey(const Key('monitoringModeSwitch')));
    await tester.pumpAndSettle();
    await enter(tester, const Key('monitoringPeriodField'), '8');

    await tester.ensureVisible(find.byKey(const Key('calculateButton')));
    await tester.tap(find.byKey(const Key('calculateButton')));
    await tester.pumpAndSettle();

    expect(find.text('Consumption in period'), findsOneWidget);
    expect(find.text('800.00 mAh'), findsOneWidget);
    expect(find.text('Battery capacity used'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);
  });

  testWidgets('resets entered fields and output', (WidgetTester tester) async {
    await pumpApp(tester);
    await enter(tester, const Key('capacityField'), '1000');
    await enter(tester, const Key('activeCurrentField'), '100');

    final Finder calculate = find.byKey(const Key('calculateButton'));
    await tester.ensureVisible(calculate);
    await tester.tap(calculate);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('resultDuration')), findsOneWidget);

    await tester.tap(find.byKey(const Key('resetButton')));
    await tester.pumpAndSettle();

    final TextField capacity = tester.widget<TextField>(
      find.byKey(const Key('capacityField')),
    );
    expect(capacity.controller?.text, isEmpty);
    expect(find.byKey(const Key('resultDuration')), findsNothing);
  });

  testWidgets('changes language immediately and persists it', (
    WidgetTester tester,
  ) async {
    final MemorySettingsRepository repository = MemorySettingsRepository();
    await pumpApp(tester, repository: repository);
    await tester.tap(find.byKey(const Key('settingsButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('system')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Português (Brasil)').last);
    await tester.pumpAndSettle();

    expect(find.text('Configurações'), findsOneWidget);
    expect(repository.current.localeTag, 'pt_BR');

    Navigator.of(tester.element(find.byType(SettingsPage))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Bateria'), findsOneWidget);
    expect(find.text('Estimativa de autonomia'), findsNothing);
  });

  testWidgets('applies dark theme immediately', (WidgetTester tester) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('settingsButton')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey<AppThemePreference>(AppThemePreference.light)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.byType(SettingsPage));
    expect(Theme.of(context).brightness, Brightness.dark);
  });

  testWidgets('reports unavailable email clients', (WidgetTester tester) async {
    final FakeFeedbackLauncher feedback = FakeFeedbackLauncher(result: false);
    await pumpApp(tester, feedbackLauncher: feedback);
    await tester.tap(find.byKey(const Key('settingsButton')));
    await tester.pumpAndSettle();

    final Finder feedbackButton = find.byKey(const Key('feedbackButton'));
    await tester.ensureVisible(feedbackButton);
    await tester.tap(feedbackButton);
    await tester.pumpAndSettle();

    expect(feedback.calls, 1);
    expect(
      find.text('No compatible email app could be opened.'),
      findsOneWidget,
    );
  });

  testWidgets('exposes the privacy policy from settings', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('settingsButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('privacyPolicyButton')), findsOneWidget);
    expect(find.text('Privacy policy'), findsOneWidget);
  });

  testWidgets('does not overflow on a small screen with large text', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await pumpApp(tester);

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('capacityField')), findsOneWidget);
    final Rect calculate = tester.getRect(
      find.byKey(const Key('calculateButton')),
    );
    final Rect reset = tester.getRect(find.byKey(const Key('resetButton')));
    expect(calculate.bottom, lessThan(reset.top));
  });

  testWidgets('saves, exports, and restores a historical calculation', (
    WidgetTester tester,
  ) async {
    final MemoryCalculationHistoryRepository history =
        MemoryCalculationHistoryRepository();
    final FakeResultExporter exporter = FakeResultExporter();
    await pumpApp(tester, historyRepository: history, resultExporter: exporter);
    await enter(tester, const Key('capacityField'), '1000');
    await enter(tester, const Key('activeCurrentField'), '100');
    await tester.ensureVisible(find.byKey(const Key('calculateButton')));
    await tester.tap(find.byKey(const Key('calculateButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('exportResultButton')));
    await tester.pumpAndSettle();
    expect(exporter.calls, 1);
    expect(exporter.lastBody, contains('10 hours'));
    expect(history.entries, hasLength(1));

    await tester.ensureVisible(find.byKey(const Key('resetButton')));
    await tester.tap(find.byKey(const Key('resetButton')));
    await tester.pumpAndSettle();
    TextField capacity = tester.widget<TextField>(
      find.byKey(const Key('capacityField')),
    );
    expect(capacity.controller?.text, isEmpty);

    await tester.tap(find.byKey(const Key('historyButton')));
    await tester.pumpAndSettle();
    expect(find.text('Calculation history'), findsOneWidget);
    expect(find.text('10 hours'), findsOneWidget);

    await tester.tap(
      find.byKey(ValueKey<String>('historyEntry-${history.entries.single.id}')),
    );
    await tester.pumpAndSettle();

    capacity = tester.widget<TextField>(find.byKey(const Key('capacityField')));
    final TextField activeCurrent = tester.widget<TextField>(
      find.byKey(const Key('activeCurrentField')),
    );
    final SwitchListTile sleepMode = tester.widget<SwitchListTile>(
      find.byKey(const Key('sleepModeSwitch')),
    );
    expect(capacity.controller?.text, '1000');
    expect(activeCurrent.controller?.text, '100');
    expect(sleepMode.value, isFalse);
    expect(find.byKey(const Key('resultDuration')), findsNothing);
  });
}
