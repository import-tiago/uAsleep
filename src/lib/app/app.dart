import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/services/app_info_provider.dart';
import '../core/services/feedback_launcher.dart';
import '../core/services/result_exporter.dart';
import '../features/calculator/domain/repositories/calculation_history_repository.dart';
import '../features/settings/domain/entities/app_settings.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import '../features/settings/presentation/cubit/settings_state.dart';
import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class UAsleepApp extends StatelessWidget {
  const UAsleepApp({
    required this.settingsRepository,
    required this.historyRepository,
    this.feedbackLauncher = const MailtoFeedbackLauncher(),
    this.appInfoProvider = const PackageAppInfoProvider(),
    this.resultExporter = const ShareResultExporter(),
    super.key,
  });

  final SettingsRepository settingsRepository;
  final CalculationHistoryRepository historyRepository;
  final FeedbackLauncher feedbackLauncher;
  final AppInfoProvider appInfoProvider;
  final ResultExporter resultExporter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit(repository: settingsRepository)..load(),
      child: _AppView(
        feedbackLauncher: feedbackLauncher,
        appInfoProvider: appInfoProvider,
        historyRepository: historyRepository,
        resultExporter: resultExporter,
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({
    required this.feedbackLauncher,
    required this.appInfoProvider,
    required this.historyRepository,
    required this.resultExporter,
  });

  final FeedbackLauncher feedbackLauncher;
  final AppInfoProvider appInfoProvider;
  final CalculationHistoryRepository historyRepository;
  final ResultExporter resultExporter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (BuildContext context, SettingsState state) {
        final AppSettings settings = state.settings;
        final AppRouter router = AppRouter(
          feedbackLauncher: feedbackLauncher,
          appInfoProvider: appInfoProvider,
          historyRepository: historyRepository,
          resultExporter: resultExporter,
        );
        return MaterialApp(
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _themeMode(settings.theme),
          locale: _locale(settings.localeTag),
          localizationsDelegates: const <LocalizationsDelegate<Object>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback:
              (Locale? locale, Iterable<Locale> supportedLocales) {
                if (locale == null) {
                  return const Locale('en');
                }
                for (final Locale supported in supportedLocales) {
                  if (supported.languageCode == locale.languageCode) {
                    return supported;
                  }
                }
                return const Locale('en');
              },
          initialRoute: AppRoutes.calculator,
          onGenerateRoute: router.onGenerateRoute,
        );
      },
    );
  }

  Locale? _locale(String? tag) {
    return switch (tag) {
      'en' => const Locale('en'),
      'pt_BR' => const Locale('pt', 'BR'),
      _ => null,
    };
  }

  ThemeMode _themeMode(AppThemePreference preference) {
    return switch (preference) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };
  }
}
