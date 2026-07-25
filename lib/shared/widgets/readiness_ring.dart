// lib/shared/widgets/readiness_ring.dart
// §P0-D2 — Readiness score ring with color zones.
// Rule of Two: gradient fill + glow at tip.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

/// Circular ring displaying the readiness score (0–100) with zone coloring.
/// - 0–44  → error (red)  — forced rest day
/// - 45–64 → warning (amber) — reduced intensity
/// - 65–84 → success (green) — normal training
/// - 85–100→ teal — peak performance day
class ReadinessRing extends StatelessWidget {
  const ReadinessRing({
    super.key,
    required this.score,
    this.size = 120.0,
    this.strokeWidth = 10.0,
    this.showLabel = true,
  });

  final int score;
  final double size;
  final double strokeWidth;
  final bool showLabel;

  Color get _zoneColor {
    if (score >= 85) return AppColorsDark.teal;
    if (score >= 65) return AppColorsDark.success;
    if (score >= 45) return AppColorsDark.warning;
    return AppColorsDark.error;
  }

  String get _zoneLabel {
    if (score >= 85) return 'Peak';
    if (score >= 65) return 'Good';
    if (score >= 45) return 'Low';
    return 'Rest';
  }

  @override
  Widget build(BuildContext context) {
    final color = _zoneColor;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _ReadinessRingPainter(
              score: score,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ),
          if (showLabel)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: AppTypography.metricLg.copyWith(
                    color: AppColorsDark.textPrimary,
                    fontSize: size * 0.28,
                  ),
                ),
                Text(
                  _zoneLabel,
                  style: AppTypography.labelMd.copyWith(color: color),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ReadinessRingPainter extends CustomPainter {
  const _ReadinessRingPainter({
    required this.score,
    required this.color,
    required this.strokeWidth,
  });

  final int score;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;
    const startAngle = -math.pi / 2;
    final pct = (score / 100.0).clamp(0.0, 1.0);

    // Track background
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (pct > 0) {
      // Progress arc with glow
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        pct * 2 * math.pi,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0),
      );
      // Crisp foreground arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        pct * 2 * math.pi,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ReadinessRingPainter old) =>
      old.score != score || old.color != color;
}
