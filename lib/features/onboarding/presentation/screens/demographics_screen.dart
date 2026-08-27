import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radii.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../../../shared/widgets/glowing_metric.dart';
import '../../../metabolism/domain/adaptive_metabolism_engine.dart';
import '../../providers/onboarding_flow_provider.dart';

class DemographicsScreen extends ConsumerStatefulWidget {
  const DemographicsScreen({super.key});

  @override
  ConsumerState<DemographicsScreen> createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends ConsumerState<DemographicsScreen> {
  late BiologicalSex _selectedSex;
  late double _weightKg;
  late double _heightCm;
  late int _age;
  late NutritionGoal _goal;

  @override
  void initState() {
    super.initState();
    final currentState = ref.read(onboardingFlowProvider);
    _selectedSex = currentState.sex;
    _weightKg = currentState.weightKg;
    _heightCm = currentState.heightCm;
    _age = currentState.age;
    _goal = currentState.nutritionGoal;
  }

  // Real-time Asian-Indian BMI Calculation
  double get _bmi {
    final heightM = _heightCm / 100.0;
    if (heightM <= 0) return 22.0;
    return _weightKg / (heightM * heightM);
  }

  String get _bmiCategory {
    final val = _bmi;
    if (val < 18.5) return 'Underweight (कम वजन)';
    if (val < 23.0) return 'Normal / Optimal (संतुलित)';
    if (val < 25.0) return 'Overweight (अधिक वजन)';
    return 'Obese (मोटापा)';
  }

  Color get _bmiColor {
    final val = _bmi;
    if (val < 18.5) return AppColors.focusBlue;
    if (val < 23.0) return AppColors.karmaGreen;
    if (val < 25.0) return AppColors.energyOrange;
    return AppColors.alertRed;
  }

  @override
  Widget build(BuildContext context) {
    // Real-time metabolic calculation preview
    final metaProfile = AdaptiveMetabolismEngine.computeMetabolism(
      weightKg: _weightKg,
      heightCm: _heightCm,
      age: _age,
      sex: _selectedSex,
      goal: _goal,
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                const BilingualLabel(
                  primaryText: 'Your Demographics',
                  regionalText: 'आपकी शारीरिक जानकारी',
                  primaryStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'FitKarma uses Asian-Indian BMI and metabolic algorithms to calibrate your daily energy expenditure.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 1. Biological Sex Selector
                Row(
                  children: [
                    Expanded(
                      child: _buildSexCard(
                        sex: BiologicalSex.male,
                        label: 'Male',
                        regionalLabel: 'पुरुष',
                        icon: Icons.male_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildSexCard(
                        sex: BiologicalSex.female,
                        label: 'Female',
                        regionalLabel: 'महिला',
                        icon: Icons.female_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // 2. Live BMI Gauge Bento Card
                BentoCard(
                  hasGlow: true,
                  glowColor: _bmiColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BilingualLabel(
                            primaryText: 'Asian-Indian BMI',
                            regionalText: 'बॉडी मास इंडेक्स',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _bmiCategory,
                            style: AppTypography.bodySmall.copyWith(
                              color: _bmiColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      GlowingMetric(
                        label: 'BMI Score',
                        value: _bmi.toStringAsFixed(1),
                        accentColor: _bmiColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 3. Weight Slider
                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const BilingualLabel(
                            primaryText: 'Current Weight',
                            regionalText: 'वर्तमान वजन',
                          ),
                          Text(
                            '${_weightKg.toStringAsFixed(1)} kg',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.karmaGreen,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.karmaGreen,
                          inactiveTrackColor: AppColors.surfaceElevated,
                          thumbColor: AppColors.karmaGreen,
                          overlayColor: AppColors.karmaGreen.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: _weightKg,
                          min: 40.0,
                          max: 150.0,
                          divisions: 220,
                          onChanged: (val) => setState(() => _weightKg = val),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 4. Height Slider
                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const BilingualLabel(
                            primaryText: 'Height',
                            regionalText: 'कद (ऊंचाई)',
                          ),
                          Text(
                            '${_heightCm.round()} cm (${(_heightCm / 30.48).toStringAsFixed(1)} ft)',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.focusBlue,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.focusBlue,
                          inactiveTrackColor: AppColors.surfaceElevated,
                          thumbColor: AppColors.focusBlue,
                          overlayColor: AppColors.focusBlue.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: _heightCm,
                          min: 130.0,
                          max: 210.0,
                          divisions: 80,
                          onChanged: (val) => setState(() => _heightCm = val),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 5. Age & Goal Selector
                Row(
                  children: [
                    // Age Stepper Card
                    Expanded(
                      child: BentoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AGE (उम्र)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.textSecondary),
                                  onPressed: () {
                                    if (_age > 16) setState(() => _age--);
                                  },
                                ),
                                Text(
                                  '$_age yrs',
                                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.add_circle_outline, color: AppColors.karmaGreen),
                                  onPressed: () {
                                    if (_age < 85) setState(() => _age++);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Goal Dropdown Card
                    Expanded(
                      child: BentoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('GOAL (लक्ष्य)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            const SizedBox(height: 6),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<NutritionGoal>(
                                value: _goal,
                                isDense: true,
                                dropdownColor: AppColors.surfaceElevated,
                                icon: const Icon(Icons.arrow_drop_down, color: AppColors.karmaGreen),
                                items: const [
                                  DropdownMenuItem(
                                    value: NutritionGoal.fatLoss,
                                    child: Text('Fat Loss', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                                  ),
                                  DropdownMenuItem(
                                    value: NutritionGoal.maintenance,
                                    child: Text('Maintain', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                                  ),
                                  DropdownMenuItem(
                                    value: NutritionGoal.muscleGain,
                                    child: Text('Build Muscle', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _goal = val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // 6. Live Calibrated Targets Preview Card
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Calibrated Targets Preview',
                        regionalText: 'अनुमानित दैनिक लक्ष्य',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GlowingMetric(
                            label: 'Base TDEE',
                            value: '${metaProfile.staticTdee.round()}',
                            unit: 'kcal',
                            accentColor: AppColors.focusBlue,
                          ),
                          GlowingMetric(
                            label: 'Target Calories',
                            value: '${metaProfile.targetCalories}',
                            unit: 'kcal',
                            accentColor: AppColors.karmaGreen,
                          ),
                          GlowingMetric(
                            label: 'Daily Protein',
                            value: '${metaProfile.targetProteinGrams}',
                            unit: 'g',
                            accentColor: AppColors.energyOrange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),

        // Continue Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: AppRadii.radiusMd,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.karmaGreen.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.radiusMd,
              ),
            ),
            onPressed: () {
              ref.read(onboardingFlowProvider.notifier).updateDemographics(
                    weightKg: _weightKg,
                    heightCm: _heightCm,
                    age: _age,
                    sex: _selectedSex,
                    goal: _goal,
                  );
              ref.read(onboardingFlowProvider.notifier).nextStep();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textInverse,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  Widget _buildSexCard({
    required BiologicalSex sex,
    required String label,
    required String regionalLabel,
    required IconData icon,
  }) {
    final isSelected = _selectedSex == sex;

    return BentoCard(
      hasGlow: isSelected,
      glowColor: AppColors.focusBlue,
      backgroundColor: isSelected ? AppColors.surfaceElevated : AppColors.surface,
      border: Border.all(
        color: isSelected ? AppColors.focusBlue : AppColors.glassBorder,
        width: isSelected ? 1.5 : 1.0,
      ),
      onTap: () => setState(() => _selectedSex = sex),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? AppColors.focusBlue : AppColors.textSecondary, size: 24),
          const SizedBox(width: 8),
          BilingualLabel(
            primaryText: label,
            regionalText: regionalLabel,
            primaryStyle: AppTypography.titleMedium.copyWith(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
