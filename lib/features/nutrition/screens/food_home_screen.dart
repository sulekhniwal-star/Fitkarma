import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/nutrition_engine.dart';
import '../models/indian_food_item.dart';
import '../providers/nutrition_provider.dart';

/// §P5-A Food Screen Home
/// Route: /food
class FoodHomeScreen extends ConsumerWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutritionProvider);
    final engine = const NutritionEngine();

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Smart Indian Nutrition', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Today's Summary Card ──────────────────────────────────────
            _TodayNutritionSummaryCard(state: state, engine: engine),
            const SizedBox(height: AppSpacing.lg),

            // ── 2. Rule-Based Protein Deficit Alert Banner ───────────────────
            if (state.isProteinDeficit) ...[
              _ProteinDeficitAlertCard(alertText: engine.generateProteinAlertText()),
              const SizedBox(height: AppSpacing.lg),
            ],

            // ── 3. Collapsible Meal Sections ─────────────────────────────────
            for (final sectionType in MealType.values)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _CollapsibleMealSectionCard(
                  type: sectionType,
                  entries: state.getMealsForSection(sectionType),
                  isExpanded: state.sectionExpanded[sectionType] ?? true,
                  onToggle: () => ref.read(nutritionProvider.notifier).toggleSection(sectionType),
                  onAddFood: () => _showAddFoodModal(context, ref, sectionType),
                ),
              ),

            const SizedBox(height: AppSpacing.sm),

            // ── 4. DIP Nutrition Focus Insight Card ──────────────────────────
            if (state.dipNutritionFocus != null)
              _DipNutritionFocusInsightCard(focusMessage: state.dipNutritionFocus!),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showAddFoodModal(BuildContext context, WidgetRef ref, MealType sectionType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.6,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Food to ${sectionType.displayName}', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.builder(
                  itemCount: SeededIndianFoodDatabase.items.length,
                  itemBuilder: (context, idx) {
                    final item = SeededIndianFoodDatabase.items[idx];
                    return ListTile(
                      title: Text(item.name, style: AppTypography.labelLg),
                      subtitle: Text(
                        '${item.calories} kcal · P: ${item.proteinGrams}g · C: ${item.carbsGrams}g · F: ${item.fatGrams}g',
                        style: AppTypography.bodySm,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: AppColors.primary),
                        onPressed: () {
                          ref.read(nutritionProvider.notifier).logMeal(
                                type: sectionType,
                                foodItem: item,
                              );
                          Navigator.pop(ctx);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Today's Summary GlassCard ─────────────────────────────────────────────────

class _TodayNutritionSummaryCard extends StatelessWidget {
  final NutritionState state;
  final NutritionEngine engine;

  const _TodayNutritionSummaryCard({required this.state, required this.engine});

  @override
  Widget build(BuildContext context) {
    final calorieRatio = (state.totalCalories / state.targetCalories).clamp(0.0, 1.0);
    final isProteinLow = state.isProteinDeficit;
    final proteinColor = isProteinLow ? AppColors.error : AppColors.success;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Nutrition Summary', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              // Calorie Progress Ring / Value
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: calorieRatio,
                      strokeWidth: 8,
                      backgroundColor: AppColors.surface2,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${state.totalCalories.round()}', style: AppTypography.h3),
                        Text('/${state.targetCalories.round()} kcal', style: AppTypography.bodySm.copyWith(fontSize: 9)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),

              // Macro Progress Bars
              Expanded(
                child: Column(
                  children: [
                    _MacroProgressBar(
                      label: 'Protein',
                      valueGrams: state.totalProtein,
                      targetGrams: state.targetProtein,
                      barColor: proteinColor,
                      isAlert: isProteinLow,
                    ),
                    const SizedBox(height: 8),
                    _MacroProgressBar(
                      label: 'Carbs',
                      valueGrams: state.totalCarbs,
                      targetGrams: state.targetCarbs,
                      barColor: AppColors.teal,
                    ),
                    const SizedBox(height: 8),
                    _MacroProgressBar(
                      label: 'Fat',
                      valueGrams: state.totalFat,
                      targetGrams: state.targetFat,
                      barColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroProgressBar extends StatelessWidget {
  final String label;
  final double valueGrams;
  final double targetGrams;
  final Color barColor;
  final bool isAlert;

  const _MacroProgressBar({
    required this.label,
    required this.valueGrams,
    required this.targetGrams,
    required this.barColor,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (valueGrams / targetGrams).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: ${valueGrams.round()}g / ${targetGrams.round()}g',
              style: AppTypography.bodySm.copyWith(
                color: isAlert ? AppColors.error : AppColors.textPrimary,
                fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isAlert)
              Text('LOW', style: AppTypography.bodySm.copyWith(color: AppColors.error, fontSize: 9, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 5,
            backgroundColor: barColor.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }
}

// ── Rule-Based Protein Deficit Alert Card ─────────────────────────────────────

class _ProteinDeficitAlertCard extends StatelessWidget {
  final String alertText;
  const _ProteinDeficitAlertCard({required this.alertText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              alertText,
              style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Collapsible Meal Section Card ─────────────────────────────────────────────

class _CollapsibleMealSectionCard extends StatelessWidget {
  final MealType type;
  final List<MealEntry> entries;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAddFood;

  const _CollapsibleMealSectionCard({
    required this.type,
    required this.entries,
    required this.isExpanded,
    required this.onToggle,
    required this.onAddFood,
  });

  @override
  Widget build(BuildContext context) {
    double sectionCals = 0.0;
    for (final e in entries) {
      sectionCals += e.totalCalories;
    }

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Section Header (Collapsible Toggle)
          InkWell(
            onTap: onToggle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(type.displayName, style: AppTypography.h3),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${sectionCals.round()} kcal',
                        style: AppTypography.bodySm.copyWith(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),

          if (isExpanded) ...[
            const SizedBox(height: AppSpacing.md),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('No food logged yet for this meal.', style: AppTypography.bodySm),
              )
            else
              for (final entry in entries)
                _MealEntryTile(entry: entry),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onAddFood,
                icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                label: Text('Add Food', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MealEntryTile extends StatelessWidget {
  final MealEntry entry;

  const _MealEntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final engine = const NutritionEngine();
    final quality = engine.calculateMealQuality(entry.foodItem);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${entry.foodItem.name} (${entry.quantityServings}x)',
                style: AppTypography.labelLg,
              ),
              Text(
                '${entry.totalCalories.round()} kcal',
                style: AppTypography.labelMd.copyWith(color: AppColors.teal),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Protein: ${entry.totalProtein.round()}g · Carbs: ${entry.totalCarbs.round()}g · Fat: ${entry.totalFat.round()}g',
            style: AppTypography.bodySm.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 6),

          // Meal Quality Breakdown Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Quality Score: ${quality.overallScore}/100',
                  style: AppTypography.bodySm.copyWith(color: AppColors.secondary, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  quality.readinessImpact,
                  style: AppTypography.bodySm.copyWith(fontSize: 9, color: AppColors.success),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            quality.goalImpact,
            style: AppTypography.bodySm.copyWith(fontSize: 9, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ── DIP Nutrition Focus Insight Card ──────────────────────────────────────────

class _DipNutritionFocusInsightCard extends StatelessWidget {
  final String focusMessage;

  const _DipNutritionFocusInsightCard({required this.focusMessage});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Intelligence Insight', style: AppTypography.labelMd.copyWith(color: AppColors.accent)),
                const SizedBox(height: 2),
                Text(
                  focusMessage,
                  style: AppTypography.bodyMd.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
