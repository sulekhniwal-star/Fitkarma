import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../data/indian_food_database.dart';
import '../domain/nutrition_models.dart';
import '../providers/nutrition_provider.dart';

class FoodScreenHome extends ConsumerWidget {
  const FoodScreenHome({super.key});

  void _showAddFoodBottomSheet(BuildContext context, WidgetRef ref, MealPhase phase) {
    String query = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final results = IndianFoodDatabase.search(query);

            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BilingualLabel(
                      primaryText: 'Log to ${phase.name}',
                      regionalText: '${phase.regionalName} में जोड़ें',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      onChanged: (val) => setModalState(() => query = val),
                      decoration: const InputDecoration(
                        hintText: 'Search Indian foods (e.g. Paneer, Daal, Idli, Poha)...',
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: AppRadii.radiusSm,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return BentoCard(
                            backgroundColor: AppColors.surface,
                            onTap: () {
                              ref.read(nutritionProvider.notifier).addMeal(item, phase, 1.0);
                              Navigator.of(ctx).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, style: AppTypography.titleSmall.copyWith(fontSize: 14)),
                                      Text(item.regionalName, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.calories} kcal • ${item.proteinGrams}g Protein • ${item.servingUnit}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.karmaGreen, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.add_circle_rounded, color: AppColors.karmaGreen, size: 24),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrition = ref.watch(nutritionProvider);

    final calProgress = (nutrition.consumedCalories / nutrition.targetCalories).clamp(0.0, 1.0);
    final proteinProgress = (nutrition.consumedProtein / nutrition.targetProtein).clamp(0.0, 1.0);
    final carbsProgress = (nutrition.consumedCarbs / nutrition.targetCarbs).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Smart Indian Nutrition',
          regionalText: 'स्मार्ट भारतीय पोषण योजना',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Caloric Budget Bento Card with Concentric Activity Rings
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.karmaGreen,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BilingualLabel(
                            primaryText: 'Calories Remaining',
                            regionalText: 'बची हुई कैलोरी लक्ष्य',
                          ),
                          const SizedBox(height: 6),
                          GlowingMetric(
                            label: 'To Consume',
                            value: '${nutrition.remainingCalories}',
                            unit: 'kcal',
                            isHero: true,
                            accentColor: AppColors.karmaGreen,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Consumed: ${nutrition.consumedCalories} / ${nutrition.targetCalories} kcal',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ActivityRings(
                      size: 110,
                      rings: [
                        RingData(progress: calProgress, color: AppColors.karmaGreen, strokeWidth: 8),
                        RingData(progress: proteinProgress, color: AppColors.energyOrange, strokeWidth: 8),
                        RingData(progress: carbsProgress, color: AppColors.focusBlue, strokeWidth: 8),
                      ],
                      centerWidget: const Icon(Icons.restaurant_rounded, color: AppColors.karmaGreen, size: 22),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Macronutrient Progress Metrics Bar
              BentoCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GlowingMetric(
                      label: 'Protein',
                      value: '${nutrition.consumedProtein.round()}g',
                      unit: '/ ${nutrition.targetProtein}g',
                      accentColor: AppColors.energyOrange,
                    ),
                    GlowingMetric(
                      label: 'Carbs',
                      value: '${nutrition.consumedCarbs.round()}g',
                      unit: '/ ${nutrition.targetCarbs}g',
                      accentColor: AppColors.focusBlue,
                    ),
                    GlowingMetric(
                      label: 'Fats',
                      value: '${nutrition.consumedFats.round()}g',
                      unit: '/ ${nutrition.targetFats}g',
                      accentColor: AppColors.aiPurple,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. 4-Phase Meal Slots
              const Text(
                'TODAY\'S MEAL LOG (दैनिक भोजन विवरण)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...MealPhase.values.map((phase) {
                final meals = nutrition.getMealsForPhase(phase);
                final phaseCalories = meals.fold<int>(0, (sum, m) => sum + m.totalCalories);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.focusBlue.withValues(alpha: 0.15),
                                    borderRadius: AppRadii.radiusSm,
                                  ),
                                  child: Icon(_getPhaseIcon(phase), color: AppColors.focusBlue, size: 16),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(phase.name, style: AppTypography.titleSmall.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                                    Text(phase.regionalName, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (phaseCalories > 0)
                                  Text(
                                    '$phaseCalories kcal',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.karmaGreen),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.focusBlue, size: 20),
                                  onPressed: () => _showAddFoodBottomSheet(context, ref, phase),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (meals.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          const Divider(color: AppColors.glassBorder, height: 1),
                          const SizedBox(height: 6),
                          ...meals.map((m) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${m.food.name} (${m.food.servingUnit})',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
                                    ),
                                    Text(
                                      '${m.totalCalories} kcal • ${m.totalProtein}g P',
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                    ),
                                  ],
                                ),
                              )),
                        ],
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

  IconData _getPhaseIcon(MealPhase phase) {
    switch (phase) {
      case MealPhase.breakfast:
        return Icons.wb_sunny_rounded;
      case MealPhase.lunch:
        return Icons.restaurant_rounded;
      case MealPhase.eveningSnack:
        return Icons.local_cafe_rounded;
      case MealPhase.dinner:
        return Icons.nightlight_round;
    }
  }
}
