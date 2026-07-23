/// §P7-B Karma Hub Screen — Notifier & State Management
///
/// Holds user gamification state including level, progress ratio, badges,
/// demographic cohort comparison, and activity history matching §P7-B spec.
library;

import 'package:fitkarma/features/karma/karma_models.dart';
import 'package:fitkarma/features/karma/karma_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

class KarmaAchievement {
  const KarmaAchievement({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconSymbol,
    required this.isUnlocked,
    required this.progressPercentage,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconSymbol;
  final bool isUnlocked;
  final double progressPercentage; // 0.0 to 1.0
}

class KarmaHubState {
  const KarmaHubState({
    required this.totalXp,
    required this.currentLevelNumber,
    required this.levelName,
    required this.progressToNextLevel,
    required this.xpInCurrentLevel,
    required this.xpNeededForNextLevel,
    required this.achievements,
    required this.cohortPercentile,
    required this.cohortRank,
    required this.totalCohortMembers,
    required this.cohortName,
    required this.recentEvents,
  });

  final int totalXp;
  final int currentLevelNumber;
  final String levelName;
  final double progressToNextLevel;
  final int xpInCurrentLevel;
  final int xpNeededForNextLevel;
  final List<KarmaAchievement> achievements;
  final int cohortPercentile;
  final int cohortRank;
  final int totalCohortMembers;
  final String cohortName;
  final List<KarmaEventRecord> recentEvents;
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class KarmaHubNotifier extends Notifier<KarmaHubState> {
  @override
  KarmaHubState build() {
    final repository = ref.watch(karmaRepositoryProvider);
    final profile = repository.profileSummary;

    // Default sample achievements
    final sampleAchievements = [
      const KarmaAchievement(
        id: 'prote_king',
        title: 'Prote-King',
        subtitle: 'Protein Hit 7d',
        iconSymbol: '🏆',
        isUnlocked: true,
        progressPercentage: 1.0,
      ),
      const KarmaAchievement(
        id: 'sleepy_head',
        title: 'Sleepy-Head',
        subtitle: 'Sleep >= 7h 7d',
        iconSymbol: '🏆',
        isUnlocked: true,
        progressPercentage: 1.0,
      ),
      const KarmaAchievement(
        id: 'rep_master',
        title: 'Rep-Master',
        subtitle: '100 Reps Form',
        iconSymbol: '🔒',
        isUnlocked: false,
        progressPercentage: 0.45,
      ),
    ];

    return KarmaHubState(
      totalXp: profile.totalXp,
      currentLevelNumber: profile.currentLevel.levelNumber,
      levelName: profile.currentLevel.name,
      progressToNextLevel: profile.progressToNextLevel,
      xpInCurrentLevel: profile.xpInCurrentLevel,
      xpNeededForNextLevel: profile.xpNeededForNextLevel,
      achievements: sampleAchievements,
      cohortPercentile: 82,
      cohortRank: 142,
      totalCohortMembers: 4210,
      cohortName: 'Noida Builders',
      recentEvents: repository.eventHistory,
    );
  }
}

final karmaHubProvider =
    NotifierProvider<KarmaHubNotifier, KarmaHubState>(KarmaHubNotifier.new);
