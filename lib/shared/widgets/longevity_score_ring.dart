// lib/shared/widgets/longevity_score_ring.dart
// §P0-D2 (NEW v1) — Longevity score + biological age ring.
// Rule of Two: gradient fill + shadow (no glow overlay).

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

/// Circular ring displaying the longevity score with biological vs chronological age comparison.
class LongevityScoreRing extends StatelessWidget {
  const LongevityScoreRing({
    super.key,
    required this.longevityScore,
    required this.biologicalAge,
    required this.chronologicalAge,
    this.size = 140.0,
  });

  final int longevityScore;      // 0–100
  final int biologicalAge;
  final int chronologicalAge;
  final double size;

  int get _ageDelta => chronologicalAge - biologicalAge;
  bool get _younger => _ageDelta > 0;

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
            painter: _LongevityRingPainter(score: longevityScore, size: size),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$biologicalAge',
                style: AppTypography.metricLg.copyWith(
                  color: AppColorsDark.textPrimary,
                  fontSize: size * 0.22,
                ),
              ),
              Text(
                'Bio Age',
                style: AppTypography.labelMd.copyWith(color: AppColorsDark.teal),
              ),
              if (_ageDelta != 0)
                Text(
                  _younger
                      ? '${_ageDelta}y younger ↑'
                      : '${-_ageDelta}y older ↓',
                  style: AppTypography.bodySm.copyWith(
                    color: _younger ? AppColorsDark.success : AppColorsDark.error,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LongevityRingPainter extends CustomPainter {
  const _LongevityRingPainter({required this.score, required this.size});
  final int score;
  final double size;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 11.0;
    final radius = (size.width / 2) - strokeWidth / 2;
    const startAngle = -math.pi / 2;
    final pct = (score / 100.0).clamp(0.0, 1.0);

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColorsDark.teal.withOpacity(0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (pct > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(
        rect,
        startAngle,
        pct * 2 * math.pi,
        false,
        Paint()
          ..shader = SweepGradient(
            colors: [AppColorsDark.teal, AppColorsDark.secondary],
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
  bool shouldRepaint(covariant _LongevityRingPainter old) => old.score != score;
}
