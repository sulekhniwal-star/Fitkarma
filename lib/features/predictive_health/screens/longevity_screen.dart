import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/longevity_score_calculator.dart';

final longevityCalculatorProvider = Provider<LongevityScoreCalculator>(
    (ref) => const LongevityScoreCalculator());

final longevityResultStateProvider = Provider<LongevityResult>((ref) {
  final calculator = ref.watch(longevityCalculatorProvider);
  const sampleInput = LongevityInputData(
    age: 28,
    gender: 'male',
    estimatedVO2Max: 46.0,
    bodyFatPct: 17.5,
    avgSleepH: 7.8,
    sleepQuality7dAvg: 4.2,
    avgSteps7d: 8800,
    workoutsPerWeek: 4,
    restingHR: 60.0,
    hrv: 68.0,
    baselineHRV: 62.0,
    hasClinicalData: true,
  );
  return calculator.calculate(sampleInput);
});

/// §P10-G Longevity Score Screen
/// Route: /longevity
class LongevityScreen extends ConsumerWidget {
  const LongevityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(longevityResultStateProvider);

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
        title: Text('🌱 Longevity Score', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primary Longevity & Biological Age BentoCard
              BentoCard(
                child: Column(
                  children: [
                    Text('Longevity Score: ${result.longevityScore}',
                        style: AppTypography.h1
                            .copyWith(color: AppColors.primary)),
                    const SizedBox(height: 8),

                    // Score Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: result.longevityScore / 100.0,
                        minHeight: 12,
                        backgroundColor: AppColors.bg1,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('Biological Age',
                                style: AppTypography.labelSmall
                                    .copyWith(color: AppColors.textSecondary)),
                            Text('${result.biologicalAge}',
                                style: AppTypography.h2
                                    .copyWith(color: AppColors.teal)),
                          ],
                        ),
                        Container(
                            width: 1,
                            height: 35,
                            color: AppColors.textMuted.withValues(alpha: 0.3)),
                        Column(
                          children: [
                            Text('Chronological Age',
                                style: AppTypography.labelSmall
                                    .copyWith(color: AppColors.textSecondary)),
                            Text('${result.chronologicalAge}',
                                style: AppTypography.h2),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'You are ${result.ageDelta} years younger than your actual age ✓',
                        style: AppTypography.labelSmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Factor Breakdown Section
              Text('Factor Breakdown', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _FactorRow(
                        label: '❤️ Cardio (HRV/HR)', score: result.cardioScore),
                    const Divider(height: 16),
                    _FactorRow(
                        label: '😴 Sleep Quality', score: result.sleepScore),
                    const Divider(height: 16),
                    _FactorRow(
                        label: '🏃 Activity Volume',
                        score: result.activityScore),
                    const Divider(height: 16),
                    _FactorRow(
                        label: '⚖️ Body Composition',
                        score: result.bodyFatScore),
                    const Divider(height: 16),
                    _FactorRow(
                        label: '🩺 Biomarkers', score: result.biomarkerScore),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Biggest Opportunity Card
              Text('Biggest Opportunity', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        color: AppColors.primary, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        result.biggestOpportunity,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Center(
                child: Text(
                  'Updated monthly. Next update: Aug 1.',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.textMuted, fontSize: 11),
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

class _FactorRow extends StatelessWidget {
  final String label;
  final double score;

  const _FactorRow({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final rounded = score.round();
    final stars = _starsForScore(score);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm),
        Row(
          children: [
            Text('$rounded ',
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.textPrimary)),
            Text(stars,
                style: const TextStyle(color: Colors.amber, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  String _starsForScore(double score) {
    if (score >= 90) return '★★★★★';
    if (score >= 75) return '★★★★☆';
    if (score >= 60) return '★★★☆☆';
    return '★★☆☆☆';
  }
}
