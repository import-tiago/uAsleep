import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../features/settings/data/repositories/local_settings_repository.dart';
import '../features/settings/data/services/legacy_settings_source.dart';
import '../features/settings/data/services/shared_preferences_settings_data_source.dart';
import 'app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final LocalSettingsRepository settingsRepository = LocalSettingsRepository(
    dataSource: SharedPreferencesSettingsDataSource(),
    legacySource: FileLegacySettingsSource(getApplicationDocumentsDirectory),
  );

  runApp(UAsleepApp(settingsRepository: settingsRepository));
}
