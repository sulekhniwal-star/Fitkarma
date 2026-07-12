import 'package:flutter/material.dart';

class AppColorsDark {
  AppColorsDark._();

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
  static const primary        = Color(0xFFFF6B35);
  static const primaryGlow    = Color(0x40FF6B35);
  static const primaryMuted   = Color(0x30FF6B35);
  static const accent         = Color(0xFFFFB547);
  static const accentGlow     = Color(0x33FFB547);
  static const secondary      = Color(0xFF7B6FF0);
  static const secondaryGlow  = Color(0x407B6FF0);
  static const teal           = Color(0xFF00D4B4);
  static const tealGlow       = Color(0x3300D4B4);

  // Hero / Onboarding welcome gradient
  static const heroDeep       = Color(0xFF0A0818);
  static const heroDeep2      = Color(0xFF130D2E);
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.45, 1.0],
    colors: [heroDeep, Color(0xFF1A0F3A), Color(0xFF0F0920)],
  );

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
}

class AppColorsLight {
  AppColorsLight._();

  // Background layers
  static const bg0         = Color(0xFFF6F6FB);
  static const bg1         = Color(0xFFFCFCFF);
  static const bg2         = Color(0xFFFFFFFF);

  // Surface layers
  static const surface0    = Color(0xFFFFFFFF);
  static const surface1    = Color(0xFFF1F1F6);
  static const surface2    = Color(0xFFEBEBEF);

  // Glassmorphic overlays (subtle shadow contrast)
  static const glass       = Color(0x08000000);
  static const glassBorder = Color(0x0C000000);

  // Brand Highlights (deeper contrast to improve accessibility ratios)
  static const primary        = Color(0xFFE04E1B);
  static const primaryGlow    = Color(0x22E04E1B);
  static const primaryMuted   = Color(0x12E04E1B);
  static const accent         = Color(0xFFD97706);
  static const accentGlow     = Color(0x1CD97706);
  static const secondary      = Color(0xFF5D50DD);
  static const secondaryGlow  = Color(0x205D50DD);
  static const teal           = Color(0xFF009688);
  static const tealGlow       = Color(0x1A009688);

  // Semantic Warnings & Health states
  static const success        = Color(0xFF16A34A);
  static const successGlow    = Color(0x1C16A34A);
  static const warning        = Color(0xFFD97706);
  static const error          = Color(0xFFDC2626);
  static const rose           = Color(0xFFE11D48);
  static const purple         = Color(0xFF9333EA);

  // Texts
  static const textPrimary    = Color(0xFF0A0A10);
  static const textSecondary  = Color(0xFF585777);
  static const textMuted      = Color(0xFF8886A5);
  static const divider        = Color(0x0A000000);
}
