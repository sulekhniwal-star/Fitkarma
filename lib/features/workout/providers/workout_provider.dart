import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutSet {
  final int setNumber;
  final double weightKg;
  final int reps;
  final double rpe;
  final bool isCompleted;

  const WorkoutSet({
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    required this.rpe,
    this.isCompleted = false,
  });

  WorkoutSet copyWith({
    int? setNumber,
    double? weightKg,
    int? reps,
    double? rpe,
    bool? isCompleted,
  }) {
    return WorkoutSet(
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class WorkoutState {
  final String exerciseName;
  final List<WorkoutSet> sets;
  final int restTimerSeconds;
  final int initialRestDurationSeconds;
  final DateTime? restTimerEndTime; // Key to surviving app backgrounding!
  final bool isTimerActive;
  final int earnedXp;

  const WorkoutState({
    this.exerciseName = 'Barbell Back Squat',
    this.sets = const [
      WorkoutSet(setNumber: 1, weightKg: 80.0, reps: 8, rpe: 7.0),
      WorkoutSet(setNumber: 2, weightKg: 80.0, reps: 8, rpe: 7.5),
      WorkoutSet(setNumber: 3, weightKg: 80.0, reps: 8, rpe: 8.0),
      WorkoutSet(setNumber: 4, weightKg: 85.0, reps: 6, rpe: 8.5),
    ],
    this.restTimerSeconds = 0,
    this.initialRestDurationSeconds = 90,
    this.restTimerEndTime,
    this.isTimerActive = false,
    this.earnedXp = 0,
  });

  WorkoutState copyWith({
    String? exerciseName,
    List<WorkoutSet>? sets,
    int? restTimerSeconds,
    int? initialRestDurationSeconds,
    DateTime? restTimerEndTime,
    bool? isTimerActive,
    int? earnedXp,
  }) {
    return WorkoutState(
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
      initialRestDurationSeconds: initialRestDurationSeconds ?? this.initialRestDurationSeconds,
      restTimerEndTime: restTimerEndTime ?? this.restTimerEndTime,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      earnedXp: earnedXp ?? this.earnedXp,
    );
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> with WidgetsBindingObserver {
  Timer? _timer;

  WorkoutNotifier() : super(const WorkoutState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recalculateRestTimer();
    }
  }

  void logSet(int setIndex, double weight, int reps, double rpe) {
    final updatedSets = List<WorkoutSet>.from(state.sets);
    final currentSet = updatedSets[setIndex];
    final newCompletion = !currentSet.isCompleted;

    updatedSets[setIndex] = currentSet.copyWith(
      weightKg: weight,
      reps: reps,
      rpe: rpe,
      isCompleted: newCompletion,
    );

    if (newCompletion) {
      startRestCountdown(state.initialRestDurationSeconds);
    }

    state = state.copyWith(sets: updatedSets);
  }

  void updateSetWeight(int setIndex, double weight) {
    final updatedSets = List<WorkoutSet>.from(state.sets);
    updatedSets[setIndex] = updatedSets[setIndex].copyWith(weightKg: weight);
    state = state.copyWith(sets: updatedSets);
  }

  void updateSetReps(int setIndex, int reps) {
    final updatedSets = List<WorkoutSet>.from(state.sets);
    updatedSets[setIndex] = updatedSets[setIndex].copyWith(reps: reps);
    state = state.copyWith(sets: updatedSets);
  }

  void startRestCountdown(int durationSeconds) {
    _timer?.cancel();
    final endTime = DateTime.now().add(Duration(seconds: durationSeconds));

    state = state.copyWith(
      restTimerSeconds: durationSeconds,
      initialRestDurationSeconds: durationSeconds,
      restTimerEndTime: endTime,
      isTimerActive: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tickTimer();
    });
  }

  void _tickTimer() {
    if (state.restTimerEndTime == null) return;
    final remaining = state.restTimerEndTime!.difference(DateTime.now()).inSeconds;

    if (remaining <= 0) {
      _timer?.cancel();
      state = state.copyWith(
        restTimerSeconds: 0,
        isTimerActive: false,
        restTimerEndTime: null,
      );
    } else {
      state = state.copyWith(restTimerSeconds: remaining);
    }
  }

  void _recalculateRestTimer() {
    if (state.isTimerActive && state.restTimerEndTime != null) {
      final remaining = state.restTimerEndTime!.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        _timer?.cancel();
        state = state.copyWith(
          restTimerSeconds: 0,
          isTimerActive: false,
          restTimerEndTime: null,
        );
      } else {
        state = state.copyWith(restTimerSeconds: remaining);
      }
    }
  }

  void skipRestTimer() {
    _timer?.cancel();
    state = state.copyWith(
      restTimerSeconds: 0,
      isTimerActive: false,
      restTimerEndTime: null,
    );
  }

  void completeWorkout() {
    _timer?.cancel();
    const completionBonusXp = 150;
    state = state.copyWith(
      earnedXp: completionBonusXp,
      isTimerActive: false,
      restTimerSeconds: 0,
      restTimerEndTime: null,
    );
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  return WorkoutNotifier();
});
