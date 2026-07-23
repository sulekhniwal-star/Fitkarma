import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class GlowingMetric extends StatelessWidget {
  const GlowingMetric({
    super.key,
    required this.value,
    this.unit,
    required this.glowColor,
    this.customStyle,
    this.hasGlow = true,
  });

  final String value;
  final String? unit;
  final Color glowColor;
  final TextStyle? customStyle;
  final bool hasGlow;

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        customStyle ?? AppTypography.metricXL.copyWith(color: Colors.white);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle.copyWith(
          shadows: hasGlow
              ? [
                  Shadow(
                    color: glowColor.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: glowColor.withOpacity(0.2),
                    blurRadius: 36,
                    offset: const Offset(0, 0),
                  ),
                ]
              : null,
        ),
        children: [
          TextSpan(text: value),
          if (unit != null)
            TextSpan(
              text: ' $unit',
              style: AppTypography.h3.copyWith(
                color: Colors.white.withOpacity(0.5),
                shadows: [], // Prevent glowing units for visual restraint
              ),
            ),
        ],
      ),
    );
  }
}
