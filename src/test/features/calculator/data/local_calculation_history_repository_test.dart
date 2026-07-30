import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/features/calculator/data/repositories/local_calculation_history_repository.dart';
import 'package:uasleep/features/calculator/domain/entities/battery_life_result.dart';
import 'package:uasleep/features/calculator/domain/entities/battery_usage_profile.dart';
import 'package:uasleep/features/calculator/domain/entities/calculation_history_entry.dart';
import 'package:uasleep/features/calculator/domain/value_objects/measurement_units.dart';

import '../../../helpers/fakes.dart';

void main() {
  CalculationHistoryEntry entry(int id) {
    return CalculationHistoryEntry(
      id: '$id',
      createdAt: DateTime.utc(2026, 7, 30, 10, id),
      profile: const BatteryUsageProfile(
        batteryCapacity: 1000,
        batteryCapacityUnit: BatteryCapacityUnit.milliampereHour,
        activeCurrent: 100,
        activeCurrentUnit: CurrentUnit.milliampere,
        sleepEnabled: false,
      ),
      result: const BatteryLifeResult(
        hours: 10,
        averageCurrentMilliamperes: 100,
        activeDutyCycle: 1,
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
