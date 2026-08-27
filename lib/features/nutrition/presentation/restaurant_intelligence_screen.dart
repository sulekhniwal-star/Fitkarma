import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../domain/nutrition_models.dart';
import '../domain/restaurant_intelligence_engine.dart';
import '../providers/nutrition_provider.dart';

class RestaurantIntelligenceScreen extends ConsumerStatefulWidget {
  const RestaurantIntelligenceScreen({super.key});

  @override
  ConsumerState<RestaurantIntelligenceScreen> createState() => _RestaurantIntelligenceScreenState();
}

class _RestaurantIntelligenceScreenState extends ConsumerState<RestaurantIntelligenceScreen> {
  int _selectedChainIndex = 0;

  @override
  Widget build(BuildContext context) {
    final chain = RestaurantIntelligenceEngine.chainPresets[_selectedChainIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Indian Restaurant Intelligence',
          regionalText: 'रेस्टोरेंट एवं बाहर खाने की स्मार्ट गाइड',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Restaurant Chain Selector Tabs
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: RestaurantIntelligenceEngine.chainPresets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final p = RestaurantIntelligenceEngine.chainPresets[index];
                    final isSelected = _selectedChainIndex == index;

                    return ChoiceChip(
                      selected: isSelected,
                      selectedColor: AppColors.focusBlue.withValues(alpha: 0.2),
                      backgroundColor: AppColors.surfaceElevated,
                      side: BorderSide(color: isSelected ? AppColors.focusBlue : AppColors.glassBorder),
                      label: Text(
                        p.chainName.split('&')[0].trim(),
                        style: TextStyle(
                          color: isSelected ? AppColors.focusBlue : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                      onSelected: (_) => setState(() => _selectedChainIndex = index),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Active Chain Banner
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.focusBlue,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.focusBlue.withValues(alpha: 0.15),
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: const Icon(Icons.restaurant_menu_rounded, color: AppColors.focusBlue, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(chain.chainName, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                          Text(chain.regionalName, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          const SizedBox(height: 2),
                          Text(
                            'Cuisine: ${chain.cuisineType}',
                            style: const TextStyle(fontSize: 11, color: AppColors.focusBlue, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. "Order This, Not That" Universal Swaps
              const Text(
                '🔄 "ORDER THIS, NOT THAT" (स्मार्ट विकल्प)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...RestaurantIntelligenceEngine.universalDiningSwaps.map((swap) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.cancel_outlined, color: AppColors.alertRed, size: 16),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      swap.badItemName,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textMuted,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_rounded, color: AppColors.karmaGreen, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppColors.karmaGreen, size: 16),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      swap.goodItemName,
                                      style: AppTypography.titleSmall.copyWith(
                                        color: AppColors.karmaGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.karmaGreen.withValues(alpha: 0.15),
                                borderRadius: AppRadii.radiusSm,
                              ),
                              child: Text(
                                swap.caloriesSaved,
                                style: const TextStyle(color: AppColors.karmaGreen, fontSize: 10, fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.focusBlue.withValues(alpha: 0.15),
                                borderRadius: AppRadii.radiusSm,
                              ),
                              child: Text(
                                swap.proteinGain,
                                style: const TextStyle(color: AppColors.focusBlue, fontSize: 10, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(swap.rationale, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),

              // 4. Curated Menu Items for Direct Logging
              const Text(
                'RECOMMENDED RESTAURANT DISHES (अनुशंसित व्यंजन)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...chain.menuItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: AppTypography.titleSmall.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                              Text(item.regionalName, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              const SizedBox(height: 2),
                              Text(
                                '${item.calories} kcal • ${item.proteinGrams}g Protein • ${item.servingUnit}',
                                style: const TextStyle(fontSize: 11, color: AppColors.karmaGreen, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.karmaGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
                          ),
                          onPressed: () {
                            ref.read(nutritionProvider.notifier).addMeal(item, MealPhase.dinner, 1.0);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Logged ${item.name} to Dinner!')),
                            );
                          },
                          child: const Text('Log Dish', style: TextStyle(color: AppColors.textInverse, fontSize: 11, fontWeight: FontWeight.w800)),
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
