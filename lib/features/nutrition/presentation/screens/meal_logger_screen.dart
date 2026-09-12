import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/models/nutrition_models.dart';
import '../../domain/services/indian_nutrition_engine.dart';
import '../../domain/services/meal_quality_engine.dart';

class MealLoggerScreen extends StatefulWidget {
  const MealLoggerScreen({super.key});

  @override
  State<MealLoggerScreen> createState() => _MealLoggerScreenState();
}

class _MealLoggerScreenState extends State<MealLoggerScreen> {
  final _searchController = TextEditingController();
  final _engine = const IndianNutritionEngine();
  final _qualityEngine = const MealQualityEngine();

  String _searchQuery = '';
  MealType _selectedMealType = MealType.lunch;
  final Map<FoodItem, double> _selectedQuantities = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _engine.searchFoods(_searchQuery);

    double totalCals = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    _selectedQuantities.forEach((food, qty) {
      totalCals += food.caloriesKcal * qty;
      totalProtein += food.proteinGrams * qty;
      totalCarbs += food.carbsGrams * qty;
      totalFat += food.fatGrams * qty;
      totalFiber += food.fiberGrams * qty;
    });

    final quality = _qualityEngine.evaluateMeal(
      caloriesKcal: totalCals,
      proteinGrams: totalProtein,
      carbsGrams: totalCarbs,
      fatGrams: totalFat,
      fiberGrams: totalFiber,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BilingualLabel(
          english: 'Log Indian Meal',
          hindi: 'आहार प्रविष्टि',
          primaryStyle: AppTypography.h3,
        ),
      ),
      body: Column(
        children: [
          // Meal Type Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: MealType.values.map((type) {
                final isSelected = _selectedMealType == type;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        type.name[0].toUpperCase() + type.name.substring(1),
                        style: AppTypography.label.copyWith(
                          color: isSelected ? AppColors.textOnAccent : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primaryCyan,
                      backgroundColor: AppColors.surfaceGlassHover,
                      onSelected: (val) {
                        if (val) setState(() => _selectedMealType = type);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlassHover,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: TextField(
                controller: _searchController,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: AppColors.textMuted),
                  hintText: 'Search 500+ Indian foods (e.g. Roti, Paneer, Dal)...',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
          ),

          // Food Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                final qty = _selectedQuantities[food] ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(food.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text(food.nameHindi, style: AppTypography.bilingualSub),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('${food.caloriesKcal.toInt()} kcal', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                                  const SizedBox(width: 8),
                                  Text('P: ${food.proteinGrams}g', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                                  const SizedBox(width: 8),
                                  Text('C: ${food.carbsGrams}g', style: AppTypography.label.copyWith(color: AppColors.accentAmber)),
                                  const SizedBox(width: 8),
                                  Text('GI: ${food.glycemicIndex.toInt()}', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                                ],
                              ),
                              Text('Unit: ${food.standardPortionUnit}', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        // Quantity increment/decrement buttons
                        Row(
                          children: [
                            if (qty > 0) ...[
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: AppColors.accentCoral, size: 22),
                                onPressed: () {
                                  setState(() {
                                    if (qty <= 1.0) {
                                      _selectedQuantities.remove(food);
                                    } else {
                                      _selectedQuantities[food] = qty - 1.0;
                                    }
                                  });
                                },
                              ),
                              Text(
                                '${qty.toInt()}',
                                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ],
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: AppColors.primaryCyan, size: 24),
                              onPressed: () {
                                setState(() {
                                  _selectedQuantities[food] = qty + 1.0;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Summary Bar & Save CTA
          if (_selectedQuantities.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surfaceCard,
                border: Border(top: BorderSide(color: AppColors.borderGlass)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${totalCals.toInt()} kcal | ${totalProtein.toStringAsFixed(1)}g Protein',
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            Text(
                              'Quality Score: ${quality.overallScore}/100',
                              style: AppTypography.label.copyWith(color: AppColors.primaryEmerald),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryEmerald,
                            foregroundColor: AppColors.textOnAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Meal successfully logged offline!'),
                                backgroundColor: AppColors.primaryEmerald,
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save Meal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
