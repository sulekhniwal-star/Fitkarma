import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../metabolism/services/metabolism_engine.dart';
import '../../domain/services/bmi_calculator.dart';

class DemographicsStep extends StatelessWidget {
  final int age;
  final Gender gender;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activityLevel;
  final ValueChanged<int> onAgeChanged;
  final ValueChanged<Gender> onGenderChanged;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<ActivityLevel> onActivityChanged;
  final VoidCallback onNext;

  const DemographicsStep({
    super.key,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    required this.onAgeChanged,
    required this.onGenderChanged,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.onActivityChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    const bmiCalculator = BMICalculator();
    final bmiResult = bmiCalculator.calculate(
      heightCm: heightCm,
      weightKg: weightKg,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BilingualLabel(
            english: 'Demographics & Body Metrics',
            hindi: 'शारीरिक विवरण और माप',
            primaryStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                // Live Asian-Indian BMI Badge Card
                BentoCard(
                  isGlowing: true,
                  glowColor: bmiResult.badgeColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'BMI ${bmiResult.bmi}',
                                  style: AppTypography.h2.copyWith(color: bmiResult.badgeColor),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: bmiResult.badgeColor.withAlpha(40),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    bmiResult.label,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: bmiResult.badgeColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bmiResult.healthRiskInsight,
                              style: AppTypography.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ideal Asian-Indian weight: ${bmiResult.idealWeightMinKg}–${bmiResult.idealWeightMaxKg} kg',
                              style: AppTypography.bilingualSub.copyWith(color: AppColors.primaryCyan),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Gender Selector
                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BilingualLabel(english: 'Gender', hindi: 'लिंग'),
                      const SizedBox(height: 12),
                      Row(
                        children: Gender.values.map((g) {
                          final isSelected = gender == g;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                label: Text(g.name.toUpperCase()),
                                selected: isSelected,
                                selectedColor: AppColors.primaryCyan,
                                labelStyle: TextStyle(
                                  color: isSelected ? AppColors.background : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                                onSelected: (_) => onGenderChanged(g),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Height & Weight Sliders
                BentoCard(
                  child: Column(
                    children: [
                      _buildSliderRow(
                        label: 'Height',
                        hindi: 'ऊंचाई',
                        valueText: '${heightCm.toInt()} cm',
                        value: heightCm,
                        min: 120.0,
                        max: 220.0,
                        onChanged: onHeightChanged,
                      ),
                      const Divider(height: 24),
                      _buildSliderRow(
                        label: 'Weight',
                        hindi: 'वज़न',
                        valueText: '${weightKg.toStringAsFixed(1)} kg',
                        value: weightKg,
                        min: 35.0,
                        max: 160.0,
                        onChanged: onWeightChanged,
                      ),
                      const Divider(height: 24),
                      _buildSliderRow(
                        label: 'Age',
                        hindi: 'उम्र',
                        valueText: '$age yrs',
                        value: age.toDouble(),
                        min: 14.0,
                        max: 90.0,
                        onChanged: (val) => onAgeChanged(val.toInt()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'Next: Dosha Assessment  •  आगे बढ़ें',
              style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required String hindi,
    required String valueText,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BilingualLabel(english: label, hindi: hindi),
            Text(valueText, style: AppTypography.h3.copyWith(color: AppColors.primaryCyan)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.primaryCyan,
          inactiveColor: AppColors.surfaceDark,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
