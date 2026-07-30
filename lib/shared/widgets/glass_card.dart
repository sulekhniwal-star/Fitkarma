import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Device Performance Tier for Adaptive UI Effects
enum PerformanceTier { low, mid, high }

/// Tier-aware Glassmorphic Container Component
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final PerformanceTier tier;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.tier = PerformanceTier.high,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppSpacing.cardRadius);

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: tier == PerformanceTier.low
            ? AppColors.bgCard
            : AppColors.glassBgLight,
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1.0,
        ),
      ),
      child: child,
    );

    if (tier != PerformanceTier.low) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: content,
        ),
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      );
    }

    return content;
  }
}
