/// Supported battery-capacity units.
enum BatteryCapacityUnit {
  milliampereHour('mAh', 1),
  ampereHour('Ah', 1000);

  const BatteryCapacityUnit(this.symbol, this.milliampereHourFactor);

  final String symbol;
  final double milliampereHourFactor;

  double toMilliampereHours(double value) => value * milliampereHourFactor;
}

/// Supported electrical-current units.
enum CurrentUnit {
  nanoampere('nA', 0.000001),
  microampere('µA', 0.001),
  milliampere('mA', 1),
  ampere('A', 1000);

  const CurrentUnit(this.symbol, this.milliampereFactor);

  final String symbol;
  final double milliampereFactor;

  double toMilliamperes(double value) => value * milliampereFactor;
}

/// Supported active-duration units.
enum TimeUnit {
  microsecond('µs', 1 / 3600000000),
  millisecond('ms', 1 / 3600000),
  second('s', 1 / 3600),
  minute('min', 1 / 60),
  hour('h', 1);

  const TimeUnit(this.symbol, this.hourFactor);

  final String symbol;
  final double hourFactor;

  double toHours(double value) => value * hourFactor;
}

/// Units intended for longer consumption-projection periods.
enum MonitoringPeriodUnit {
  hour('h', 1),
  day('d', 24),
  week('wk', 24 * 7);

  const MonitoringPeriodUnit(this.symbol, this.hourFactor);

  final String symbol;
  final double hourFactor;

  double toHours(double value) => value * hourFactor;
}
