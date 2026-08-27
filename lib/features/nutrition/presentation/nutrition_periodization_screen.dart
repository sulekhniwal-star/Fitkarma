import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/nutrition_periodization_engine.dart';

class NutritionPeriodizationScreen extends StatefulWidget {
  final double weightKg;
  final int maintenanceCalories;

  const NutritionPeriodizationScreen({
    super.key,
    this.weightKg = 72.0,
    this.maintenanceCalories = 2150,
  });

  @override
  State<NutritionPeriodizationScreen> createState() => _NutritionPeriodizationScreenState();
}

class _NutritionPeriodizationScreenState extends State<NutritionPeriodizationScreen> {
  bool _isRefeedEnabled = false;
  bool _isVratModeActive = false;
  late NutritionPeriodizationPlan _plan;

  @override
  void initState() {
    super.initState();
    _recalculatePlan();
  }

  void _recalculatePlan() {
    _plan = NutritionPeriodizationEngine.generateWeeklyPlan(
      weightKg: widget.weightKg,
      baseMaintenanceCalories: widget.maintenanceCalories,
      isRefeedEnabled: _isRefeedEnabled,
      isVratFastingDay: _isVratModeActive,
    );
  }

  Color _getIntensityColor(DayTrainingIntensity intensity) {
    switch (intensity) {
      case DayTrainingIntensity.heavyCompound:
        return AppColors.karmaGreen;
      case DayTrainingIntensity.moderateUpper:
        return AppColors.focusBlue;
      case DayTrainingIntensity.lightConditioning:
        return AppColors.energyOrange;
      case DayTrainingIntensity.fullRest:
        return AppColors.aiPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Nutrition Periodization & Carb Waves',
          regionalText: 'पोषण चक्रीकरण एवं कैलोरी प्रबंधन',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Weekly Caloric Average Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.focusBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Weekly Caloric Wave Average',
                      regionalText: 'साप्ताहिक औसत कैलोरी व प्रोटीन',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Weekly Avg',
                          value: '${_plan.averageWeeklyCalories}',
                          unit: 'kcal/day',
                          isHero: true,
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Target Protein',
                          value: '${_plan.weeklyProteinAverage.round()}g',
                          unit: 'fixed/day',
                          accentColor: AppColors.energyOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _plan.strategicRationale,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Refeed & Indian Vrat Mode Switches
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Saturday High-Carb Refeed Day', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                            Text('Breaks metabolic plateaus & restores leptin', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                        Switch(
                          value: _isRefeedEnabled,
                          activeThumbColor: AppColors.karmaGreen,
                          onChanged: (val) {
                            setState(() {
                              _isRefeedEnabled = val;
                              _recalculatePlan();
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Indian Vrat / Fasting Calibrator', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                            Text('Sabudana/Kuttu macro adjustments', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                        Switch(
                          value: _isVratModeActive,
                          activeThumbColor: AppColors.gold,
                          onChanged: (val) {
                            setState(() {
                              _isVratModeActive = val;
                              _recalculatePlan();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. 7-Day Periodization Schedule
              const Text(
                '7-DAY CARB & CALORIE SCHEDULE (दैनिक लक्ष्य)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ..._plan.weeklySchedule.map((day) {
                final col = _getIntensityColor(day.intensity);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(day.dayName, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800, fontSize: 14)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: col.withValues(alpha: 0.15),
                                    borderRadius: AppRadii.radiusSm,
                                  ),
                                  child: Text(
                                    day.intensity.name.split('/')[0].trim(),
                                    style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${day.targetProteinGrams}g Protein • ${day.targetCarbsGrams}g Carbs • ${day.targetFatsGrams}g Fats',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        Text(
                          '${day.targetCalories} kcal',
                          style: AppTypography.titleSmall.copyWith(color: col, fontWeight: FontWeight.w800),
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
