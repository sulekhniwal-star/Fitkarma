// lib/shared/widgets/level_up_animation.dart
// §P0-D2 — Full-screen level-up celebration overlay.
// Rule of Two: gradient + animation (no blur on the same layer).

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_springs.dart';

/// Overlay that celebrates a level-up event with a burst animation.
/// Shown over the existing screen; auto-dismisses after 2.5 seconds.
class LevelUpAnimation extends StatefulWidget {
  const LevelUpAnimation({
    super.key,
    required this.newLevel,
    required this.levelTitle,
    this.onDismiss,
  });

  final int newLevel;
  final String levelTitle;
  final VoidCallback? onDismiss;

  @override
  State<LevelUpAnimation> createState() => _LevelUpAnimationState();
}

class _LevelUpAnimationState extends State<LevelUpAnimation>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _exitController;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<double> _bgOpacity;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: AppSprings.logoRevealCurve),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _bgOpacity = Tween<double>(begin: 0.0, end: 0.85).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );

    _entryController.forward();

    // Auto-dismiss after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (mounted) {
        await _exitController.forward();
        widget.onDismiss?.call();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entryController, _exitController]),
      builder: (context, _) {
        final exitT = _exitController.value;
        return Opacity(
          opacity: (1.0 - exitT).clamp(0.0, 1.0),
          child: GestureDetector(
            onTap: () async {
              await _exitController.forward();
              widget.onDismiss?.call();
            },
            child: Container(
              color: AppColorsDark.bg0.withOpacity(_bgOpacity.value),
              child: Center(
                child: FadeTransition(
                  opacity: _opacity,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Trophy icon with glow
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColorsDark.accent.withOpacity(0.3),
                                AppColorsDark.primary.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.emoji_events_rounded,
                            size: 52,
                            color: AppColorsDark.accent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'LEVEL UP!',
                          style: AppTypography.labelLg.copyWith(
                            color: AppColorsDark.accent,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Level ${widget.newLevel}',
                          style: AppTypography.heroDisplay.copyWith(
                            color: AppColorsDark.textPrimary,
                            fontSize: 56,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.levelTitle,
                          style: AppTypography.displayMd.copyWith(
                            color: AppColorsDark.secondary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Tap to continue',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColorsDark.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
