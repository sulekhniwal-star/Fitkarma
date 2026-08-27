import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors (Deep rich dark theme)
  static const Color background = Color(0xFF0D0F12);
  static const Color surface = Color(0xFF161A20);
  static const Color surfaceElevated = Color(0xFF1E232B);
  
  // Accents
  static const Color primary = Color(0xFF00E676); // Vibrant Karma Green
  static const Color primaryGlow = Color(0x3300E676);
  static const Color secondary = Color(0xFF00B0FF); // Focus Blue
  static const Color accent = Color(0xFFFF9100); // Energy Orange
  static const Color alert = Color(0xFFFF5252); // Alert Red

  // Text Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: alert,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
