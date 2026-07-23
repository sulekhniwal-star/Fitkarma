/// §P6-B Active Workout Screen UI
///
/// Route `/workout/active` — full-screen workout interface with set/rep logging table,
/// circular rest timer, +30s / Skip Rest / Pause controls, and XP Burst completion overlay.
library;

import 'dart:async';

import 'package:fitkarma/features/workout/active_workout_controller.dart';
import 'package:fitkarma/features/workout/rest_timer_painter.dart';
import 'package:fitkarma/features/workout/workout_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _bgColor       = Color(0xFF0F111A);
const _surfaceColor  = Color(0xFF181B29);
const _cardBgColor   = Color(0xFF222638);
const _accentOrange  = Color(0xFFFF6B35);
const _accentGreen   = Color(0xFF4ADE80);
const _accentBlue    = Color(0xFF60A5FA);
const _accentYellow  = Color(0xFFFBBF24);
const _accentRed     = Color(0xFFF87171);
const _textPrimary   = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor   = Color(0xFF2E324A);

class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeWorkoutProvider);
    final notifier = ref.read(activeWorkoutProvider.notifier);

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Active Workout',
          style: TextStyle(color: _textPrimary, fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w800),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _ElapsedClock(),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Exercise Progress Header ──
                _ExerciseProgressHeader(
                  exerciseIndex: state.currentExerciseIndex,
                  totalExercises: state.session.exercises.length,
                  exercise: state.currentExercise,
                ),

                const SizedBox(height: 16),

                // ── Exercise Navigation Pills ──
                _ExerciseNavPills(
                  exercises: state.session.exercises,
                  currentIndex: state.currentExerciseIndex,
                  onTap: notifier.goToExercise,
                ),

                const SizedBox(height: 16),

                // ── Set / Rep Logging Table ──
                _SetLoggingTable(
                  exerciseIndex: state.currentExerciseIndex,
                  setStates: state.currentSetStates,
                  onSetComplete: (setIdx) =>
                      notifier.completeSet(state.currentExerciseIndex, setIdx),
                ),

                const SizedBox(height: 20),

                // ── Rest Timer Card ──
                if (state.isTimerRunning || state.restTimerSeconds > 0)
                  _RestTimerCard(
                    secondsRemaining: state.restTimerSeconds,
                    fraction: state.timerFraction,
                    isPaused: state.isTimerPaused,
                    onAddThirty: notifier.addThirtySeconds,
                    onSkip: notifier.skipRest,
                    onPause: notifier.pauseTimer,
                    onResume: notifier.resumeTimer,
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),

          // ── XP Burst Completion Overlay ──
          if (state.isWorkoutComplete)
            _XpBurstOverlay(onDismiss: notifier.dismissCompletion),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Elapsed Clock Widget (StatefulWidget with Timer)
// ─────────────────────────────────────────────────────────────────────────────

class _ElapsedClock extends StatefulWidget {
  const _ElapsedClock();

  @override
  State<_ElapsedClock> createState() => _ElapsedClockState();
}

class _ElapsedClockState extends State<_ElapsedClock> {
  late DateTime _startTime;
  late String _elapsed;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _elapsed = '00:00';
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final diff = DateTime.now().difference(_startTime);
      final mins = diff.inMinutes.toString().padLeft(2, '0');
      final secs = (diff.inSeconds % 60).toString().padLeft(2, '0');
      setState(() => _elapsed = '$mins:$secs');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Time: $_elapsed',
        key: const Key('workout_elapsed_timer'),
        style: const TextStyle(color: _accentBlue, fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Exercise Progress Header
// ─────────────────────────────────────────────────────────────────────────────

class _ExerciseProgressHeader extends StatelessWidget {
  const _ExerciseProgressHeader({
    required this.exerciseIndex,
    required this.totalExercises,
    required this.exercise,
  });

  final int exerciseIndex;
  final int totalExercises;
  final ExerciseSummary exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('exercise_progress_header'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise ${exerciseIndex + 1} of $totalExercises',
            style: const TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            exercise.name,
            style: const TextStyle(
              color: _textPrimary,
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Target: ${exercise.targetSets} sets × ${exercise.targetReps} reps @ ${exercise.suggestedWeightKg} kg',
            style: const TextStyle(color: _textSecondary, fontSize: 13),
          ),
          if (exercise.progressionNudge != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _accentYellow.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '📈 ${exercise.progressionNudge}',
                style: const TextStyle(color: _accentYellow, fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Exercise Navigation Pills
// ─────────────────────────────────────────────────────────────────────────────

class _ExerciseNavPills extends StatelessWidget {
  const _ExerciseNavPills({
    required this.exercises,
    required this.currentIndex,
    required this.onTap,
  });

  final List<ExerciseSummary> exercises;
  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(exercises.length, (i) {
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? _accentOrange : _cardBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isActive ? _accentOrange : _borderColor),
              ),
              child: Text(
                'Ex ${i + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : _textSecondary,
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Set / Rep Logging Table
// ─────────────────────────────────────────────────────────────────────────────

class _SetLoggingTable extends StatelessWidget {
  const _SetLoggingTable({
    required this.exerciseIndex,
    required this.setStates,
    required this.onSetComplete,
  });

  final int exerciseIndex;
  final List<SetRowState> setStates;
  final void Function(int setIdx) onSetComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('set_logging_table'),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          // Table Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _HeaderCell('Set', flex: 1),
                _HeaderCell('Target', flex: 2),
                _HeaderCell('Weight', flex: 2),
                _HeaderCell('Reps', flex: 2),
                _HeaderCell('Done?', flex: 1),
              ],
            ),
          ),
          const Divider(color: _borderColor, height: 1),
          // Table Rows
          ...setStates.asMap().entries.map((entry) {
            final setIdx = entry.key;
            final row = entry.value;
            return _SetRow(
              key: Key('set_row_${exerciseIndex}_$setIdx'),
              row: row,
              setIdx: setIdx,
              onComplete: () => onSetComplete(setIdx),
            );
          }),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label, {required this.flex});

  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    super.key,
    required this.row,
    required this.setIdx,
    required this.onComplete,
  });

  final SetRowState row;
  final int setIdx;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final isCompleted = row.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: isCompleted ? _accentGreen.withAlpha(20) : Colors.transparent,
        border: const Border(bottom: BorderSide(color: _borderColor, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Set number
          Expanded(
            flex: 1,
            child: Text(
              '${row.setNumber}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isCompleted ? _accentGreen : _textPrimary,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          // Target reps
          Expanded(
            flex: 2,
            child: Text(
              '${row.targetReps} reps',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _textSecondary, fontSize: 12),
            ),
          ),
          // Weight kg (display)
          Expanded(
            flex: 2,
            child: Text(
              '${row.weightKg.toStringAsFixed(1)} kg',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _textPrimary, fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          // Actual reps (display)
          Expanded(
            flex: 2,
            child: Text(
              row.isCompleted ? '${row.actualReps ?? row.targetReps}' : '-',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isCompleted ? _accentGreen : _textSecondary,
                fontSize: 13,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Done checkbox
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onComplete,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? _accentGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCompleted ? _accentGreen : _textSecondary,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check_rounded, color: Colors.black, size: 18)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rest Timer Card
// ─────────────────────────────────────────────────────────────────────────────

class _RestTimerCard extends StatelessWidget {
  const _RestTimerCard({
    required this.secondsRemaining,
    required this.fraction,
    required this.isPaused,
    required this.onAddThirty,
    required this.onSkip,
    required this.onPause,
    required this.onResume,
  });

  final int secondsRemaining;
  final double fraction;
  final bool isPaused;
  final VoidCallback onAddThirty;
  final VoidCallback onSkip;
  final VoidCallback onPause;
  final VoidCallback onResume;

  String get _formatted {
    final m = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final s = (secondsRemaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('rest_timer_card'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          const Text(
            'Rest Timer',
            style: TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Circular arc timer
          SizedBox(
            width: 130,
            height: 130,
            child: CustomPaint(
              painter: RestTimerPainter(fraction: fraction),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatted,
                      key: const Key('rest_timer_display'),
                      style: const TextStyle(
                        color: _textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      isPaused ? 'paused' : 'remaining',
                      style: const TextStyle(color: _textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimerButton(
                key: const Key('timer_add30_btn'),
                label: '+30s',
                color: _accentBlue,
                onTap: onAddThirty,
              ),
              const SizedBox(width: 10),
              _TimerButton(
                key: const Key('timer_skip_btn'),
                label: 'Skip Rest',
                color: _accentRed,
                onTap: onSkip,
              ),
              const SizedBox(width: 10),
              _TimerButton(
                key: const Key('timer_pause_btn'),
                label: isPaused ? 'Resume' : 'Pause',
                color: _accentYellow,
                onTap: isPaused ? onResume : onPause,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  const _TimerButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(120)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// XP Burst Completion Overlay
// ─────────────────────────────────────────────────────────────────────────────

class _XpBurstOverlay extends StatelessWidget {
  const _XpBurstOverlay({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        key: const Key('xp_burst_overlay'),
        color: Colors.black.withAlpha(200),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              const Text(
                'Workout Complete!',
                style: TextStyle(
                  color: _accentYellow,
                  fontFamily: 'Outfit',
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '+250 XP Earned',
                style: TextStyle(
                  color: _accentGreen,
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: _accentOrange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
