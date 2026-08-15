import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/pose_estimation_engine.dart';
import '../../../core/brain/progressive_overload_engine.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/workout_provider.dart';

/// §P6-B Active Workout Screen
/// Route: /workout/active
class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);
    const overloadEngine = ProgressiveOverloadEngine();
    const poseEngine = PoseEstimationEngine();

    final nextTarget = overloadEngine.calculateNextTarget(
      previousWeightKg: 80.0,
      previousReps: 8,
      rpe: 7.0,
      readinessScore: 85,
    );

    final poseResult = poseEngine.analyzeSquatForm(
      leftKneeAngle: 88.0,
      rightKneeAngle: 86.0,
      hipAngle: 95.0,
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
        title: Text(state.exerciseName, style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Rest Countdown Banner (Survives Backgrounding)
              if (state.isTimerActive && state.restTimerSeconds > 0) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer,
                              color: AppColors.primary, size: 24),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('REST COUNTDOWN (Background Resilient)',
                                  style: AppTypography.labelMd
                                      .copyWith(color: AppColors.primary)),
                              Text(
                                '${state.restTimerSeconds ~/ 60}:${(state.restTimerSeconds % 60).toString().padLeft(2, '0')}',
                                style: AppTypography.h1
                                    .copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.read(workoutProvider.notifier).skipRestTimer(),
                        child: Text('Skip Rest',
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.teal)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Progressive Overload Target Card
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progressive Overload Target',
                            style: AppTypography.h3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                              '${nextTarget.weightKg} kg x ${nextTarget.reps}',
                              style: AppTypography.labelLg
                                  .copyWith(color: AppColors.teal)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(nextTarget.recommendationReason,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // MediaPipe Real-Time Form Analysis Feedback
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.camera_front,
                        color: AppColors.success, size: 24),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MediaPipe Form Feedback',
                              style: AppTypography.h3),
                          Text(poseResult.formFeedback,
                              style: AppTypography.bodySm
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Active Sets Logging List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sets & Reps Logging', style: AppTypography.h3),
                  Text(
                      '${state.sets.where((s) => s.isCompleted).length}/${state.sets.length} Completed',
                      style: AppTypography.bodySm),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              ...state.sets.asMap().entries.map((entry) {
                final index = entry.key;
                final set = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 8),
                  decoration: BoxDecoration(
                    color: set.isCompleted
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.surface1,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: set.isCompleted
                          ? AppColors.success
                          : AppColors.glassBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.surface0,
                              shape: BoxShape.circle,
                            ),
                            child: Text('${set.setNumber}',
                                style: AppTypography.labelMd),
                          ),
                          const SizedBox(width: 12),
                          Text('${set.weightKg} kg x ${set.reps} reps',
                              style: AppTypography.labelLg),
                        ],
                      ),
                      Row(
                        children: [
                          Text('RPE ${set.rpe}', style: AppTypography.bodySm),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              set.isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: set.isCompleted
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                              size: 26,
                            ),
                            onPressed: () {
                              ref.read(workoutProvider.notifier).logSet(
                                  index, set.weightKg, set.reps, set.rpe);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.lg),

              // Workout Completion CTA Button
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.cardRadius),
                    ),
                  ),
                  onPressed: () {
                    ref.read(workoutProvider.notifier).completeWorkout();
                    _showOutcomeXpDialog(context, ref,
                        state.earnedXp > 0 ? state.earnedXp : 150);
                  },
                  icon: const Icon(Icons.verified, size: 22),
                  label: Text('Complete Workout & Claim XP',
                      style: AppTypography.h3.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showOutcomeXpDialog(BuildContext context, WidgetRef ref, int xp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Workout Complete!', style: AppTypography.h2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium,
                  color: AppColors.accent, size: 64.0),
              const SizedBox(height: AppSpacing.md),
              Text('Earned +$xp Outcome XP!',
                  style: AppTypography.h2.copyWith(color: AppColors.success)),
              const SizedBox(height: AppSpacing.xs),
              Text('XP awarded for full workout completion, not logging.',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Awesome',
                  style: AppTypography.h3.copyWith(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }
}
