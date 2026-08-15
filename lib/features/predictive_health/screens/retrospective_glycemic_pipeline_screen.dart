import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/retrospective_glucose_matcher.dart';

final retrospectiveMatcherProvider = Provider<RetrospectiveGlucoseMatcher>(
    (ref) => const RetrospectiveGlucoseMatcher());

final sampleMealsAwaitingAnalysisProvider =
    StateProvider<List<RetrospectiveFoodLog>>((ref) {
  final now = DateTime.now();
  return [
    RetrospectiveFoodLog(
      localId: 'f1',
      foodName: 'Lunch (Dal Makhani + 2 Rotis)',
      consumeTime: now.subtract(const Duration(hours: 3)),
      carbsGrams: 78.0,
      processingTier: 2,
      hasGlycemicAnalysis: true,
      glycemicSpike: 48.0,
      mealQualityScore: 51.0,
    ),
    RetrospectiveFoodLog(
      localId: 'f2',
      foodName: 'Snack (Samosa + Chai)',
      consumeTime: now.subtract(const Duration(hours: 1)),
      carbsGrams: 55.0,
      processingTier: 3,
      hasGlycemicAnalysis: false,
    ),
  ];
});

/// §P10-L Retrospective Glycemic Processing Pipeline (RGPP) Screen
/// Route: /rgpp
class RetrospectiveGlycemicPipelineScreen extends ConsumerWidget {
  const RetrospectiveGlycemicPipelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(sampleMealsAwaitingAnalysisProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title:
            Text('🔄 Retrospective Glycemic Pipeline', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pipeline Overview BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sync_rounded,
                            color: AppColors.teal, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Retrospective Sync & Backfill',
                                  style: AppTypography.labelLg),
                              Text(
                                  'Background Sync • Late-Arriving Sensor Streams',
                                  style: AppTypography.bodySm.copyWith(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Health Connect sync latency can delay CGM readings. RGPP automatically retroactively links late-arriving CGM batches to your past 24h food logs.',
                      style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Analyzed & Pending Meals Section
              Text('Recent Meals & Glycemic Audit Status',
                  style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              for (final meal in meals)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: meal.hasGlycemicAnalysis
                      ? _ProcessedInsightCard(meal: meal)
                      : GlassCard(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(Icons.hourglass_top_rounded,
                                  color: AppColors.warning, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(meal.foodName,
                                        style: AppTypography.labelLg),
                                    Text('Awaiting CGM sensor stream sync...',
                                        style: AppTypography.bodySm.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessedInsightCard extends StatelessWidget {
  final RetrospectiveFoodLog meal;

  const _ProcessedInsightCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    final spike = meal.glycemicSpike ?? 0.0;
    final isSpikeHigh = spike > 45.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSpikeHigh
            ? AppColors.warning.withValues(alpha: 0.1)
            : AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSpikeHigh
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🩺 Glycemic Response Audit (Processed)',
                  style: AppTypography.labelLg.copyWith(
                      color:
                          isSpikeHigh ? AppColors.warning : AppColors.success,
                      fontWeight: FontWeight.bold)),
              Text('Quality: ${meal.mealQualityScore?.round()}/100',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Meal: ${meal.foodName}',
              style:
                  AppTypography.bodySm.copyWith(fontWeight: FontWeight.w600)),
          Text(
            isSpikeHigh
                ? '⚠️ +${spike.round()} mg/dL spike detected post-meal'
                : '✓ Normal response (+${spike.round()} mg/dL)',
            style: AppTypography.bodySm.copyWith(
                color: isSpikeHigh ? AppColors.warning : AppColors.success),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bg0.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'AI Retrospective Rule: Carbohydrate surge detected. Next time, add 100g curd or a fresh fiber salad BEFORE parsing to blunt this surge.',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
