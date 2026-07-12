import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Design tokens for the Fitkarma application.
/// Focuses on dark-mode-first, neon accents, glassmorphic blurs, and spring physics.
class FitkarmaDesignTokens {
  // --- COLOR PALETTE (Dark-mode-first) ---
  
  /// Base background color (Obsidian dark)
  static const Color background = Color(0xFF08080A);
  
  /// Surface color for container overlays (Charcoal/Dark slate)
  static const Color surface = Color(0xFF121216);
  
  /// Semi-translucent glass background color for cards
  static Color glassBackground = const Color(0xFF1E1E24).withOpacity(0.55);

  /// Solid card background for fallback when blur isn't supported
  static const Color cardFallback = Color(0xFF18181D);

  // --- TEXT COLORS ---
  static const Color textPrimary = Color(0xFFF3F3F5);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textMuted = Color(0xFF55555C);

  // --- ACCENTS & GLOWS (Fitness/Activity themes) ---
  
  // Neon Cyan to Electric Blue (Cardio / Steps)
  static const Color cyanAccent = Color(0xFF00F0FF);
  static const Color blueAccent = Color(0xFF0066FF);
  static const LinearGradient cardioGradient = LinearGradient(
    colors: [cyanAccent, blueAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glowing Pink to Magenta/Purple (Calories / Energy)
  static const Color pinkAccent = Color(0xFFFF007F);
  static const Color purpleAccent = Color(0xFF7F00FF);
  static const LinearGradient caloriesGradient = LinearGradient(
    colors: [pinkAccent, purpleAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Lime Green to Emerald (Strength / Activity)
  static const Color greenAccent = Color(0xFF39FF14);
  static const Color emeraldAccent = Color(0xFF00FF75);
  static const LinearGradient activityGradient = LinearGradient(
    colors: [greenAccent, emeraldAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Neon Orange to Deep Red/Amber (Sleep / Recovery)
  static const Color orangeAccent = Color(0xFFFF9900);
  static const Color redAccent = Color(0xFFFF3300);
  static const LinearGradient recoveryGradient = LinearGradient(
    colors: [orangeAccent, redAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- GLASSMORPHISM VALUES ---
  static const double glassBlurX = 16.0;
  static const double glassBlurY = 16.0;
  
  static Color glassBorderColor = const Color(0xFFFFFFFF).withOpacity(0.09);
  static Color glassBorderHighlight = const Color(0xFFFFFFFF).withOpacity(0.18);
  
  static const List<BoxShadow> glassShadows = [
    BoxShadow(
      color: Color(0x22000000),
      offset: Offset(0, 8),
      blurRadius: 24.0,
      spreadRadius: -4.0,
    ),
    BoxShadow(
      color: Color(0x11000000),
      offset: Offset(0, 4),
      blurRadius: 8.0,
      spreadRadius: -2.0,
    ),
  ];

  // --- SPRING PHYSICS ---
  
  /// Snappy spring curve for tap/click feedback
  static const Curve springSnappy = SpringCurve(damping: 0.5, frequency: 1.8);
  
  /// Smooth spring curve for transitions and entries
  static const Curve springSmooth = SpringCurve(damping: 0.7, frequency: 1.2);
}

/// A custom Curve that implements damped spring (harmonic oscillator) physics.
class SpringCurve extends Curve {
  /// Damping ratio (0 to 1, where 1 is critically damped, <1 is underdamped/bouncy)
  final double damping;
  
  /// Oscillation frequency (higher value means more bounces)
  final double frequency;

  const SpringCurve({
    this.damping = 0.6,
    this.frequency = 1.5,
  });

  @override
  double transformInternal(double t) {
    if (t == 0.0 || t == 1.0) return t;
    
    // Normalizing time and mapping to harmonic oscillator:
    // f(t) = 1 - e^(-c * t) * cos(w * t)
    // We adjust parameters dynamically based on damping and frequency
    final double decay = 7.0 * damping;
    final double omega = 2.0 * math.pi * frequency;
    
    return 1.0 - math.exp(-decay * t) * math.cos(omega * t);
  }
}
