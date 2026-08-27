import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radii.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../providers/onboarding_flow_provider.dart';

class FitnessGoalOption {
  final String id;
  final String title;
  final String regionalTitle;
  final String description;
  final IconData icon;
  final Color accentColor;

  const FitnessGoalOption({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  static const List<FitnessGoalOption> availableGoals = [
    FitnessGoalOption(
      id: 'fat_loss',
      title: 'Lose Fat & Tone Up',
      regionalTitle: 'चर्बी घटाएं एवं फिट रहें',
      description: 'Burn fat sustainably while retaining lean muscle with smart Indian meal swaps.',
      icon: Icons.local_fire_department_rounded,
      accentColor: AppColors.energyOrange,
    ),
    FitnessGoalOption(
      id: 'build_muscle',
      title: 'Build Muscle & Strength',
      regionalTitle: 'मांसपेशियां एवं ताकत बढ़ाएं',
      description: 'Progressive overload training paired with high-protein vegetarian/non-veg plans.',
      icon: Icons.fitness_center_rounded,
      accentColor: AppColors.karmaGreen,
    ),
    FitnessGoalOption(
      id: 'boost_energy',
      title: 'Boost Energy & Stamina',
      regionalTitle: 'ऊर्जा एवं सहनशक्ति में सुधार',
      description: 'Optimize circadian rhythm, daily steps, and metabolic energy balance.',
      icon: Icons.bolt_rounded,
      accentColor: AppColors.focusBlue,
    ),
    FitnessGoalOption(
      id: 'stress_recovery',
      title: 'Stress & Sleep Recovery',
      regionalTitle: 'तनाव प्रबंधन एवं गहरी नींद',
      description: 'Guided breathwork, sleep stage optimization, and somatic recovery tracking.',
      icon: Icons.nightlight_round,
      accentColor: AppColors.aiPurple,
    ),
    FitnessGoalOption(
      id: 'metabolic_health',
      title: 'Metabolic & Heart Health',
      regionalTitle: 'मधुमेह एवं हृदय स्वास्थ्य',
      description: 'Manage glucose spikes, lipid profiles, and maintain healthy blood pressure.',
      icon: Icons.favorite_rounded,
      accentColor: AppColors.alertRed,
    ),
    FitnessGoalOption(
      id: 'longevity',
      title: 'Longevity & Vitality',
      regionalTitle: 'दीर्घायु एवं सक्रिय जीवनशैली',
      description: 'Long-term biological age reduction and functional mobility preservation.',
      icon: Icons.eco_rounded,
      accentColor: AppColors.gold,
    ),
  ];

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  final Set<String> _selectedGoalIds = {};

  @override
  void initState() {
    super.initState();
    final currentGoals = ref.read(onboardingFlowProvider).selectedGoals;
    if (currentGoals.isNotEmpty) {
      _selectedGoalIds.addAll(currentGoals);
    } else {
      _selectedGoalIds.add('fat_loss'); // Default selection
    }
  }

  void _toggleGoal(String id) {
    setState(() {
      if (_selectedGoalIds.contains(id)) {
        if (_selectedGoalIds.length > 1) {
          _selectedGoalIds.remove(id);
        }
      } else {
        if (_selectedGoalIds.length < 3) {
          _selectedGoalIds.add(id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                const BilingualLabel(
                  primaryText: 'What is your primary goal?',
                  regionalText: 'आपका मुख्य स्वास्थ्य लक्ष्य क्या है?',
                  primaryStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select up to 3 goals. Your Health OS Brain will adapt your nutrition, workouts, and readiness accordingly.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Goals List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: GoalsScreen.availableGoals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final goal = GoalsScreen.availableGoals[index];
                    final isSelected = _selectedGoalIds.contains(goal.id);

                    return BentoCard(
                      hasGlow: isSelected,
                      glowColor: goal.accentColor,
                      backgroundColor: isSelected
                          ? AppColors.surfaceElevated
                          : AppColors.surface,
                      border: Border.all(
                        color: isSelected
                            ? goal.accentColor
                            : AppColors.glassBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      onTap: () => _toggleGoal(goal.id),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? goal.accentColor.withValues(alpha: 0.20)
                                  : AppColors.surfaceElevated,
                              borderRadius: AppRadii.radiusSm,
                              border: Border.all(
                                color: isSelected
                                    ? goal.accentColor
                                    : AppColors.glassBorder,
                              ),
                            ),
                            child: Icon(
                              goal.icon,
                              color: isSelected ? goal.accentColor : AppColors.textSecondary,
                              size: 22,
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
                                      child: BilingualLabel(
                                        primaryText: goal.title,
                                        regionalText: goal.regionalTitle,
                                        primaryStyle: AppTypography.titleMedium.copyWith(
                                          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected ? goal.accentColor : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected ? goal.accentColor : AppColors.glassBorder,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 14,
                                              color: AppColors.textInverse,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  goal.description,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
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
            gradient: _selectedGoalIds.isNotEmpty ? AppColors.primaryGradient : null,
            color: _selectedGoalIds.isEmpty ? AppColors.surfaceElevated : null,
            boxShadow: _selectedGoalIds.isNotEmpty
                ? [
                    BoxShadow(
                      color: AppColors.karmaGreen.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.radiusMd,
              ),
            ),
            onPressed: _selectedGoalIds.isNotEmpty
                ? () {
                    ref.read(onboardingFlowProvider.notifier).updateGoals(_selectedGoalIds.toList());
                    ref.read(onboardingFlowProvider.notifier).nextStep();
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: AppTypography.titleMedium.copyWith(
                    color: _selectedGoalIds.isNotEmpty ? AppColors.textInverse : AppColors.textMuted,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: _selectedGoalIds.isNotEmpty ? AppColors.textInverse : AppColors.textMuted,
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
}
