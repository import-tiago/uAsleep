import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/features/calculator/domain/value_objects/measurement_units.dart';

void main() {
  group('BatteryCapacityUnit', () {
    test('normalizes ampere-hours to milliampere-hours', () {
      expect(BatteryCapacityUnit.ampereHour.toMilliampereHours(2.5), 2500);
      expect(BatteryCapacityUnit.milliampereHour.toMilliampereHours(2.5), 2.5);
    });
  });

  group('CurrentUnit', () {
    test('normalizes every supported unit to milliamperes', () {
      expect(CurrentUnit.nanoampere.toMilliamperes(1000000), 1);
      expect(CurrentUnit.microampere.toMilliamperes(1000), 1);
      expect(CurrentUnit.milliampere.toMilliamperes(1), 1);
      expect(CurrentUnit.ampere.toMilliamperes(0.001), 1);
    });
  });

  group('TimeUnit', () {
    test('normalizes every supported unit to hours', () {
      expect(TimeUnit.microsecond.toHours(3600000000), closeTo(1, 1e-12));
      expect(TimeUnit.millisecond.toHours(3600000), closeTo(1, 1e-12));
      expect(TimeUnit.second.toHours(3600), closeTo(1, 1e-12));
      expect(TimeUnit.minute.toHours(60), closeTo(1, 1e-12));
      expect(TimeUnit.hour.toHours(1), 1);
    });
  });

  group('MonitoringPeriodUnit', () {
    test('normalizes hours, days, and weeks to hours', () {
      expect(MonitoringPeriodUnit.hour.toHours(8), 8);
      expect(MonitoringPeriodUnit.day.toHours(1), 24);
      expect(MonitoringPeriodUnit.week.toHours(1), 168);
    });
  });
}
