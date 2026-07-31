import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Standard Gradients for Backgrounds and Overlays
class AppGradients {
  AppGradients._();

  static const LinearGradient heroDeep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.bg0,
      AppColors.bg1,
    ],
  );

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.accent,
    ],
  );

  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.secondary,
      AppColors.purple,
    ],
  );
}
