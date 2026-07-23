import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppSpacing {
  AppSpacing._();

  static const double screenH = 20.0;
  static const double cardH = 16.0;
  static const double fabClearance = 120.0;
  static const double bentoGap = 12.0;
}

class AppRadius {
  AppRadius._();

  static const double sm = 10.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 28.0;
  static const double full = 9999.0;
  static const double bentoInner = 14.0;
  static const double bentoOuter = 20.0;
  static const double bentoHero = 28.0;
}

class AppElevation {
  AppElevation._();

  static const double none = 0.0;
  static const double card = 4.0;
  static const double dialog = 12.0;

  // Custom shadow lists matching brand specifications for dark and light modes
  static const List<BoxShadow> primaryGlowDark = [
    BoxShadow(
      color: AppColorsDark.primaryGlow,
      blurRadius: 16.0,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> primaryGlowLight = [
    BoxShadow(
      color: AppColorsLight.primaryGlow,
      blurRadius: 12.0,
      offset: Offset(0, 3),
    ),
  ];
}
