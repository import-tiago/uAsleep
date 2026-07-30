import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/battery_life_result.dart';
import '../../domain/services/battery_life_formatter.dart';

class BatteryResultCard extends StatelessWidget {
  const BatteryResultCard({
    required this.result,
    required this.precision,
    required this.showWarning,
    super.key,
  });

  final BatteryLifeResult? result;
  final int precision;
  final bool showWarning;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colors = Theme.of(context).colorScheme;
    final BatteryLifeResult? value = result;
    return Semantics(
      liveRegion: true,
      container: true,
      label: value == null ? l10n.resultEmptyTitle : l10n.resultTitle,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: value == null
            ? _EmptyResult(key: const ValueKey<String>('empty-result'))
            : Card(
                key: const ValueKey<String>('battery-result'),
                color: colors.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.battery_charging_full_rounded,
                            color: colors.onPrimaryContainer,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Text(
                            l10n.resultTitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      Text(
                        _duration(context, value.hours),
                        key: const Key('resultDuration'),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      Wrap(
                        spacing: AppSpacing.large,
                        runSpacing: AppSpacing.small,
                        children: <Widget>[
                          _Metric(
                            label: l10n.averageCurrentLabel,
                            value: l10n.averageCurrentValue(
                              _number(
                                context,
                                value.averageCurrentMilliamperes,
                                precision == 0 ? 2 : 4,
                              ),
                            ),
                          ),
                          _Metric(
                            label: l10n.dutyCycleLabel,
                            value: l10n.percentageValue(
                              _number(
                                context,
                                value.activeDutyCycle * 100,
                                precision,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (showWarning) ...<Widget>[
                        const SizedBox(height: AppSpacing.medium),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Icon(Icons.warning_amber_rounded, size: 20),
                            const SizedBox(width: AppSpacing.small),
                            Expanded(child: Text(l10n.validationUnrealistic)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  String _duration(BuildContext context, double hours) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final BatteryLifeDisplay display = const BatteryLifeFormatter()
        .selectDisplay(hours);
    final String formatted = _number(context, display.value, precision);
    return switch (display.unit) {
      BatteryLifeDisplayUnit.hours => l10n.durationHours(
        display.value,
        formatted,
      ),
      BatteryLifeDisplayUnit.days => l10n.durationDays(
        display.value,
        formatted,
      ),
      BatteryLifeDisplayUnit.months => l10n.durationMonths(
        display.value,
        formatted,
      ),
      BatteryLifeDisplayUnit.years => l10n.durationYears(
        display.value,
        formatted,
      ),
    };
  }

  String _number(BuildContext context, double value, int digits) {
    return NumberFormat.decimalPatternDigits(
      locale: Localizations.localeOf(context).toLanguageTag(),
      decimalDigits: digits,
    ).format(value);
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.battery_unknown_outlined,
              size: 44,
              color: colors.secondary,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              l10n.resultEmptyTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xSmall),
            Text(
              l10n.resultEmptyDescription,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
