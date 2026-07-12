import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const heroDisplay  = TextStyle(fontSize: 72, fontWeight: FontWeight.w800, letterSpacing: -2.0, height: 0.95);
  static const metricXL     = TextStyle(fontSize: 56, fontWeight: FontWeight.w700, letterSpacing: -1.5, height: 1.0);
  static const metricLg     = TextStyle(fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -1.0, height: 1.1);
  static const displayLg    = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.8, height: 1.15);
  static const displayMd    = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.4, height: 1.2);
  static const h1           = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, height: 1.25);
  static const h2           = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.3);
  static const h3           = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.1, height: 1.35);
  static const bodyLg       = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static const bodyMd       = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static const bodySm       = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);
  static const labelLg      = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.2, height: 1.4);
  static const labelMd      = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, height: 1.4);

  // Devanagari — NEVER use PlusJakartaSans for Hindi
  static TextStyle hindi({double size = 14, FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: size, fontWeight: weight, height: 1.6);
}
