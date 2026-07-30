import 'package:equatable/equatable.dart';

enum AppThemePreference { system, light, dark }

class AppSettings extends Equatable {
  const AppSettings({
    this.localeTag,
    this.precision = 0,
    this.theme = AppThemePreference.light,
  }) : assert(precision == 0 || precision == 2);

  /// Null means that the operating-system locale is followed.
  final String? localeTag;
  final int precision;
  final AppThemePreference theme;

  AppSettings copyWith({
    String? localeTag,
    bool clearLocale = false,
    int? precision,
    AppThemePreference? theme,
  }) {
    return AppSettings(
      localeTag: clearLocale ? null : localeTag ?? this.localeTag,
      precision: precision ?? this.precision,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => <Object?>[localeTag, precision, theme];
}
