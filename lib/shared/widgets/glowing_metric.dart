import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

class GlowingMetric extends StatelessWidget {
  final String value;
  final String label; // Adding label back as it's used in current UI
  final String? unit;
  final Color glowColor;
  final TextStyle? customStyle;
  final bool hasGlow;

  const GlowingMetric({
    super.key,
    required this.value,
    required this.label,
    this.unit,
    required this.glowColor,
    this.customStyle,
    this.hasGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = customStyle ?? AppTypography.metricXL.copyWith(
      color: Colors.white,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
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
        ),
        const SizedBox(height: 4.0),
        Text(
          label.toUpperCase(),
          style: AppTypography.labelMd.copyWith(
            color: Colors.white.withOpacity(0.5),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
