import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RingData {
  final double progress; // 0.0 to 1.0+
  final Color color;
  final double strokeWidth;

  const RingData({
    required this.progress,
    required this.color,
    this.strokeWidth = 10.0,
  });
}

/// ActivityRings — Custom painted concentric progress rings for Health OS metrics
class ActivityRings extends StatelessWidget {
  final List<RingData> rings;
  final double size;
  final Widget? centerChild;

  const ActivityRings({
    super.key,
    required this.rings,
    this.size = 140.0,
    this.centerChild,
  });

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
            painter: _ConcentricRingsPainter(rings: rings),
          ),
          if (centerChild != null) centerChild!,
        ],
      ),
    );
  }
}

class _ConcentricRingsPainter extends CustomPainter {
  final List<RingData> rings;

  _ConcentricRingsPainter({required this.rings});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    double currentRadius = (math.min(size.width, size.height) / 2) - 8;

    for (final ring in rings) {
      if (currentRadius <= 0) break;

      // Track Background
      final trackPaint = Paint()
        ..color = ring.color.withAlpha(40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring.strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, currentRadius, trackPaint);

      // Progress Arc
      final sweepAngle = 2 * math.pi * ring.progress.clamp(0.0, 1.0);
      if (sweepAngle > 0) {
        final progressPaint = Paint()
          ..color = ring.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring.strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: currentRadius),
          -math.pi / 2, // Start at 12 o'clock
          sweepAngle,
          false,
          progressPaint,
        );
      }

      currentRadius -= (ring.strokeWidth + 6);
    }
  }

  @override
  bool shouldRepaint(covariant _ConcentricRingsPainter oldDelegate) {
    return oldDelegate.rings != rings;
  }
}
