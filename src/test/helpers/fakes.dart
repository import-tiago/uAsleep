import 'package:uasleep/core/services/app_info_provider.dart';
import 'package:uasleep/core/services/feedback_launcher.dart';
import 'package:uasleep/core/services/result_exporter.dart';
import 'package:uasleep/features/calculator/domain/entities/calculation_history_entry.dart';
import 'package:uasleep/features/calculator/domain/repositories/calculation_history_repository.dart';
import 'package:uasleep/features/settings/data/services/legacy_settings_source.dart';
import 'package:uasleep/features/settings/data/services/settings_data_source.dart';
import 'package:uasleep/features/settings/domain/entities/app_settings.dart';
import 'package:uasleep/features/settings/domain/repositories/settings_repository.dart';

class MemorySettingsDataSource implements SettingsDataSource {
  final Map<String, Object> values = <String, Object>{};

  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;

  @override
  Future<int?> getInt(String key) async => values[key] as int?;

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    values[key] = value;
  }

  @override
  Future<void> setInt(String key, int value) async {
    values[key] = value;
  }

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }
}

class StubLegacySettingsSource implements LegacySettingsSource {
  const StubLegacySettingsSource(this.settings);

  final LegacySettings? settings;

  @override
  Future<LegacySettings?> read() async => settings;
}

class MemorySettingsRepository implements SettingsRepository {
  MemorySettingsRepository({
    this.current = const AppSettings(),
    this.failLoad = false,
    this.failSave = false,
  });

  AppSettings current;
  bool failLoad;
  bool failSave;

  @override
  Future<AppSettings> load() async {
    if (failLoad) {
      throw StateError('load failed');
    }
    return current;
  }

  @override
  Future<void> save(AppSettings settings) async {
    if (failSave) {
      throw StateError('save failed');
    }
    current = settings;
  }
}

class FakeFeedbackLauncher implements FeedbackLauncher {
  FakeFeedbackLauncher({this.result = true});

  bool result;
  int calls = 0;

  @override
  Future<bool> open({required String subject, required String body}) async {
    calls += 1;
    return result;
  }
}

class FakeAppInfoProvider implements AppInfoProvider {
  const FakeAppInfoProvider([this.value = '2.0.0+6']);

  final String value;

  @override
  Future<String> version() async => value;
}

class FakeResultExporter implements ResultExporter {
  FakeResultExporter({this.result = true});

  bool result;
  int calls = 0;
  String? lastBody;
  String? lastSubject;

  @override
  Future<bool> export({required String subject, required String body}) async {
    calls += 1;
    lastSubject = subject;
    lastBody = body;
    return result;
  }
}

class MemoryCalculationHistoryRepository
    implements CalculationHistoryRepository {
  final List<CalculationHistoryEntry> entries = <CalculationHistoryEntry>[];

  @override
  Future<void> add(CalculationHistoryEntry entry) async {
    entries.insert(0, entry);
  }

  @override
  Future<void> clear() async {
    entries.clear();
  }

  @override
  Future<List<CalculationHistoryEntry>> load() async =>
      List<CalculationHistoryEntry>.unmodifiable(entries);
}
