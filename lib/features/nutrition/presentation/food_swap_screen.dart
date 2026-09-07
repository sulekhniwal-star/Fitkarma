import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../domain/food_swap_engine.dart';
import '../domain/nutrition_models.dart';
import '../providers/nutrition_provider.dart';

class FoodSwapScreen extends ConsumerStatefulWidget {
  const FoodSwapScreen({super.key});

  @override
  ConsumerState<FoodSwapScreen> createState() => _FoodSwapScreenState();
}

class _FoodSwapScreenState extends ConsumerState<FoodSwapScreen> {
  SwapCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final swaps = FoodSwapEngine.getSwapsForCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Indian Smart Food Swaps',
          regionalText: 'स्मार्ट भारतीय भोजन प्रतिस्थापन',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All Swaps (सभी)'),
                        selected: _selectedCategory == null,
                        selectedColor: AppColors.karmaGreen.withValues(alpha: 0.2),
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: _selectedCategory == null ? AppColors.karmaGreen : AppColors.textSecondary,
                          fontWeight: _selectedCategory == null ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: _selectedCategory == null ? AppColors.karmaGreen : AppColors.glassBorder,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCategory = null);
                        },
                      ),
                    ),
                    ...SwapCategory.values.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat.label),
                          selected: isSelected,
                          selectedColor: Color(cat.colorCode).withValues(alpha: 0.2),
                          backgroundColor: AppColors.surface,
                          labelStyle: TextStyle(
                            color: isSelected ? Color(cat.colorCode) : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected ? Color(cat.colorCode) : AppColors.glassBorder,
                          ),
                          onSelected: (val) {
                            setState(() => _selectedCategory = val ? cat : null);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Swaps List
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.screenPadding,
                itemCount: swaps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final swap = swaps[index];
                  final Color categoryColor = Color(swap.category.colorCode);

                  return BentoCard(
                    hasGlow: true,
                    glowColor: categoryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header category tag & taste score
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: categoryColor.withValues(alpha: 0.15),
                                borderRadius: AppRadii.radiusSm,
                                border: Border.all(color: categoryColor.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                swap.category.label.toUpperCase(),
                                style: TextStyle(color: categoryColor, fontSize: 10, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Row(
                              children: [
                                const Text('Taste Match: ', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                ...List.generate(5, (starIdx) {
                                  return Icon(
                                    starIdx < swap.tasteFidelityScore ? Icons.star_rounded : Icons.star_outline_rounded,
                                    color: AppColors.gold,
                                    size: 13,
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Comparison row: Original -> Suggested
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Original Dish
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: AppRadii.radiusSm,
                                  border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('CURRENT (पारंपरिक)', style: TextStyle(color: AppColors.alertRed, fontSize: 9, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 2),
                                    Text(swap.originalItem.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary)),
                                    Text(swap.originalItem.servingUnit, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${swap.originalItem.calories} kcal • ${swap.originalItem.proteinGrams}g P',
                                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(Icons.arrow_forward_rounded, color: AppColors.karmaGreen, size: 20),
                            ),
                            // Suggested Swap Dish
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: AppRadii.radiusSm,
                                  border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('SMART SWAP (उन्नत विकल्प)', style: TextStyle(color: AppColors.karmaGreen, fontSize: 9, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 2),
                                    Text(swap.suggestedItem.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary)),
                                    Text(swap.suggestedItem.servingUnit, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${swap.suggestedItem.calories} kcal • ${swap.suggestedItem.proteinGrams}g P',
                                      style: const TextStyle(fontSize: 10, color: AppColors.karmaGreen, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Delta Metrics Pills
                        Row(
                          children: [
                            _buildDeltaPill(
                              label: swap.deltaCalories <= 0 ? '${swap.deltaCalories} kcal' : '+${swap.deltaCalories} kcal',
                              isPositiveAdvantage: swap.deltaCalories <= 0,
                            ),
                            const SizedBox(width: 6),
                            _buildDeltaPill(
                              label: swap.deltaProtein >= 0 ? '+${swap.deltaProtein}g Protein' : '${swap.deltaProtein}g Protein',
                              isPositiveAdvantage: swap.deltaProtein >= 0,
                            ),
                            const SizedBox(width: 6),
                            _buildDeltaPill(
                              label: swap.deltaFiber >= 0 ? '+${swap.deltaFiber}g Fiber' : '${swap.deltaFiber}g Fiber',
                              isPositiveAdvantage: swap.deltaFiber >= 0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Culinary tip & physiological reason
                        Text(
                          swap.physiologicalAdvantage,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '🍳 Chef Tip: ${swap.culinaryPreparationTip}',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10, height: 1.3),
                        ),
                        const SizedBox(height: 8),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.karmaGreen),
                              shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.karmaGreen, size: 18),
                            label: const Text(
                              'Log This Smart Swap to Daily Diet',
                              style: TextStyle(color: AppColors.karmaGreen, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              ref.read(nutritionProvider.notifier).addMeal(
                                    swap.suggestedItem,
                                    MealPhase.lunch,
                                    1.0,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.surfaceElevated,
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, color: AppColors.karmaGreen, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Logged "${swap.suggestedItem.name}" to Lunch!',
                                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
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
  }

  Widget _buildDeltaPill({
    required String label,
    required bool isPositiveAdvantage,
  }) {
    final Color color = isPositiveAdvantage ? AppColors.karmaGreen : AppColors.energyOrange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}
