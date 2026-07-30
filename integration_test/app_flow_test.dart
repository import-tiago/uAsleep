import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uasleep/app/app.dart';
import 'package:uasleep/core/services/app_info_provider.dart';
import 'package:uasleep/core/services/feedback_launcher.dart';
import 'package:uasleep/features/settings/domain/entities/app_settings.dart';
import 'package:uasleep/features/settings/domain/repositories/settings_repository.dart';
import 'package:uasleep/features/settings/presentation/pages/settings_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('calculates and applies a persisted language change', (
    WidgetTester tester,
  ) async {
    final _IntegrationSettingsRepository repository =
        _IntegrationSettingsRepository();
    await tester.pumpWidget(
      UAsleepApp(
        settingsRepository: repository,
        feedbackLauncher: const _NoopFeedbackLauncher(),
        appInfoProvider: const _StaticAppInfoProvider(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sleepModeSwitch')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('capacityField')), '1000');
    await tester.enterText(find.byKey(const Key('activeCurrentField')), '100');
    final Finder calculate = find.byKey(const Key('calculateButton'));
    await tester.ensureVisible(calculate);
    await tester.tap(calculate);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('resultDuration')), findsOneWidget);

    await tester.tap(find.byKey(const Key('settingsButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('system')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Português (Brasil)').last);
    await tester.pumpAndSettle();
    expect(find.text('Configurações'), findsOneWidget);

    Navigator.of(tester.element(find.byType(SettingsPage))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Estimativa de autonomia'), findsOneWidget);
    expect(repository.current.localeTag, 'pt_BR');
  });
}

class _IntegrationSettingsRepository implements SettingsRepository {
  AppSettings current = const AppSettings();

  @override
  Future<AppSettings> load() async => current;

  @override
  Future<void> save(AppSettings settings) async {
    current = settings;
  }
}

class _NoopFeedbackLauncher implements FeedbackLauncher {
  const _NoopFeedbackLauncher();

  @override
  Future<bool> open({required String subject, required String body}) async {
    return true;
  }
}

class _StaticAppInfoProvider implements AppInfoProvider {
  const _StaticAppInfoProvider();

  @override
  Future<String> version() async => '2.0.0+6';
}
