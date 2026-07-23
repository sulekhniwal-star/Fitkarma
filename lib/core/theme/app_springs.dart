import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppSprings {
  AppSprings._();

  static const Curve touchResponseCurve = SpringCurve(
    damping: 0.5,
    frequency: 1.8,
  );
  static const Curve smoothAnimationCurve = SpringCurve(
    damping: 0.7,
    frequency: 1.2,
  );

  /// Underdamped spring for the Welcome logo bounce-reveal (slightly bouncy).
  static const Curve logoRevealCurve = SpringCurve(
    damping: 0.45,
    frequency: 0.9,
  );
}

class SpringCurve extends Curve {
  const SpringCurve({this.damping = 0.6, this.frequency = 1.5});

  final double damping;
  final double frequency;

  @override
  double transformInternal(double t) {
    if (t == 0.0 || t == 1.0) return t;

    final double decay = 7.0 * damping;
    final double omega = 2.0 * math.pi * frequency;

    return 1.0 - math.exp(-decay * t) * math.cos(omega * t);
  }
}
