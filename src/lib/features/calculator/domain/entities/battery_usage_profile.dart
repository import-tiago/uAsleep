import 'package:equatable/equatable.dart';

import '../value_objects/measurement_units.dart';

/// Electrical and duty-cycle inputs used by the estimator.
///
/// The frequency is expressed as wake-ups per hour to preserve the public
/// model used by uAsleep 1.x.
class BatteryUsageProfile extends Equatable {
  const BatteryUsageProfile({
    required this.batteryCapacity,
    required this.batteryCapacityUnit,
    required this.activeCurrent,
    required this.activeCurrentUnit,
    this.sleepEnabled = true,
    this.sleepCurrent = 0,
    this.sleepCurrentUnit = CurrentUnit.microampere,
    this.activeDuration = 1,
    this.activeDurationUnit = TimeUnit.second,
    this.wakeupsPerHour = 1,
  });

  final double batteryCapacity;
  final BatteryCapacityUnit batteryCapacityUnit;
  final double activeCurrent;
  final CurrentUnit activeCurrentUnit;
  final bool sleepEnabled;
  final double sleepCurrent;
  final CurrentUnit sleepCurrentUnit;
  final double activeDuration;
  final TimeUnit activeDurationUnit;
  final double wakeupsPerHour;

  @override
  List<Object> get props => <Object>[
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
  ];
}
