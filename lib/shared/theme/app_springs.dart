import 'dart:math' as math;
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
        : (math.pow(2, -10 * t) *
                    math.sin((t - period / 4) * (2 * math.pi) / period) +
                1)
            .toDouble();
  }
}
