import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/transformation_models.dart';
import 'providers/transformation_provider.dart';

/// Screen displaying the athlete's Longitudinal Transformation Journey,
/// Biometric Progression Deltas, Stage Evolution, Milestone Timeline, and Velocity Forecasts.
class TransformationTimelineScreen extends ConsumerWidget {
  const TransformationTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(transformationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Transformation Journey',
          regionalText: 'कायाकल्प यात्रा एवं सिद्धि',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showStagePhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Bento Card: Current Stage & Composite Score
            _buildStageHeroCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Cultural Stage Insight Bento
            _buildStageInsightCard(report),
            const SizedBox(height: AppSpacing.md),

            // 3. Biometric Delta Comparison Matrix (Baseline vs Current)
            const BilingualLabel(
              primaryText: 'Longitudinal Biometric Deltas',
              regionalText: 'बायोमार्कर प्रगति एवं परिवर्तन',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.pillarDeltas.map((delta) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildBiometricDeltaCard(delta),
                )),
            const SizedBox(height: AppSpacing.md),

            // 4. Milestone Velocity & Projections Card
            const BilingualLabel(
              primaryText: 'Trajectory Projections & Velocity',
              regionalText: 'भविष्य लक्ष्य पूर्वानुमान व गति',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildProjectionsCard(report.activeProjections),
            const SizedBox(height: AppSpacing.md),

            // 5. Vertical Milestone Timeline (Unlocked Siddhis)
            const BilingualLabel(
              primaryText: 'Transformation Milestones (Siddhi)',
              regionalText: 'अर्जित उपलब्धियां एवं पड़ाव',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildMilestonesTimeline(report.unlockedMilestones),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStageHeroCard(TransformationJourneyReport report) {
    final stage = report.currentStage;
    final stageColor = stage == TransformationStage.sthirata
        ? AppColors.gold
        : stage == TransformationStage.koushalya
            ? AppColors.karmaGreen
            : stage == TransformationStage.abhyasa
                ? AppColors.focusBlue
                : AppColors.energyOrange;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: stageColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                  border: Border.all(color: stageColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      stage == TransformationStage.sthirata
                          ? Icons.workspace_premium
                          : stage == TransformationStage.koushalya
                              ? Icons.fitness_center
                              : stage == TransformationStage.abhyasa
                                  ? Icons.trending_up
                                  : Icons.flag,
                      color: stageColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Stage ${stage.phaseNumber}: ${stage.title.split('(')[0].trim()}',
                      style: AppTypography.metricLabel.copyWith(
                        color: stageColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  'Day ${report.totalJourneyDays} of Journey',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Composite Transformation Index',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report.overallTransformationScore.toStringAsFixed(1)}%',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stage.focusArea,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              GlowingMetric(
                value: '${report.overallTransformationScore.toInt()}%',
                label: 'Transformation',
                accentColor: stageColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: (report.overallTransformationScore / 100.0).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(stageColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageInsightCard(TransformationJourneyReport report) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.focusBlue.withValues(alpha: 0.10),
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.focusBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.focusBlue, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stage Guidance (Yatra Sandesh)',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.motivationalInsight,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.regionalMotivationalInsight,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricDeltaCard(BiometricPillarDelta delta) {
    final isPositive = delta.isPositiveProgress;
    final progressColor = isPositive ? AppColors.karmaGreen : AppColors.energyOrange;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delta.metricName,
                      style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                    ),
                    Text(
                      delta.regionalMetricName,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.12),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '${delta.scoreProgressContribution.toStringAsFixed(0)}% Progress',
                  style: AppTypography.metricLabel.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Baseline (Day 1)', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                  Text(
                    '${delta.baselineValue % 1 != 0 ? delta.baselineValue.toStringAsFixed(2) : delta.baselineValue.toInt()} ${delta.unit}',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward, color: AppColors.textMuted, size: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Current Value', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                  Text(
                    '${delta.currentValue % 1 != 0 ? delta.currentValue.toStringAsFixed(2) : delta.currentValue.toInt()} ${delta.unit}',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_flat,
                color: progressColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${delta.absoluteDelta >= 0 ? '+' : ''}${delta.absoluteDelta.toStringAsFixed(2)} ${delta.unit} (${delta.percentageDelta.abs().toStringAsFixed(1)}% shift)',
                style: AppTypography.bodySmall.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectionsCard(List<TransformationProjection> projections) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.speed, color: AppColors.focusBlue, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Biometric Trajectory Forecaster',
                style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Extrapolated from current adherence velocity & physiological adaptation rates.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          ...projections.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            p.targetGoal,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.focusBlue.withValues(alpha: 0.12),
                            borderRadius: AppRadii.radiusFull,
                          ),
                          child: Text(
                            '~${p.estimatedDaysToAchievement} days left',
                            style: AppTypography.metricLabel.copyWith(
                              color: AppColors.focusBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Current: ${p.currentValue % 1 != 0 ? p.currentValue.toStringAsFixed(2) : p.currentValue.toInt()} ${p.unit} | Target: ${p.targetValue % 1 != 0 ? p.targetValue.toStringAsFixed(2) : p.targetValue.toInt()} ${p.unit}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: AppRadii.radiusFull,
                      child: LinearProgressIndicator(
                        value: p.progressFraction,
                        backgroundColor: AppColors.surfaceElevated,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.focusBlue),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMilestonesTimeline(List<TransformationMilestone> milestones) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.military_tech, color: AppColors.gold, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Unlocked Milestones & Siddhis',
                style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...milestones.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                      child: const Icon(Icons.check, color: AppColors.gold, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                m.title,
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.12),
                                  borderRadius: AppRadii.radiusFull,
                                ),
                                child: Text(
                                  '+${m.karmaBonus} Karma',
                                  style: AppTypography.metricLabel.copyWith(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            m.description,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            m.regionalDescription,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showStagePhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transformation Stages (Yatra Charan)',
                style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '1. Arambha (W1-4): Circadian reset & foundational habits.\n'
                '2. Abhyasa (W5-12): Metabolic adaptation & progressive overload.\n'
                '3. Koushalya (W13-24): Lean muscle hypertrophy & VO2 Max elevation.\n'
                '4. Sthirata (W25+): Autonomous lifestyle mastery & lifelong resilience.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
