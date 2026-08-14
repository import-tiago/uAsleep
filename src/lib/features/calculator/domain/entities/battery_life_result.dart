/// Canonical result of a battery-life calculation.
class BatteryLifeResult {
  const BatteryLifeResult({
    required this.hours,
    required this.averageCurrentMilliamperes,
    required this.activeDutyCycle,
    this.monitoredConsumptionMilliampereHours,
    this.monitoredCapacityPercentage,
    this.monitoringPeriodHours,
  });

  final double hours;
  final double averageCurrentMilliamperes;

  /// Fraction in the inclusive range 0–1.
  final double activeDutyCycle;

  /// Projected charge demand during the optional monitoring period.
  final double? monitoredConsumptionMilliampereHours;
  final double? monitoredCapacityPercentage;
  final double? monitoringPeriodHours;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BatteryLifeResult &&
            hours == other.hours &&
            averageCurrentMilliamperes == other.averageCurrentMilliamperes &&
            activeDutyCycle == other.activeDutyCycle &&
            monitoredConsumptionMilliampereHours ==
                other.monitoredConsumptionMilliampereHours &&
            monitoredCapacityPercentage == other.monitoredCapacityPercentage &&
            monitoringPeriodHours == other.monitoringPeriodHours;
  }

  @override
  int get hashCode => Object.hash(
    hours,
    averageCurrentMilliamperes,
    activeDutyCycle,
    monitoredConsumptionMilliampereHours,
    monitoredCapacityPercentage,
    monitoringPeriodHours,
  );
}
