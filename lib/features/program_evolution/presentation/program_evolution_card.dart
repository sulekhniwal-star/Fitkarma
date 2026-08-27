import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/program_evolution_engine.dart';

class ProgramEvolutionCard extends StatelessWidget {
  final ProgramEvolutionResult evolution;
  final VoidCallback? onTap;

  const ProgramEvolutionCard({
    super.key,
    required this.evolution,
    this.onTap,
  });

  Color _getActionColor(EvolutionAction action) {
    switch (action) {
      case EvolutionAction.progress:
        return AppColors.karmaGreen;
      case EvolutionAction.maintain:
        return AppColors.focusBlue;
      case EvolutionAction.deload:
        return AppColors.energyOrange;
      case EvolutionAction.recalibrate:
        return AppColors.aiPurple;
    }
  }

  String _getActionRegional(EvolutionAction action) {
    switch (action) {
      case EvolutionAction.progress:
        return 'प्रगति चरण';
      case EvolutionAction.maintain:
        return 'स्थिरता चरण';
      case EvolutionAction.deload:
        return 'पुनर्प्राप्ति चक्र';
      case EvolutionAction.recalibrate:
        return 'पुनः अंशांकन';
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionColor = _getActionColor(evolution.action);

    return BentoCard(
      hasGlow: evolution.action == EvolutionAction.progress,
      glowColor: actionColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Program Evolution',
                regionalText: 'कार्यक्रम विकास प्रणाली',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: actionColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  _getActionRegional(evolution.action),
                  style: AppTypography.bodySmall.copyWith(
                    color: actionColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlowingMetric(
                label: 'Cycle Adherence',
                value: '${(evolution.adherenceRate * 100).round()}%',
                accentColor: actionColor,
                trend: evolution.adherenceRate >= 0.8 ? MetricTrend.up : MetricTrend.down,
              ),
              GlowingMetric(
                label: 'Avg Readiness',
                value: '${evolution.averageReadiness.round()}',
                unit: '/100',
                accentColor: AppColors.focusBlue,
              ),
              GlowingMetric(
                label: 'Vol Adjust',
                value: '${((evolution.volumeMultiplier - 1.0) * 100).round() >= 0 ? '+' : ''}${((evolution.volumeMultiplier - 1.0) * 100).round()}%',
                accentColor: actionColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(
              evolution.reasoning,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
