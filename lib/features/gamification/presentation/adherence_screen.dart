import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/adherence_models.dart';
import 'providers/adherence_provider.dart';

class AdherenceScreen extends ConsumerWidget {
  const AdherenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(adherenceProvider);
    final tierColor = Color(report.currentTier.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adherence Score OS',
              style: AppTypography.titleLarge,
            ),
            Text(
              'Multi-Pillar Biological Compliance Fidelity',
              style:
                  AppTypography.bodySmall.copyWith(color: AppColors.focusBlue),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroAdherenceGauge(report, tierColor),
            const SizedBox(height: AppSpacing.md),
            _buildWeeklyStatsRow(report),
            const SizedBox(height: AppSpacing.md),
            _buildFourPillarsBreakdown(report),
            const SizedBox(height: AppSpacing.md),
            _buildConsistencyStabilityCard(report),
            const SizedBox(height: AppSpacing.md),
            _buildWeeklyHistoryGrid(report),
            const SizedBox(height: AppSpacing.md),
            _buildCoachRecommendationBanner(report),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroAdherenceGauge(AdherenceReport report, Color tierColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tierColor.withAlpha(35),
            AppColors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: tierColor.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: tierColor.withAlpha(30),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tierColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppRadii.full),
                  border: Border.all(color: tierColor),
                ),
                child: Text(
                  report.currentTier.title.toUpperCase(),
                  style: TextStyle(
                    color: tierColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                'LIVE BIOMETRIC SYNC',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            report.currentScore.toStringAsFixed(1),
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 52,
            ),
          ),
          Text(
            'COMPOSITE ADHERENCE SCORE / 100',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            report.currentTier.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.focusBlue,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              report.currentTier.coachMessage,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatsRow(AdherenceReport report) {
    return Row(
      children: [
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: '7-Day Avg',
              value: report.weeklyAverageScore.toStringAsFixed(1),
              unit: '/ 100',
              accentColor: AppColors.karmaGreen,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: '30-Day Avg',
              value: report.monthlyAverageScore.toStringAsFixed(1),
              unit: '/ 100',
              accentColor: AppColors.focusBlue,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Stability Index',
              value: '${report.consistencyStabilityIndex.toInt()}%',
              unit: 'Low Drift',
              accentColor: AppColors.energyOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFourPillarsBreakdown(AdherenceReport report) {
    final pillars = [
      report.nutritionPillar,
      report.trainingPillar,
      report.recoveryPillar,
      report.circadianPillar,
    ];

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Multi-Pillar Compliance Fidelity',
            regionalText: '४-स्तंभ अनुपालन और भार विभाजन',
          ),
          const SizedBox(height: AppSpacing.md),
          ...pillars.map((pillar) {
            Color pColor = AppColors.karmaGreen;
            if (pillar.score < 70) {
              pColor = AppColors.energyOrange;
            }
            if (pillar.score < 50) {
              pColor = AppColors.alertRed;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadii.sm),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${pillar.name} (${(pillar.weight * 100).toInt()}% Weight)',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            pillar.regionalName,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${pillar.score.toStringAsFixed(1)} / 100',
                        style: TextStyle(
                          color: pColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.full),
                    child: LinearProgressIndicator(
                      value: pillar.score / 100.0,
                      minHeight: 6,
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(pColor),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pillar.keyMetricLabel,
                        style: AppTypography.bodySmall.copyWith(
                            fontSize: 10, color: AppColors.textSecondary),
                      ),
                      Text(
                        pillar.statusSummary,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: pColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildConsistencyStabilityCard(AdherenceReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: 'Consistency Stability Index (ASI)',
            regionalText: 'स्थिरता एवं निरंतरता सूचकांक',
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'The Stability Index measures adherence variance over rolling 7-day cycles. High scores confirm freedom from extreme binge/crash swings.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.full),
                  child: LinearProgressIndicator(
                    value: report.consistencyStabilityIndex / 100.0,
                    minHeight: 10,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.karmaGreen),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${report.consistencyStabilityIndex.toInt()}% STABLE',
                style: const TextStyle(
                  color: AppColors.karmaGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHistoryGrid(AdherenceReport report) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Today'];

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            primaryText: '7-Day Execution Timeline',
            regionalText: '७-दिवसीय निष्पादन समयरेखा',
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(report.weeklyHistory.length, (index) {
              final snapshot = report.weeklyHistory[index];
              final scoreColor = Color(snapshot.tier.colorCode);
              final dayLabel =
                  index < days.length ? days[index] : 'D${index + 1}';

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: scoreColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: scoreColor.withAlpha(90)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${snapshot.compositeScore.toInt()}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachRecommendationBanner(AdherenceReport report) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.focusBlue.withAlpha(80)),
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
                const Text(
                  'AI Coach Protocol Recommendation',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.primaryRecommendation,
                  style: AppTypography.bodySmall
                      .copyWith(fontSize: 11, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  report.regionalRecommendation,
                  style: AppTypography.bodySmall
                      .copyWith(fontSize: 10, color: AppColors.focusBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
