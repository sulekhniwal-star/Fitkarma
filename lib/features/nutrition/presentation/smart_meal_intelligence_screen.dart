import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../data/indian_food_database.dart';
import '../domain/meal_intelligence_engine.dart';
import '../domain/nutrition_models.dart';

class SmartMealIntelligenceScreen extends StatefulWidget {
  const SmartMealIntelligenceScreen({super.key});

  @override
  State<SmartMealIntelligenceScreen> createState() => _SmartMealIntelligenceScreenState();
}

class _SmartMealIntelligenceScreenState extends State<SmartMealIntelligenceScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  static const List<String> _categories = [
    'All',
    'High Protein',
    'Daal',
    'Roti/Bread',
    'Dairy',
    'Breakfast',
    'Snack',
    'Non-Veg',
  ];

  void _showFoodComparisonModal(BuildContext context, FoodItem itemA) {
    FoodItem itemB = IndianFoodDatabase.stapleIndianFoods.firstWhere(
      (f) => f.id != itemA.id,
      orElse: () => IndianFoodDatabase.stapleIndianFoods.last,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final comparison = MealIntelligenceEngine.compareFoods(itemA, itemB);

            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.70,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Smart Indian Food Comparison',
                      regionalText: 'खाद्य पदार्थों की तुलना',
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Side-by-side Food Header Cards
                    Row(
                      children: [
                        Expanded(
                          child: BentoCard(
                            backgroundColor: AppColors.surface,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CURRENT (वर्तमान)', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(itemA.name, style: AppTypography.titleSmall.copyWith(fontSize: 12, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text('${itemA.calories} kcal • ${itemA.proteinGrams}g P', style: const TextStyle(fontSize: 11, color: AppColors.karmaGreen)),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.compare_arrows_rounded, color: AppColors.focusBlue, size: 22),
                        ),
                        Expanded(
                          child: BentoCard(
                            backgroundColor: AppColors.surface,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('COMPARE WITH (तुलना)', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                DropdownButton<FoodItem>(
                                  value: itemB,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  dropdownColor: AppColors.surfaceElevated,
                                  items: IndianFoodDatabase.stapleIndianFoods.map((f) {
                                    return DropdownMenuItem(
                                      value: f,
                                      child: Text(f.name, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => itemB = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Delta Metrics Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Calorie Diff',
                          value: '${comparison.calorieDelta > 0 ? "+${comparison.calorieDelta}" : comparison.calorieDelta}',
                          unit: 'kcal',
                          accentColor: comparison.calorieDelta <= 0 ? AppColors.karmaGreen : AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Protein Diff',
                          value: '${comparison.proteinDelta > 0 ? "+${comparison.proteinDelta}" : comparison.proteinDelta}g',
                          accentColor: comparison.proteinDelta >= 0 ? AppColors.karmaGreen : AppColors.alertRed,
                        ),
                        GlowingMetric(
                          label: 'Fiber Diff',
                          value: '${comparison.fiberDelta > 0 ? "+${comparison.fiberDelta}" : comparison.fiberDelta}g',
                          accentColor: comparison.fiberDelta >= 0 ? AppColors.focusBlue : AppColors.textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Recommendation Card
                    BentoCard(
                      backgroundColor: AppColors.surface,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              comparison.recommendation,
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
                            ),
                          ),
                        ],
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
  Widget build(BuildContext context) {
    List<FoodItem> items = IndianFoodDatabase.search(_searchQuery);
    if (_selectedCategory == 'High Protein') {
      items = items.where((f) => f.proteinGrams >= 12.0).toList();
    } else if (_selectedCategory != 'All') {
      items = items.where((f) => f.category == _selectedCategory).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Smart Indian Meal Intelligence',
          regionalText: 'भारतीय आहार डेटाबेस एवं तुलना',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Bar & Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search 100+ Indian dishes, rotis, daals, snacks...',
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.radiusSm,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;

                  return ChoiceChip(
                    selected: isSelected,
                    selectedColor: AppColors.focusBlue.withValues(alpha: 0.2),
                    backgroundColor: AppColors.surfaceElevated,
                    side: BorderSide(color: isSelected ? AppColors.focusBlue : AppColors.glassBorder),
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? AppColors.focusBlue : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.glassBorder, height: 1),

            // 2. Food Item Stream with Instant Quality Score Badges
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final qualityScore = MealIntelligenceEngine.calculateLocalMealScore(item);
                  final Color scoreColor = qualityScore >= 80
                      ? AppColors.karmaGreen
                      : qualityScore >= 60
                          ? AppColors.focusBlue
                          : AppColors.energyOrange;

                  return BentoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(item.name, style: AppTypography.titleSmall.copyWith(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: scoreColor.withValues(alpha: 0.15),
                                      borderRadius: AppRadii.radiusSm,
                                    ),
                                    child: Text(
                                      'Score $qualityScore',
                                      style: TextStyle(color: scoreColor, fontSize: 10, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              Text(item.regionalName, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              const SizedBox(height: 3),
                              Text(
                                '${item.calories} kcal • ${item.proteinGrams}g Protein • ${item.carbsGrams}g Carbs • ${item.fatsGrams}g Fat',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.focusBlue, size: 20),
                          tooltip: 'Compare Food',
                          onPressed: () => _showFoodComparisonModal(context, item),
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
}
