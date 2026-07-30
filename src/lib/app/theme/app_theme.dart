import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color navy = Color(0xFF071A33);
  static const Color navyMid = Color(0xFF0B2A4A);
  static const Color electricBlue = Color(0xFF2F80ED);
  static const Color cyan = Color(0xFF38BDF8);

  static ThemeData light() => _theme(Brightness.light);

  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;
    final ColorScheme colors =
        ColorScheme.fromSeed(
          seedColor: navyMid,
          brightness: brightness,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ).copyWith(
          primary: isLight ? navyMid : const Color(0xFF8FC1FF),
          onPrimary: isLight ? Colors.white : navy,
          primaryContainer: isLight
              ? const Color(0xFFDCEBFF)
              : const Color(0xFF173F67),
          onPrimaryContainer: isLight ? navy : const Color(0xFFD8E9FF),
          secondary: isLight ? electricBlue : cyan,
          onSecondary: isLight ? Colors.white : const Color(0xFF003548),
          secondaryContainer: isLight
              ? const Color(0xFFDDF1FF)
              : const Color(0xFF0C4660),
          onSecondaryContainer: isLight
              ? const Color(0xFF062A45)
              : const Color(0xFFC6EEFF),
          tertiary: isLight ? const Color(0xFF007C91) : const Color(0xFF67E8F9),
          tertiaryContainer: isLight
              ? const Color(0xFFC8F4FA)
              : const Color(0xFF164E63),
          surface: isLight ? const Color(0xFFF8FAFC) : navy,
          onSurface: isLight
              ? const Color(0xFF0D1B2A)
              : const Color(0xFFE8F1FA),
          surfaceContainerLowest: isLight
              ? Colors.white
              : const Color(0xFF061426),
          surfaceContainerLow: isLight ? Colors.white : const Color(0xFF0A203B),
          surfaceContainer: isLight
              ? const Color(0xFFF1F5F9)
              : const Color(0xFF0D2745),
          surfaceContainerHigh: isLight
              ? const Color(0xFFE2E8F0)
              : const Color(0xFF112D4D),
          outline: isLight ? const Color(0xFF60758A) : const Color(0xFF8BA0B5),
          outlineVariant: isLight
              ? const Color(0xFFCBD5E1)
              : const Color(0xFF344B63),
        );
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.outlineVariant),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      canvasColor: colors.surface,
      focusColor: colors.secondary.withValues(alpha: 0.14),
      splashColor: colors.secondary.withValues(alpha: 0.12),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.secondary,
        selectionColor: colors.secondary.withValues(alpha: 0.24),
        selectionHandleColor: colors.secondary,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.primary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: colors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      iconTheme: IconThemeData(color: colors.primary),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: colors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLowest,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.secondary, width: 2),
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
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? colors.onSecondary
              : colors.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? colors.secondary
              : colors.surfaceContainerHigh,
        ),
        trackOutlineColor: WidgetStatePropertyAll(colors.outlineVariant),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? navyMid : const Color(0xFFDCEBFF),
        contentTextStyle: TextStyle(
          color: isLight ? Colors.white : navy,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant),
    );
  }
}
