import 'package:flutter/material.dart';

/// FitKarma Curated Color Palette & Glassmorphism Tokens (v1.0)
class AppColors {
  AppColors._();

  // Background layers
  static const bg0         = Color(0xFF080810);
  static const bg1         = Color(0xFF0F0F1A);
  static const bg2         = Color(0xFF161625);

  // Surface layers
  static const surface0    = Color(0xFF1C1C2E);
  static const surface1    = Color(0xFF22223A);
  static const surface2    = Color(0xFF2A2A45);

  // Glassmorphism
  static const glass       = Color(0x0FFFFFFF);
  static const glassBorder = Color(0x1AFFFFFF);

  // Brand
  static const primary        = Color(0xFFFF6B35); // Orange
  static const primaryGlow    = Color(0x40FF6B35);
  static const primaryMuted   = Color(0x30FF6B35);
  static const accent         = Color(0xFFFFB547); // Amber
  static const accentGlow     = Color(0x33FFB547);
  static const secondary      = Color(0xFF7B6FF0); // Indigo
  static const secondaryGlow  = Color(0x407B6FF0);
  static const teal           = Color(0xFF00D4B4);
  static const tealGlow       = Color(0x3300D4B4);

  // Semantic
  static const success        = Color(0xFF4ADE80);
  static const successGlow    = Color(0x334ADE80);
  static const warning        = Color(0xFFFBBF24);
  static const error          = Color(0xFFF87171);
  static const rose           = Color(0xFFFB7185);
  static const purple         = Color(0xFFC084FC);

  // Text
  static const textPrimary    = Color(0xFFF1F0FF);
  static const textSecondary  = Color(0xFF9B99CC);
  static const textMuted      = Color(0xFF6B68A0);
  static const divider        = Color(0x14FFFFFF);

  // Legacy mappings for temporary compatibility
  static const bgPrimary = bg0;
  static const bgSecondary = bg1;
  static const primaryCyan = primary;
  static const primaryEmerald = success;
}
