// lib/shared/widgets/benchmarking_card.dart
// §P0-D2 (NEW v1) — Fitness percentile vs demographic cohort card.
// Rule of Two: gradient + shadow.

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';

/// Shows the user's fitness percentile ranking within their demographic cohort.
class BenchmarkingCard extends StatelessWidget {
  const BenchmarkingCard({
    super.key,
    required this.percentile,
    required this.cohortLabel,
    required this.metric,
    required this.userValue,
    required this.cohortAverage,
    this.unit = '',
  });

  final int percentile;         // 0–100
  final String cohortLabel;     // e.g. "Males 25–34 in Mumbai"
  final String metric;          // e.g. "Steps/day"
  final double userValue;
  final double cohortAverage;
  final String unit;

  Color get _percentileColor {
    if (percentile >= 75) return AppColorsDark.success;
    if (percentile >= 40) return AppColorsDark.warning;
    return AppColorsDark.error;
  }

  String get _percentileLabel {
    if (percentile >= 90) return 'Top 10%';
    if (percentile >= 75) return 'Top 25%';
    if (percentile >= 50) return 'Above Average';
    if (percentile >= 25) return 'Below Average';
    return 'Bottom 25%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardH),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          colors: [AppColorsDark.surface1, AppColorsDark.surface0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColorsDark.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric,
                      style: AppTypography.h3.copyWith(color: AppColorsDark.textPrimary),
                    ),
                    Text(
                      cohortLabel,
                      style: AppTypography.bodySm.copyWith(color: AppColorsDark.textMuted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$percentile%',
                    style: AppTypography.metricLg.copyWith(
                      color: _percentileColor,
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    _percentileLabel,
                    style: AppTypography.labelMd.copyWith(color: _percentileColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Percentile bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentile / 100.0,
              backgroundColor: _percentileColor.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(_percentileColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatPill(
                label: 'You',
                value: '${userValue.toStringAsFixed(0)}$unit',
                color: _percentileColor,
              ),
              _StatPill(
                label: 'Cohort Avg',
                value: '${cohortAverage.toStringAsFixed(0)}$unit',
                color: AppColorsDark.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: AppTypography.h2.copyWith(color: color)),
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColorsDark.textMuted)),
      ],
    );
  }
}
