import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';
import 'active_workout_screen.dart';
import 'exercise_library_screen.dart';

class WorkoutHomeScreen extends ConsumerWidget {
  final bool showBackButton;

  const WorkoutHomeScreen({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardStateProvider);
    final workoutsAsync = ref.watch(todayWorkoutsStreamProvider);
    final workouts = workoutsAsync.value ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: (showBackButton && Navigator.canPop(context))
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: BilingualLabel(
          english: 'Training Operating System',
          hindi: 'व्यायाम व शक्ति प्रशिक्षण',
          primaryStyle: AppTypography.h3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined, color: AppColors.primaryCyan),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ExerciseLibraryScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Training Volume & Today Stats Bento Card
            BentoCard(
              isGlowing: dashboard.workoutsLoggedCount > 0,
              glowColor: AppColors.primaryCyan,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlowingMetric(
                        value: '${dashboard.totalVolumeTonnageKg.toInt()}',
                        label: 'Total Tonnage',
                        unit: 'kg moved today',
                        glowColor: AppColors.primaryCyan,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryCyan.withAlpha(100)),
                        ),
                        child: Text(
                          '${dashboard.workoutDurationMinutes} mins active',
                          style: AppTypography.label.copyWith(color: AppColors.primaryCyan, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dashboard.workoutsLoggedCount > 0
                        ? 'Active training session logged. Progressive overload tracked in local DB.'
                        : 'No workouts completed yet today. Start a training session below.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // Today's Logged Sessions / Blueprint Header
            Text('Today\'s Training Sessions', style: AppTypography.h3),
            const SizedBox(height: 12),

            if (workouts.isEmpty)
              BentoCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.fitness_center_outlined, size: 40, color: AppColors.textMuted),
                        const SizedBox(height: 10),
                        Text(
                          'No workout sessions recorded today',
                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Start your session tracker below to log sets, reps, and tonnage',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...workouts.map((w) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(w.name, style: AppTypography.h3),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryEmerald.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primaryEmerald.withAlpha(80)),
                              ),
                              child: Text('${(w.durationSeconds / 60).round()} Mins', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Volume: ${w.totalVolumeKg.toInt()} kg • RPE: ${w.avgRpe.toStringAsFixed(1)} • Burned: ~${(w.durationSeconds / 60 * 7.5).round()} kcal',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Start Workout CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryEmerald,
                  foregroundColor: AppColors.textOnAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ActiveWorkoutScreen()),
                ),
                icon: const Icon(Icons.fitness_center),
                label: Text('Start Session Tracker', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textOnAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
