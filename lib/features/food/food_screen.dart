import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

class FoodScreen extends ConsumerStatefulWidget {
  const FoodScreen({super.key});

  @override
  ConsumerState<FoodScreen> createState() => _FoodScreenState();
}

class _WatchSectionState {
  bool isExpanded = true;
}

class _FoodScreenState extends ConsumerState<FoodScreen> {
  final Map<String, bool> _collapsedStates = {
    'Breakfast': true,
    'Lunch': true,
    'Dinner': true,
    'Snacks': true,
  };

  final TextEditingController _searchController = TextEditingController();
  String _selectedMealTypeForLogging = 'Breakfast';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(foodProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final cardBg = isDark ? AppColorsDark.bg1 : AppColorsLight.bg1;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsLight.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsLight.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final accentColor = isDark ? AppColorsDark.accent : AppColorsLight.accent;
    final successColor = isDark
        ? AppColorsDark.success
        : AppColorsLight.success;

    // Aggregate totals
    int totalKcal = 0;
    int totalProtein = 0;
    int totalCarbs = 0;
    int totalFat = 0;

    for (final item in state.loggedItems) {
      totalKcal += item.calories;
      totalProtein += item.protein;
      totalCarbs += item.carbs;
      totalFat += item.fat;
    }

    final double kcalProgress = (totalKcal / state.caloriesTarget).clamp(
      0.0,
      1.0,
    );
    final double proteinProgress = (totalProtein / state.proteinTarget).clamp(
      0.0,
      1.0,
    );
    final double carbsProgress = (totalCarbs / state.carbsTarget).clamp(
      0.0,
      1.0,
    );
    final double fatProgress = (totalFat / state.fatTarget).clamp(0.0, 1.0);

    // Protein alert calculation: 70% threshold of 110g is 77g
    final bool showProteinAlert = totalProtein < (state.proteinTarget * 0.70);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Nutrition',
          style: AppTypography.h3.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Macros Summary Card
            BentoCard(
              customBgColor: cardBg,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Calorie Ring Stack
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: kcalProgress,
                              strokeWidth: 10,
                              backgroundColor: Colors.white10,
                              color: primaryColor,
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$totalKcal',
                                    style: AppTypography.h3.copyWith(
                                      color: textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'kcal',
                                    style: AppTypography.labelMd.copyWith(
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Macros details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMacroProgress(
                              'Protein',
                              totalProtein,
                              state.proteinTarget,
                              proteinProgress,
                              showProteinAlert
                                  ? Colors.redAccent
                                  : successColor,
                              textPrimary,
                              textSecondary,
                            ),
                            const SizedBox(height: 10),
                            _buildMacroProgress(
                              'Carbs',
                              totalCarbs,
                              state.carbsTarget,
                              carbsProgress,
                              accentColor,
                              textPrimary,
                              textSecondary,
                            ),
                            const SizedBox(height: 10),
                            _buildMacroProgress(
                              'Fat',
                              totalFat,
                              state.fatTarget,
                              fatProgress,
                              Colors.orangeAccent,
                              textPrimary,
                              textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (showProteinAlert) ...[
                    const SizedBox(height: 16),
                    Container(
                      key: const Key('food_protein_alert_banner'),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Protein low — add paneer or eggs to your next meal',
                              style: AppTypography.bodySm.copyWith(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.bentoGap),

            // 2. Search & Log Bento Card
            BentoCard(
              customBgColor: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Log / Search Food',
                    style: AppTypography.bodyMd.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search TextField
                  TextField(
                    key: const Key('food_search_input'),
                    controller: _searchController,
                    style: TextStyle(color: textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search food (e.g. Oats, Egg, Chicken)',
                      hintStyle: TextStyle(color: textSecondary),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: textSecondary,
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (val) {
                      ref.read(foodProvider.notifier).searchFood(val);
                    },
                  ),
                  const SizedBox(height: 12),
                  // Meal target dropdown for new items
                  Row(
                    children: [
                      Text(
                        'Log to: ',
                        style: TextStyle(color: textSecondary, fontSize: 13),
                      ),
                      DropdownButton<String>(
                        key: const Key('food_meal_type_log_dropdown'),
                        dropdownColor: cardBg,
                        value: _selectedMealTypeForLogging,
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(
                            value: 'Breakfast',
                            child: Text('Breakfast'),
                          ),
                          DropdownMenuItem(
                            value: 'Lunch',
                            child: Text('Lunch'),
                          ),
                          DropdownMenuItem(
                            value: 'Dinner',
                            child: Text('Dinner'),
                          ),
                          DropdownMenuItem(
                            value: 'Snacks',
                            child: Text('Snacks'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedMealTypeForLogging = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (state.searchResults.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        final res = state.searchResults[index];
                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            key: Key('food_search_result_${res.name}'),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              res.name,
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${res.calories} kcal · P: ${res.protein}g · C: ${res.carbs}g',
                              style: TextStyle(color: textSecondary),
                            ),
                            trailing: Icon(
                              Icons.add_circle_outline_rounded,
                              color: successColor,
                            ),
                            onTap: () {
                              ref
                                  .read(foodProvider.notifier)
                                  .addFood(
                                    res.copyWith(
                                      mealType: _selectedMealTypeForLogging,
                                    ),
                                  );
                              _searchController.clear();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.bentoGap),

            // 3. Collapsible Meal Sections
            ...['Breakfast', 'Lunch', 'Dinner', 'Snacks'].map((mealType) {
              final sectionItems = state.loggedItems
                  .where((element) => element.mealType == mealType)
                  .toList();
              final isExpanded = _collapsedStates[mealType] ?? true;

              int sectionKcal = 0;
              int sectionProtein = 0;
              for (final item in sectionItems) {
                sectionKcal += item.calories;
                sectionProtein += item.protein;
              }

              // Meal Quality score dimensions calculated locally
              // Glycemic load: estimated (lower is better)
              // Readiness impact: higher protein = positive recovery
              final bool alignsGoal = sectionProtein > 15;
              final bool supportsRecovery = sectionProtein > 20;

              return Container(
                key: Key('food_meal_section_$mealType'),
                margin: const EdgeInsets.only(bottom: AppSpacing.bentoGap),
                child: BentoCard(
                  customBgColor: cardBg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      InkWell(
                        onTap: () {
                          setState(() {
                            _collapsedStates[mealType] = !isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _getMealEmoji(mealType),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  mealType,
                                  style: AppTypography.h3.copyWith(
                                    color: textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '$sectionKcal kcal',
                                  style: AppTypography.bodyLg.copyWith(
                                    color: textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isExpanded
                                      ? Icons.expand_more_rounded
                                      : Icons.chevron_right_rounded,
                                  color: textSecondary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 12),
                        const Divider(color: Colors.white10),
                        if (sectionItems.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'No food logged yet.',
                              style: TextStyle(
                                color: textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        else ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sectionItems.length,
                            itemBuilder: (context, index) {
                              final item = sectionItems[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            color: textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'P: ${item.protein}g · C: ${item.carbs}g · F: ${item.fat}g',
                                          style: TextStyle(
                                            color: textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${item.calories} kcal',
                                          style: TextStyle(
                                            color: textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          key: Key(
                                            'food_remove_item_${item.id}',
                                          ),
                                          icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.redAccent,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(foodProvider.notifier)
                                                .removeFood(item.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 8),
                          // Local calculated Meal Quality scores
                          Text(
                            'Meal Quality Score (5 Dimensions)',
                            style: AppTypography.bodySm.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildQualityStat(
                            'Protein Score',
                            sectionProtein > 10 ? 'High' : 'Low',
                            sectionProtein > 10
                                ? successColor
                                : Colors.orangeAccent,
                          ),
                          _buildQualityStat(
                            'Readiness Impact',
                            supportsRecovery
                                ? 'This meal will support recovery (+2% readiness)'
                                : 'Moderate glycemic impact',
                            supportsRecovery ? successColor : textSecondary,
                          ),
                          _buildQualityStat(
                            'Goal Impact',
                            alignsGoal
                                ? 'This meal aligns with your fat-loss goal ✓'
                                : 'Matches baseline target',
                            alignsGoal ? successColor : textSecondary,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.bentoGap),

            // 4. Focus Card
            BentoCard(
              customBgColor: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, color: accentColor),
                      const SizedBox(width: 8),
                      Text(
                        'Nutrition Focus Recommendation',
                        style: AppTypography.bodyMd.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Prioritize high-fiber carbs (oats, brown rice) and keep protein intake timed within 2 hours post-workout to support circadian rhythm and muscle synthesis.',
                    style: AppTypography.bodySm.copyWith(color: textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroProgress(
    String label,
    int val,
    int target,
    double progress,
    Color barColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              '${val}g / ${target}g',
              style: TextStyle(color: textSecondary, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white10,
            color: barColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQualityStat(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMealEmoji(String mealType) {
    return switch (mealType) {
      'Breakfast' => '🌅',
      'Lunch' => '☀️',
      'Dinner' => '🌙',
      'Snacks' => '🍎',
      _ => '🍔',
    };
  }
}
