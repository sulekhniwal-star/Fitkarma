import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum MetricTrend { up, down, neutral }

class GlowingMetric extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final Color accentColor;
  final MetricTrend? trend;
  final String? trendLabel;
  final bool isHero;

  const GlowingMetric({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.accentColor = AppColors.karmaGreen,
    this.trend,
    this.trendLabel,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.metricLabel,
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: isHero
                  ? AppTypography.metricHero.copyWith(
                      color: AppColors.textPrimary,
                      shadows: [
                        Shadow(
                          color: accentColor.withValues(alpha: 0.5),
                          blurRadius: 16,
                        ),
                      ],
                    )
                  : AppTypography.metricValue.copyWith(
                      color: AppColors.textPrimary,
                      shadows: [
                        Shadow(
                          color: accentColor.withValues(alpha: 0.4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit!,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        if (trend != null || trendLabel != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trend != null) _buildTrendIcon(),
              if (trendLabel != null) ...[
                const SizedBox(width: 4),
                Text(
                  trendLabel!,
                  style: AppTypography.bodySmall.copyWith(
                    color: _getTrendColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrendIcon() {
    final IconData iconData;
    final Color color = _getTrendColor();

    switch (trend!) {
      case MetricTrend.up:
        iconData = Icons.trending_up_rounded;
        break;
      case MetricTrend.down:
        iconData = Icons.trending_down_rounded;
        break;
      case MetricTrend.neutral:
        iconData = Icons.trending_flat_rounded;
        break;
    }

    return Icon(iconData, size: 16, color: color);
  }

  Color _getTrendColor() {
    if (trend == null) return AppColors.textSecondary;
    switch (trend!) {
      case MetricTrend.up:
        return AppColors.karmaGreen;
      case MetricTrend.down:
        return AppColors.alertRed;
      case MetricTrend.neutral:
        return AppColors.textSecondary;
    }
  }
}
