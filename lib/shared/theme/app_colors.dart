import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0D0F12);
  static const Color surface = Color(0xFF161A20);
  static const Color surfaceElevated = Color(0xFF1E232B);
  static const Color surfaceElevatedHigh = Color(0xFF272D37);

  // Glassmorphic Fills & Borders
  static const Color glassFill = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x26FFFFFF); // 15% white
  static const Color glassBorderHighlight = Color(0x4DFFFFFF); // 30% white

  // Brand Accents
  static const Color karmaGreen = Color(0xFF00E676); // Primary Brand & Optimal State
  static const Color focusBlue = Color(0xFF00B0FF); // Secondary Brand & Focus
  static const Color energyOrange = Color(0xFFFF9100); // Activity & High Energy
  static const Color alertRed = Color(0xFFFF5252); // Safety alerts & critical states
  static const Color aiPurple = Color(0xFF7C4DFF); // Groq / AI Coach features
  static const Color gold = Color(0xFFFFD700); // Karma achievements & streaks

  // Glow Opacities
  static const Color karmaGlow = Color(0x4000E676);
  static const Color blueGlow = Color(0x4000B0FF);
  static const Color purpleGlow = Color(0x407C4DFF);

  // Readiness Zone Colors
  static const Color readinessOptimal = karmaGreen;
  static const Color readinessModerate = focusBlue;
  static const Color readinessRecovery = Color(0xFFFFAB00);
  static const Color readinessRest = alertRed;

  // Text Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textInverse = Color(0xFF0D0F12);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [karmaGreen, Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGradient = LinearGradient(
    colors: [aiPurple, focusBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGlassGradient = LinearGradient(
    colors: [Color(0x2AFFFFFF), Color(0x0AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
