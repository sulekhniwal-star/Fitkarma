import 'package:flutter/material.dart';

/// FitKarma Curated Color Palette & Glassmorphism Tokens
class AppColors {
  AppColors._();

  // Primary Dark Backgrounds
  static const Color bgPrimary = Color(0xFF0B0E14);
  static const Color bgSecondary = Color(0xFF141923);
  static const Color bgCard = Color(0xFF1A2130);

  // Brand Accents
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color primaryEmerald = Color(0xFF00E676);
  static const Color primaryViolet = Color(0xFF7C4DFF);

  // Status & Health Indicators
  static const Color successGreen = Color(0xFF00C853);
  static const Color warningAmber = Color(0xFFFFAB00);
  static const Color errorRed = Color(0xFFFF1744);
  static const Color infoBlue = Color(0xFF2979FF);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% white
  static const Color textMuted = Color(0x66FFFFFF);     // 40% white

  // Glassmorphism Overlays & Borders
  static const Color glassBorder = Color(0x1AFFFFFF);   // 10% white border
  static const Color glassBgLight = Color(0x0DFFFFFF);  // 5% white fill
  static const Color glassBgMid = Color(0x19FFFFFF);    // 10% white fill
}
