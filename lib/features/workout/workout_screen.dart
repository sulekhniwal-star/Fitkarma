/// §P6-A Workout Screen Home UI
///
/// Route `/workout` scaffold: Dark theme bento grid layout displaying active program overview,
/// weekly progress bar, today's workout session card with progression badge,
/// prominent [ Start Workout ] CTA button, and recent workout history.
library;

import 'package:fitkarma/features/workout/workout_controller.dart';
import 'package:fitkarma/features/workout/workout_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _bgColor = Color(0xFF0F111A);
const _surfaceColor = Color(0xFF181B29);
const _cardBgColor = Color(0xFF222638);
const _accentOrange = Color(0xFFFF6B35);
const _accentGreen = Color(0xFF4ADE80);
const _accentBlue = Color(0xFF60A5FA);
const _accentYellow = Color(0xFFFBBF24);
const _accentPurple = Color(0xFFA78BFA);
const _textPrimary = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor = Color(0xFF2E324A);

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);
    final notifier = ref.read(workoutProvider.notifier);
    final program = state.activeProgram;
    final session = state.todaysSession;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Workout Home 💪',
          style: TextStyle(
            color: _textPrimary,
            fontFamily: 'Outfit',
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Active Program Overview Bento Card ──
            Container(
              key: const Key('workout_active_program_card'),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active: ${program.title}',
                        style: const TextStyle(
                          color: _accentBlue,
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _accentBlue.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Week ${program.currentWeek} / Day ${program.currentDay}',
                          key: const Key('workout_week_day_text'),
                          style: const TextStyle(
                            color: _accentBlue,
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weekly Progress',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${program.completedDaysThisWeek} of ${program.targetDaysPerWeek} days',
                        key: const Key('workout_weekly_progress_text'),
                        style: const TextStyle(
                          color: _textPrimary,
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      key: const Key('workout_progress_bar'),
                      value: program.weeklyProgressFraction,
                      backgroundColor: _cardBgColor,
                      valueColor: const AlwaysStoppedAnimation(_accentGreen),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Today's Session Bento Card ──
            Container(
              key: const Key('workout_todays_session_card'),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _accentOrange.withAlpha(120)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Session:",
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.title,
                    key: const Key('workout_session_title_text'),
                    style: const TextStyle(
                      color: _textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Stats Chips
                  Row(
                    children: [
                      _StatChip(
                        label: '${session.durationMinutes} mins',
                        icon: Icons.timer_outlined,
                        color: _accentOrange,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        label: '${session.exercises.length} Exercises',
                        icon: Icons.fitness_center_rounded,
                        color: _accentBlue,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        label: '${session.totalSets} sets',
                        icon: Icons.repeat_rounded,
                        color: _accentPurple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Progression Badge Nudge
                  if (session.progressionBadgeText != null) ...[
                    Container(
                      key: const Key('workout_progression_badge'),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _accentYellow.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _accentYellow.withAlpha(100)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            color: _accentYellow,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              session.progressionBadgeText!,
                              style: const TextStyle(
                                color: _accentYellow,
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Start Workout CTA Button
                  ElevatedButton(
                    key: const Key('start_workout_btn'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      notifier.startWorkout();
                    },
                    child: const Text(
                      'Start Workout ▶',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Recent Workout History Section ──
            const Text(
              'Recent History:',
              style: TextStyle(
                color: _textPrimary,
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            ...state.recentHistory.map((item) {
              return _HistoryTile(item: item);
            }),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final WorkoutHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('workout_history_tile_${item.id}'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: _accentGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.sessionTitle,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.durationMinutes} mins · ${item.totalSets} sets · ${item.totalVolumeKg.round()} kg volume',
                  style: const TextStyle(color: _textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const Text(
            'Completed ✓',
            style: TextStyle(
              color: _accentGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
