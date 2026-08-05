import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/app_info_provider.dart';
import '../../../../core/services/feedback_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_settings.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.feedbackLauncher,
    required this.appInfoProvider,
    super.key,
  });

  final FeedbackLauncher feedbackLauncher;
  final AppInfoProvider appInfoProvider;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static final Uri _privacyPolicyUri = Uri.parse(
    'https://raw.githubusercontent.com/import-tiago/uAsleep/main/PRIVACY.md',
  );

  late final Future<String> _version = widget.appInfoProvider.version();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listenWhen: (SettingsState previous, SettingsState current) =>
              previous.failure != SettingsFailure.save &&
              current.failure == SettingsFailure.save,
          listener: (BuildContext context, SettingsState state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.settingsSaveFailure)));
          },
          builder: (BuildContext context, SettingsState state) {
            final AppSettings settings = state.settings;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.small,
                AppSpacing.page,
                AppSpacing.xLarge,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (state.failure == SettingsFailure.load) ...<Widget>[
                        _FailureNotice(message: l10n.settingsLoadFailure),
                        const SizedBox(height: AppSpacing.medium),
                      ],
                      _SettingsSection(
                        icon: Icons.palette_outlined,
                        title: l10n.appearanceTitle,
                        children: <Widget>[
                          DropdownButtonFormField<AppThemePreference>(
                            key: ValueKey<AppThemePreference>(settings.theme),
                            initialValue: settings.theme,
                            decoration: InputDecoration(
                              labelText: l10n.themeLabel,
                            ),
                            items: AppThemePreference.values
                                .map(
                                  (AppThemePreference value) =>
                                      DropdownMenuItem<AppThemePreference>(
                                        value: value,
                                        child: Text(_themeLabel(l10n, value)),
                                      ),
                                )
                                .toList(growable: false),
                            onChanged: (AppThemePreference? value) {
                              if (value != null) {
                                context.read<SettingsCubit>().setTheme(value);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      _SettingsSection(
                        icon: Icons.translate_rounded,
                        title: l10n.languageTitle,
                        children: <Widget>[
                          DropdownButtonFormField<String>(
                            key: ValueKey<String>(
                              settings.localeTag ?? 'system',
                            ),
                            initialValue: settings.localeTag ?? 'system',
                            decoration: InputDecoration(
                              labelText: l10n.languageTitle,
                            ),
                            items: <DropdownMenuItem<String>>[
                              DropdownMenuItem<String>(
                                value: 'system',
                                child: Text(l10n.languageSystem),
                              ),
                              DropdownMenuItem<String>(
                                value: 'en',
                                child: Text(l10n.languageEnglish),
                              ),
                              DropdownMenuItem<String>(
                                value: 'pt_BR',
                                child: Text(l10n.languagePortuguese),
                              ),
                            ],
                            onChanged: (String? value) {
                              if (value != null) {
                                context.read<SettingsCubit>().setLocale(
                                  value == 'system' ? null : value,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      _SettingsSection(
                        icon: Icons.straighten_rounded,
                        title: l10n.precisionTitle,
                        children: <Widget>[
                          DropdownButtonFormField<int>(
                            key: ValueKey<int>(settings.precision),
                            initialValue: settings.precision,
                            decoration: InputDecoration(
                              labelText: l10n.precisionTitle,
                            ),
                            items: <DropdownMenuItem<int>>[
                              DropdownMenuItem<int>(
                                value: 0,
                                child: Text(l10n.precisionSimple),
                              ),
                              DropdownMenuItem<int>(
                                value: 2,
                                child: Text(l10n.precisionDetailed),
                              ),
                            ],
                            onChanged: (int? value) {
                              if (value != null) {
                                context.read<SettingsCubit>().setPrecision(
                                  value,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      _SettingsSection(
                        icon: Icons.mark_email_read_outlined,
                        title: l10n.feedbackTitle,
                        children: <Widget>[
                          Text(l10n.feedbackDescription),
                          const SizedBox(height: AppSpacing.medium),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: FilledButton.tonalIcon(
                              key: const Key('feedbackButton'),
                              onPressed: _openFeedback,
                              icon: const Icon(Icons.outgoing_mail),
                              label: Text(l10n.feedbackButton),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      _SettingsSection(
                        icon: Icons.info_outline_rounded,
                        title: l10n.aboutTitle,
                        children: <Widget>[
                          Text(l10n.aboutDescription),
                          const SizedBox(height: AppSpacing.small),
                          FutureBuilder<String>(
                            future: _version,
                            builder:
                                (
                                  BuildContext context,
                                  AsyncSnapshot<String> snapshot,
                                ) {
                                  final String? version = snapshot.data;
                                  return Text(
                                    version != null
                                        ? l10n.appVersion(version)
                                        : l10n.loadingLabel,
                                    key: const Key('appVersion'),
                                  );
                                },
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Wrap(
                              spacing: AppSpacing.small,
                              runSpacing: AppSpacing.small,
                              children: <Widget>[
                                TextButton.icon(
                                  key: const Key('privacyPolicyButton'),
                                  onPressed: _openPrivacyPolicy,
                                  icon: const Icon(Icons.privacy_tip_outlined),
                                  label: Text(l10n.privacyPolicy),
                                ),
                                TextButton.icon(
                                  onPressed: _showLicenses,
                                  icon: const Icon(Icons.description_outlined),
                                  label: Text(l10n.softwareLicenses),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openFeedback() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool opened = await widget.feedbackLauncher.open(
      subject: l10n.feedbackSubject,
      body: l10n.feedbackBody,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.feedbackUnavailable)));
    }
  }

  Future<void> _showLicenses() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String version = await _version;
    if (!mounted) {
      return;
    }
    showLicensePage(
      context: context,
      applicationName: l10n.appTitle,
      applicationVersion: version,
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final bool opened;
    try {
      opened = await launchUrl(
        _privacyPolicyUri,
        mode: LaunchMode.externalApplication,
      );
    } on Object {
      if (mounted) {
        _showPrivacyPolicyUnavailable();
      }
      return;
    }
    if (!opened && mounted) {
      _showPrivacyPolicyUnavailable();
    }
  }

  void _showPrivacyPolicyUnavailable() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.privacyPolicyUnavailable)));
  }

  String _themeLabel(AppLocalizations l10n, AppThemePreference preference) {
    return switch (preference) {
      AppThemePreference.system => l10n.themeSystem,
      AppThemePreference.light => l10n.themeLight,
      AppThemePreference.dark => l10n.themeDark,
    };
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _FailureNotice extends StatelessWidget {
  const _FailureNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Text(message, style: TextStyle(color: colors.onErrorContainer)),
      ),
    );
  }
}
