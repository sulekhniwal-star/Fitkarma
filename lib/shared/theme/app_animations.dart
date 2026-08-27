import 'package:flutter/material.dart';

class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration splash = Duration(milliseconds: 1000);

  // Curves (Spring physics & ease transitions)
  static const Curve spring = ElasticOutCurve(0.8);
  static const Curve smooth = Curves.easeOutCubic;
  static const Curve snappy = Curves.easeOutQuart;
  static const Curve bounce = Curves.bounceOut;
}
