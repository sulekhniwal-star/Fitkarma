import 'dart:ui';

import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_springs.dart';
import 'package:flutter/material.dart';

class BentoCard extends StatefulWidget {
  const BentoCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.onTap,
    this.customBgColor,
    this.blurRadius = 16.0,
    this.borderRadius = AppRadius.bentoOuter,
    this.hasSecondaryGlow = false,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? customBgColor;
  final double blurRadius;
  final double borderRadius;
  final bool hasSecondaryGlow;

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppSprings
            .touchResponseCurve, // Swift Touch-to-Response Spring physics
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Widget cardBody = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurRadius,
          sigmaY: widget.blurRadius,
        ),
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.cardH),
          decoration: BoxDecoration(
            color:
                widget.customBgColor ??
                (isDark ? AppColorsDark.glass : AppColorsLight.glass),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: isDark
                  ? AppColorsDark.glassBorder
                  : AppColorsLight.glassBorder,
              width: 1.0,
            ),
            boxShadow: widget.hasSecondaryGlow
                ? [
                    BoxShadow(
                      color: isDark
                          ? AppColorsDark.primaryMuted
                          : AppColorsLight.primaryMuted,
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap == null) {
      return cardBody;
    }

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap!();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: cardBody),
    );
  }
}
