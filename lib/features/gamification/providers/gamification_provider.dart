import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/gamification_engine.dart';
import '../models/achievement.dart';

class GamificationState {
  final int totalXp;
  final LevelResult levelInfo;
  final List<Achievement> achievements;
  final List<CohortBenchmark> benchmarks;

  const GamificationState({
    this.totalXp = 450,
    required this.levelInfo,
    this.achievements = const [
      Achievement(
          id: 'a1',
          title: 'First Workout Complete',
          description: 'Finished 1 full workout session',
          iconName: 'fitness_center',
          isUnlocked: true,
          category: 'Workout'),
      Achievement(
          id: 'a2',
          title: 'Protein Master',
          description: 'Met daily protein target 5 times',
          iconName: 'restaurant',
          isUnlocked: true,
          category: 'Nutrition'),
      Achievement(
          id: 'a3',
          title: '7-Day Consistency',
          description: 'Achieved 7-day readiness streak',
          iconName: 'local_fire_department',
          isUnlocked: false,
          category: 'Streak'),
      Achievement(
          id: 'a4',
          title: 'MediaPipe Master',
          description: 'Completed squat session with zero asymmetry faults',
          iconName: 'camera',
          isUnlocked: false,
          category: 'Form'),
    ],
    this.benchmarks = const [
      CohortBenchmark(
          metricName: 'Weekly Consistency',
          userPercentile: 'Top 12%',
          cohortName: 'Indian Age 25-30 Cohort'),
      CohortBenchmark(
          metricName: 'Protein Target Adherence',
          userPercentile: 'Top 18%',
          cohortName: 'Active Male Cohort'),
    ],
  });

  GamificationState copyWith({
    int? totalXp,
    LevelResult? levelInfo,
    List<Achievement>? achievements,
    List<CohortBenchmark>? benchmarks,
  }) {
    return GamificationState(
      totalXp: totalXp ?? this.totalXp,
      levelInfo: levelInfo ?? this.levelInfo,
      achievements: achievements ?? this.achievements,
      benchmarks: benchmarks ?? this.benchmarks,
    );
  }
}

class GamificationNotifier extends StateNotifier<GamificationState> {
  final GamificationEngine _engine;

  GamificationNotifier(this._engine)
      : super(
          GamificationState(
            levelInfo: const GamificationEngine().calculateLevel(450),
          ),
        );

  void awardOutcomeXp(String actionType) {
    final reward = _engine.getOutcomeXpReward(actionType);
    if (reward > 0) {
      final newXp = state.totalXp + reward;
      final newLevel = _engine.calculateLevel(newXp,
          previousLevel: state.levelInfo.currentLevel);
      state = state.copyWith(totalXp: newXp, levelInfo: newLevel);
    }
  }
}

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier(const GamificationEngine());
});
