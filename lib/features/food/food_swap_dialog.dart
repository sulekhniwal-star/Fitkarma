/// §P5-R Indian Food Swap Suggestion UI Dialog / Modal
///
/// Interactive UI Modal displaying side-by-side comparison of original caved food vs
/// Smart Swap alternative, metric delta badges (-150 kcal 🟢, +18g Pro 🟣, +55 Satiety 🟡),
/// culinary preparation tips, and "Apply Swap" action.
library;

import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/food_swap_controller.dart';
import 'package:fitkarma/features/food/food_swap_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _bgColor       = Color(0xFF161822);
const _surfaceColor  = Color(0xFF202334);
const _cardBgColor   = Color(0xFF282C42);
const _accentOrange  = Color(0xFFFF6B35);
const _accentGreen   = Color(0xFF4ADE80);
const _accentRed     = Color(0xFFF87171);
const _accentYellow  = Color(0xFFFBBF24);
const _accentPurple  = Color(0xFFA78BFA);
const _textPrimary   = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor   = Color(0xFF2E324A);

class FoodSwapDialog extends ConsumerWidget {
  const FoodSwapDialog({
    super.key,
    this.initialQuery,
  });

  final String? initialQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(foodSwapProvider);
    final engine = ref.read(foodSwapEngineProvider);

    final currentSub = state.activeSubstitute ??
        (initialQuery != null ? engine.findBestSwap(initialQuery!) : FoodSwapEngine.targetSwapRegistry.first);

    return Dialog(
      backgroundColor: _bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: _borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.swap_horiz_rounded, color: _accentOrange, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Indian Smart Swap 🔄',
                        style: TextStyle(
                          color: _textPrimary,
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: _textSecondary, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              if (currentSub == null) ...[
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No specific swap match found. Enjoy your meal in moderation!',
                      style: TextStyle(color: _textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ] else ...[
                // ── Side-by-Side Food Comparison Card ──
                Container(
                  key: const Key('food_swap_comparison_card'),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _FoodComparisonColumn(
                              title: 'Original Food',
                              name: currentSub.originalFoodName,
                              calories: currentSub.originalCalories,
                              protein: currentSub.originalProtein,
                              isAlternative: false,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward_rounded, color: _accentOrange, size: 20),
                          ),
                          Expanded(
                            child: _FoodComparisonColumn(
                              title: 'Smart Swap',
                              name: currentSub.alternativeName,
                              calories: currentSub.alternativeCalories,
                              protein: currentSub.alternativeProtein,
                              isAlternative: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── 3 Metric Delta Badges ──
                Row(
                  children: [
                    Expanded(
                      child: _MetricBadgeTile(
                        label: 'Calorie Delta',
                        value: '${currentSub.calorieDelta.round()} kcal',
                        color: _accentGreen,
                        icon: Icons.local_fire_department_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricBadgeTile(
                        label: 'Protein Gain',
                        value: '+${currentSub.proteinDelta.round()}g Pro',
                        color: _accentPurple,
                        icon: Icons.fitness_center_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricBadgeTile(
                        label: 'Satiety Gain',
                        value: '+${currentSub.satietyGain.round()} pts',
                        color: _accentYellow,
                        icon: Icons.sentiment_satisfied_alt_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Culinary Preparation Tip Card ──
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _cardBgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.restaurant_rounded, color: _accentOrange, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Culinary Prep Tip',
                            style: TextStyle(
                              color: _accentOrange,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentSub.culinaryPreparationTip,
                        key: const Key('swap_prep_tip_text'),
                        style: const TextStyle(color: _textPrimary, fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Action Buttons ──
                ElevatedButton(
                  key: const Key('apply_swap_btn'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // Log the smart swap alternative to foodProvider
                    ref.read(foodProvider.notifier).addFood(
                      FoodItem(
                        id: 'swap_${DateTime.now().millisecondsSinceEpoch}',
                        name: currentSub.alternativeName,
                        calories: currentSub.alternativeCalories.round(),
                        protein: currentSub.alternativeProtein.round(),
                        carbs: 25,
                        fat: 5,
                        mealType: 'Snacks',
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Apply Smart Swap & Log Meal',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodComparisonColumn extends StatelessWidget {
  const _FoodComparisonColumn({
    required this.title,
    required this.name,
    required this.calories,
    required this.protein,
    required this.isAlternative,
  });

  final String title;
  final String name;
  final double calories;
  final double protein;
  final bool isAlternative;

  @override
  Widget build(BuildContext context) {
    final titleColor = isAlternative ? _accentGreen : _accentRed;

    return Column(
      crossAxisAlignment: isAlternative ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: titleColor, fontSize: 10, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: const TextStyle(color: _textPrimary, fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${calories.round()} kcal • ${protein.round()}g Pro',
          style: const TextStyle(color: _textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _MetricBadgeTile extends StatelessWidget {
  const _MetricBadgeTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(color: color, fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: const TextStyle(color: _textSecondary, fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
