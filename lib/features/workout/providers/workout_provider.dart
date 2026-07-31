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
  final bool isTimerActive;
  final int earnedXp;

  const WorkoutState({
    this.exerciseName = 'Barbell Back Squat',
    this.sets = const [
      WorkoutSet(setNumber: 1, weightKg: 80.0, reps: 8, rpe: 7.0),
      WorkoutSet(setNumber: 2, weightKg: 80.0, reps: 8, rpe: 7.5),
      WorkoutSet(setNumber: 3, weightKg: 80.0, reps: 8, rpe: 8.0),
    ],
    this.restTimerSeconds = 90,
    this.isTimerActive = false,
    this.earnedXp = 0,
  });

  WorkoutState copyWith({
    String? exerciseName,
    List<WorkoutSet>? sets,
    int? restTimerSeconds,
    bool? isTimerActive,
    int? earnedXp,
  }) {
    return WorkoutState(
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      earnedXp: earnedXp ?? this.earnedXp,
    );
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  WorkoutNotifier() : super(const WorkoutState());

  void logSet(int setIndex, double weight, int reps, double rpe) {
    final updatedSets = List<WorkoutSet>.from(state.sets);
    updatedSets[setIndex] = updatedSets[setIndex].copyWith(
      weightKg: weight,
      reps: reps,
      rpe: rpe,
      isCompleted: true,
    );

    state = state.copyWith(sets: updatedSets, isTimerActive: true);
  }

  void completeWorkout() {
    // Completion Outcome XP (Reward for finishing full session, not logging)
    const completionBonusXp = 150;
    state = state.copyWith(earnedXp: completionBonusXp, isTimerActive: false);
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  return WorkoutNotifier();
});
