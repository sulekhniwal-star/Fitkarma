/// §P6-A Workout State Controller
///
/// Riverpod Notifier managing active program overview, today's workout session,
/// progressive overload badges, and recent workout history.
library;

import 'package:fitkarma/features/workout/workout_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class WorkoutState {
  const WorkoutState({
    required this.activeProgram,
    required this.todaysSession,
    required this.recentHistory,
    this.isWorkoutActive = false,
  });

  final WorkoutProgram activeProgram;
  final WorkoutSession todaysSession;
  final List<WorkoutHistoryItem> recentHistory;
  final bool isWorkoutActive;

  WorkoutState copyWith({
    WorkoutProgram? activeProgram,
    WorkoutSession? todaysSession,
    List<WorkoutHistoryItem>? recentHistory,
    bool? isWorkoutActive,
  }) {
    return WorkoutState(
      activeProgram: activeProgram ?? this.activeProgram,
      todaysSession: todaysSession ?? this.todaysSession,
      recentHistory: recentHistory ?? this.recentHistory,
      isWorkoutActive: isWorkoutActive ?? this.isWorkoutActive,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

class WorkoutNotifier extends Notifier<WorkoutState> {
  static const defaultProgram = WorkoutProgram(
    id: 'prog_1',
    title: 'Corporate Fat Loss',
    currentWeek: 4,
    currentDay: 2,
    totalWeeks: 8,
    completedDaysThisWeek: 2,
    targetDaysPerWeek: 4,
  );

  static const defaultSession = WorkoutSession(
    id: 'session_1',
    title: 'Upper Body Power & Hypertrophy',
    durationMinutes: 45,
    progressionBadgeText: 'Suggesting +2.5kg on Bench Press today 🏋️',
    exercises: [
      ExerciseSummary(
        name: 'Barbell Bench Press',
        targetSets: 4,
        targetReps: '8-10',
        suggestedWeightKg: 72.5,
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

  static final defaultHistory = [
    WorkoutHistoryItem(
      id: 'h_1',
      sessionTitle: 'Lower Body Core',
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
      durationMinutes: 50,
      totalSets: 16,
      totalVolumeKg: 4200.0,
    ),
    WorkoutHistoryItem(
      id: 'h_2',
      sessionTitle: 'Upper Body Pull',
      completedAt: DateTime.now().subtract(const Duration(days: 3)),
      durationMinutes: 45,
      totalSets: 14,
      totalVolumeKg: 3800.0,
    ),
  ];

  @override
  WorkoutState build() {
    return WorkoutState(
      activeProgram: defaultProgram,
      todaysSession: defaultSession,
      recentHistory: defaultHistory,
    );
  }

  /// Starts today's workout session.
  void startWorkout() {
    state = state.copyWith(isWorkoutActive: true);
  }

  /// Ends and completes active workout session.
  void completeWorkout() {
    final newHistoryItem = WorkoutHistoryItem(
      id: 'h_${DateTime.now().millisecondsSinceEpoch}',
      sessionTitle: state.todaysSession.title,
      completedAt: DateTime.now(),
      durationMinutes: state.todaysSession.durationMinutes,
      totalSets: state.todaysSession.totalSets,
      totalVolumeKg: 4500.0,
    );

    final updatedHistory = List<WorkoutHistoryItem>.from(state.recentHistory)
      ..insert(0, newHistoryItem);
    final updatedProgram = WorkoutProgram(
      id: state.activeProgram.id,
      title: state.activeProgram.title,
      currentWeek: state.activeProgram.currentWeek,
      currentDay: state.activeProgram.currentDay,
      totalWeeks: state.activeProgram.totalWeeks,
      completedDaysThisWeek: (state.activeProgram.completedDaysThisWeek + 1)
          .clamp(0, state.activeProgram.targetDaysPerWeek),
      targetDaysPerWeek: state.activeProgram.targetDaysPerWeek,
    );

    state = state.copyWith(
      isWorkoutActive: false,
      activeProgram: updatedProgram,
      recentHistory: updatedHistory,
    );
  }
}

final workoutProvider = NotifierProvider<WorkoutNotifier, WorkoutState>(
  WorkoutNotifier.new,
);
