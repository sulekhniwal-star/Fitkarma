import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/cohort_insights_service.dart';

class CohortNotifier extends StateNotifier<CohortInsightsData> {
  final CohortInsightsService _service;

  CohortNotifier(this._service)
      : super(
          const CohortInsightsService().processInsights(
            metrics: const UserMetricsInput(
              avgSteps: 9420,
              avgProtein: 82,
              avgReadiness: 78,
              city: 'Noida',
              ageRange: '25-30',
            ),
            rawCohortSize: 4210,
            stepsDistribution: [3000, 5000, 6800, 8500, 9420, 11000, 13000],
            proteinDistribution: [40, 55, 70, 82, 95, 110, 125],
            readinessDistribution: [50, 62, 70, 78, 85, 90, 96],
          ),
        );

  void toggleOptOut(bool optOut) {
    if (optOut) {
      // Simulate fallback to regional anonymized group (smaller / state cohort)
      state = _service.processInsights(
        metrics: const UserMetricsInput(
          avgSteps: 9420,
          avgProtein: 82,
          avgReadiness: 78,
          city: 'Noida',
          ageRange: '25-30',
        ),
        rawCohortSize: 32, // < 50 triggers privacy guarantee fallback!
        stepsDistribution: [3000, 5000, 6800, 8500, 9420, 11000],
        proteinDistribution: [40, 55, 70, 82, 95, 110],
        readinessDistribution: [50, 62, 70, 78, 85, 90],
      );
    } else {
      state = _service.processInsights(
        metrics: const UserMetricsInput(
          avgSteps: 9420,
          avgProtein: 82,
          avgReadiness: 78,
          city: 'Noida',
          ageRange: '25-30',
        ),
        rawCohortSize: 4210,
        stepsDistribution: [3000, 5000, 6800, 8500, 9420, 11000, 13000],
        proteinDistribution: [40, 55, 70, 82, 95, 110, 125],
        readinessDistribution: [50, 62, 70, 78, 85, 90, 96],
      );
    }
  }
}

final cohortProvider =
    StateNotifierProvider<CohortNotifier, CohortInsightsData>((ref) {
  return CohortNotifier(const CohortInsightsService());
});

/// §P7-F Community Cohort Insights Screen
/// Route: /cohorts
class CommunityCohortInsightsScreen extends ConsumerWidget {
  const CommunityCohortInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(cohortProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Demographic Cohort Insights', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📊 Cohort: ${insights.cohortName} (n = ${insights.cohortSize})',
                style: AppTypography.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),

              // Privacy Guarantee Safeguard Alert
              if (!insights.isAnonymityPreserved)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.security, color: AppColors.warning, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '🛡️ Privacy Guarantee Enforced: City cohort size < 50. Aggregated into State-level category for regional anonymity.',
                            style: AppTypography.bodySm.copyWith(color: AppColors.warning),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 1. Steps Distribution BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('👟 STEPS DISTRIBUTION', style: AppTypography.h3),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Top ${100 - insights.stepPercentile}% in ${insights.cityRank.city}',
                            textAlign: TextAlign.right,
                            style: AppTypography.labelLg.copyWith(color: AppColors.teal),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your 14-day average: 9,420 steps (Percentile: ${insights.stepPercentile}th)',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: insights.stepPercentile / 100.0,
                        backgroundColor: AppColors.glassBorder,
                        color: AppColors.teal,
                        minHeight: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. City Leaderboard BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_city, color: AppColors.primary, size: 22),
                        const SizedBox(width: 8),
                        Text('🏙️ ${insights.cityRank.city} Leaderboard', style: AppTypography.h3),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rank: #${insights.cityRank.rank} of ${insights.cityRank.totalUsers} active members',
                      style: AppTypography.bodySm,
                    ),
                    Text(
                      'Percentile: Top ${insights.cityRank.percentile}% in City',
                      style: AppTypography.labelLg.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Next Rank Reward: +150 Karma XP at Rank #400',
                      style: AppTypography.bodySm.copyWith(color: AppColors.warning),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 3. Program Comparison Stat GlassCard
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📈 Program Comparison — "${insights.programSuccessStat.programName}"',
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(insights.programSuccessStat.completionRate * 100).round()}% of corporate workers completed this program!',
                      style: AppTypography.bodySm.copyWith(color: AppColors.success),
                    ),
                    const SizedBox(height: 8),
                    Text('Completed Users Average Outcomes:', style: AppTypography.bodySm),
                    const SizedBox(height: 4),
                    Text('  • Weight loss: ${insights.programSuccessStat.averageWeightLossKg}kg average', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                    Text('  • HRV baseline: +${insights.programSuccessStat.averageHrvImprovementMs}ms recovery capacity', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                    Text('  • Sleep duration increase: +45 mins/night', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Anonymized Cohort Sharing Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Opt-Out of Cohort Sharing (Anonymized)', style: AppTypography.bodySm),
                  Switch(
                    value: !insights.isAnonymityPreserved,
                    onChanged: (val) {
                      ref.read(cohortProvider.notifier).toggleOptOut(val);
                    },
                    activeThumbColor: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
