import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/app_info_provider.dart';
import '../../core/services/feedback_launcher.dart';
import '../../features/calculator/presentation/cubit/calculator_cubit.dart';
import '../../features/calculator/presentation/pages/calculator_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../l10n/app_localizations.dart';

abstract final class AppRoutes {
  static const String calculator = '/';
  static const String settings = '/settings';
}

class AppRouter {
  const AppRouter({
    required this.feedbackLauncher,
    required this.appInfoProvider,
  });

  final FeedbackLauncher feedbackLauncher;
  final AppInfoProvider appInfoProvider;

  Route<void> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.calculator => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => BlocProvider<CalculatorCubit>(
          create: (_) => CalculatorCubit(),
          child: const CalculatorPage(),
        ),
      ),
      AppRoutes.settings => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => SettingsPage(
          feedbackLauncher: feedbackLauncher,
          appInfoProvider: appInfoProvider,
        ),
      ),
      _ => MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => const _UnknownRoutePage(),
      ),
    };
  }
}

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.routeNotFoundTitle)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.route_outlined, size: 64),
                const SizedBox(height: 16),
                Text(
                  l10n.routeNotFoundDescription,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.calculator, (_) => false),
                  child: Text(l10n.backToCalculator),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
