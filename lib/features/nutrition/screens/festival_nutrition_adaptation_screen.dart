import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/festival_nutrition_adapter.dart';

/// §P5-K Smart Festival Nutrition Adaptation Screen
/// Route: /food/festival-adaptation
class FestivalNutritionAdaptationScreen extends StatefulWidget {
  const FestivalNutritionAdaptationScreen({super.key});

  @override
  State<FestivalNutritionAdaptationScreen> createState() =>
      _FestivalNutritionAdaptationScreenState();
}

class _FestivalNutritionAdaptationScreenState
    extends State<FestivalNutritionAdaptationScreen> {
  final _adapter = const FestivalNutritionAdapter();
  FestivalType _selectedFestival = FestivalType.diwali;
  FestivalDayRelative _selectedPhase = FestivalDayRelative.festivalDay;

  final double _baseCalories = 2000.0;
  final double _baseProtein = 120.0;
  final double _baseCarbs = 220.0;
  final double _baseWater = 2.5;

  @override
  Widget build(BuildContext context) {
    final adapted = _adapter.adjustTargets(
      baseCalories: _baseCalories,
      baseProteinG: _baseProtein,
      baseCarbsG: _baseCarbs,
      baseWaterLers: _baseWater,
      festivalType: _selectedFestival,
      relativeDay: _selectedPhase,
    );

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Festival Nutrition Adaptation', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phase Selection GlassCard
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Festival Protocol', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Selected Festival', style: AppTypography.bodySm),
                      DropdownButton<FestivalType>(
                        value: _selectedFestival,
                        dropdownColor: AppColors.surface1,
                        items: FestivalType.values
                            .map((f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(f.name.toUpperCase(),
                                      style: AppTypography.labelLg
                                          .copyWith(color: AppColors.primary)),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedFestival = val!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Festival Timeline Phase:', style: AppTypography.bodySm),
                  const SizedBox(height: 6),
                  SegmentedButton<FestivalDayRelative>(
                    segments: const [
                      ButtonSegment(
                          value: FestivalDayRelative.pre3Days,
                          label: Text('Pre (3D)')),
                      ButtonSegment(
                          value: FestivalDayRelative.festivalDay,
                          label: Text('Festival')),
                      ButtonSegment(
                          value: FestivalDayRelative.post1Day,
                          label: Text('Post (1D)')),
                    ],
                    selected: {_selectedPhase},
                    onSelectionChanged: (set) =>
                        setState(() => _selectedPhase = set.first),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Adapted Targets Display Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Adapted Nutrition Targets',
                          style: AppTypography.h3),
                      Icon(Icons.celebration,
                          color: AppColors.accent, size: 22),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TargetStat(
                        label: 'Calories',
                        value: '${adapted.calories.round()} kcal',
                        diff: adapted.calories - _baseCalories,
                      ),
                      _TargetStat(
                        label: 'Protein',
                        value: '${adapted.proteinG.round()} g',
                        diff: adapted.proteinG - _baseProtein,
                      ),
                      _TargetStat(
                        label: 'Water',
                        value: '${adapted.waterLers.toStringAsFixed(1)} L',
                        diff: adapted.waterLers - _baseWater,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Satiety & Protocol Alert:',
                            style: AppTypography.labelMd
                                .copyWith(color: AppColors.accent)),
                        const SizedBox(height: 4),
                        Text(adapted.alertMessage,
                            style: AppTypography.bodySm.copyWith(height: 1.3)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.directions_walk,
                          color: AppColors.teal, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Cardio Protocol: ${adapted.recoveryWalkRecommendation}',
                          style: AppTypography.bodySm
                              .copyWith(color: AppColors.teal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _TargetStat extends StatelessWidget {
  final String label;
  final String value;
  final double diff;

  const _TargetStat(
      {required this.label, required this.value, required this.diff});

  @override
  Widget build(BuildContext context) {
    final diffStr = diff > 0 ? '+${diff.round()}' : '${diff.round()}';
    final diffColor = diff > 0
        ? AppColors.accent
        : (diff < 0 ? AppColors.teal : AppColors.textMuted);

    return Column(
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.h3),
        if (diff != 0)
          Text(diffStr,
              style: AppTypography.labelMd
                  .copyWith(color: diffColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
