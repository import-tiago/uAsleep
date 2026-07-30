import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  factory SettingsCubit({required SettingsRepository repository}) {
    return SettingsCubit._(repository);
  }

  SettingsCubit._(this._repository) : super(const SettingsState());

  final SettingsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: SettingsStatus.loading, clearFailure: true));
    try {
      final AppSettings settings = await _repository.load();
      emit(SettingsState(status: SettingsStatus.ready, settings: settings));
    } on Object {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          failure: SettingsFailure.load,
        ),
      );
    }
  }

  Future<void> setLocale(String? localeTag) {
    return _save(
      state.settings.copyWith(
        localeTag: localeTag,
        clearLocale: localeTag == null,
      ),
    );
  }

  Future<void> setPrecision(int precision) {
    return _save(state.settings.copyWith(precision: precision));
  }

  Future<void> setTheme(AppThemePreference theme) {
    return _save(state.settings.copyWith(theme: theme));
  }

  Future<void> _save(AppSettings next) async {
    final AppSettings previous = state.settings;
    emit(SettingsState(status: SettingsStatus.ready, settings: next));
    try {
      await _repository.save(next);
    } on Object {
      emit(
        SettingsState(
          status: SettingsStatus.failure,
          settings: previous,
          failure: SettingsFailure.save,
        ),
      );
    }
  }
}
