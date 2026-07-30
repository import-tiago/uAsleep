import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/app/theme/app_theme.dart';

void main() {
  test('light theme uses the navy brand palette', () {
    final ColorScheme colors = AppTheme.light().colorScheme;

    expect(colors.brightness, Brightness.light);
    expect(colors.primary, AppTheme.navyMid);
    expect(colors.secondary, AppTheme.electricBlue);
    expect(colors.surface, const Color(0xFFF8FAFC));
  });

  test('dark theme keeps navy surfaces and blue accents', () {
    final ColorScheme colors = AppTheme.dark().colorScheme;

    expect(colors.brightness, Brightness.dark);
    expect(colors.surface, AppTheme.navy);
    expect(colors.secondary, AppTheme.cyan);
    expect(colors.primary, const Color(0xFF8FC1FF));
  });
}
