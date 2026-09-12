import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import 'fix_my_meal_screen.dart';
import 'grocery_optimizer_screen.dart';
import 'indian_food_swaps_screen.dart';
import 'meal_logger_screen.dart';

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Daily Calorie & Macro Target Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryEmerald,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const GlowingMetric(
                        value: '1,420',
                        label: 'Calories Consumed',
                        unit: '/ 1,850 kcal',
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
                          'Score 84/100',
                          style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Macro Bars Row
                  Row(
                    children: [
                      _buildMacroColumn('Protein', '68g', '/ 90g', AppColors.primaryCyan, 0.75),
                      const SizedBox(width: 12),
                      _buildMacroColumn('Carbs', '165g', '/ 220g', AppColors.accentAmber, 0.75),
                      const SizedBox(width: 12),
                      _buildMacroColumn('Fats', '42g', '/ 55g', AppColors.accentCoral, 0.76),
                      const SizedBox(width: 12),
                      _buildMacroColumn('Fiber', '24g', '/ 30g', AppColors.primaryEmerald, 0.80),
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

            const SizedBox(height: 20),

            // Meal Timeline Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today\'s Thali Timeline', style: AppTypography.h3),
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

            // Meal Timeline Items
            _buildMealTimelineCard(
              context,
              title: 'Breakfast',
              hindiTitle: 'नाश्ता',
              foodNames: '2 Steamed Idlis + 1 Katori Drumstick Sambar + 1 Boiled Egg',
              calories: '286 kcal',
              protein: '15g Protein',
              qualityScore: 88,
              time: '08:30 AM',
            ),
            const SizedBox(height: 10),
            _buildMealTimelineCard(
              context,
              title: 'Lunch',
              hindiTitle: 'दोपहर का भोजन',
              foodNames: '2 Jowar Bhakris + 1 Katori Dal Tadka + 100g Raw Paneer Salad',
              calories: '625 kcal',
              protein: '30.6g Protein',
              qualityScore: 92,
              time: '01:30 PM',
            ),
            const SizedBox(height: 10),
            _buildMealTimelineCard(
              context,
              title: 'Evening Snack',
              hindiTitle: 'शाम का अल्पाहार',
              foodNames: '1 Bowl Roasted Makhana + Spiced Cinnamon Kadha',
              calories: '115 kcal',
              protein: '3.2g Protein',
              qualityScore: 80,
              time: '05:15 PM',
            ),

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
    required int qualityScore,
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
