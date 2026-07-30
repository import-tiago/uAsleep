import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/features/settings/data/repositories/local_settings_repository.dart';
import 'package:uasleep/features/settings/data/services/legacy_settings_source.dart';
import 'package:uasleep/features/settings/domain/entities/app_settings.dart';

import '../../../helpers/fakes.dart';

void main() {
  group('LocalSettingsRepository', () {
    test('returns safe defaults for absent settings', () async {
      final MemorySettingsDataSource source = MemorySettingsDataSource();
      final LocalSettingsRepository repository = LocalSettingsRepository(
        dataSource: source,
      );

      expect(await repository.load(), const AppSettings());
      expect(source.values['migration.legacy_settings.v1'], isTrue);
    });

    test('persists and recovers all settings', () async {
      final MemorySettingsDataSource source = MemorySettingsDataSource();
      final LocalSettingsRepository repository = LocalSettingsRepository(
        dataSource: source,
      );
      const AppSettings expected = AppSettings(
        localeTag: 'pt_BR',
        precision: 0,
        theme: AppThemePreference.dark,
      );

      await repository.save(expected);

      expect(await repository.load(), expected);
    });

    test('sanitizes invalid persisted values', () async {
      final MemorySettingsDataSource source = MemorySettingsDataSource();
      source.values.addAll(<String, Object>{
        'settings.locale': 'xx',
        'settings.precision': 99,
        'settings.theme': 'unknown',
        'migration.legacy_settings.v1': true,
      });
      final LocalSettingsRepository repository = LocalSettingsRepository(
        dataSource: source,
      );

      expect(await repository.load(), const AppSettings());
    });

    test('migrates language and precision from uAsleep 1.x once', () async {
      final MemorySettingsDataSource source = MemorySettingsDataSource();
      final LocalSettingsRepository repository = LocalSettingsRepository(
        dataSource: source,
        legacySource: const StubLegacySettingsSource(
          LegacySettings(localeTag: 'pt_BR', precision: 0),
        ),
      );

      expect(
        await repository.load(),
        const AppSettings(localeTag: 'pt_BR', precision: 0),
      );
      expect(source.values['migration.legacy_settings.v1'], isTrue);
    });
  });

  group('FileLegacySettingsSource', () {
    late Directory directory;

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('uasleep_legacy_test_');
    });

    tearDown(() async {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    });

    test('reads the original text-file JSON format', () async {
      final File file = File(
        '${directory.path}${Platform.pathSeparator}DataPersistence.txt',
      );
      await file.writeAsString(
        '{"CurrentLenguage":"PT-BR","ResultPrecision":"Precision"}',
      );
      final FileLegacySettingsSource source = FileLegacySettingsSource(
        () async => directory,
      );

      final LegacySettings? settings = await source.read();

      expect(settings?.localeTag, 'pt_BR');
      expect(settings?.precision, 2);
    });

    test('returns null for malformed legacy data', () async {
      final File file = File(
        '${directory.path}${Platform.pathSeparator}DataPersistence.txt',
      );
      await file.writeAsString('not-json');
      final FileLegacySettingsSource source = FileLegacySettingsSource(
        () async => directory,
      );

      expect(await source.read(), isNull);
    });
  });
}
