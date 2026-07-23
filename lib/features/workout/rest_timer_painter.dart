/// §P6-B Rest Timer — CustomPainter for circular arc countdown ring.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Draws a circular arc progress ring for the rest timer.
///
/// [fraction] is 0.0 (timer expired) to 1.0 (full time remaining).
/// Color shifts: green (>0.5) → amber (0.25–0.5) → red (<0.25).
class RestTimerPainter extends CustomPainter {
  const RestTimerPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    const strokeWidth = 10.0;

    // Background track arc
    final trackPaint = Paint()
      ..color = const Color(0xFF2E324A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (fraction <= 0) return;

    // Foreground progress arc
    final Color arcColor;
    if (fraction > 0.5) {
      arcColor = const Color(0xFF4ADE80); // green
    } else if (fraction > 0.25) {
      arcColor = const Color(0xFFFBBF24); // amber
    } else {
      arcColor = const Color(0xFFF87171); // red
    }

    final progressPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Sweep clockwise from 12 o'clock (−π/2)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * fraction.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(RestTimerPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}
