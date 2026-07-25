// lib/shared/widgets/breathing_circle.dart
// §P0-D2 — Animated breathing guide circle for stress/recovery screens.
// Rule of Two: gradient + animation (no glow, no blur).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';

/// Breathing phases for a standard 4-7-8 or box breathing exercise.
enum BreathingPhase { inhale, hold, exhale, holdEmpty }

/// Animated breathing guide circle that expands/contracts with the breathing rhythm.
class BreathingCircle extends StatefulWidget {
  const BreathingCircle({
    super.key,
    this.size = 180.0,
    this.inhaleDuration = const Duration(seconds: 4),
    this.holdDuration = const Duration(seconds: 7),
    this.exhaleDuration = const Duration(seconds: 8),
  });

  final double size;
  final Duration inhaleDuration;
  final Duration holdDuration;
  final Duration exhaleDuration;

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  BreathingPhase _phase = BreathingPhase.inhale;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.inhaleDuration,
    );
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    setState(() => _isRunning = true);
    _runInhale();
  }

  void _stop() {
    setState(() {
      _isRunning = false;
      _phase = BreathingPhase.inhale;
    });
    _controller.reset();
  }

  void _runInhale() async {
    if (!mounted || !_isRunning) return;
    setState(() => _phase = BreathingPhase.inhale);
    _controller.duration = widget.inhaleDuration;
    await _controller.forward(from: 0.0);
    _runHold();
  }

  void _runHold() async {
    if (!mounted || !_isRunning) return;
    setState(() => _phase = BreathingPhase.hold);
    await Future.delayed(widget.holdDuration);
    _runExhale();
  }

  void _runExhale() async {
    if (!mounted || !_isRunning) return;
    setState(() => _phase = BreathingPhase.exhale);
    _controller.duration = widget.exhaleDuration;
    await _controller.reverse();
    _runInhale();
  }

  String get _label {
    return switch (_phase) {
      BreathingPhase.inhale => 'Inhale',
      BreathingPhase.hold => 'Hold',
      BreathingPhase.exhale => 'Exhale',
      BreathingPhase.holdEmpty => 'Hold',
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isRunning ? _stop : _start,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, _) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColorsDark.teal.withOpacity(0.15 * _scale.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Main circle
                Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: widget.size * 0.75,
                    height: widget.size * 0.75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColorsDark.teal.withOpacity(0.3),
                          AppColorsDark.secondary.withOpacity(0.15),
                        ],
                      ),
                      border: Border.all(
                        color: AppColorsDark.teal.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                // Phase label
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isRunning ? _label : 'Tap to\nStart',
                      style: AppTypography.h3.copyWith(
                        color: AppColorsDark.textPrimary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
