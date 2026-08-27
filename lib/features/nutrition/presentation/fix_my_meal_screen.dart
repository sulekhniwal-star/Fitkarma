import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../data/fix_my_meal_templates.dart';
import '../domain/nutrition_models.dart';
import '../providers/nutrition_provider.dart';

class FixMyMealScreen extends ConsumerStatefulWidget {
  final MealPhase phase;

  const FixMyMealScreen({
    super.key,
    this.phase = MealPhase.lunch,
  });

  @override
  ConsumerState<FixMyMealScreen> createState() => _FixMyMealScreenState();
}

class _FixMyMealScreenState extends ConsumerState<FixMyMealScreen> {
  int _selectedTemplateIndex = 0;
  final Set<int> _appliedSuggestions = {};

  @override
  Widget build(BuildContext context) {
    final template = FixMyMealTemplates.preconfiguredTemplates[_selectedTemplateIndex];

    // Compute adjusted macros if suggestions applied
    int adjustedCalories = template.totalCalories;
    double adjustedProtein = template.totalProteinGrams;
    if (_appliedSuggestions.contains(0)) {
      adjustedProtein += 18.0;
    }
    if (_appliedSuggestions.contains(2)) {
      adjustedCalories -= 90;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Fix My Meal AI Analysis',
          regionalText: 'एआई फोटो भोजन विश्लेषण एवं सुधार',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Template / Photo Selector Bar
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: FixMyMealTemplates.preconfiguredTemplates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = FixMyMealTemplates.preconfiguredTemplates[index];
                    final isSelected = _selectedTemplateIndex == index;

                    return ChoiceChip(
                      selected: isSelected,
                      selectedColor: AppColors.focusBlue.withValues(alpha: 0.2),
                      backgroundColor: AppColors.surfaceElevated,
                      side: BorderSide(color: isSelected ? AppColors.focusBlue : AppColors.glassBorder),
                      label: Text(
                        item.mealName.split(' ')[0],
                        style: TextStyle(
                          color: isSelected ? AppColors.focusBlue : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      onSelected: (_) => setState(() {
                        _selectedTemplateIndex = index;
                        _appliedSuggestions.clear();
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Hero Meal Analysis Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.aiPurple,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: template.mealName,
                          regionalText: 'स्वचालित एआई पहचान',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.aiPurple.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: AppColors.aiPurple.withValues(alpha: 0.4)),
                          ),
                          child: const Text(
                            'AI VISION PARSED',
                            style: TextStyle(color: AppColors.aiPurple, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Estimated Calories',
                          value: '$adjustedCalories',
                          unit: 'kcal',
                          isHero: true,
                          accentColor: AppColors.karmaGreen,
                        ),
                        GlowingMetric(
                          label: 'Protein',
                          value: '${adjustedProtein.round()}g',
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Carbs',
                          value: '${template.totalCarbsGrams.round()}g',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Fats',
                          value: '${template.totalFatsGrams.round()}g',
                          accentColor: AppColors.aiPurple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Detected Food Components List
              const Text(
                'DETECTED FOOD ITEMS (पहचाने गए खाद्य पदार्थ)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              BentoCard(
                child: Column(
                  children: template.detectedFoods.map((f) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f.name, style: AppTypography.titleSmall.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                              Text('${f.regionalName} • ${f.estimatedPortion}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                          Text(
                            '${f.calories} kcal • ${f.proteinGrams}g P',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. "Fix My Meal" AI Optimization Suggestions
              const Text(
                '✨ "FIX MY MEAL" CALIBRATIONS (एआई भोजन सुधार)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...List.generate(template.fixMyMealSuggestions.length, (index) {
                final sug = template.fixMyMealSuggestions[index];
                final isApplied = _appliedSuggestions.contains(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    hasGlow: isApplied,
                    glowColor: AppColors.karmaGreen,
                    backgroundColor: isApplied ? AppColors.surfaceElevated : AppColors.surface,
                    border: Border.all(
                      color: isApplied ? AppColors.karmaGreen : AppColors.glassBorder,
                    ),
                    onTap: () {
                      setState(() {
                        if (isApplied) {
                          _appliedSuggestions.remove(index);
                        } else {
                          _appliedSuggestions.add(index);
                        }
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (isApplied ? AppColors.karmaGreen : AppColors.gold).withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Icon(
                            isApplied ? Icons.check_circle_rounded : Icons.tune_rounded,
                            color: isApplied ? AppColors.karmaGreen : AppColors.gold,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      sug.title,
                                      style: AppTypography.titleSmall.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isApplied ? AppColors.karmaGreen : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.focusBlue.withValues(alpha: 0.15),
                                      borderRadius: AppRadii.radiusSm,
                                    ),
                                    child: Text(
                                      sug.macroImpact,
                                      style: const TextStyle(color: AppColors.focusBlue, fontSize: 10, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(sug.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.25)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.lg),

              // 5. Log Confirmed Meal to Daily Plan Button
              Container(
                width: double.infinity,
                height: 52,
                decoration: const BoxDecoration(
                  borderRadius: AppRadii.radiusMd,
                  gradient: AppColors.primaryGradient,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
                  ),
                  onPressed: () {
                    // Log all detected items to the daily plan
                    for (final item in template.detectedFoods) {
                      ref.read(nutritionProvider.notifier).addMeal(item.toFoodItem(), widget.phase, 1.0);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Log Meal to Daily Plan (+${template.detectedFoods.length} items)',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
