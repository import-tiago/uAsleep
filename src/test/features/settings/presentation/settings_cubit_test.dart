import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/features/settings/domain/entities/app_settings.dart';
import 'package:uasleep/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:uasleep/features/settings/presentation/cubit/settings_state.dart';

import '../../../helpers/fakes.dart';

void main() {
  group('SettingsCubit', () {
    blocTest<SettingsCubit, SettingsState>(
      'loads persisted settings',
      build: () => SettingsCubit(
        repository: MemorySettingsRepository(
          current: const AppSettings(
            localeTag: 'pt_BR',
            precision: 0,
            theme: AppThemePreference.dark,
          ),
        ),
      ),
      act: (SettingsCubit cubit) => cubit.load(),
      expect: () => const <SettingsState>[
        SettingsState(status: SettingsStatus.loading),
        SettingsState(
          status: SettingsStatus.ready,
          settings: AppSettings(
            localeTag: 'pt_BR',
            precision: 0,
            theme: AppThemePreference.dark,
          ),
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'changes locale, precision, and theme',
      build: () => SettingsCubit(repository: MemorySettingsRepository()),
      act: (SettingsCubit cubit) async {
        await cubit.setLocale('pt_BR');
        await cubit.setPrecision(0);
        await cubit.setTheme(AppThemePreference.dark);
      },
      verify: (SettingsCubit cubit) {
        expect(
          cubit.state.settings,
          const AppSettings(
            localeTag: 'pt_BR',
            precision: 0,
            theme: AppThemePreference.dark,
          ),
        );
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'reports a load failure',
      build: () =>
          SettingsCubit(repository: MemorySettingsRepository(failLoad: true)),
      act: (SettingsCubit cubit) => cubit.load(),
      expect: () => const <SettingsState>[
        SettingsState(status: SettingsStatus.loading),
        SettingsState(
          status: SettingsStatus.failure,
          failure: SettingsFailure.load,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'rolls back after a save failure',
      build: () =>
          SettingsCubit(repository: MemorySettingsRepository(failSave: true)),
      act: (SettingsCubit cubit) => cubit.setTheme(AppThemePreference.dark),
      expect: () => const <SettingsState>[
        SettingsState(
          status: SettingsStatus.ready,
          settings: AppSettings(theme: AppThemePreference.dark),
        ),
        SettingsState(
          status: SettingsStatus.failure,
          failure: SettingsFailure.save,
        ),
      ],
    );
  });
}
