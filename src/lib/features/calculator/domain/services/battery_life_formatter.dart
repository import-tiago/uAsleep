enum BatteryLifeDisplayUnit { hours, days, months, years }

class BatteryLifeDisplay {
  const BatteryLifeDisplay({required this.value, required this.unit});

  final double value;
  final BatteryLifeDisplayUnit unit;
}

/// Selects a human-scale duration without coupling domain calculations to UI.
class BatteryLifeFormatter {
  const BatteryLifeFormatter();

  BatteryLifeDisplay selectDisplay(double hours) {
    final double days = hours / 24;
    if (hours < 48) {
      return BatteryLifeDisplay(
        value: hours,
        unit: BatteryLifeDisplayUnit.hours,
      );
    }
    if (days < 60) {
      return BatteryLifeDisplay(value: days, unit: BatteryLifeDisplayUnit.days);
    }

    final double months = days / 30;
    if (months < 24) {
      return BatteryLifeDisplay(
        value: months,
        unit: BatteryLifeDisplayUnit.months,
      );
    }
    return BatteryLifeDisplay(
      value: days / 365,
      unit: BatteryLifeDisplayUnit.years,
    );
  }
}
