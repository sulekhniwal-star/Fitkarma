import 'dart:ui';
import 'package:fitkarma/core/config/device_tier.dart';
import 'package:fitkarma/core/providers/core_providers.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlassCard extends ConsumerWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.onTap,
    this.borderRadius = AppRadius.bentoOuter,
    this.blurRadius = 16.0,
    this.customBgColor,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final double blurRadius;
  final Color? customBgColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceTier = ref.watch(deviceTierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Low performance tier disables BackdropFilter blur to save GPU cycles
    final shouldBlur = deviceTier != DeviceTier.low;

    // Choose appropriate fallback backgrounds
    final baseBgColor =
        customBgColor ??
        (isDark ? AppColorsDark.surface0 : AppColorsLight.surface0);

    final glassColor = isDark ? AppColorsDark.glass : AppColorsLight.glass;
    final glassBorderColor = isDark
        ? AppColorsDark.glassBorder
        : AppColorsLight.glassBorder;

    final decoration = BoxDecoration(
      color: shouldBlur ? glassColor : baseBgColor.withOpacity(0.95),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: glassBorderColor, width: 1.0),
    );

    Widget cardBody;
    if (shouldBlur) {
      cardBody = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
          child: Container(
            width: width,
            height: height,
            padding: padding ?? const EdgeInsets.all(AppSpacing.cardH),
            decoration: decoration,
            child: child,
          ),
        ),
      );
    } else {
      cardBody = Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(AppSpacing.cardH),
        decoration: decoration,
        child: child,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: cardBody),
      );
    }

    return cardBody;
  }
}
