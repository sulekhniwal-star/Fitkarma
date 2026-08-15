import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';

/// §P6-A Workout Screen Home
/// Route: /workout
class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({super.key});

  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  // Demo State for Workout Home
  final String _activeProgram = 'Corporate Fat Loss';
  final int _currentWeek = 4;
  final int _currentDay = 2;
  final int _completedDays = 2;
  final int _totalDaysInWeek = 4;

  final String _sessionTitle = 'Upper Body Power & Hypertrophy';
  final int _estimatedMinutes = 45;
  final int _exerciseCount = 4;
  final int _totalSetsCount = 16;
  final String _progressionNudge =
      'Suggesting +2.5kg on Bench Press today based on last week RPE 7.0';

  final List<Map<String, String>> _recentHistory = const [
    {'title': 'Lower Body Core', 'time': 'Yesterday', 'status': 'Completed ✓'},
    {'title': 'Upper Body Pull', 'time': '3 days ago', 'status': 'Completed ✓'},
    {
      'title': 'Push Hypertrophy',
      'time': '5 days ago',
      'status': 'Completed ✓'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
        title: Text('Workout Home', style: AppTypography.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Program Banner BentoCard
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'ACTIVE PROGRAM',
                          style: AppTypography.labelMd
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                      Text(
                        'Week $_currentWeek / Day $_currentDay',
                        style: AppTypography.labelLg
                            .copyWith(color: AppColors.teal),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(_activeProgram, style: AppTypography.h2),
                  const SizedBox(height: AppSpacing.md),

                  // Weekly Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Weekly Progress', style: AppTypography.bodySm),
                      Text('$_completedDays of $_totalDaysInWeek days',
                          style: AppTypography.labelMd),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _completedDays / _totalDaysInWeek,
                      backgroundColor: AppColors.surface1,
                      color: AppColors.primary,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Today's Session GlassCard
            Text("Today's Session", style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),

            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_sessionTitle, style: AppTypography.h2),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('$_estimatedMinutes mins',
                          style: AppTypography.bodySm),
                      const SizedBox(width: 12),
                      const Icon(Icons.fitness_center,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('$_exerciseCount Exercises',
                          style: AppTypography.bodySm),
                      const SizedBox(width: 12),
                      const Icon(Icons.repeat,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('$_totalSetsCount sets',
                          style: AppTypography.bodySm),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Progression Badge / Nudge
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt,
                            color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _progressionNudge,
                            style: AppTypography.bodySm
                                .copyWith(color: AppColors.accent, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Start Workout CTA
                  SizedBox(
                    width: double.infinity,
                    height: 50,
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
                        context.push('/workout/active');
                      },
                      icon: const Icon(Icons.play_arrow_rounded, size: 24),
                      label: Text('Start Workout',
                          style:
                              AppTypography.h3.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Recent History Section
            Text('Recent History', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),

            for (final history in _recentHistory)
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface1,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: AppColors.success, size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(history['title']!,
                                style: AppTypography.labelLg),
                            Text(history['time']!, style: AppTypography.bodySm),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      history['status']!,
                      style: AppTypography.bodySm.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600),
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
