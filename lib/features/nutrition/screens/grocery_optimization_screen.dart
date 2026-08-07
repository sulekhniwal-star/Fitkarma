import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/grocery_models.dart';
import '../models/grocery_optimization_engine.dart';

/// §P5-F Meal Plan → Budget-Optimized Grocery Flow Screen
/// Route: /food/grocery-optimizer
class GroceryOptimizationScreen extends StatefulWidget {
  const GroceryOptimizationScreen({super.key});

  @override
  State<GroceryOptimizationScreen> createState() => _GroceryOptimizationScreenState();
}

class _GroceryOptimizationScreenState extends State<GroceryOptimizationScreen> {
  final _engine = const GroceryOptimizationEngine();
  double _monthlyBudget = 3000.0;
  int _dailyProteinTarget = 110;
  OptimizedGroceryList? _optimizedResult;

  @override
  void initState() {
    super.initState();
    _runOptimization();
  }

  void _runOptimization() {
    // Sample 7-day meal plan with premium ingredients (Greek yogurt, salmon, whey)
    final samplePlan = List.generate(7, (i) {
      return DayMealPlan(
        dayName: 'Day ${i + 1}',
        ingredients: const [
          GroceryItem(id: 'g1', name: 'Greek Yogurt 200g', quantityGrams: 200, price: 180, proteinG: 20, category: FoodCategory.protein),
          GroceryItem(id: 'g2', name: 'Salmon Fillet 150g', quantityGrams: 150, price: 450, proteinG: 34, category: FoodCategory.protein),
          GroceryItem(id: 'g3', name: 'Whole Wheat Roti Pack', quantityGrams: 300, price: 50, proteinG: 12, category: FoodCategory.staples),
          GroceryItem(id: 'g4', name: 'Mixed Green Salad', quantityGrams: 200, price: 60, proteinG: 3, category: FoodCategory.produce),
        ],
      );
    });

    final result = _engine.optimize(
      weekPlan: samplePlan,
      monthlyBudgetInr: _monthlyBudget,
      dailyProteinTargetG: _dailyProteinTarget,
    );

    setState(() {
      _optimizedResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Grocery Optimizer 2.0', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget & Protein Controls Card
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Monthly Budget Limit:', style: AppTypography.labelLg),
                      Text('₹${_monthlyBudget.round()}/mo', style: AppTypography.h3.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  Slider(
                    value: _monthlyBudget,
                    min: 1500,
                    max: 8000,
                    divisions: 13,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _monthlyBudget = val);
                      _runOptimization();
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daily Protein Target:', style: AppTypography.labelLg),
                      Text('${_dailyProteinTarget}g/day', style: AppTypography.h3.copyWith(color: AppColors.teal)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (_optimizedResult != null) ...[
              // Budget Warning / Notice Banner
              if (_optimizedResult!.budgetWarning != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _optimizedResult!.isWithinBudget
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(
                      color: _optimizedResult!.isWithinBudget
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _optimizedResult!.isWithinBudget ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                        color: _optimizedResult!.isWithinBudget ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _optimizedResult!.budgetWarning!,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),

              // Weekly Cost & Protein Summary
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Weekly Cost', style: AppTypography.bodySm),
                        Text('₹${_optimizedResult!.costInr.round()}', style: AppTypography.h2.copyWith(color: AppColors.primary)),
                        Text('Limit: ₹${(_monthlyBudget / 4.33).round()}', style: AppTypography.bodySm.copyWith(fontSize: 10)),
                      ],
                    ),
                    Container(height: 35, width: 1, color: AppColors.glassBorder),
                    Column(
                      children: [
                        Text('Monthly Est.', style: AppTypography.bodySm),
                        Text('₹${(_optimizedResult!.costInr * 4.33).round()}', style: AppTypography.h2.copyWith(color: AppColors.teal)),
                        Text('Budget: ₹${_monthlyBudget.round()}', style: AppTypography.bodySm.copyWith(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Applied Swaps Section
              if (_optimizedResult!.appliedSwaps.isNotEmpty) ...[
                Text('Protein-per-Rupee Swaps Applied:', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                for (final swap in _optimizedResult!.appliedSwaps)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface1,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.swap_horiz, color: AppColors.accent, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(swap, style: AppTypography.bodySm)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Aggregated Grocery Shopping List
              Text('Optimized Shopping List:', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              for (final item in _optimizedResult!.items)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface0,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: AppTypography.labelLg),
                          Text('${item.quantityGrams.round()}g · P: ${item.proteinG.round()}g', style: AppTypography.bodySm),
                        ],
                      ),
                      Text('₹${item.price.round()}', style: AppTypography.h3.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
