import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/decision_hierarchy.dart';
import '../../../core/brain/readiness_engine.dart';

class DailyMissionState {
  final MorningCheckIn checkIn;
  final ReadinessResult readiness;
  final double dailyStrain; // 0.0 to 21.0
  final double sleepHours;
  final List<DecisionAction> activeActions;

  const DailyMissionState({
    this.checkIn = const MorningCheckIn(),
    required this.readiness,
    this.dailyStrain = 8.5,
    this.sleepHours = 7.5,
    this.activeActions = const [],
  });

  DailyMissionState copyWith({
    MorningCheckIn? checkIn,
    ReadinessResult? readiness,
    double? dailyStrain,
    double? sleepHours,
    List<DecisionAction>? activeActions,
  }) {
    return DailyMissionState(
      checkIn: checkIn ?? this.checkIn,
      readiness: readiness ?? this.readiness,
      dailyStrain: dailyStrain ?? this.dailyStrain,
      sleepHours: sleepHours ?? this.sleepHours,
      activeActions: activeActions ?? this.activeActions,
    );
  }
}

class DailyMissionNotifier extends StateNotifier<DailyMissionState> {
  final ReadinessEngine _engine;
  final DecisionHierarchy _hierarchy;

  DailyMissionNotifier(this._engine, this._hierarchy)
      : super(
          DailyMissionState(
            readiness: const ReadinessEngine().calculateReadiness(
              checkIn: const MorningCheckIn(),
              sleepHours: 7.5,
            ),
          ),
        ) {
    _recalculateState();
  }

  void submitCheckIn(int energy, int soreness, int mood) {
    final updatedCheckIn = MorningCheckIn(
      energyLevel: energy,
      muscleSoreness: soreness,
      moodRating: mood,
      isCompleted: true,
    );

    state = state.copyWith(checkIn: updatedCheckIn);
    _recalculateState();
  }

  void _recalculateState() {
    final readinessResult = _engine.calculateReadiness(
      checkIn: state.checkIn,
      sleepHours: state.sleepHours,
      dailyStrain: state.dailyStrain,
    );

    final resolvedActions = _hierarchy.resolveActions(
      readinessScore: readinessResult.score,
      dailyStrain: state.dailyStrain,
    );

    state = state.copyWith(
      readiness: readinessResult,
      activeActions: resolvedActions,
    );
  }
}

final dailyMissionProvider =
    StateNotifierProvider<DailyMissionNotifier, DailyMissionState>((ref) {
  return DailyMissionNotifier(
    const ReadinessEngine(),
    const DecisionHierarchy(),
  );
});
