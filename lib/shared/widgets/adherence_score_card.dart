// lib/shared/widgets/adherence_score_card.dart
// §P0-D2 (NEW v1) — Nutrition/Training/Recovery adherence % card.
// Rule of Two: gradient + shadow.

import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';

/// Displays the three-pillar adherence score (Nutrition / Training / Recovery).
class AdherenceScoreCard extends StatelessWidget {
  const AdherenceScoreCard({
    super.key,
    required this.nutritionPct,
    required this.trainingPct,
    required this.recoveryPct,
  });

  final double nutritionPct;  // 0.0–1.0
  final double trainingPct;
  final double recoveryPct;

  double get _overall =>
      (nutritionPct + trainingPct + recoveryPct) / 3.0;

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
              Text(
                'Adherence Score',
                style: AppTypography.h3.copyWith(color: AppColorsDark.textPrimary),
              ),
              Text(
                '${(_overall * 100).round()}%',
                style: AppTypography.metricLg.copyWith(
                  color: _overallColor,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _AdherencePillar(label: 'Nutrition', pct: nutritionPct, color: AppColorsDark.accent),
          const SizedBox(height: 10),
          _AdherencePillar(label: 'Training', pct: trainingPct, color: AppColorsDark.secondary),
          const SizedBox(height: 10),
          _AdherencePillar(label: 'Recovery', pct: recoveryPct, color: AppColorsDark.teal),
        ],
      ),
    );
  }

  Color get _overallColor {
    if (_overall >= 0.85) return AppColorsDark.success;
    if (_overall >= 0.65) return AppColorsDark.warning;
    return AppColorsDark.error;
  }
}

class _AdherencePillar extends StatelessWidget {
  const _AdherencePillar({required this.label, required this.pct, required this.color});
  final String label;
  final double pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodyMd.copyWith(color: AppColorsDark.textSecondary)),
            Text('${(pct * 100).round()}%', style: AppTypography.labelLg.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            backgroundColor: color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
