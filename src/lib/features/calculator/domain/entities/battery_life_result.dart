/// Canonical result of a battery-life calculation.
class BatteryLifeResult {
  const BatteryLifeResult({
    required this.hours,
    required this.averageCurrentMilliamperes,
    required this.activeDutyCycle,
  });

  final double hours;
  final double averageCurrentMilliamperes;

  /// Fraction in the inclusive range 0–1.
  final double activeDutyCycle;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BatteryLifeResult &&
            hours == other.hours &&
            averageCurrentMilliamperes == other.averageCurrentMilliamperes &&
            activeDutyCycle == other.activeDutyCycle;
  }

  @override
  int get hashCode =>
      Object.hash(hours, averageCurrentMilliamperes, activeDutyCycle);
}
