import 'dart:math' as math;
import 'package:flutter/material.dart';

class RingData {
  final double progress; // 0.0 to 1.0 (or >1.0 for overtime)
  final Color color;
  final Color? trackColor;
  final double strokeWidth;

  const RingData({
    required this.progress,
    required this.color,
    this.trackColor,
    this.strokeWidth = 14.0,
  });
}

class ActivityRings extends StatefulWidget {
  final List<RingData> rings;
  final double size;
  final Widget? centerWidget;
  final Duration animationDuration;

  const ActivityRings({
    super.key,
    required this.rings,
    this.size = 180.0,
    this.centerWidget,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<ActivityRings> createState() => _ActivityRingsState();
}

class _ActivityRingsState extends State<ActivityRings> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ActivityRings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rings != widget.rings) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ActivityRingsPainter(
              rings: widget.rings,
              animationValue: _animation.value,
            ),
            child: widget.centerWidget != null
                ? Center(child: widget.centerWidget)
                : null,
          );
        },
      ),
    );
  }
}

class _ActivityRingsPainter extends CustomPainter {
  final List<RingData> rings;
  final double animationValue;

  _ActivityRingsPainter({
    required this.rings,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    double currentRadius = maxRadius;
    const ringSpacing = 4.0;

    for (int i = 0; i < rings.length; i++) {
      final ring = rings[i];
      final strokeWidth = ring.strokeWidth;
      final radius = currentRadius - (strokeWidth / 2);

      // 1. Draw Track
      final trackPaint = Paint()
        ..color = ring.trackColor ?? ring.color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, radius, trackPaint);

      // 2. Draw Animated Progress Arc
      final progressSweep = 2 * math.pi * (ring.progress * animationValue);
      if (progressSweep > 0) {
        final progressPaint = Paint()
          ..color = ring.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi / 2, // Start at top (12 o'clock)
          progressSweep,
          false,
          progressPaint,
        );
      }

      currentRadius -= (strokeWidth + ringSpacing);
    }
  }

  @override
  bool shouldRepaint(covariant _ActivityRingsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.rings != rings;
  }
}
