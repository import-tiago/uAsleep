import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../services/legacy_settings_source.dart';
import '../services/settings_data_source.dart';

class LocalSettingsRepository implements SettingsRepository {
  factory LocalSettingsRepository({
    required SettingsDataSource dataSource,
    LegacySettingsSource? legacySource,
  }) {
    return LocalSettingsRepository._(dataSource, legacySource);
  }

  const LocalSettingsRepository._(this._dataSource, this._legacySource);

  static const String _localeKey = 'settings.locale';
  static const String _precisionKey = 'settings.precision';
  static const String _themeKey = 'settings.theme';
  static const String _migrationKey = 'migration.legacy_settings.v1';

  final SettingsDataSource _dataSource;
  final LegacySettingsSource? _legacySource;

  @override
  Future<AppSettings> load() async {
    await _migrateLegacySettingsIfNeeded();

    final String? storedLocale = await _dataSource.getString(_localeKey);
    final int? storedPrecision = await _dataSource.getInt(_precisionKey);
    final String? storedTheme = await _dataSource.getString(_themeKey);

    return AppSettings(
      localeTag: _validLocale(storedLocale),
      precision: switch (storedPrecision) {
        0 => 0,
        2 => 2,
        _ => 2,
      },
      theme: AppThemePreference.values.firstWhere(
        (AppThemePreference value) => value.name == storedTheme,
        orElse: () => AppThemePreference.system,
      ),
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    if (settings.localeTag == null) {
      await _dataSource.remove(_localeKey);
    } else {
      final String localeTag = settings.localeTag ?? 'en';
      await _dataSource.setString(_localeKey, localeTag);
    }
    await _dataSource.setInt(_precisionKey, settings.precision);
    await _dataSource.setString(_themeKey, settings.theme.name);
  }

  Future<void> _migrateLegacySettingsIfNeeded() async {
    if (await _dataSource.getBool(_migrationKey) ?? false) {
      return;
    }

    final LegacySettings? legacy = await _legacySource?.read();
    if (legacy?.localeTag != null &&
        await _dataSource.getString(_localeKey) == null) {
      final String? localeTag = legacy?.localeTag;
      if (localeTag != null) {
        await _dataSource.setString(_localeKey, localeTag);
      }
    }
    if (legacy?.precision != null &&
        await _dataSource.getInt(_precisionKey) == null) {
      final int? precision = legacy?.precision;
      if (precision != null) {
        await _dataSource.setInt(_precisionKey, precision);
      }
    }
    await _dataSource.setBool(_migrationKey, true);
  }

  String? _validLocale(String? locale) {
    return switch (locale) {
      'en' || 'pt_BR' => locale,
      _ => null,
    };
  }
}
