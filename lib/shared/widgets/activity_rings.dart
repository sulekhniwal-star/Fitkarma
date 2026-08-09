import 'dart:math' as math;
import 'package:flutter/material.dart';

class RingData {
  final double value;
  final double target;
  final List<Color> colors;
  final double strokeWidth;

  RingData({
    required this.value,
    required this.target,
    required this.colors,
    this.strokeWidth = 12.0,
  });
}

class ActivityRings extends StatelessWidget {
  final List<RingData> rings;
  final double size;
  final double gap;

  const ActivityRings({
    super.key,
    required this.rings,
    this.size = 200.0,
    this.gap = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ActivityRingsPainter(
        rings: rings,
        gap: gap,
      ),
    );
  }
}

class _ActivityRingsPainter extends CustomPainter {
  final List<RingData> rings;
  final double gap;

  _ActivityRingsPainter({
    required this.rings,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    double currentRadius = math.min(size.width, size.height) / 2 - (rings.isNotEmpty ? rings.first.strokeWidth / 2 : 0);

    for (int i = 0; i < rings.length; i++) {
      final ring = rings[i];
      final pct = (ring.target > 0) ? (ring.value / ring.target).clamp(0.0, 1.0) : 0.0;

      // 1. Draw track background
      final bgPaint = Paint()
        ..color = ring.colors.first.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring.strokeWidth;
      
      canvas.drawCircle(center, currentRadius, bgPaint);

      // 2. Draw progress arc
      if (pct > 0) {
        final rect = Rect.fromCircle(center: center, radius: currentRadius);
        final progressPaint = Paint()
          ..shader = SweepGradient(
            colors: ring.colors,
            startAngle: -math.pi / 2,
            endAngle: 3 * math.pi / 2,
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = ring.strokeWidth;

        // Apply rotation matrix to start the sweep from 12 o'clock (-pi/2)
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(-math.pi / 2);
        canvas.translate(-center.dx, -center.dy);

        canvas.drawArc(
          rect,
          0.0,
          pct * 2 * math.pi,
          false,
          progressPaint,
        );
        canvas.restore();
      }

      currentRadius -= (ring.strokeWidth + gap);
    }
  }

  @override
  bool shouldRepaint(covariant _ActivityRingsPainter oldDelegate) => true;
}
