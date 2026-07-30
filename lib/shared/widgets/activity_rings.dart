import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Activity progress rings (Move, Exercise, Stand)
class ActivityRings extends StatelessWidget {
  final double moveProgress; // 0.0 to 1.0
  final double exerciseProgress; // 0.0 to 1.0
  final double standProgress; // 0.0 to 1.0
  final double size;

  const ActivityRings({
    super.key,
    required this.moveProgress,
    required this.exerciseProgress,
    required this.standProgress,
    this.size = 140.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RingsPainter(
        moveProgress: moveProgress,
        exerciseProgress: exerciseProgress,
        standProgress: standProgress,
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final double moveProgress;
  final double exerciseProgress;
  final double standProgress;

  _RingsPainter({
    required this.moveProgress,
    required this.exerciseProgress,
    required this.standProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.09;

    _drawRing(canvas, center, (size.width / 2) - strokeWidth, AppColors.errorRed, moveProgress, strokeWidth);
    _drawRing(canvas, center, (size.width / 2) - (strokeWidth * 2.2), AppColors.primaryEmerald, exerciseProgress, strokeWidth);
    _drawRing(canvas, center, (size.width / 2) - (strokeWidth * 3.4), AppColors.primaryCyan, standProgress, strokeWidth);
  }

  void _drawRing(Canvas canvas, Offset center, double radius, Color color, double progress, double strokeWidth) {
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);
    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) => true;
}
