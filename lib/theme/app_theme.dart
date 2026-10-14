import 'package:flutter/material.dart';
import 'app_theme_palette.dart';

ThemeData buildTheme([AppThemePalette? palette]) {
  final p = palette ?? AppThemePalette.classicDark;

  final scheme = ColorScheme.fromSeed(
    seedColor: p.accent,
    brightness: p.brightness,
    primary: p.primary,
    secondary: p.success,
    surface: p.surface,
  );

  final baseTheme = ThemeData(
    brightness: p.brightness,
    useMaterial3: true,
  );

  return ThemeData(
    brightness: p.brightness,
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.background,
    textTheme: baseTheme.textTheme.apply(
      bodyColor: p.textPrimary,
      displayColor: p.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: p.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: p.textPrimary,
      titleTextStyle: TextStyle(
        color: p.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    dividerColor: p.dividerColor,
    extensions: [p],
  );
}

