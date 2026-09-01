import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/nutrition_adherence_engine.dart';

class NutritionAdherenceScreen extends StatefulWidget {
  const NutritionAdherenceScreen({super.key});

  @override
  State<NutritionAdherenceScreen> createState() => _NutritionAdherenceScreenState();
}

class _NutritionAdherenceScreenState extends State<NutritionAdherenceScreen> {
  late AdherenceReport _report;

  @override
  void initState() {
    super.initState();
    final samples = [
      const DailyAdherenceSample(dayName: 'Mon', targetCalories: 2100, consumedCalories: 2050, targetProtein: 135, consumedProtein: 138),
      const DailyAdherenceSample(dayName: 'Tue', targetCalories: 2100, consumedCalories: 2140, targetProtein: 135, consumedProtein: 132),
      const DailyAdherenceSample(dayName: 'Wed', targetCalories: 1950, consumedCalories: 1900, targetProtein: 135, consumedProtein: 140),
      const DailyAdherenceSample(dayName: 'Thu', targetCalories: 2250, consumedCalories: 2200, targetProtein: 135, consumedProtein: 136),
      const DailyAdherenceSample(dayName: 'Fri', targetCalories: 2100, consumedCalories: 2350, targetProtein: 135, consumedProtein: 120),
      const DailyAdherenceSample(dayName: 'Sat', targetCalories: 2300, consumedCalories: 2450, targetProtein: 135, consumedProtein: 130, isShieldApplied: true),
      const DailyAdherenceSample(dayName: 'Sun', targetCalories: 1850, consumedCalories: 1820, targetProtein: 135, consumedProtein: 135),
    ];
    _report = NutritionAdherenceEngine.evaluateWeeklyAdherence(samples);
  }

  @override
  Widget build(BuildContext context) {
    final Color scoreColor = _report.weeklyAdherenceScore >= 80
        ? AppColors.karmaGreen
        : _report.weeklyAdherenceScore >= 65
            ? AppColors.focusBlue
            : AppColors.energyOrange;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Nutrition Adherence & Resilience',
          regionalText: 'आहार निरंतरता एवं साप्ताहिक संतुलन',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Adherence Score & Streak Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: scoreColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: 'Weekly Adherence Index',
                          regionalText: '7-दिवसीय पोषण स्कोर',
                        ),
                        Icon(Icons.verified_rounded, color: AppColors.karmaGreen, size: 22),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Adherence',
                          value: '${_report.weeklyAdherenceScore}%',
                          unit: 'score',
                          isHero: true,
                          accentColor: scoreColor,
                        ),
                        GlowingMetric(
                          label: 'Active Streak',
                          value: '${_report.currentStreakDays}',
                          unit: 'days',
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Streak Shield',
                          value: '${_report.availableShieldsCount}',
                          unit: 'active',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _report.compassionateFeedback,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Streak Armor Callout
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.focusBlue, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Streak Armor active: Occasional family gatherings or weddings use your weekly freeze shield without resetting your streak.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. 7-Day Caloric Variance Breakdown
              const Text(
                '7-DAY CALORIC DEVIATION (दैनिक कैलोरी विचलन)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ..._report.weekHistory.map((day) {
                final isOver = day.calorieVariance > 0;
                final isProtected = day.isShieldApplied;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: AppRadii.radiusSm,
                              ),
                              child: Text(day.dayName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.textPrimary)),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${day.consumedCalories} / ${day.targetCalories} kcal',
                                  style: AppTypography.titleSmall.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Protein: ${day.consumedProtein}g / ${day.targetProtein}g',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (isProtected)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.focusBlue.withValues(alpha: 0.15),
                              borderRadius: AppRadii.radiusSm,
                            ),
                            child: const Text('SHIELD USED', style: TextStyle(color: AppColors.focusBlue, fontSize: 10, fontWeight: FontWeight.w800)),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isOver ? AppColors.energyOrange : AppColors.karmaGreen).withValues(alpha: 0.15),
                              borderRadius: AppRadii.radiusSm,
                            ),
                            child: Text(
                              '${isOver ? "+${day.calorieVariance}" : day.calorieVariance} kcal',
                              style: TextStyle(
                                color: isOver ? AppColors.energyOrange : AppColors.karmaGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
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
