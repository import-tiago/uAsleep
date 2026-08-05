import 'dart:convert';

import '../../../settings/data/services/settings_data_source.dart';
import '../../domain/entities/battery_life_result.dart';
import '../../domain/entities/battery_usage_profile.dart';
import '../../domain/entities/calculation_history_entry.dart';
import '../../domain/repositories/calculation_history_repository.dart';
import '../../domain/value_objects/measurement_units.dart';

class LocalCalculationHistoryRepository
    implements CalculationHistoryRepository {
  LocalCalculationHistoryRepository(this._dataSource, {this.maxEntries = 50});

  static const String _storageKey = 'calculator.history.v1';

  final SettingsDataSource _dataSource;
  final int maxEntries;
  Future<void> _pendingMutation = Future<void>.value();

  @override
  Future<void> add(CalculationHistoryEntry entry) {
    final Future<void> operation = _pendingMutation.then((_) async {
      final List<CalculationHistoryEntry> entries = await _read();
      final List<CalculationHistoryEntry> updated =
          <CalculationHistoryEntry>[entry, ...entries]..removeWhere(
            (CalculationHistoryEntry item) =>
                item.id == entry.id && !identical(item, entry),
          );
      await _write(updated.take(maxEntries).toList(growable: false));
    });
    _pendingMutation = operation.onError((Object _, StackTrace _) {});
    return operation;
  }

  @override
  Future<void> clear() {
    final Future<void> operation = _pendingMutation.then(
      (_) => _dataSource.remove(_storageKey),
    );
    _pendingMutation = operation.onError((Object _, StackTrace _) {});
    return operation;
  }

  @override
  Future<List<CalculationHistoryEntry>> load() async {
    await _pendingMutation;
    return _read();
  }

  Future<List<CalculationHistoryEntry>> _read() async {
    final String? source = await _dataSource.getString(_storageKey);
    if (source == null || source.isEmpty) {
      return const <CalculationHistoryEntry>[];
    }

    try {
      final Object? decoded = jsonDecode(source);
      if (decoded is! List<Object?>) {
        return const <CalculationHistoryEntry>[];
      }
      return decoded
          .map(_tryEntryFromJson)
          .whereType<CalculationHistoryEntry>()
          .toList(growable: false);
    } on FormatException {
      return const <CalculationHistoryEntry>[];
    } on TypeError {
      return const <CalculationHistoryEntry>[];
    }
  }

  CalculationHistoryEntry? _tryEntryFromJson(Object? value) {
    if (value is! Map<String, Object?>) {
      return null;
    }
    try {
      return _entryFromJson(value);
    } on FormatException {
      return null;
    } on StateError {
      return null;
    } on TypeError {
      return null;
    }
  }

  CalculationHistoryEntry? _entryFromJson(Map<String, Object?> json) {
    final DateTime? createdAt = DateTime.tryParse(json['createdAt'] as String);
    final Map<String, Object?> profile =
        (json['profile'] as Map<Object?, Object?>).cast<String, Object?>();
    final Map<String, Object?> result =
        (json['result'] as Map<Object?, Object?>).cast<String, Object?>();
    final String id = json['id'] as String;
    if (createdAt == null) {
      return null;
    }

    return CalculationHistoryEntry(
      id: id,
      createdAt: createdAt,
      profile: BatteryUsageProfile(
        batteryCapacity: (profile['batteryCapacity'] as num).toDouble(),
        batteryCapacityUnit: _enumByName(
          BatteryCapacityUnit.values,
          profile['batteryCapacityUnit'] as String,
        ),
        activeCurrent: (profile['activeCurrent'] as num).toDouble(),
        activeCurrentUnit: _enumByName(
          CurrentUnit.values,
          profile['activeCurrentUnit'] as String,
        ),
        sleepEnabled: profile['sleepEnabled'] as bool,
        sleepCurrent: (profile['sleepCurrent'] as num).toDouble(),
        sleepCurrentUnit: _enumByName(
          CurrentUnit.values,
          profile['sleepCurrentUnit'] as String,
        ),
        activeDuration: (profile['activeDuration'] as num).toDouble(),
        activeDurationUnit: _enumByName(
          TimeUnit.values,
          profile['activeDurationUnit'] as String,
        ),
        wakeupsPerHour: (profile['wakeupsPerHour'] as num).toDouble(),
      ),
      result: BatteryLifeResult(
        hours: (result['hours'] as num).toDouble(),
        averageCurrentMilliamperes:
            (result['averageCurrentMilliamperes'] as num).toDouble(),
        activeDutyCycle: (result['activeDutyCycle'] as num).toDouble(),
      ),
    );
  }

  T _enumByName<T extends Enum>(List<T> values, String name) {
    return values.firstWhere((T value) => value.name == name);
  }

  Map<String, Object> _entryToJson(CalculationHistoryEntry entry) {
    
    final BatteryUsageProfile profile = entry.profile;
    final BatteryLifeResult result = entry.result;
    return <String, Object>{
      'id': entry.id,
      'createdAt': entry.createdAt.toIso8601String(),
      'profile': <String, Object>{
        'batteryCapacity': profile.batteryCapacity,
        'batteryCapacityUnit': profile.batteryCapacityUnit.name,
        'activeCurrent': profile.activeCurrent,
        'activeCurrentUnit': profile.activeCurrentUnit.name,
        'sleepEnabled': profile.sleepEnabled,
        'sleepCurrent': profile.sleepCurrent,
        'sleepCurrentUnit': profile.sleepCurrentUnit.name,
        'activeDuration': profile.activeDuration,
        'activeDurationUnit': profile.activeDurationUnit.name,
        'wakeupsPerHour': profile.wakeupsPerHour,
      },
      'result': <String, Object>{
        'hours': result.hours,
        'averageCurrentMilliamperes': result.averageCurrentMilliamperes,
        'activeDutyCycle': result.activeDutyCycle,
      },
    };
  }

  Future<void> _write(List<CalculationHistoryEntry> entries) {
    return _dataSource.setString(
      _storageKey,
      jsonEncode(entries.map(_entryToJson).toList(growable: false)),
    );
  }
}
