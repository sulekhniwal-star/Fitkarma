import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/exercise_database.dart';
import '../domain/workout_models.dart';

class WorkoutState {
  final WorkoutSession todaysSession;
  final List<WorkoutSession> weeklySchedule;
  final bool isSessionActive;
  final int completedWorkoutsThisWeek;
  final double totalVolumeTonnageThisWeek;

  const WorkoutState({
    required this.todaysSession,
    required this.weeklySchedule,
    this.isSessionActive = false,
    this.completedWorkoutsThisWeek = 3,
    this.totalVolumeTonnageThisWeek = 14250.0,
  });

  WorkoutState copyWith({
    WorkoutSession? todaysSession,
    List<WorkoutSession>? weeklySchedule,
    bool? isSessionActive,
    int? completedWorkoutsThisWeek,
    double? totalVolumeTonnageThisWeek,
  }) {
    return WorkoutState(
      todaysSession: todaysSession ?? this.todaysSession,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      completedWorkoutsThisWeek: completedWorkoutsThisWeek ?? this.completedWorkoutsThisWeek,
      totalVolumeTonnageThisWeek: totalVolumeTonnageThisWeek ?? this.totalVolumeTonnageThisWeek,
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
            const WorkoutSet(setNumber: 1, weightKg: 72.5, reps: 10, rpe: 8.0, isCompleted: true),
            const WorkoutSet(setNumber: 2, weightKg: 72.5, reps: 9, rpe: 8.5, isCompleted: true),
            const WorkoutSet(setNumber: 3, weightKg: 72.5, reps: 8, rpe: 9.0, isCompleted: false),
            const WorkoutSet(setNumber: 4, weightKg: 72.5, reps: 8, rpe: 9.5, isCompleted: false),
          ],
        ),
        PlannedExercise(
          exercise: ExerciseDatabase.exercises[1], // Incline Dumbbell Press
          targetSets: 3,
          targetRepsMin: 10,
          targetRepsMax: 12,
          suggestedWeightKg: 24.0,
          completedSets: [
            const WorkoutSet(setNumber: 1, weightKg: 24.0, reps: 12, rpe: 8.0, isCompleted: false),
            const WorkoutSet(setNumber: 2, weightKg: 24.0, reps: 11, rpe: 8.5, isCompleted: false),
            const WorkoutSet(setNumber: 3, weightKg: 24.0, reps: 10, rpe: 9.0, isCompleted: false),
          ],
        ),
        PlannedExercise(
          exercise: ExerciseDatabase.exercises[9], // Cable Lateral Raise
          targetSets: 4,
          targetRepsMin: 12,
          targetRepsMax: 15,
          suggestedWeightKg: 7.5,
          completedSets: [
            const WorkoutSet(setNumber: 1, weightKg: 7.5, reps: 15, isCompleted: false),
            const WorkoutSet(setNumber: 2, weightKg: 7.5, reps: 14, isCompleted: false),
            const WorkoutSet(setNumber: 3, weightKg: 7.5, reps: 12, isCompleted: false),
            const WorkoutSet(setNumber: 4, weightKg: 7.5, reps: 12, isCompleted: false),
          ],
        ),
        PlannedExercise(
          exercise: ExerciseDatabase.exercises[2], // Desi Dand (Hindu Pushups)
          targetSets: 3,
          targetRepsMin: 15,
          targetRepsMax: 20,
          suggestedWeightKg: 0.0,
          completedSets: [
            const WorkoutSet(setNumber: 1, weightKg: 0.0, reps: 20, isCompleted: false),
            const WorkoutSet(setNumber: 2, weightKg: 0.0, reps: 18, isCompleted: false),
            const WorkoutSet(setNumber: 3, weightKg: 0.0, reps: 15, isCompleted: false),
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
    state = state.copyWith(
      isSessionActive: false,
      completedWorkoutsThisWeek: state.completedWorkoutsThisWeek + 1,
    );
  }
}

final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  return WorkoutNotifier();
});
