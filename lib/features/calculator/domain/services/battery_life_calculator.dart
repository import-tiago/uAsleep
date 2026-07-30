import '../entities/battery_life_result.dart';
import '../entities/battery_usage_profile.dart';
import '../errors/battery_life_exception.dart';

/// Estimates theoretical battery life with a constant-current duty cycle.
///
/// Internal units are milliampere-hours (mAh), milliamperes (mA), and hours.
/// With sleep enabled, each cycle lasts `1 / wakeupsPerHour` hours:
///
/// `Iavg = (Iactive × Tactive + Isleep × Tsleep) / Tcycle`
///
/// `lifeHours = capacityMah / IavgMa`
///
/// This is algebraically equivalent to the one-hour window used by uAsleep
/// 1.x, but explicitly validates that active time cannot exceed a complete
/// cycle. Without sleep, the active current is treated as continuous.
///
/// The estimate is idealized. It excludes self-discharge, regulator losses,
/// temperature, battery aging, discharge curves, and load transients.
class BatteryLifeCalculator {
  const BatteryLifeCalculator();

  BatteryLifeResult calculate(BatteryUsageProfile profile) {
    _ensureFinite(<double>[
      profile.batteryCapacity,
      profile.activeCurrent,
      if (profile.sleepEnabled) ...<double>[
        profile.sleepCurrent,
        profile.activeDuration,
        profile.wakeupsPerHour,
      ],
    ]);

    if (profile.batteryCapacity <= 0) {
      throw const BatteryLifeException(
        BatteryLifeErrorCode.nonPositiveCapacity,
      );
    }
    if (profile.activeCurrent < 0 ||
        (profile.sleepEnabled && profile.sleepCurrent < 0)) {
      throw const BatteryLifeException(BatteryLifeErrorCode.negativeCurrent);
    }

    final double capacityMah = profile.batteryCapacityUnit.toMilliampereHours(
      profile.batteryCapacity,
    );
    final double activeCurrentMa = profile.activeCurrentUnit.toMilliamperes(
      profile.activeCurrent,
    );

    if (!profile.sleepEnabled) {
      return _result(
        capacityMah: capacityMah,
        averageCurrentMa: activeCurrentMa,
        activeDutyCycle: 1,
      );
    }

    if (profile.activeDuration <= 0) {
      throw const BatteryLifeException(
        BatteryLifeErrorCode.nonPositiveActiveDuration,
      );
    }
    if (profile.wakeupsPerHour <= 0) {
      throw const BatteryLifeException(
        BatteryLifeErrorCode.nonPositiveWakeupFrequency,
      );
    }

    final double activeDurationHours = profile.activeDurationUnit.toHours(
      profile.activeDuration,
    );
    final double cycleDurationHours = 1 / profile.wakeupsPerHour;
    if (activeDurationHours > cycleDurationHours) {
      throw const BatteryLifeException(
        BatteryLifeErrorCode.activeDurationExceedsCycle,
      );
    }

    final double sleepDurationHours = cycleDurationHours - activeDurationHours;
    final double sleepCurrentMa = profile.sleepCurrentUnit.toMilliamperes(
      profile.sleepCurrent,
    );
    final double averageCurrentMa =
        ((activeCurrentMa * activeDurationHours) +
            (sleepCurrentMa * sleepDurationHours)) /
        cycleDurationHours;

    return _result(
      capacityMah: capacityMah,
      averageCurrentMa: averageCurrentMa,
      activeDutyCycle: activeDurationHours / cycleDurationHours,
    );
  }

  void _ensureFinite(List<double> values) {
    if (values.any((double value) => !value.isFinite)) {
      throw const BatteryLifeException(BatteryLifeErrorCode.nonFiniteValue);
    }
  }

  BatteryLifeResult _result({
    required double capacityMah,
    required double averageCurrentMa,
    required double activeDutyCycle,
  }) {
    if (!averageCurrentMa.isFinite) {
      throw const BatteryLifeException(BatteryLifeErrorCode.nonFiniteValue);
    }
    if (averageCurrentMa <= 0) {
      throw const BatteryLifeException(BatteryLifeErrorCode.zeroAverageCurrent);
    }

    final double hours = capacityMah / averageCurrentMa;
    if (!hours.isFinite) {
      throw const BatteryLifeException(BatteryLifeErrorCode.nonFiniteValue);
    }
    return BatteryLifeResult(
      hours: hours,
      averageCurrentMilliamperes: averageCurrentMa,
      activeDutyCycle: activeDutyCycle,
    );
  }
}
