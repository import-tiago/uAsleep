import 'dart:convert';
import 'dart:io';

class LegacySettings {
  const LegacySettings({this.localeTag, this.precision});

  final String? localeTag;
  final int? precision;
}

abstract interface class LegacySettingsSource {
  Future<LegacySettings?> read();
}

/// Reads the `DataPersistence.txt` format written by uAsleep 1.x.
///
/// This source is intentionally read-only and is invoked only once. New data
/// is stored through shared_preferences.
class FileLegacySettingsSource implements LegacySettingsSource {
  const FileLegacySettingsSource(this._documentsDirectory);

  final Future<Directory> Function() _documentsDirectory;

  @override
  Future<LegacySettings?> read() async {
    try {
      final Directory directory = await _documentsDirectory();
      final File file = File(
        '${directory.path}${Platform.pathSeparator}DataPersistence.txt',
      );
      if (!await file.exists()) {
        return null;
      }

      final String contents = await file.readAsString();
      final Object? decoded = jsonDecode(contents);
      final Map<String, Object?>? values = _extractValues(decoded);
      if (values == null) {
        return null;
      }

      final Object? languageValue = values['CurrentLenguage'];
      final Object? precisionValue = values['ResultPrecision'];
      final String? legacyLanguage = languageValue is String
          ? languageValue
          : null;
      final String? legacyPrecision = precisionValue is String
          ? precisionValue
          : null;
      return LegacySettings(
        localeTag: switch (legacyLanguage) {
          'PT-BR' => 'pt_BR',
          'EN' => 'en',
          _ => null,
        },
        precision: switch (legacyPrecision) {
          'Simple' => 0,
          'Precision' => 2,
          _ => null,
        },
      );
    } on FileSystemException {
      return null;
    } on FormatException {
      return null;
    }
  }

  Map<String, Object?>? _extractValues(Object? decoded) {
    if (decoded is Map<String, Object?>) {
      return decoded;
    }
    if (decoded is List<Object?> &&
        decoded.isNotEmpty &&
        decoded.first is Map<String, Object?>) {
      return decoded.first as Map<String, Object?>;
    }
    return null;
  }
}
