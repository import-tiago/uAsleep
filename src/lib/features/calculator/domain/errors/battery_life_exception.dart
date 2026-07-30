enum BatteryLifeErrorCode {
  nonFiniteValue,
  nonPositiveCapacity,
  negativeCurrent,
  nonPositiveActiveDuration,
  nonPositiveWakeupFrequency,
  activeDurationExceedsCycle,
  zeroAverageCurrent,
}

class BatteryLifeException implements Exception {
  const BatteryLifeException(this.code);

  final BatteryLifeErrorCode code;

  @override
  String toString() => 'BatteryLifeException($code)';
}
