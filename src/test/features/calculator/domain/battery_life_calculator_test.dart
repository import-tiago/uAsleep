import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/features/calculator/domain/entities/battery_usage_profile.dart';
import 'package:uasleep/features/calculator/domain/errors/battery_life_exception.dart';
import 'package:uasleep/features/calculator/domain/services/battery_life_calculator.dart';
import 'package:uasleep/features/calculator/domain/value_objects/measurement_units.dart';

void main() {
  const BatteryLifeCalculator calculator = BatteryLifeCalculator();

  BatteryUsageProfile profile({
    double capacity = 1000,
    double activeCurrent = 100,
    bool sleepEnabled = true,
    double sleepCurrent = 0,
    double activeDuration = 1,
    TimeUnit activeDurationUnit = TimeUnit.second,
    double wakeupsPerHour = 60,
    bool monitoringEnabled = false,
    double monitoringPeriod = 1,
    MonitoringPeriodUnit monitoringPeriodUnit = MonitoringPeriodUnit.hour,
  }) {
    return BatteryUsageProfile(
      batteryCapacity: capacity,
      batteryCapacityUnit: BatteryCapacityUnit.milliampereHour,
      activeCurrent: activeCurrent,
      activeCurrentUnit: CurrentUnit.milliampere,
      sleepEnabled: sleepEnabled,
      sleepCurrent: sleepCurrent,
      sleepCurrentUnit: CurrentUnit.milliampere,
      activeDuration: activeDuration,
      activeDurationUnit: activeDurationUnit,
      wakeupsPerHour: wakeupsPerHour,
      monitoringEnabled: monitoringEnabled,
      monitoringPeriod: monitoringPeriod,
      monitoringPeriodUnit: monitoringPeriodUnit,
    );
  }

  Matcher throwsCode(BatteryLifeErrorCode code) {
    return throwsA(
      isA<BatteryLifeException>().having(
        (BatteryLifeException error) => error.code,
        'code',
        code,
      ),
    );
  }

  test('calculates continuous consumption without sleep', () {
    final result = calculator.calculate(
      profile(sleepEnabled: false, activeCurrent: 100),
    );

    // 1000 mAh / 100 mA = 10 h.
    expect(result.hours, 10);
    expect(result.averageCurrentMilliamperes, 100);
    expect(result.activeDutyCycle, 1);
  });

  test('projects consumption over eight hours', () {
    final result = calculator.calculate(
      profile(
        sleepEnabled: false,
        activeCurrent: 100,
        monitoringEnabled: true,
        monitoringPeriod: 8,
      ),
    );

    expect(result.monitoringPeriodHours, 8);
    expect(result.monitoredConsumptionMilliampereHours, 800);
    expect(result.monitoredCapacityPercentage, 80);
  });

  test('normalizes a one-week monitoring period to hours', () {
    final result = calculator.calculate(
      profile(
        sleepEnabled: false,
        activeCurrent: 10,
        monitoringEnabled: true,
        monitoringPeriodUnit: MonitoringPeriodUnit.week,
      ),
    );

    expect(result.monitoringPeriodHours, 168);
    expect(result.monitoredConsumptionMilliampereHours, 1680);
    expect(result.monitoredCapacityPercentage, 168);
  });

  test('rejects a non-positive monitoring period', () {
    expect(
      () => calculator.calculate(
        profile(monitoringEnabled: true, monitoringPeriod: 0),
      ),
      throwsCode(BatteryLifeErrorCode.nonPositiveMonitoringPeriod),
    );
  });

  test('preserves the legacy one-hour weighted-duty-cycle behavior', () {
    final result = calculator.calculate(
      BatteryUsageProfile(
        batteryCapacity: 2000,
        batteryCapacityUnit: BatteryCapacityUnit.milliampereHour,
        activeCurrent: 20,
        activeCurrentUnit: CurrentUnit.milliampere,
        sleepCurrent: 10,
        sleepCurrentUnit: CurrentUnit.microampere,
        activeDuration: 1,
        activeDurationUnit: TimeUnit.second,
        wakeupsPerHour: 60,
      ),
    );

    // One minute cycle: (20 mA × 1 s + 0.01 mA × 59 s) / 60 s.
    expect(
      result.averageCurrentMilliamperes,
      closeTo(0.3431666666666667, 1e-12),
    );
    expect(result.hours, closeTo(5828.071879669743, 1e-6));
    expect(result.activeDutyCycle, closeTo(1 / 60, 1e-12));
  });

  test('supports zero sleep current', () {
    final result = calculator.calculate(
      profile(activeCurrent: 10, sleepCurrent: 0),
    );

    expect(result.averageCurrentMilliamperes, closeTo(1 / 6, 1e-12));
    expect(result.hours, closeTo(6000, 1e-9));
  });

  test('treats active duration equal to the cycle as 100% duty cycle', () {
    final result = calculator.calculate(
      profile(
        activeCurrent: 10,
        activeDuration: 1,
        activeDurationUnit: TimeUnit.minute,
      ),
    );

    expect(result.averageCurrentMilliamperes, closeTo(10, 1e-12));
    expect(result.activeDutyCycle, closeTo(1, 1e-12));
    expect(result.hours, closeTo(100, 1e-12));
  });

  test('rejects active duration greater than the cycle', () {
    expect(
      () => calculator.calculate(
        profile(activeDuration: 61, activeDurationUnit: TimeUnit.second),
      ),
      throwsCode(BatteryLifeErrorCode.activeDurationExceedsCycle),
    );
  });

  test('rejects zero capacity', () {
    expect(
      () => calculator.calculate(profile(capacity: 0)),
      throwsCode(BatteryLifeErrorCode.nonPositiveCapacity),
    );
  });

  test('rejects negative capacity', () {
    expect(
      () => calculator.calculate(profile(capacity: -1)),
      throwsCode(BatteryLifeErrorCode.nonPositiveCapacity),
    );
  });

  test('rejects negative active current', () {
    expect(
      () => calculator.calculate(profile(activeCurrent: -1)),
      throwsCode(BatteryLifeErrorCode.negativeCurrent),
    );
  });

  test('rejects negative sleep current', () {
    expect(
      () => calculator.calculate(profile(sleepCurrent: -1)),
      throwsCode(BatteryLifeErrorCode.negativeCurrent),
    );
  });

  test('rejects non-positive active duration', () {
    expect(
      () => calculator.calculate(profile(activeDuration: 0)),
      throwsCode(BatteryLifeErrorCode.nonPositiveActiveDuration),
    );
  });

  test('rejects non-positive wake-up frequency', () {
    expect(
      () => calculator.calculate(profile(wakeupsPerHour: 0)),
      throwsCode(BatteryLifeErrorCode.nonPositiveWakeupFrequency),
    );
  });

  test('rejects zero average current', () {
    expect(
      () => calculator.calculate(
        profile(activeCurrent: 0, sleepCurrent: 0, sleepEnabled: false),
      ),
      throwsCode(BatteryLifeErrorCode.zeroAverageCurrent),
    );
  });

  test('rejects NaN and infinity', () {
    expect(
      () => calculator.calculate(profile(capacity: double.nan)),
      throwsCode(BatteryLifeErrorCode.nonFiniteValue),
    );
    expect(
      () => calculator.calculate(profile(activeCurrent: double.infinity)),
      throwsCode(BatteryLifeErrorCode.nonFiniteValue),
    );
  });

  test('keeps very small finite values finite', () {
    final result = calculator.calculate(
      profile(capacity: 1e-9, activeCurrent: 1e-12, sleepEnabled: false),
    );

    expect(result.hours, closeTo(1000, 1e-9));
    expect(result.hours.isFinite, isTrue);
  });

  test('keeps very large finite values finite', () {
    final result = calculator.calculate(
      profile(capacity: 1e100, activeCurrent: 1e90, sleepEnabled: false),
    );

    expect(result.hours, closeTo(1e10, 1));
    expect(result.hours.isFinite, isTrue);
  });
}
