import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/features/calculator/data/repositories/local_calculation_history_repository.dart';
import 'package:uasleep/features/calculator/domain/entities/battery_life_result.dart';
import 'package:uasleep/features/calculator/domain/entities/battery_usage_profile.dart';
import 'package:uasleep/features/calculator/domain/entities/calculation_history_entry.dart';
import 'package:uasleep/features/calculator/domain/value_objects/measurement_units.dart';

import '../../../helpers/fakes.dart';

void main() {
  CalculationHistoryEntry entry(int id, {bool projected = false}) {
    return CalculationHistoryEntry(
      id: '$id',
      createdAt: DateTime.utc(2026, 7, 30, 10, id),
      profile: BatteryUsageProfile(
        batteryCapacity: 1000,
        batteryCapacityUnit: BatteryCapacityUnit.milliampereHour,
        activeCurrent: 100,
        activeCurrentUnit: CurrentUnit.milliampere,
        sleepEnabled: false,
        monitoringEnabled: projected,
        monitoringPeriod: 1,
        monitoringPeriodUnit: projected
            ? MonitoringPeriodUnit.week
            : MonitoringPeriodUnit.hour,
      ),
      result: BatteryLifeResult(
        hours: 10,
        averageCurrentMilliamperes: 100,
        activeDutyCycle: 1,
        monitoredConsumptionMilliampereHours: projected ? 16800 : null,
        monitoredCapacityPercentage: projected ? 1680 : null,
        monitoringPeriodHours: projected ? 168 : null,
      ),
    );
  }

  test('persists and restores complete history entries', () async {
    final MemorySettingsDataSource source = MemorySettingsDataSource();
    final LocalCalculationHistoryRepository repository =
        LocalCalculationHistoryRepository(source);

    await repository.add(entry(1));

    expect(await repository.load(), <CalculationHistoryEntry>[entry(1)]);
  });

  test('persists and restores monitoring projections', () async {
    final MemorySettingsDataSource source = MemorySettingsDataSource();
    final LocalCalculationHistoryRepository repository =
        LocalCalculationHistoryRepository(source);
    final CalculationHistoryEntry projected = entry(1, projected: true);

    await repository.add(projected);

    expect(await repository.load(), <CalculationHistoryEntry>[projected]);
  });

  test('keeps only the configured number of newest entries', () async {
    final MemorySettingsDataSource source = MemorySettingsDataSource();
    final LocalCalculationHistoryRepository repository =
        LocalCalculationHistoryRepository(source, maxEntries: 2);

    await repository.add(entry(1));
    await repository.add(entry(2));
    await repository.add(entry(3));

    expect(
      (await repository.load()).map((CalculationHistoryEntry item) => item.id),
      <String>['3', '2'],
    );
  });

  test('clears history and safely ignores malformed storage', () async {
    final MemorySettingsDataSource source = MemorySettingsDataSource();
    final LocalCalculationHistoryRepository repository =
        LocalCalculationHistoryRepository(source);
    source.values['calculator.history.v1'] = 'invalid JSON';

    expect(await repository.load(), isEmpty);

    await repository.add(entry(1));
    await repository.clear();
    expect(await repository.load(), isEmpty);
  });
}
