import 'package:equatable/equatable.dart';

import '../../domain/entities/battery_life_result.dart';
import '../../domain/entities/battery_usage_profile.dart';
import '../../domain/value_objects/measurement_units.dart';

enum CalculatorStatus { initial, editing, success, invalid }

enum CalculatorField {
  batteryCapacity,
  activeCurrent,
  sleepCurrent,
  activeDuration,
  wakeupsPerHour,
  monitoringPeriod,
  form,
}

enum CalculatorInputError {
  required,
  invalidNumber,
  nonFinite,
  mustBePositive,
  cannotBeNegative,
  activeDurationExceedsCycle,
  zeroAverageCurrent,
}

enum CalculatorWarning { potentiallyUnrealistic }

class CalculatorIssue extends Equatable {
  const CalculatorIssue({required this.field, required this.error});

  final CalculatorField field;
  final CalculatorInputError error;

  @override
  List<Object> get props => <Object>[field, error];
}

class CalculatorState extends Equatable {
  const CalculatorState({
    this.status = CalculatorStatus.initial,
    this.batteryCapacity = '',
    this.batteryCapacityUnit = BatteryCapacityUnit.milliampereHour,
    this.activeCurrent = '',
    this.activeCurrentUnit = CurrentUnit.milliampere,
    this.sleepEnabled = false,
    this.sleepCurrent = '',
    this.sleepCurrentUnit = CurrentUnit.microampere,
    this.activeDuration = '',
    this.activeDurationUnit = TimeUnit.second,
    this.wakeupsPerHour = '',
    this.monitoringEnabled = false,
    this.monitoringPeriod = '',
    this.monitoringPeriodUnit = MonitoringPeriodUnit.hour,
    this.result,
    this.profile,
    this.issues = const <CalculatorIssue>[],
    this.warnings = const <CalculatorWarning>[],
  });

  final CalculatorStatus status;
  final String batteryCapacity;
  final BatteryCapacityUnit batteryCapacityUnit;
  final String activeCurrent;
  final CurrentUnit activeCurrentUnit;
  final bool sleepEnabled;
  final String sleepCurrent;
  final CurrentUnit sleepCurrentUnit;
  final String activeDuration;
  final TimeUnit activeDurationUnit;
  final String wakeupsPerHour;
  final bool monitoringEnabled;
  final String monitoringPeriod;
  final MonitoringPeriodUnit monitoringPeriodUnit;
  final BatteryLifeResult? result;
  final BatteryUsageProfile? profile;
  final List<CalculatorIssue> issues;
  final List<CalculatorWarning> warnings;

  CalculatorInputError? errorFor(CalculatorField field) {
    for (final CalculatorIssue issue in issues) {
      if (issue.field == field) {
        return issue.error;
      }
    }
    return null;
  }

  CalculatorState copyWith({
    CalculatorStatus? status,
    String? batteryCapacity,
    BatteryCapacityUnit? batteryCapacityUnit,
    String? activeCurrent,
    CurrentUnit? activeCurrentUnit,
    bool? sleepEnabled,
    String? sleepCurrent,
    CurrentUnit? sleepCurrentUnit,
    String? activeDuration,
    TimeUnit? activeDurationUnit,
    String? wakeupsPerHour,
    bool? monitoringEnabled,
    String? monitoringPeriod,
    MonitoringPeriodUnit? monitoringPeriodUnit,
    BatteryLifeResult? result,
    BatteryUsageProfile? profile,
    bool clearResult = false,
    List<CalculatorIssue>? issues,
    List<CalculatorWarning>? warnings,
  }) {
    return CalculatorState(
      status: status ?? this.status,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      batteryCapacityUnit: batteryCapacityUnit ?? this.batteryCapacityUnit,
      activeCurrent: activeCurrent ?? this.activeCurrent,
      activeCurrentUnit: activeCurrentUnit ?? this.activeCurrentUnit,
      sleepEnabled: sleepEnabled ?? this.sleepEnabled,
      sleepCurrent: sleepCurrent ?? this.sleepCurrent,
      sleepCurrentUnit: sleepCurrentUnit ?? this.sleepCurrentUnit,
      activeDuration: activeDuration ?? this.activeDuration,
      activeDurationUnit: activeDurationUnit ?? this.activeDurationUnit,
      wakeupsPerHour: wakeupsPerHour ?? this.wakeupsPerHour,
      monitoringEnabled: monitoringEnabled ?? this.monitoringEnabled,
      monitoringPeriod: monitoringPeriod ?? this.monitoringPeriod,
      monitoringPeriodUnit: monitoringPeriodUnit ?? this.monitoringPeriodUnit,
      result: clearResult ? null : result ?? this.result,
      profile: clearResult ? null : profile ?? this.profile,
      issues: issues ?? this.issues,
      warnings: warnings ?? this.warnings,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    batteryCapacity,
    batteryCapacityUnit,
    activeCurrent,
    activeCurrentUnit,
    sleepEnabled,
    sleepCurrent,
    sleepCurrentUnit,
    activeDuration,
    activeDurationUnit,
    wakeupsPerHour,
    monitoringEnabled,
    monitoringPeriod,
    monitoringPeriodUnit,
    result,
    profile,
    issues,
    warnings,
  ];
}
