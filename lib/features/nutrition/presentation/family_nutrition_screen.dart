import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/family_nutrition_engine.dart';

class FamilyNutritionScreen extends ConsumerStatefulWidget {
  const FamilyNutritionScreen({super.key});

  @override
  ConsumerState<FamilyNutritionScreen> createState() =>
      _FamilyNutritionScreenState();
}

class _FamilyNutritionScreenState extends ConsumerState<FamilyNutritionScreen> {
  final List<FamilyMemberProfile> _members =
      FamilyNutritionEngine.getDefaultIndianFamily();

  final List<MasterPotDish> _presetMasterDishes = const [
    MasterPotDish(
      dishName: 'Dal Tadka Handi',
      regionalName: 'दाल तड़का हांडी (४ कटोरी)',
      totalYieldServings: 4,
      totalPotCalories: 760,
      totalPotProtein: 44.0,
      totalPotCarbs: 104.0,
      totalPotFats: 18.0,
      totalPotFiber: 24.0,
    ),
    MasterPotDish(
      dishName: 'Matar Paneer Kadhai',
      regionalName: 'मटर पनीर कढ़ाई (४ सर्विंग)',
      totalYieldServings: 4,
      totalPotCalories: 1120,
      totalPotProtein: 56.0,
      totalPotCarbs: 68.0,
      totalPotFats: 64.0,
      totalPotFiber: 18.0,
    ),
    MasterPotDish(
      dishName: 'Rajma Masala Pot',
      regionalName: 'राजमा मसाला पॉट (४ कटोरी)',
      totalYieldServings: 4,
      totalPotCalories: 940,
      totalPotProtein: 52.0,
      totalPotCarbs: 140.0,
      totalPotFats: 16.0,
      totalPotFiber: 36.0,
    ),
  ];

  late MasterPotDish _selectedDish;
  late Map<String, double> _servingsMap;

  @override
  void initState() {
    super.initState();
    _selectedDish = _presetMasterDishes.first;
    _servingsMap = {
      'member_1': 1.5, // Self takes 1.5 katori
      'member_2': 1.0, // Spouse takes 1 katori
      'member_3': 1.0, // Parent takes 1 katori
      'member_4': 0.5, // Child takes 0.5 katori
    };
  }

  @override
  Widget build(BuildContext context) {
    final report = FamilyNutritionEngine.decomposeMasterPotMeal(
      dish: _selectedDish,
      familyMembers: _members,
      servingsPerMember: _servingsMap,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Family Nutrition Sync',
          regionalText: 'पारिवारिक भोजन एवं पोषण समक्रमण',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Master Pot Dish Selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _presetMasterDishes.map((dish) {
                    final isSelected = dish.dishName == _selectedDish.dishName;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(dish.dishName),
                        selected: isSelected,
                        selectedColor:
                            AppColors.karmaGreen.withValues(alpha: 0.2),
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.karmaGreen
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.karmaGreen
                              : AppColors.glassBorder,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedDish = dish);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Master Pot Overview Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.focusBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: 'Master Cooked Pot',
                          regionalText: _selectedDish.regionalName,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.focusBlue.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(
                                color:
                                    AppColors.focusBlue.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            '${_selectedDish.totalYieldServings} KATORI YIELD',
                            style: const TextStyle(
                              color: AppColors.focusBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Total Pot Energy',
                          value: '${_selectedDish.totalPotCalories}',
                          unit: 'kcal',
                          isHero: true,
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Total Protein',
                          value: '${_selectedDish.totalPotProtein.round()}g',
                          unit: 'protein',
                          accentColor: AppColors.karmaGreen,
                        ),
                        GlowingMetric(
                          label: 'Pot Remaining',
                          value: '${report.remainingServingsInPot}',
                          unit: 'katoris',
                          accentColor: AppColors.energyOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.batchSynergySummary,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Member Portions & Decomposed Macros
              const Text(
                'INDIVIDUAL SERVING ALLOCATIONS (व्यक्तिगत हिस्सा एवं पोषण)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.memberAllocations.map((alloc) {
                final member = alloc.member;
                final servings = _servingsMap[member.id] ?? 1.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  member.role.defaultGoal,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.focusBlue,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            // Serving Counter Adjuster
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: AppColors.textMuted,
                                      size: 22),
                                  onPressed: servings > 0.5
                                      ? () {
                                          setState(() {
                                            _servingsMap[member.id] =
                                                (servings - 0.5);
                                          });
                                        }
                                      : null,
                                ),
                                Text(
                                  '${servings.toStringAsFixed(1)} katori',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.karmaGreen,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: AppColors.karmaGreen,
                                      size: 22),
                                  onPressed: () {
                                    setState(() {
                                      _servingsMap[member.id] =
                                          (servings + 0.5);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('${alloc.allocatedCalories} kcal',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      color: AppColors.textPrimary)),
                              const Text('•',
                                  style: TextStyle(color: AppColors.textMuted)),
                              Text('${alloc.allocatedProtein}g Protein',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      color: AppColors.karmaGreen)),
                              const Text('•',
                                  style: TextStyle(color: AppColors.textMuted)),
                              Text('${alloc.allocatedCarbs}g Carbs',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                              const Text('•',
                                  style: TextStyle(color: AppColors.textMuted)),
                              Text('${alloc.allocatedFats}g Fats',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.tips_and_updates_outlined,
                                color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                alloc.personalizedPlateTip,
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
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
