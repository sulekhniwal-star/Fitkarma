// lib/shared/widgets/health_score_ring.dart
// §P0-D2 — Unified Health Score ring (0–100).
// Rule of Two: gradient fill + glow tip.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

/// Circular ring showing the unified Health Score (0–100) with a label.
/// Uses the primary brand gradient for the arc fill.
class HealthScoreRing extends StatelessWidget {
  const HealthScoreRing({
    super.key,
    required this.score,
    this.size = 140.0,
    this.strokeWidth = 12.0,
    this.showLabel = true,
    this.showSubLabel = true,
  });

  final int score;
  final double size;
  final double strokeWidth;
  final bool showLabel;
  final bool showSubLabel;

  String get _scoreLabel {
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 55) return 'Fair';
    if (score >= 35) return 'Low';
    return 'Critical';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _HealthScoreRingPainter(
              score: score,
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
                    fontSize: size * 0.26,
                    shadows: [
                      Shadow(
                        color: AppColorsDark.primaryGlow,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                ),
                if (showSubLabel)
                  Text(
                    _scoreLabel,
                    style: AppTypography.labelMd.copyWith(
                      color: AppColorsDark.primary,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _HealthScoreRingPainter extends CustomPainter {
  const _HealthScoreRingPainter({
    required this.score,
    required this.strokeWidth,
  });

  final int score;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;
    const startAngle = -math.pi / 2;
    final pct = (score / 100.0).clamp(0.0, 1.0);

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColorsDark.primary.withOpacity(0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (pct > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);

      // Glow pass
      canvas.drawArc(
        rect,
        startAngle,
        pct * 2 * math.pi,
        false,
        Paint()
          ..shader = SweepGradient(
            colors: [AppColorsDark.primary, AppColorsDark.accent],
            startAngle: 0,
            endAngle: 2 * math.pi,
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0),
      );

      // Crisp pass
      canvas.drawArc(
        rect,
        startAngle,
        pct * 2 * math.pi,
        false,
        Paint()
          ..shader = SweepGradient(
            colors: [AppColorsDark.primary, AppColorsDark.accent],
            startAngle: 0,
            endAngle: 2 * math.pi,
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HealthScoreRingPainter old) =>
      old.score != score;
}
