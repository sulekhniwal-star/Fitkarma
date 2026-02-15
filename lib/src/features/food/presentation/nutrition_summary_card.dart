import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../application/food_controller.dart';

class NutritionSummaryCard extends ConsumerWidget {
  final double? targetCalories;

  const NutritionSummaryCard({
    super.key,
    this.targetCalories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionAsync = ref.watch(dailyNutritionProvider);

    return nutritionAsync.when(
      data: (nutrition) {
        final calories = nutrition['calories'] ?? 0;
        final protein = nutrition['protein'] ?? 0;
        final carbs = nutrition['carbs'] ?? 0;
        final fats = nutrition['fats'] ?? 0;
        final target = targetCalories ?? 2000;

        final progress = (calories / target).clamp(0.0, 1.0);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.surface,
                AppColors.surface.withValues(alpha: 0.8),

              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),

          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🍽️ Today\'s Nutrition',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getCalorieColor(calories, target),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${calories.toInt()} / ${target.toInt()} kcal',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),

                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getCalorieColor(calories, target),
                  ),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 20),

              // Macros Grid
              Row(
                children: [
                  _buildMacroCard(
                    'Protein',
                    protein,
                    50, // Target protein
                    Colors.orange,
                    Icons.fitness_center,
                  ),
                  const SizedBox(width: 12),
                  _buildMacroCard(
                    'Carbs',
                    carbs,
                    200, // Target carbs
                    Colors.blue,
                    Icons.grain,
                  ),
                  const SizedBox(width: 12),
                  _buildMacroCard(
                    'Fats',
                    fats,
                    50, // Target fats
                    Colors.purple,
                    Icons.water_drop,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (_, _) => _buildErrorCard(),
    );
  }

  Color _getCalorieColor(double calories, double target) {
    if (calories > target) return AppColors.error;
    if (calories > target * 0.9) return AppColors.warning;
    return AppColors.success;
  }

  Widget _buildMacroCard(
    String label,
    double value,
    double target,
    Color color,
    IconData icon,
  ) {
    final progress = (value / target).clamp(0.0, 1.0);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),

        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${value.toInt()}g',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 0.2),

                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '/ ${target.toInt()}g',
              style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          'Failed to load nutrition data',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
