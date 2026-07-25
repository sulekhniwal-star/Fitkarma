// lib/shared/widgets/logo_reveal.dart
// §P0-D2 — Spring-animated FitKarma logo widget.
// Rule of Two: gradient + spring animation (no blur).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_springs.dart';

/// Spring-reveal animated FitKarma logo used on the Welcome/Splash screen.
/// Implements §P1-B: AnimatedOpacity + Transform.scale with logoRevealCurve.
class LogoReveal extends StatefulWidget {
  const LogoReveal({
    super.key,
    this.size = 72.0,
    this.delay = const Duration(milliseconds: 300),
  });

  final double size;
  final Duration delay;

  @override
  State<LogoReveal> createState() => _LogoRevealState();
}

class _LogoRevealState extends State<LogoReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppSprings.logoRevealCurve),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo mark — flame inside a rounded square
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.size * 0.28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColorsDark.primary, AppColorsDark.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsDark.primaryGlow,
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  size: widget.size * 0.56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              // Wordmark
              Text(
                'FitKarma',
                style: AppTypography.displayLg.copyWith(
                  color: AppColorsDark.textPrimary,
                  letterSpacing: -1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
