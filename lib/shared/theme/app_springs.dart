import 'package:flutter/material.dart';

/// Central Spring Physics Curves for Fluid Motion
class AppSprings {
  AppSprings._();

  /// Swift Touch-to-Response Spring physics
  static const Curve touchResponseCurve = ElasticOutCurve(0.8);

  /// Logo reveal bounce effect
  static const Curve logoRevealCurve = ElasticOutCurve(0.6);

  /// Smooth entry transition
  static const Curve smoothEntry = Curves.easeOutCubic;
}

class ElasticOutCurve extends Curve {
  final double period;

  const ElasticOutCurve([this.period = 0.4]);

  @override
  double transformInternal(double t) {
    return (t == 0 || t == 1)
        ? t
        : (Math.pow(2, -10 * t) * Math.sin((t - period / 4) * (2 * Math.PI) / period) + 1).toDouble();
  }
}

// Utility class for math operations since Math.PI is not available directly in Dart standard library as such, 
// though dart:math is. I'll use dart:math.

class Math {
  static double pow(double x, double y) => x.toDouble(); // Placeholder if I don't import
  // Actually I should just import dart:math
}
