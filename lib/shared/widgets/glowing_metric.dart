import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Hero metric widget with controlled glow punctuation & typography hierarchy
class GlowingMetric extends StatelessWidget {
  final String value;
  final String label;
  final String? unit;
  final Color color;
  final bool hasGlow;

  const GlowingMetric({
    super.key,
    required this.value,
    required this.label,
    this.unit,
    this.color = AppColors.primaryCyan,
    this.hasGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.displayLarge.copyWith(
              color: color,
              shadows: hasGlow
                  ? [
                      Shadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 16.0,
                      ),
                    ]
                  : null,
            ),
            children: [
              TextSpan(text: value),
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                    shadows: [],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        Text(label.toUpperCase(), style: AppTypography.labelSmall),
      ],
    );
  }
}
