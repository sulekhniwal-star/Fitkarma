/// §P6-B Active Workout State Controller
///
/// Riverpod Notifier managing current exercise index, per-set completion,
/// rest timer countdown, and in-memory WorkoutLogEntry accumulation.
library;

import 'dart:async';

import 'package:fitkarma/features/workout/workout_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class ActiveWorkoutState {
  const ActiveWorkoutState({
    required this.session,
    required this.currentExerciseIndex,
    required this.setStates,
    this.restTimerSeconds = 0,
    this.restTimerTotal = 90,
    this.isTimerRunning = false,
    this.isTimerPaused = false,
    this.workoutLogs = const [],
    this.isWorkoutComplete = false,
  });

  final WorkoutSession session;
  final int currentExerciseIndex;

  /// Outer list = exercises, inner list = sets for that exercise.
  final List<List<SetRowState>> setStates;

  final int restTimerSeconds;
  final int restTimerTotal;
  final bool isTimerRunning;
  final bool isTimerPaused;
  final List<WorkoutLogEntry> workoutLogs;
  final bool isWorkoutComplete;

  double get timerFraction => restTimerTotal > 0
      ? (restTimerSeconds / restTimerTotal).clamp(0.0, 1.0)
      : 0.0;

  ExerciseSummary get currentExercise =>
      session.exercises[currentExerciseIndex];

  List<SetRowState> get currentSetStates => setStates[currentExerciseIndex];

  ActiveWorkoutState copyWith({
    int? currentExerciseIndex,
    List<List<SetRowState>>? setStates,
    int? restTimerSeconds,
    int? restTimerTotal,
    bool? isTimerRunning,
    bool? isTimerPaused,
    List<WorkoutLogEntry>? workoutLogs,
    bool? isWorkoutComplete,
  }) {
    return ActiveWorkoutState(
      session: session,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      setStates: setStates ?? this.setStates,
      restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
      restTimerTotal: restTimerTotal ?? this.restTimerTotal,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      isTimerPaused: isTimerPaused ?? this.isTimerPaused,
      workoutLogs: workoutLogs ?? this.workoutLogs,
      isWorkoutComplete: isWorkoutComplete ?? this.isWorkoutComplete,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class ActiveWorkoutNotifier extends Notifier<ActiveWorkoutState> {
  Timer? _timer;

  static const int _defaultRestSeconds = 90;

  static List<List<SetRowState>> _buildSetStates(WorkoutSession session) {
    return session.exercises.map((exercise) {
      return List.generate(exercise.targetSets, (i) {
        return SetRowState(
          setNumber: i + 1,
          targetReps: int.tryParse(exercise.targetReps.split('-').first) ?? 8,
          weightKg: exercise.suggestedWeightKg,
        );
      });
    }).toList();
  }

  @override
  ActiveWorkoutState build() {
    // Default session from WorkoutNotifier's preset
    const session = WorkoutSession(
      id: 'session_1',
      title: 'Upper Body Power & Hypertrophy',
      durationMinutes: 45,
      progressionBadgeText: 'Suggesting +2.5kg on Bench Press today 🏋️',
      exercises: [
        ExerciseSummary(
          name: 'Flat Barbell Bench Press',
          targetSets: 4,
          targetReps: '8-10',
          suggestedWeightKg: 80.0,
          progressionNudge: '+2.5kg',
        ),
        ExerciseSummary(
          name: 'Incline Dumbbell Press',
          targetSets: 4,
          targetReps: '10-12',
          suggestedWeightKg: 24.0,
        ),
        ExerciseSummary(
          name: 'Lat Pulldown',
          targetSets: 4,
          targetReps: '10-12',
          suggestedWeightKg: 55.0,
        ),
        ExerciseSummary(
          name: 'Seated Cable Row',
          targetSets: 4,
          targetReps: '12-15',
          suggestedWeightKg: 47.5,
        ),
      ],
    );

    ref.onDispose(() {
      _timer?.cancel();
    });

    return ActiveWorkoutState(
      session: session,
      currentExerciseIndex: 0,
      setStates: _buildSetStates(session),
    );
  }

  // ── Set Completion ──

  /// Marks a set as done, records its log entry, and auto-starts the rest timer.
  void completeSet(
    int exerciseIdx,
    int setIdx, {
    int? actualReps,
    double? weightKg,
  }) {
    final newSetStates = state.setStates
        .map((rows) => rows.map((r) => r).toList())
        .toList();

    final row = newSetStates[exerciseIdx][setIdx];
    final completed = !row.isCompleted;
    newSetStates[exerciseIdx][setIdx] = row.copyWith(
      isCompleted: completed,
      actualReps: actualReps ?? row.targetReps,
      weightKg: weightKg ?? row.weightKg,
      completedAt: completed ? DateTime.now() : null,
    );

    // Append to workout log for this exercise
    final updatedLogs = List<WorkoutLogEntry>.from(state.workoutLogs);
    final existingLogIdx = updatedLogs.indexWhere(
      (l) => l.exerciseName == state.session.exercises[exerciseIdx].name,
    );
    final setEntry = SetLogEntry(
      setNumber: setIdx + 1,
      targetReps: row.targetReps,
      actualReps: actualReps ?? row.targetReps,
      weightKg: weightKg ?? row.weightKg,
      isCompleted: completed,
      completedAt: completed ? DateTime.now() : null,
    );

    if (existingLogIdx >= 0) {
      final existingSets = List<SetLogEntry>.from(
        updatedLogs[existingLogIdx].sets,
      );
      final existingSetIdx = existingSets.indexWhere(
        (s) => s.setNumber == setIdx + 1,
      );
      if (existingSetIdx >= 0) {
        existingSets[existingSetIdx] = setEntry;
      } else {
        existingSets.add(setEntry);
      }
      updatedLogs[existingLogIdx] = WorkoutLogEntry(
        sessionId: state.session.id,
        exerciseName: state.session.exercises[exerciseIdx].name,
        sets: existingSets,
        loggedAt: DateTime.now(),
      );
    } else {
      updatedLogs.add(
        WorkoutLogEntry(
          sessionId: state.session.id,
          exerciseName: state.session.exercises[exerciseIdx].name,
          sets: [setEntry],
          loggedAt: DateTime.now(),
        ),
      );
    }

    state = state.copyWith(setStates: newSetStates, workoutLogs: updatedLogs);

    // Auto-start rest timer when a set is checked (not unchecked)
    if (completed) {
      _startRestTimer();
    }

    // Check if entire workout is complete
    _checkWorkoutComplete();
  }

  // ── Rest Timer ──

  void _startRestTimer() {
    _timer?.cancel();
    state = state.copyWith(
      restTimerSeconds: _defaultRestSeconds,
      restTimerTotal: _defaultRestSeconds,
      isTimerRunning: true,
      isTimerPaused: false,
    );
    _scheduleTick();
  }

  void _scheduleTick() {
    _timer = Timer(const Duration(seconds: 1), () {
      if (!state.isTimerRunning || state.isTimerPaused) return;
      final newSeconds = state.restTimerSeconds - 1;
      if (newSeconds <= 0) {
        state = state.copyWith(restTimerSeconds: 0, isTimerRunning: false);
      } else {
        state = state.copyWith(restTimerSeconds: newSeconds);
        _scheduleTick();
      }
    });
  }

  /// Exposed for testing — advances timer by one tick.
  void tickTimer() {
    if (!state.isTimerRunning || state.isTimerPaused) return;
    final newSeconds = state.restTimerSeconds - 1;
    if (newSeconds <= 0) {
      state = state.copyWith(restTimerSeconds: 0, isTimerRunning: false);
    } else {
      state = state.copyWith(restTimerSeconds: newSeconds);
    }
  }

  void addThirtySeconds() {
    state = state.copyWith(
      restTimerSeconds: state.restTimerSeconds + 30,
      restTimerTotal: state.restTimerTotal + 30,
    );
  }

  void skipRest() {
    _timer?.cancel();
    state = state.copyWith(
      restTimerSeconds: 0,
      isTimerRunning: false,
      isTimerPaused: false,
    );
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(isTimerPaused: true);
  }

  void resumeTimer() {
    state = state.copyWith(isTimerPaused: false);
    _scheduleTick();
  }

  // ── Navigation ──

  void goToExercise(int idx) {
    if (idx >= 0 && idx < state.session.exercises.length) {
      state = state.copyWith(currentExerciseIndex: idx);
    }
  }

  void _checkWorkoutComplete() {
    final allDone = state.setStates.every(
      (exerciseSets) => exerciseSets.every((s) => s.isCompleted),
    );
    if (allDone) {
      _timer?.cancel();
      state = state.copyWith(isWorkoutComplete: true, isTimerRunning: false);
    }
  }

  void dismissCompletion() {
    state = state.copyWith(isWorkoutComplete: false);
  }
}

final activeWorkoutProvider =
    NotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>(
      ActiveWorkoutNotifier.new,
    );
