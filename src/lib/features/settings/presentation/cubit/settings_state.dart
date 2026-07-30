import 'package:equatable/equatable.dart';

import '../../domain/entities/app_settings.dart';

enum SettingsStatus { initial, loading, ready, failure }

enum SettingsFailure { load, save }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settings = const AppSettings(),
    this.failure,
  });

  final SettingsStatus status;
  final AppSettings settings;
  final SettingsFailure? failure;

  SettingsState copyWith({
    SettingsStatus? status,
    AppSettings? settings,
    SettingsFailure? failure,
    bool clearFailure = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, settings, failure];
}
