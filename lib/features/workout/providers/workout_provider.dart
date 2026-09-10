import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/exercise_database.dart';
import '../domain/workout_models.dart';

class WorkoutState {
  final WorkoutSession todaysSession;
  final List<WorkoutSession> weeklySchedule;
  final bool isSessionActive;
  final int completedWorkoutsThisWeek;
  final double totalVolumeTonnageThisWeek;
  final int? activeRestTimerSeconds;

  const WorkoutState({
    required this.todaysSession,
    required this.weeklySchedule,
    this.isSessionActive = false,
    this.completedWorkoutsThisWeek = 3,
    this.totalVolumeTonnageThisWeek = 14250.0,
    this.activeRestTimerSeconds,
  });

  WorkoutState copyWith({
    WorkoutSession? todaysSession,
    List<WorkoutSession>? weeklySchedule,
    bool? isSessionActive,
    int? completedWorkoutsThisWeek,
    double? totalVolumeTonnageThisWeek,
    int? activeRestTimerSeconds,
    bool clearRestTimer = false,
  }) {
    return WorkoutState(
      todaysSession: todaysSession ?? this.todaysSession,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      completedWorkoutsThisWeek:
          completedWorkoutsThisWeek ?? this.completedWorkoutsThisWeek,
      totalVolumeTonnageThisWeek:
          totalVolumeTonnageThisWeek ?? this.totalVolumeTonnageThisWeek,
      activeRestTimerSeconds: clearRestTimer
          ? null
          : (activeRestTimerSeconds ?? this.activeRestTimerSeconds),
    );
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  WorkoutNotifier() : super(_buildInitialState());

  static WorkoutState _buildInitialState() {
    final pushSession = WorkoutSession(
      id: 'session_push_1',
      title: 'Push Hypertrophy & Deltoid Focus',
      regionalTitle: 'पुश हाइपरट्रॉफी (छाती, कंधे एवं ट्राइसेप्स)',
      splitCategory: 'Push Day (दिन १)',
      estimatedDurationMinutes: 52,
      scheduledDate: DateTime.now(),
      plannedExercises: [
        PlannedExercise(
          exercise: ExerciseDatabase.exercises[0], // Flat Barbell Bench Press
          targetSets: 4,
          targetRepsMin: 8,
          targetRepsMax: 10,
          suggestedWeightKg: 72.5,
          completedSets: [
            const WorkoutSet(
                setNumber: 1,
                weightKg: 72.5,
                reps: 10,
                rpe: 8.0,
                isCompleted: true),
            const WorkoutSet(
                setNumber: 2,
                weightKg: 72.5,
                reps: 9,
                rpe: 8.5,
                isCompleted: true),
            const WorkoutSet(
                setNumber: 3,
                weightKg: 72.5,
                reps: 8,
                rpe: 9.0,
                isCompleted: false),
            const WorkoutSet(
                setNumber: 4,
                weightKg: 72.5,
                reps: 8,
                rpe: 9.5,
                isCompleted: false),
          ],
        ),
        PlannedExercise(
          exercise: ExerciseDatabase.exercises[1], // Incline Dumbbell Press
          targetSets: 3,
          targetRepsMin: 10,
          targetRepsMax: 12,
          suggestedWeightKg: 24.0,
          completedSets: [
            const WorkoutSet(
                setNumber: 1,
                weightKg: 24.0,
                reps: 12,
                rpe: 8.0,
                isCompleted: false),
            const WorkoutSet(
                setNumber: 2,
                weightKg: 24.0,
                reps: 11,
                rpe: 8.5,
                isCompleted: false),
            const WorkoutSet(
                setNumber: 3,
                weightKg: 24.0,
                reps: 10,
                rpe: 9.0,
                isCompleted: false),
          ],
        ),
        PlannedExercise(
          exercise: ExerciseDatabase.exercises[9], // Cable Lateral Raise
          targetSets: 4,
          targetRepsMin: 12,
          targetRepsMax: 15,
          suggestedWeightKg: 7.5,
          completedSets: [
            const WorkoutSet(
                setNumber: 1, weightKg: 7.5, reps: 15, isCompleted: false),
            const WorkoutSet(
                setNumber: 2, weightKg: 7.5, reps: 14, isCompleted: false),
            const WorkoutSet(
                setNumber: 3, weightKg: 7.5, reps: 12, isCompleted: false),
            const WorkoutSet(
                setNumber: 4, weightKg: 7.5, reps: 12, isCompleted: false),
          ],
        ),
        PlannedExercise(
          exercise: ExerciseDatabase.exercises[2], // Desi Dand (Hindu Pushups)
          targetSets: 3,
          targetRepsMin: 15,
          targetRepsMax: 20,
          suggestedWeightKg: 0.0,
          completedSets: [
            const WorkoutSet(
                setNumber: 1, weightKg: 0.0, reps: 20, isCompleted: false),
            const WorkoutSet(
                setNumber: 2, weightKg: 0.0, reps: 18, isCompleted: false),
            const WorkoutSet(
                setNumber: 3, weightKg: 0.0, reps: 15, isCompleted: false),
          ],
        ),
      ],
    );

    final pullSession = WorkoutSession(
      id: 'session_pull_1',
      title: 'Pull Power & Lats Density',
      regionalTitle: 'पुल पावर एवं पीठ सुदृढ़ीकरण',
      splitCategory: 'Pull Day (दिन २)',
      estimatedDurationMinutes: 48,
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      plannedExercises: const [],
    );

    final legsSession = WorkoutSession(
      id: 'session_legs_1',
      title: 'Legs & Akhara Baithak Conditioning',
      regionalTitle: 'लेग्स एवं अखाड़ा बैठक कंडीशनिंग',
      splitCategory: 'Legs Day (दिन ३)',
      estimatedDurationMinutes: 55,
      scheduledDate: DateTime.now().add(const Duration(days: 2)),
      plannedExercises: const [],
    );

    return WorkoutState(
      todaysSession: pushSession,
      weeklySchedule: [pushSession, pullSession, legsSession],
      isSessionActive: false,
      completedWorkoutsThisWeek: 3,
      totalVolumeTonnageThisWeek: 14250.0,
    );
  }

  void startWorkout() {
    state = state.copyWith(isSessionActive: true);
  }

  void completeWorkout() {
    final currentSession = state.todaysSession;
    final sessionVolume = currentSession.totalVolumeTonnage;

    state = state.copyWith(
      isSessionActive: false,
      completedWorkoutsThisWeek: state.completedWorkoutsThisWeek + 1,
      totalVolumeTonnageThisWeek:
          state.totalVolumeTonnageThisWeek + sessionVolume,
      clearRestTimer: true,
    );
  }

  void toggleSetCompletion(int exerciseIndex, int setIndex) {
    final session = state.todaysSession;
    final planned = List<PlannedExercise>.from(session.plannedExercises);
    if (exerciseIndex >= planned.length) return;

    final targetEx = planned[exerciseIndex];
    final sets = List<WorkoutSet>.from(targetEx.completedSets);
    if (setIndex >= sets.length) return;

    final currentSet = sets[setIndex];
    final isNowCompleted = !currentSet.isCompleted;

    sets[setIndex] = currentSet.copyWith(isCompleted: isNowCompleted);
    planned[exerciseIndex] = PlannedExercise(
      exercise: targetEx.exercise,
      targetSets: targetEx.targetSets,
      targetRepsMin: targetEx.targetRepsMin,
      targetRepsMax: targetEx.targetRepsMax,
      suggestedWeightKg: targetEx.suggestedWeightKg,
      completedSets: sets,
    );

    state = state.copyWith(
      todaysSession: WorkoutSession(
        id: session.id,
        title: session.title,
        regionalTitle: session.regionalTitle,
        splitCategory: session.splitCategory,
        estimatedDurationMinutes: session.estimatedDurationMinutes,
        plannedExercises: planned,
        scheduledDate: session.scheduledDate,
        isCompleted: session.isCompleted,
      ),
      activeRestTimerSeconds: isNowCompleted ? 90 : null,
      clearRestTimer: !isNowCompleted,
    );
  }

  void updateSetWeight(int exerciseIndex, int setIndex, double newWeight) {
    final session = state.todaysSession;
    final planned = List<PlannedExercise>.from(session.plannedExercises);
    if (exerciseIndex >= planned.length) return;

    final targetEx = planned[exerciseIndex];
    final sets = List<WorkoutSet>.from(targetEx.completedSets);
    if (setIndex >= sets.length) return;

    sets[setIndex] = sets[setIndex].copyWith(weightKg: newWeight);
    planned[exerciseIndex] = PlannedExercise(
      exercise: targetEx.exercise,
      targetSets: targetEx.targetSets,
      targetRepsMin: targetEx.targetRepsMin,
      targetRepsMax: targetEx.targetRepsMax,
      suggestedWeightKg: targetEx.suggestedWeightKg,
      completedSets: sets,
    );

    state = state.copyWith(
      todaysSession: WorkoutSession(
        id: session.id,
        title: session.title,
        regionalTitle: session.regionalTitle,
        splitCategory: session.splitCategory,
        estimatedDurationMinutes: session.estimatedDurationMinutes,
        plannedExercises: planned,
        scheduledDate: session.scheduledDate,
      ),
    );
  }

  void updateSetReps(int exerciseIndex, int setIndex, int newReps) {
    final session = state.todaysSession;
    final planned = List<PlannedExercise>.from(session.plannedExercises);
    if (exerciseIndex >= planned.length) return;

    final targetEx = planned[exerciseIndex];
    final sets = List<WorkoutSet>.from(targetEx.completedSets);
    if (setIndex >= sets.length) return;

    sets[setIndex] = sets[setIndex].copyWith(reps: newReps);
    planned[exerciseIndex] = PlannedExercise(
      exercise: targetEx.exercise,
      targetSets: targetEx.targetSets,
      targetRepsMin: targetEx.targetRepsMin,
      targetRepsMax: targetEx.targetRepsMax,
      suggestedWeightKg: targetEx.suggestedWeightKg,
      completedSets: sets,
    );

    state = state.copyWith(
      todaysSession: WorkoutSession(
        id: session.id,
        title: session.title,
        regionalTitle: session.regionalTitle,
        splitCategory: session.splitCategory,
        estimatedDurationMinutes: session.estimatedDurationMinutes,
        plannedExercises: planned,
        scheduledDate: session.scheduledDate,
      ),
    );
  }

  void addSet(int exerciseIndex) {
    final session = state.todaysSession;
    final planned = List<PlannedExercise>.from(session.plannedExercises);
    if (exerciseIndex >= planned.length) return;

    final targetEx = planned[exerciseIndex];
    final sets = List<WorkoutSet>.from(targetEx.completedSets);
    final lastSet = sets.isNotEmpty ? sets.last : null;

    final newSet = WorkoutSet(
      setNumber: sets.length + 1,
      weightKg: lastSet?.weightKg ?? targetEx.suggestedWeightKg,
      reps: lastSet?.reps ?? targetEx.targetRepsMin,
      rpe: 8.0,
      isCompleted: false,
    );

    sets.add(newSet);
    planned[exerciseIndex] = PlannedExercise(
      exercise: targetEx.exercise,
      targetSets: sets.length,
      targetRepsMin: targetEx.targetRepsMin,
      targetRepsMax: targetEx.targetRepsMax,
      suggestedWeightKg: targetEx.suggestedWeightKg,
      completedSets: sets,
    );

    state = state.copyWith(
      todaysSession: WorkoutSession(
        id: session.id,
        title: session.title,
        regionalTitle: session.regionalTitle,
        splitCategory: session.splitCategory,
        estimatedDurationMinutes: session.estimatedDurationMinutes,
        plannedExercises: planned,
        scheduledDate: session.scheduledDate,
      ),
    );
  }

  void clearRestTimer() {
    state = state.copyWith(clearRestTimer: true);
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  return WorkoutNotifier();
});
