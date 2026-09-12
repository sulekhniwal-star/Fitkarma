import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'bilingual_label.dart';

/// GlowingMetric — Single-number hero metric with a dynamic glowing halo treatment
class GlowingMetric extends StatelessWidget {
  final String value;
  final String label;
  final String? hindiLabel;
  final String? unit;
  final Color glowColor;
  final double size;

  const GlowingMetric({
    super.key,
    required this.value,
    required this.label,
    this.hindiLabel,
    this.unit,
    this.glowColor = AppColors.primaryCyan,
    this.size = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Radial Glow
            Container(
              width: 80 * size,
              height: 80 * size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    glowColor.withAlpha(90),
                    glowColor.withAlpha(0),
                  ],
                ),
              ),
            ),
            // Metric Value & Unit
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: AppTypography.heroMetric.copyWith(
                    fontSize: 48 * size,
                    color: glowColor,
                    shadows: [
                      Shadow(
                        color: glowColor.withAlpha(180),
                        blurRadius: 20 * size,
                      ),
                    ],
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    unit!,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16 * size,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        BilingualLabel(
          english: label,
          hindi: hindiLabel,
          crossAxisAlignment: CrossAxisAlignment.center,
          primaryStyle: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
