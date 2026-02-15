import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFFFF9933); // Saffron-ish
  static const Color secondary = Color(0xFF138808); // India Green
  static const Color accent = Color(0xFF00B4D8); // Sky blue/Teal accent

  // Dark Mode Palette (Premium Aesthetics)
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color cardBackground = Color(0xFF252525);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textHint = Color(0xFF666666);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFFFF9933),
    Color(0xFFFFB366),
  ];

  static const List<Color> karmaGradient = [
    Color(0xFFFFD700), // Gold
    Color(0xFFFFA500), // Orange
  ];

  // Specific Karma Points colors
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color diamond = Color(0xFFB9F2FF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
}
