import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/nutrition_reliability_engine.dart';
import '../providers/nutrition_provider.dart';

class NutritionReliabilityScreen extends ConsumerStatefulWidget {
  const NutritionReliabilityScreen({super.key});

  @override
  ConsumerState<NutritionReliabilityScreen> createState() =>
      _NutritionReliabilityScreenState();
}

class _NutritionReliabilityScreenState
    extends ConsumerState<NutritionReliabilityScreen> {
  bool _isOilExplicitlyTracked = false;

  @override
  Widget build(BuildContext context) {
    final nutrition = ref.watch(nutritionProvider);
    final allMeals = nutrition.loggedMeals;

    final report = NutritionReliabilityEngine.evaluateDailyReliability(
      allDayMeals: allMeals,
      targetCalories: nutrition.targetCalories,
      isOilExplicitlyTracked: _isOilExplicitlyTracked,
    );

    final Color levelColor = Color(report.level.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Nutrition Data Shield',
          regionalText: 'पोषण डेटा विश्वसनीयता सुरक्षा कवच',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Reliability Score & Shield Status Card
              BentoCard(
                hasGlow: true,
                glowColor: levelColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Data Confidence Shield',
                          regionalText: 'डेटा सटीकता एवं सुरक्षा स्थिति',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: levelColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(
                                color: levelColor.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                report.isShieldActive
                                    ? Icons.shield_rounded
                                    : Icons.shield_outlined,
                                color: levelColor,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                report.isShieldActive
                                    ? 'SHIELD ACTIVE'
                                    : 'UNSHIELDED',
                                style: TextStyle(
                                  color: levelColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Reliability',
                          value: '${report.overallReliabilityScore}%',
                          unit: 'Score',
                          isHero: true,
                          accentColor: levelColor,
                        ),
                        GlowingMetric(
                          label: 'Calorie Margin',
                          value: '±${report.caloricUncertaintyMargin}',
                          unit: 'kcal',
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Protein Margin',
                          value: '±${report.proteinUncertaintyMargin}',
                          unit: 'g',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.confidenceSummary,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Interactive Cooking Oil & Preparation Toggle
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Cooking Medium Explicitly Tracked',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: const Text(
                    'Explicit oil/ghee measurements remove the default +180 kcal Indian tadka buffer',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  value: _isOilExplicitlyTracked,
                  activeThumbColor: AppColors.karmaGreen,
                  onChanged: (val) =>
                      setState(() => _isOilExplicitlyTracked = val),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Reliability Pillars
              const Text(
                '5 RELIABILITY PILLARS (5 विश्वसनीयता आधार स्तंभ)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.factors.map((factor) {
                final double scoreFrac = (factor.score / 100.0).clamp(0.0, 1.0);
                final Color factorColor = factor.score >= 80
                    ? AppColors.karmaGreen
                    : (factor.score >= 60
                        ? AppColors.focusBlue
                        : (factor.score >= 40
                            ? AppColors.gold
                            : AppColors.alertRed));

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
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
                                  Row(
                                    children: [
                                      Text(
                                        factor.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 1),
                                        decoration: const BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: AppRadii.radiusSm,
                                        ),
                                        child: Text(
                                          '${(factor.weight * 100).toInt()}% wt',
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: AppColors.textMuted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    factor.regionalName,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${factor.score.round()}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: factorColor,
                                  ),
                                ),
                                Text(
                                  factor.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: factorColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: scoreFrac,
                            backgroundColor: AppColors.surface,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(factorColor),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          factor.detail,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline_rounded,
                                color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                factor.recommendation,
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.sm),

              // 4. Data Confidence Shield Auto-Calibrations
              const Text(
                'ACTIVE DATA SHIELD CALIBRATIONS (स्वचालित सुरक्षा समायोजन)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.shieldCalibrations.map((calib) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.verified_user_rounded,
                            color: AppColors.focusBlue, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            calib,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
