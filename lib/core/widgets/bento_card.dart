import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BentoSpan {
  oneByOne,
  twoByOne,
  twoByTwo,
}

/// BentoCard — Base card primitive for FitKarma Bento Grid layouts
/// Features glassmorphism background, subtle gradient border, and tap physics.
class BentoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final BentoSpan span;
  final Color? glowColor;
  final bool isGlowing;

  const BentoCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.span = BentoSpan.oneByOne,
    this.glowColor,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGlowColor = glowColor ?? AppColors.primaryCyan;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      splashColor: AppColors.primaryCyan.withAlpha(25),
      highlightColor: AppColors.surfaceGlassHover,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isGlowing
                ? effectiveGlowColor.withAlpha(128)
                : AppColors.borderGlass,
            width: isGlowing ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (isGlowing)
              BoxShadow(
                color: effectiveGlowColor.withAlpha(50),
                blurRadius: 18,
                spreadRadius: 2,
              )
            else
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: child,
      ),
    );
  }
}
