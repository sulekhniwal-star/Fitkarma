import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';
import 'barcode_scanner_screen.dart';
import 'event_nutrition_guide_screen.dart';
import 'fix_my_meal_screen.dart';
import 'grocery_optimizer_screen.dart';
import 'indian_food_swaps_screen.dart';
import 'meal_logger_screen.dart';
import 'thali_presets_screen.dart';

class FoodHomeScreen extends ConsumerWidget {
  final bool showBackButton;

  const FoodHomeScreen({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardStateProvider);
    final mealsAsync = ref.watch(todayMealsStreamProvider);
    final meals = mealsAsync.value ?? [];

    final proteinProgress = dashboard.targetProteinGrams > 0
        ? (dashboard.consumedProteinGrams / dashboard.targetProteinGrams).clamp(0.0, 1.0)
        : 0.0;
    final carbsProgress = dashboard.targetCarbsGrams > 0
        ? (dashboard.consumedCarbsGrams / dashboard.targetCarbsGrams).clamp(0.0, 1.0)
        : 0.0;
    final fatsProgress = dashboard.targetFatsGrams > 0
        ? (dashboard.consumedFatsGrams / dashboard.targetFatsGrams).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: (showBackButton && Navigator.canPop(context))
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: BilingualLabel(
          english: 'Smart Indian Nutrition',
          hindi: 'स्मार्ट भारतीय पोषण व आहार',
          primaryStyle: AppTypography.h3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.primaryCyan),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GroceryOptimizerScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Calorie & Macro Target Card (Live User Data)
            BentoCard(
              isGlowing: dashboard.consumedCalories > 0,
              glowColor: AppColors.primaryEmerald,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlowingMetric(
                        value: '${dashboard.consumedCalories.toInt()}',
                        label: 'Calories Consumed',
                        unit: '/ ${dashboard.targetCalories.toInt()} kcal',
                        glowColor: AppColors.primaryEmerald,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryEmerald.withAlpha(100)),
                        ),
                        child: Text(
                          '${meals.length} Meals Logged',
                          style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Macro Bars Row
                  Row(
                    children: [
                      _buildMacroColumn(
                        'Protein',
                        '${dashboard.consumedProteinGrams.toInt()}g',
                        '/ ${dashboard.targetProteinGrams.toInt()}g',
                        AppColors.primaryCyan,
                        proteinProgress,
                      ),
                      const SizedBox(width: 12),
                      _buildMacroColumn(
                        'Carbs',
                        '${dashboard.consumedCarbsGrams.toInt()}g',
                        '/ ${dashboard.targetCarbsGrams.toInt()}g',
                        AppColors.accentAmber,
                        carbsProgress,
                      ),
                      const SizedBox(width: 12),
                      _buildMacroColumn(
                        'Fats',
                        '${dashboard.consumedFatsGrams.toInt()}g',
                        '/ ${dashboard.targetFatsGrams.toInt()}g',
                        AppColors.accentCoral,
                        fatsProgress,
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 16),

            // AI Fix My Meal Banner
            BentoCard(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FixMyMealScreen()),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppColors.accentPurple, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Fix My Meal', style: AppTypography.h3),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accentPurple.withAlpha(60),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('AI Vision', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.accentPurple)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Scan your Indian thali to detect hidden refined carbs & instant protein swaps.',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 16),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 12),

            // Barcode Scanner & Thali Presets Row
            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan.withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.qr_code_scanner, color: AppColors.primaryCyan, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Barcode Scan', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text('Amul, Maggi, etc.', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BentoCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ThaliPresetsScreen()),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accentAmber.withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.lunch_dining, color: AppColors.accentAmber, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Thali Presets', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text('1-Tap Ghar Ki Thali', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 180.ms, duration: 400.ms),

            const SizedBox(height: 12),

            // Tonight's Event / Shaadi Food Strategy Card
            BentoCard(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EventNutritionGuideScreen()),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentCoral.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.celebration, color: AppColors.accentCoral, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Tonight\'s Event Plan', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.accentCoral.withAlpha(35),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('Shaadi / Party', style: AppTypography.label.copyWith(fontSize: 9, color: AppColors.accentCoral, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Text(
                          'Pre-load protein & master the buffet without spiking fat or guilt.',
                          style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 14),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Meal Timeline Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today\'s Logged Thalis', style: AppTypography.h3),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const IndianFoodSwapsScreen()),
                  ),
                  icon: const Icon(Icons.swap_horiz, size: 16, color: AppColors.primaryCyan),
                  label: Text('Smart Swaps', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Dynamic Real Logged Meals from User
            if (meals.isEmpty)
              BentoCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.restaurant_menu_outlined, size: 40, color: AppColors.textMuted),
                        const SizedBox(height: 10),
                        Text(
                          'No meals logged yet today',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap below to log your breakfast, lunch, snack, or dinner',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...meals.map((meal) {
                final timeStr = '${meal.loggedAt.hour.toString().padLeft(2, '0')}:${meal.loggedAt.minute.toString().padLeft(2, '0')}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildMealTimelineCard(
                    context,
                    title: meal.name,
                    hindiTitle: meal.mealType,
                    foodNames: '${meal.proteinGrams.toStringAsFixed(1)}g Protein • ${meal.carbsGrams.toStringAsFixed(1)}g Carbs • ${meal.fatGrams.toStringAsFixed(1)}g Fat',
                    calories: '${meal.caloriesKcal.toInt()} kcal',
                    protein: '${meal.proteinGrams.toStringAsFixed(1)}g Protein',
                    time: timeStr,
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Log New Meal CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: AppColors.textOnAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MealLoggerScreen()),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: Text('Log Meal / Thali', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textOnAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroColumn(String label, String value, String target, Color color, double progress) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceGlassHover,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Text(value, style: AppTypography.bodyMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
            Text(target, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: AppColors.surfaceCard,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTimelineCard(
    BuildContext context, {
    required String title,
    required String hindiTitle,
    required String foodNames,
    required String calories,
    required String protein,
    int qualityScore = 85,
    required String time,
  }) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: AppTypography.h3),
                  const SizedBox(width: 8),
                  Text('($hindiTitle)', style: AppTypography.bilingualSub),
                ],
              ),
              Row(
                children: [
                  Text(time, style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Q-$qualityScore', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(foodNames, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const Divider(color: AppColors.borderGlass, height: 16),
          Row(
            children: [
              Text(calories, style: AppTypography.label.copyWith(color: AppColors.textPrimary)),
              const SizedBox(width: 12),
              const Text('•', style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(width: 12),
              Text(protein, style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
            ],
          ),
        ],
      ),
    );
  }
}
