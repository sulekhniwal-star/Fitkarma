import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class FitkarmaAppTheme {
  FitkarmaAppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.bg0,
      primaryColor: AppColorsDark.primary,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColorsDark.primary,
        secondary: AppColorsDark.secondary,
        surface: AppColorsDark.surface0,
        error: AppColorsDark.error,
      ),
      
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColorsDark.primary,
        selectionColor: AppColorsDark.primaryMuted,
        selectionHandleColor: AppColorsDark.primary,
      ),

      textTheme: const TextTheme(
        displayLarge: AppTypography.heroDisplay,
        displayMedium: AppTypography.metricXL,
        displaySmall: AppTypography.metricLg,
        headlineLarge: AppTypography.displayLg,
        headlineMedium: AppTypography.displayMd,
        headlineSmall: AppTypography.h1,
        titleLarge: AppTypography.h1,
        titleMedium: AppTypography.h2,
        titleSmall: AppTypography.h3,
        bodyLarge: AppTypography.bodyLg,
        bodyMedium: AppTypography.bodyMd,
        bodySmall: AppTypography.bodySm,
        labelLarge: AppTypography.labelLg,
        labelSmall: AppTypography.labelMd,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColorsLight.bg0,
      primaryColor: AppColorsLight.primary,
      
      colorScheme: const ColorScheme.light(
        primary: AppColorsLight.primary,
        secondary: AppColorsLight.secondary,
        surface: AppColorsLight.surface0,
        error: AppColorsLight.error,
      ),
      
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColorsLight.primary,
        selectionColor: AppColorsLight.primaryMuted,
        selectionHandleColor: AppColorsLight.primary,
      ),

      textTheme: const TextTheme(
        displayLarge: AppTypography.heroDisplay,
        displayMedium: AppTypography.metricXL,
        displaySmall: AppTypography.metricLg,
        headlineLarge: AppTypography.displayLg,
        headlineMedium: AppTypography.displayMd,
        headlineSmall: AppTypography.h1,
        titleLarge: AppTypography.h1,
        titleMedium: AppTypography.h2,
        titleSmall: AppTypography.h3,
        bodyLarge: AppTypography.bodyLg,
        bodyMedium: AppTypography.bodyMd,
        bodySmall: AppTypography.bodySm,
        labelLarge: AppTypography.labelLg,
        labelSmall: AppTypography.labelMd,
      ),
    );
  }
}
