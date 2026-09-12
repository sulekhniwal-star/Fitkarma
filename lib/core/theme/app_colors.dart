import 'package:flutter/material.dart';

/// FitKarma Design System Colors
/// Dark mode primary: `#0D0F12` with rich neon accents and glass layers
class AppColors {
  AppColors._();

  // Backgrounds & Surfaces
  static const Color background = Color(0xFF0D0F12);
  static const Color surfaceDark = Color(0xFF161A20);
  static const Color surfaceCard = Color(0xFF1E232B);
  static const Color surfaceGlass = Color(0x33252C37); // 20% opacity glass
  static const Color surfaceGlassHover = Color(0x4D333B49);
  static const Color borderGlass = Color(0x33FFFFFF); // 20% white border

  // Glowing Accents & Health OS Metrics
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color primaryEmerald = Color(0xFF00E676);
  static const Color accentAmber = Color(0xFFFFB300);
  static const Color accentCoral = Color(0xFFFF5252);
  static const Color accentPurple = Color(0xFFB388FF);

  // Readiness States
  static const Color readinessHigh = Color(0xFF00E676); // Green / Prime
  static const Color readinessModerate = Color(0xFFFFB300); // Amber / Steady
  static const Color readinessLow = Color(0xFFFF5252); // Red / Rest

  // Text & Content
  static const Color textPrimary = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textOnAccent = Color(0xFF0D0F12);

  // Gradient Presets
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x332E3748),
      Color(0x1A1E2430),
    ],
  );

  static const LinearGradient readinessGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00E5FF),
      Color(0xFF00E676),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00E5FF),
      Color(0xFFB388FF),
    ],
  );
}
