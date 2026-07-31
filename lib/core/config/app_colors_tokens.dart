import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';

/// Dark Theme Color Tokens Alias (AppColorsDark)
class AppColorsDark {
  AppColorsDark._();

  // Background layers
  static const bg0         = AppColors.bg0;
  static const bg1         = AppColors.bg1;
  static const bg2         = AppColors.bg2;

  // Surface layers
  static const surface0    = AppColors.surface0;
  static const surface1    = AppColors.surface1;
  static const surface2    = AppColors.surface2;

  // Glassmorphism
  static const glass       = AppColors.glass;
  static const glassBorder = AppColors.glassBorder;

  // Brand
  static const primary        = AppColors.primary;
  static const primaryGlow    = AppColors.primaryGlow;
  static const primaryMuted   = AppColors.primaryMuted;
  static const accent         = AppColors.accent;
  static const accentGlow     = AppColors.accentGlow;
  static const secondary      = AppColors.secondary;
  static const secondaryGlow  = AppColors.secondaryGlow;
  static const teal           = AppColors.teal;
  static const tealGlow       = AppColors.tealGlow;

  // Semantic
  static const success        = AppColors.success;
  static const successGlow    = AppColors.successGlow;
  static const warning        = AppColors.warning;
  static const error          = AppColors.error;
  static const rose           = AppColors.rose;
  static const purple         = AppColors.purple;

  // Text
  static const textPrimary    = AppColors.textPrimary;
  static const textSecondary  = AppColors.textSecondary;
  static const textMuted      = AppColors.textMuted;
  static const divider        = AppColors.divider;
}

/// Light Mode Saffron Inversion Palette (AppColorsLight)
class AppColorsLight {
  AppColorsLight._();

  static const bg0         = Color(0xFFFAF8F5);
  static const bg1         = Color(0xFFF3EFE9);
  static const bg2         = Color(0xFFEBE5DC);

  static const surface0    = Color(0xFFFFFFFF);
  static const surface1    = Color(0xFFF5F0E8);
  static const surface2    = Color(0xFFEFE8DD);

  static const glass       = Color(0x0F000000);
  static const glassBorder = Color(0x1A000000);

  static const primary        = Color(0xFFE65100); // Warm Saffron
  static const primaryGlow    = Color(0x40E65100);
  static const primaryMuted   = Color(0x30E65100);
  static const accent         = Color(0xFFF57C00);
  static const accentGlow     = Color(0x33F57C00);
  static const secondary      = Color(0xFF5C6BC0);
  static const secondaryGlow  = Color(0x405C6BC0);
  static const teal           = Color(0xFF00897B);
  static const tealGlow       = Color(0x3300897B);

  static const success        = Color(0xFF2E7D32);
  static const successGlow    = Color(0x332E7D32);
  static const warning        = Color(0xFFF57F17);
  static const error          = Color(0xFFC62828);
  static const rose           = Color(0xFFAD1457);
  static const purple         = Color(0xFF6A1B9A);

  static const textPrimary    = Color(0xFF1F1B16);
  static const textSecondary  = Color(0xFF5C5449);
  static const textMuted      = Color(0xFF8C8275);
  static const divider        = Color(0x14000000);
}
