import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/battery_life_result.dart';
import '../../domain/entities/battery_usage_profile.dart';
import '../../domain/services/battery_life_formatter.dart';
import '../../domain/value_objects/measurement_units.dart';

class CalculationPresentationFormatter {
  const CalculationPresentationFormatter();

  String dateTime(BuildContext context, DateTime value) {
    return DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm().format(value.toLocal());
  }

  String duration(BuildContext context, double hours, int precision) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final BatteryLifeDisplay display = const BatteryLifeFormatter()
        .selectDisplay(hours);
    final String formatted = number(context, display.value, precision);
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

  String number(BuildContext context, double value, int digits) {
    return NumberFormat.decimalPatternDigits(
      locale: Localizations.localeOf(context).toLanguageTag(),
      decimalDigits: digits,
    ).format(value);
  }

  String report(
    BuildContext context, {
    required BatteryUsageProfile profile,
    required BatteryLifeResult result,
    required int precision,
    DateTime? createdAt,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int inputDigits = precision == 0 ? 2 : 4;
    final List<String> lines = <String>[
      l10n.exportReportTitle,
      '',
      '${l10n.resultTitle}: ${duration(context, result.hours, precision)}',
      '${l10n.averageCurrentLabel}: '
          '${l10n.averageCurrentValue(number(context, result.averageCurrentMilliamperes, inputDigits))}',
      '${l10n.dutyCycleLabel}: '
          '${l10n.percentageValue(number(context, result.activeDutyCycle * 100, precision))}',
      if (result.monitoredConsumptionMilliampereHours case final value?)
        '${l10n.monitoredConsumptionLabel}: '
            '${l10n.consumptionValue(number(context, value, inputDigits))}',
      if (result.monitoredCapacityPercentage case final value?)
        '${l10n.monitoredCapacityLabel}: '
            '${l10n.percentageValue(number(context, value, precision))}',
      '',
      '${l10n.batteryCapacityLabel}: '
          '${number(context, profile.batteryCapacity, inputDigits)} '
          '${profile.batteryCapacityUnit.symbol}',
      '${l10n.activeCurrentLabel}: '
          '${number(context, profile.activeCurrent, inputDigits)} '
          '${profile.activeCurrentUnit.symbol}',
      '${l10n.sleepModeTitle}: '
          '${profile.sleepEnabled ? l10n.sleepModeEnabledValue : l10n.sleepModeDisabledValue}',
    ];

    if (profile.sleepEnabled) {
      lines.addAll(<String>[
        '${l10n.sleepCurrentLabel}: '
            '${number(context, profile.sleepCurrent, inputDigits)} '
            '${profile.sleepCurrentUnit.symbol}',
        '${l10n.activeDurationLabel}: '
            '${number(context, profile.activeDuration, inputDigits)} '
            '${profile.activeDurationUnit.symbol}',
        '${l10n.wakeupsPerHourLabel}: '
            '${number(context, profile.wakeupsPerHour, inputDigits)}',
      ]);
    }
    if (profile.monitoringEnabled) {
      lines.add(
        '${l10n.monitoringPeriodLabel}: '
        '${number(context, profile.monitoringPeriod, inputDigits)} '
        '${_monitoringUnit(l10n, profile.monitoringPeriodUnit)}',
      );
    }
    if (createdAt != null) {
      lines
        ..add('')
        ..add('${l10n.generatedAtLabel}: ${dateTime(context, createdAt)}');
    }
    return lines.join('\n');
  }

  String _monitoringUnit(AppLocalizations l10n, MonitoringPeriodUnit unit) {
    return switch (unit) {
      MonitoringPeriodUnit.hour => l10n.monitoringUnitHours,
      MonitoringPeriodUnit.day => l10n.monitoringUnitDays,
      MonitoringPeriodUnit.week => l10n.monitoringUnitWeeks,
    };
  }
}
