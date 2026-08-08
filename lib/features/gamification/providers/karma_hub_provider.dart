import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/gamification_engine.dart';
import '../models/achievement.dart';

class KarmaEventRecord {
  final String title;
  final int xpAwarded;
  final DateTime timestamp;

  const KarmaEventRecord({
    required this.title,
    required this.xpAwarded,
    required this.timestamp,
  });
}

class KarmaHubState {
  final int totalXp;
  final LevelResult levelInfo;
  final List<Achievement> achievements;
  final List<CohortBenchmark> benchmarks;
  final List<KarmaEventRecord> recentEvents;
  final int cohortRank;
  final int totalCohortMembers;
  final int cohortPercentile;

  const KarmaHubState({
    required this.totalXp,
    required this.levelInfo,
    required this.achievements,
    required this.benchmarks,
    required this.recentEvents,
    required this.cohortRank,
    required this.totalCohortMembers,
    required this.cohortPercentile,
  });

  factory KarmaHubState.initial() {
    const engine = GamificationEngine();
    final lvl = engine.calculateLevel(1450);
    return KarmaHubState(
      totalXp: 1450,
      levelInfo: lvl,
      achievements: const [
        Achievement(
          id: 'a1',
          title: 'Prote-King',
          description: 'Met daily protein target 7 days in a row',
          iconName: 'restaurant',
          isUnlocked: true,
          category: 'Nutrition (+50 XP)',
        ),
        Achievement(
          id: 'a2',
          title: 'Sleepy-Head',
          description: 'Logged 7h+ sleep for 7 consecutive days',
          iconName: 'single_bed',
          isUnlocked: true,
          category: 'Sleep (+80 XP)',
        ),
        Achievement(
          id: 'a3',
          title: 'Rep-Master',
          description: 'Completed squat session with zero asymmetry faults',
          iconName: 'fitness_center',
          isUnlocked: false,
          category: 'Form (+100 XP)',
        ),
        Achievement(
          id: 'a4',
          title: 'Phase-Master',
          description: 'Completed 12-week Corporate Fat Loss program',
          iconName: 'emoji_events',
          isUnlocked: false,
          category: 'Milestone (+150 XP)',
        ),
      ],
      benchmarks: const [
        CohortBenchmark(
          metricName: 'Weekly Consistency',
          userPercentile: 'Top 18%',
          cohortName: 'Noida Builders Cohort',
        ),
        CohortBenchmark(
          metricName: 'Protein Target Adherence',
          userPercentile: 'Top 14%',
          cohortName: 'Active Male 25-30 Cohort',
        ),
      ],
      recentEvents: [
        KarmaEventRecord(title: 'Readiness Streak 7d', xpAwarded: 100, timestamp: DateTime.now().subtract(const Duration(hours: 4))),
        KarmaEventRecord(title: '7-Day Sleep Streak', xpAwarded: 80, timestamp: DateTime.now().subtract(const Duration(days: 1))),
        KarmaEventRecord(title: 'Protein Target Achieved', xpAwarded: 50, timestamp: DateTime.now().subtract(const Duration(days: 2))),
      ],
      cohortRank: 142,
      totalCohortMembers: 4210,
      cohortPercentile: 82,
    );
  }

  KarmaHubState copyWith({
    int? totalXp,
    LevelResult? levelInfo,
    List<Achievement>? achievements,
    List<CohortBenchmark>? benchmarks,
    List<KarmaEventRecord>? recentEvents,
    int? cohortRank,
    int? totalCohortMembers,
    int? cohortPercentile,
  }) {
    return KarmaHubState(
      totalXp: totalXp ?? this.totalXp,
      levelInfo: levelInfo ?? this.levelInfo,
      achievements: achievements ?? this.achievements,
      benchmarks: benchmarks ?? this.benchmarks,
      recentEvents: recentEvents ?? this.recentEvents,
      cohortRank: cohortRank ?? this.cohortRank,
      totalCohortMembers: totalCohortMembers ?? this.totalCohortMembers,
      cohortPercentile: cohortPercentile ?? this.cohortPercentile,
    );
  }
}

/// KarmaHubNotifier per §P7-B spec
class KarmaHubNotifier extends StateNotifier<KarmaHubState> {
  final GamificationEngine _engine;

  KarmaHubNotifier(this._engine) : super(KarmaHubState.initial());

  void awardOutcomeXp(String actionType, {String? customEventTitle}) {
    final reward = _engine.getOutcomeXpReward(actionType);
    if (reward > 0) {
      final newXp = state.totalXp + reward;
      final newLevel = _engine.calculateLevel(newXp, previousLevel: state.levelInfo.currentLevel);

      final eventTitle = customEventTitle ?? actionType.replaceAll('_', ' ').toUpperCase();
      final newEvent = KarmaEventRecord(
        title: eventTitle,
        xpAwarded: reward,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        totalXp: newXp,
        levelInfo: newLevel,
        recentEvents: [newEvent, ...state.recentEvents],
      );
    }
  }

  void unlockAchievement(String achievementId) {
    final updated = state.achievements.map((a) {
      if (a.id == achievementId) {
        return Achievement(
          id: a.id,
          title: a.title,
          description: a.description,
          iconName: a.iconName,
          isUnlocked: true,
          category: a.category,
        );
      }
      return a;
    }).toList();

    state = state.copyWith(achievements: updated);
  }
}

// Riverpod Provider Registration
final karmaHubProvider =
    StateNotifierProvider<KarmaHubNotifier, KarmaHubState>((ref) {
  return KarmaHubNotifier(const GamificationEngine());
});
