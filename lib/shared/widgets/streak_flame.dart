// lib/shared/widgets/streak_flame.dart
// §P0-D2 — Animated streak flame for habit streak display.
// Rule of Two: gradient + animation (no glow, no blur).

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

/// Animated flame widget that scales with streak count.
/// Renders hotter (more orange/yellow) the longer the streak.
class StreakFlame extends StatefulWidget {
  const StreakFlame({
    super.key,
    required this.streakDays,
    this.size = 40.0,
    this.showCount = true,
  });

  final int streakDays;
  final double size;
  final bool showCount;

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sway;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _sway = Tween<double>(begin: -0.06, end: 0.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _flameTop {
    if (widget.streakDays >= 30) return AppColorsDark.accent;
    if (widget.streakDays >= 7) return AppColorsDark.primary;
    return AppColorsDark.primary.withOpacity(0.8);
  }

  Color get _flameBottom {
    if (widget.streakDays >= 30) return AppColorsDark.primary;
    return AppColorsDark.accent;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _sway,
          builder: (context, _) => Transform.rotate(
            angle: _sway.value,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [_flameBottom, _flameTop],
              ).createShader(bounds),
              child: Icon(
                Icons.local_fire_department_rounded,
                size: widget.size,
                color: Colors.white, // Color applied via shader
              ),
            ),
          ),
        ),
        if (widget.showCount) ...[
          const SizedBox(width: 4),
          Text(
            '${widget.streakDays}',
            style: AppTypography.metricLg.copyWith(
              color: AppColorsDark.accent,
              fontSize: widget.size * 0.55,
            ),
          ),
        ],
      ],
    );
  }
}
