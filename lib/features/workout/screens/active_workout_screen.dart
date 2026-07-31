import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/pose_estimation_engine.dart';
import '../../../core/brain/progressive_overload_engine.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/workout_provider.dart';

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
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text(state.exerciseName, style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progressive Overload Target Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progressive Overload Target', style: AppTypography.titleMedium),
                        Chip(
                          backgroundColor: AppColors.glassBgMid,
                          side: const BorderSide(color: AppColors.glassBorder),
                          label: Text('${nextTarget.weightKg} kg x ${nextTarget.reps}', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryCyan)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(nextTarget.recommendationReason, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // MediaPipe Real-Time Form Analysis Feedback
              GlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.camera_front, color: AppColors.primaryEmerald),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MediaPipe Form Feedback', style: AppTypography.titleMedium),
                          Text(poseResult.formFeedback, style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Active Sets Logging List
              Text('Sets & Reps Logging', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...state.sets.map((set) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Set ${set.setNumber}', style: AppTypography.titleMedium),
                        Text('${set.weightKg} kg x ${set.reps} reps', style: AppTypography.bodyMedium),
                        IconButton(
                          icon: Icon(
                            set.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: set.isCompleted ? AppColors.primaryEmerald : AppColors.textMuted,
                          ),
                          onPressed: () {
                            ref.read(workoutProvider.notifier).logSet(set.setNumber - 1, set.weightKg, set.reps, set.rpe);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),

              // Workout Completion XP Outcome Button
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                    ),
                  ),
                  onPressed: () {
                    ref.read(workoutProvider.notifier).completeWorkout();
                    _showOutcomeXpDialog(context, ref, state.earnedXp > 0 ? state.earnedXp : 150);
                  },
                  child: Text('Complete Workout & Claim XP', style: AppTypography.titleMedium.copyWith(color: AppColors.bgPrimary)),
                ),
              ),
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
          backgroundColor: AppColors.bgSecondary,
          title: Text('Workout Complete!', style: AppTypography.displayLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium, color: AppColors.warningAmber, size: 64.0),
              const SizedBox(height: AppSpacing.md),
              Text('Earned +$xp Outcome XP!', style: AppTypography.titleLarge.copyWith(color: AppColors.primaryEmerald)),
              const SizedBox(height: AppSpacing.xs),
              Text('XP awarded for full workout completion, not logging.', style: AppTypography.labelSmall),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Awesome', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryCyan)),
            ),
          ],
        );
      },
    );
  }
}
