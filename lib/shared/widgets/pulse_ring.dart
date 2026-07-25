// lib/shared/widgets/pulse_ring.dart
// §P0-D2 — Pulsing animated ring for active/live states.
// Rule of Two: glow + animation (no gradient, no blur).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';

/// Pulsing ring animation — used to indicate live/active states
/// (e.g. active workout, CGM reading, real-time heart rate).
class PulseRing extends StatefulWidget {
  const PulseRing({
    super.key,
    required this.child,
    this.color = AppColorsDark.primary,
    this.pulseRadius = 28.0,
    this.pulseCount = 2,
  });

  final Widget child;
  final Color color;
  final double pulseRadius;
  final int pulseCount;

  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _scales = [];
  final List<Animation<double>> _opacities = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.pulseCount; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      );
      final scale = Tween<double>(begin: 1.0, end: 2.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
      final opacity = Tween<double>(begin: 0.5, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
      _controllers.add(controller);
      _scales.add(scale);
      _opacities.add(opacity);

      // Stagger pulse rings
      Future.delayed(Duration(milliseconds: i * 700), () {
        if (mounted) controller.repeat();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.pulseRadius * 2.5,
      height: widget.pulseRadius * 2.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse rings (behind the child)
          for (int i = 0; i < widget.pulseCount; i++)
            AnimatedBuilder(
              animation: _controllers[i],
              builder: (context, _) => Transform.scale(
                scale: _scales[i].value,
                child: Opacity(
                  opacity: _opacities[i].value,
                  child: Container(
                    width: widget.pulseRadius * 2,
                    height: widget.pulseRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Foreground child
          widget.child,
        ],
      ),
    );
  }
}
