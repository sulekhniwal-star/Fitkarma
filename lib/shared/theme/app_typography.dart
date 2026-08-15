import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// FitKarma Typography System (v1.0)
class AppTypography {
  AppTypography._();

  static const heroDisplay = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w800,
    letterSpacing: -2.0,
    height: 0.95,
    color: AppColors.textPrimary,
  );

  static const metricXL = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  static const metricLg = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const displayLg = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.15,
    color: AppColors.textPrimary,
  );

  static const displayMd = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const h1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const h3 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
  );

  static const labelLg = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const labelMd = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // Devanagari — NEVER use PlusJakartaSans for Hindi
  static TextStyle hindi(
          {double size = 14, FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.notoSansDevanagari(
        fontSize: size,
        fontWeight: weight,
        height: 1.6,
        color: AppColors.textPrimary,
      );

  // Legacy mappings for temporary compatibility
  static TextStyle get displayLarge => displayLg;
  static TextStyle get titleLarge => h1;
  static TextStyle get titleMedium => h2;
  static TextStyle get bodyMedium => bodyMd;
  static TextStyle get labelSmall => labelMd;
}
