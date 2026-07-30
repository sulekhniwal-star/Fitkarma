import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/nutrition_engine.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/indian_food_item.dart';
import '../providers/nutrition_provider.dart';

class NutritionLoggerScreen extends ConsumerWidget {
  const NutritionLoggerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutritionProvider);
    const engine = NutritionEngine();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Smart Nutrition Logger', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Protein Deficit Alert Banner
              if (state.isProteinDeficit)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.warningAmber),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: AppColors.warningAmber),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Protein Deficit Alert: Current intake is under 70% of target (${state.targetProtein.round()}g).',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.warningAmber),
                        ),
                      ),
                    ],
                  ),
                ),

              // Macro Progress Summary Card
              GlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Daily Calories', style: AppTypography.titleMedium),
                        Text(
                          '${state.totalCalories.round()} / ${state.targetCalories.round()} kcal',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.primaryCyan),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMacroProgressBar('Protein', state.totalProtein, state.targetProtein, AppColors.primaryEmerald),
                    const SizedBox(height: AppSpacing.sm),
                    _buildMacroProgressBar('Carbs', state.totalCarbs, 250.0, AppColors.warningAmber),
                    const SizedBox(height: AppSpacing.sm),
                    _buildMacroProgressBar('Fats', state.totalFat, 65.0, AppColors.infoBlue),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Seeded Indian Food Database Search List
              Text('Seeded Indian Food Taxonomy', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...SeededIndianFoodDatabase.items.map((item) {
                final quality = engine.calculateMealQuality(item);
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    onTap: () {
                      ref.read(nutritionProvider.notifier).logFood(item);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: AppTypography.titleMedium),
                            Text('${item.calories} kcal • P: ${item.proteinGrams}g | C: ${item.carbsGrams}g | F: ${item.fatGrams}g', style: AppTypography.labelSmall),
                          ],
                        ),
                        Chip(
                          backgroundColor: AppColors.glassBgMid,
                          side: const BorderSide(color: AppColors.glassBorder),
                          label: Text('Q-Score: ${quality.overallScore}', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryCyan)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroProgressBar(String label, double current, double target, Color color) {
    final progress = (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodyMedium),
            Text('${current.round()} / ${target.round()} g', style: AppTypography.labelSmall),
          ],
        ),
        const SizedBox(height: 4.0),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.bgSecondary,
          color: color,
          minHeight: 6.0,
          borderRadius: BorderRadius.circular(3.0),
        ),
      ],
    );
  }
}
