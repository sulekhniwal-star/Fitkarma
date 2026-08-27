import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radii.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../domain/workout_blueprint.dart';
import '../../providers/onboarding_flow_provider.dart';

class ProgramBlueprintSelectionScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const ProgramBlueprintSelectionScreen({
    super.key,
    this.onComplete,
  });

  @override
  ConsumerState<ProgramBlueprintSelectionScreen> createState() => _ProgramBlueprintSelectionScreenState();
}

class _ProgramBlueprintSelectionScreenState extends ConsumerState<ProgramBlueprintSelectionScreen> {
  late String _selectedBlueprintId;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingFlowProvider);
    final userGoal = onboardingState.selectedGoals.isNotEmpty ? onboardingState.selectedGoals.first : 'fat_loss';

    // Auto-match recommendation based on primary goal
    final recommended = WorkoutBlueprint.catalog.firstWhere(
      (b) => b.targetGoal == userGoal,
      orElse: () => WorkoutBlueprint.catalog.first,
    );

    _selectedBlueprintId = recommended.id;
  }

  void _selectBlueprint(String id) {
    setState(() => _selectedBlueprintId = id);
    ref.read(onboardingFlowProvider.notifier).selectBlueprint(id);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingFlowProvider);
    final userPrimaryGoal = onboardingState.selectedGoals.isNotEmpty ? onboardingState.selectedGoals.first : 'fat_loss';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                const BilingualLabel(
                  primaryText: 'Select Your Workout Blueprint',
                  regionalText: 'अपना कसरत कार्यक्रम चुनें',
                  primaryStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your blueprint sets your initial progressive overload trajectory and scheduled training days.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Blueprint Cards List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: WorkoutBlueprint.catalog.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final blueprint = WorkoutBlueprint.catalog[index];
                    final isSelected = _selectedBlueprintId == blueprint.id;
                    final isRecommended = blueprint.targetGoal == userPrimaryGoal;

                    final Color accentColor;
                    switch (blueprint.location) {
                      case BlueprintLocation.gym:
                        accentColor = AppColors.karmaGreen;
                        break;
                      case BlueprintLocation.home:
                        accentColor = AppColors.focusBlue;
                        break;
                      case BlueprintLocation.hybrid:
                        accentColor = AppColors.energyOrange;
                        break;
                    }

                    return BentoCard(
                      hasGlow: isSelected,
                      glowColor: accentColor,
                      backgroundColor: isSelected ? AppColors.surfaceElevated : AppColors.surface,
                      border: Border.all(
                        color: isSelected ? accentColor : AppColors.glassBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      onTap: () => _selectBlueprint(blueprint.id),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isRecommended) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.karmaGreen.withValues(alpha: 0.20),
                                          borderRadius: AppRadii.radiusSm,
                                          border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.4)),
                                        ),
                                        child: Text(
                                          'RECOMMENDED FOR YOU',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.karmaGreen,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                    BilingualLabel(
                                      primaryText: blueprint.title,
                                      regionalText: blueprint.regionalTitle,
                                      primaryStyle: AppTypography.titleMedium.copyWith(
                                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? accentColor : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? accentColor : AppColors.glassBorder,
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
                          const SizedBox(height: 6),
                          Text(
                            blueprint.description,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // Tag Chips Row
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _buildTagChip('${blueprint.daysPerWeek} Days/Wk', Icons.calendar_today_rounded, accentColor),
                              _buildTagChip('${blueprint.durationWeeks} Weeks', Icons.timelapse_rounded, AppColors.textSecondary),
                              _buildTagChip(blueprint.level.name.toUpperCase(), Icons.speed_rounded, AppColors.textMuted),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.handyman_outlined, color: AppColors.textMuted, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  blueprint.equipmentRequired,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),

        // Launch Health OS Final Button
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
              ref.read(onboardingFlowProvider.notifier).selectBlueprint(_selectedBlueprintId);
              ref.read(onboardingFlowProvider.notifier).nextStep();
              widget.onComplete?.call();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Launch Health OS',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.rocket_launch_rounded,
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

  Widget _buildTagChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.radiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
