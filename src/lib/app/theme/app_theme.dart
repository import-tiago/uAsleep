import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color seedColor = Color.fromARGB(255, 104, 31, 138);
  static const Color energyColor = Color(0xFF007F82);

  static ThemeData light() => _theme(Brightness.light);

  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final ColorScheme colors =
        ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ).copyWith(
          secondary: brightness == Brightness.light
              ? energyColor
              : const Color(0xFF71D5D5),
        );
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: colors.outlineVariant),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLowest,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorMaxLines: 3,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant),
    );
  }
}
