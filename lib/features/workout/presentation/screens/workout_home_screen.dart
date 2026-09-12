import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import 'active_workout_screen.dart';
import 'exercise_library_screen.dart';

class WorkoutHomeScreen extends StatelessWidget {
  const WorkoutHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
            // Training Volume & Streak Bento Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryCyan,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const GlowingMetric(
                        value: '14,250',
                        label: 'Weekly Tonnage',
                        unit: 'kg moved',
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
                          'Streak: 4 Days',
                          style: AppTypography.label.copyWith(color: AppColors.primaryCyan, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Progressive overload achieved on 8 out of 10 compound sets this week.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // Today's Scheduled Blueprint
            Text('Today\'s Training Blueprint', style: AppTypography.h3),
            const SizedBox(height: 12),

            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upper Body Strength (A)', style: AppTypography.h3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGlassHover,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderGlass),
                        ),
                        child: Text('45 Mins • 5 Exercises', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Focus: Chest, Upper Back & Shoulders Hypertrophy', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryCyan)),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  _buildExerciseItem('1. Flat Barbell Bench Press', '4 Sets • 8-10 Reps', 'Target: 70kg (+2.5kg)'),
                  _buildExerciseItem('2. Bent-Over Barbell Row', '4 Sets • 8-12 Reps', 'Target: 60kg'),
                  _buildExerciseItem('3. Standing Overhead Press', '3 Sets • 6-8 Reps', 'Target: 42.5kg'),
                  _buildExerciseItem('4. Desi Dand (Hindu Pushups)', '3 Sets • 15 Reps', 'Bodyweight'),
                  _buildExerciseItem('5. Overhand Pull-ups', '3 Sets • 8 Reps', 'Bodyweight'),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

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

  Widget _buildExerciseItem(String name, String setsReps, String target) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text(setsReps, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(target, style: AppTypography.label.copyWith(color: AppColors.accentAmber)),
        ],
      ),
    );
  }
}
