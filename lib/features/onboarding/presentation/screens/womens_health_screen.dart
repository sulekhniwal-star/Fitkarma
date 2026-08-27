import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radii.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/activity_rings.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../domain/womens_health_engine.dart';
import '../../providers/onboarding_flow_provider.dart';

class WomensHealthScreen extends ConsumerStatefulWidget {
  const WomensHealthScreen({super.key});

  @override
  ConsumerState<WomensHealthScreen> createState() => _WomensHealthScreenState();
}

class _WomensHealthScreenState extends ConsumerState<WomensHealthScreen> {
  int _currentCycleDay = 10;
  final int _cycleLengthDays = 28;
  LifeStageMode _selectedMode = LifeStageMode.regularCycle;
  bool _isPcos = false;

  Color _resolvePhaseColor(MenstrualPhase phase) {
    switch (phase) {
      case MenstrualPhase.menstrual:
        return AppColors.alertRed;
      case MenstrualPhase.follicular:
        return AppColors.karmaGreen;
      case MenstrualPhase.ovulatory:
        return AppColors.energyOrange;
      case MenstrualPhase.luteal:
        return AppColors.aiPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = WomensHealthEngine.evaluateProfile(
      cycleLengthDays: _cycleLengthDays,
      currentCycleDay: _currentCycleDay,
      mode: _selectedMode,
      isPcos: _isPcos,
    );

    final phaseColor = _resolvePhaseColor(profile.currentPhase);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                const BilingualLabel(
                  primaryText: "Women's Physiology Layer",
                  regionalText: 'महिला स्वास्थ्य एवं हार्मोन संतुलन',
                  primaryStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'FitKarma synchronizes your training intensity, calorie needs, and nutrition with your natural hormonal cycle.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 1. Life Stage Mode Selector
                const Text(
                  'SELECT MODE (मोड चुनें)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _buildModeChip(
                        mode: LifeStageMode.regularCycle,
                        label: 'Cycle Sync',
                        icon: Icons.calendar_month_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildModeChip(
                        mode: LifeStageMode.pcosCalibrator,
                        label: 'PCOS / PCOD',
                        icon: Icons.spa_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildModeChip(
                        mode: LifeStageMode.fertilityWindow,
                        label: 'Fertility',
                        icon: Icons.favorite_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildModeChip(
                        mode: LifeStageMode.menopauseCare,
                        label: 'Menopause',
                        icon: Icons.shield_moon_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // 2. Current Menstrual Phase Hero Bento Card
                BentoCard(
                  hasGlow: true,
                  glowColor: phaseColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: phaseColor.withValues(alpha: 0.15),
                              borderRadius: AppRadii.radiusSm,
                            ),
                            child: Text(
                              profile.currentPhase.dayRange,
                              style: TextStyle(color: phaseColor, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.currentPhase.name,
                            style: AppTypography.titleLarge.copyWith(
                              color: phaseColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            profile.currentPhase.regionalName,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Cycle Day: $_currentCycleDay of $_cycleLengthDays',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      ActivityRings(
                        size: 90,
                        rings: [
                          RingData(
                            progress: _currentCycleDay / _cycleLengthDays,
                            color: phaseColor,
                            strokeWidth: 8,
                          ),
                        ],
                        centerWidget: Text(
                          'Day $_currentCycleDay',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 3. Cycle Day Slider
                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const BilingualLabel(
                            primaryText: 'Approximate Cycle Day',
                            regionalText: 'माहवारी का वर्तमान दिन',
                          ),
                          Text(
                            'Day $_currentCycleDay',
                            style: AppTypography.titleMedium.copyWith(
                              color: phaseColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: phaseColor,
                          inactiveTrackColor: AppColors.surfaceElevated,
                          thumbColor: phaseColor,
                        ),
                        child: Slider(
                          value: _currentCycleDay.toDouble(),
                          min: 1.0,
                          max: _cycleLengthDays.toDouble(),
                          divisions: _cycleLengthDays - 1,
                          onChanged: (val) => setState(() => _currentCycleDay = val.round()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 4. Training Adaptation Guidance
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Phase-Specific Workout Guidance',
                        regionalText: 'हार्मोन-अनुकूल कसरत सलाह',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.trainingRecommendation,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 5. Nutrition & Hormonal Balance Guidance
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Nutrition & Hormone Support',
                        regionalText: 'पोषण एवं हार्मोन संतुलन',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.nutritionRecommendation,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      if (profile.calorieOffset != 0) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.aiPurple.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Text(
                            'Calorie Adjustment: +${profile.calorieOffset} kcal (Luteal Metabolic Shift)',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.aiPurple,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),

        // Confirm & Continue CTA
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
              ref.read(onboardingFlowProvider.notifier).updateWomensHealth(
                    isPcosAware: _isPcos || _selectedMode == LifeStageMode.pcosCalibrator,
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

  Widget _buildModeChip({
    required LifeStageMode mode,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedMode == mode;

    return BentoCard(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      backgroundColor: isSelected ? AppColors.surfaceElevated : AppColors.surface,
      border: Border.all(
        color: isSelected ? AppColors.aiPurple : AppColors.glassBorder,
        width: isSelected ? 1.5 : 1.0,
      ),
      onTap: () {
        setState(() {
          _selectedMode = mode;
          _isPcos = mode == LifeStageMode.pcosCalibrator;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: isSelected ? AppColors.aiPurple : AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
