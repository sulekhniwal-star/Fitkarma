import 'dart:math';

enum SquadMissionType {
  proteinSprint,
  consistencyRun,
  readinessBoost,
}

class SquadMissionSpec {
  final SquadMissionType type;
  final String title;
  final double progressPercent;
  final String targetStatusText;
  final int collectiveXpReward;

  const SquadMissionSpec({
    required this.type,
    required this.title,
    required this.progressPercent,
    required this.targetStatusText,
    required this.collectiveXpReward,
  });
}

class SquadMemberPrivacyStatus {
  final String userId;
  final String name;
  final String readinessTierLabel; // High / Moderate / Low (NO raw numerical score shared!)
  final bool hasLoggedToday;

  const SquadMemberPrivacyStatus({
    required this.userId,
    required this.name,
    required this.readinessTierLabel,
    required this.hasLoggedToday,
  });
}

class SquadSystemEvaluation {
  final String squadId;
  final String squadName;
  final int memberCount;
  final bool isSizeValid; // ADR-022: Must be 3-8 members
  final int collectiveStreakDays;
  final double teamAverageRecoveryScore;
  final bool isSquadChallengeEligible; // >= 60% members at High readiness
  final bool isRestPaused; // True if team avg recovery < 50
  final List<SquadMemberPrivacyStatus> members;
  final SquadMissionSpec activeMission;
  final int squadLevel;
  final int collectiveXpPool;

  const SquadSystemEvaluation({
    required this.squadId,
    required this.squadName,
    required this.memberCount,
    required this.isSizeValid,
    required this.collectiveStreakDays,
    required this.teamAverageRecoveryScore,
    required this.isSquadChallengeEligible,
    required this.isRestPaused,
    required this.members,
    required this.activeMission,
    required this.squadLevel,
    required this.collectiveXpPool,
  });
}

/// Pure-Dart Squad System Engine per §P9-B spec
class SquadSystemEngine {
  const SquadSystemEngine();

  /// Validates squad size bounds (ADR-022: 3-8 members, >8 reduces accountability)
  bool validateSquadSize(int count) {
    return count >= 3 && count <= 8;
  }

  /// Evaluates full squad metrics, challenge eligibility, recovery pauses, and mission generation
  SquadSystemEvaluation evaluateSquad({
    required String squadId,
    required String squadName,
    required List<double> memberReadinessScores,
    required List<bool> memberLoggedTodayList,
    required List<String> memberNames,
    required int streakDays,
    required int currentCollectiveXp,
  }) {
    final memberCount = memberReadinessScores.length;
    final isSizeValid = validateSquadSize(memberCount);

    double totalReadiness = 0.0;
    int highCount = 0;
    final List<SquadMemberPrivacyStatus> statuses = [];

    for (int i = 0; i < memberCount; i++) {
      final score = memberReadinessScores[i];
      final name = memberNames.length > i ? memberNames[i] : 'Member ${i + 1}';
      final hasLogged = memberLoggedTodayList.length > i ? memberLoggedTodayList[i] : false;

      totalReadiness += score;

      String tierLabel = 'Moderate';
      if (score >= 80.0) {
        tierLabel = 'High';
        highCount++;
      } else if (score < 60.0) {
        tierLabel = 'Low';
      }

      statuses.add(
        SquadMemberPrivacyStatus(
          userId: 'u_$i',
          name: name,
          readinessTierLabel: tierLabel,
          hasLoggedToday: hasLogged,
        ),
      );
    }

    final avgRecovery = memberCount > 0 ? (totalReadiness / memberCount) : 70.0;
    final isChallengeEligible = memberCount > 0 ? (highCount / memberCount) >= 0.60 : false;
    final isRestPaused = avgRecovery < 50.0;

    // Mission Generation from Aggregate Data
    final mission = generateSquadMission(
      avgRecovery: avgRecovery,
      highReadinessRatio: memberCount > 0 ? (highCount / memberCount) : 0.0,
    );

    // Squad Level Progression from Collective XP Pool
    final squadLevel = (currentCollectiveXp / 1000).floor() + 1;

    return SquadSystemEvaluation(
      squadId: squadId,
      squadName: squadName,
      memberCount: memberCount,
      isSizeValid: isSizeValid,
      collectiveStreakDays: streakDays,
      teamAverageRecoveryScore: double.parse(avgRecovery.toStringAsFixed(1)),
      isSquadChallengeEligible: isChallengeEligible,
      isRestPaused: isRestPaused,
      members: statuses,
      activeMission: mission,
      squadLevel: squadLevel,
      collectiveXpPool: currentCollectiveXp,
    );
  }

  /// Generates dynamic Squad Mission from aggregate readiness and compliance
  SquadMissionSpec generateSquadMission({
    required double avgRecovery,
    required double highReadinessRatio,
  }) {
    if (avgRecovery < 50.0) {
      return const SquadMissionSpec(
        type: SquadMissionType.readinessBoost,
        title: '🧘 Squad Active Recovery Sprint',
        progressPercent: 0.40,
        targetStatusText: 'Team Recovery < 50%. Focus on 8h sleep & gentle walking.',
        collectiveXpReward: 300,
      );
    }

    if (highReadinessRatio >= 0.60) {
      return const SquadMissionSpec(
        type: SquadMissionType.proteinSprint,
        title: '⚡ Team Protein Challenge (100g / member)',
        progressPercent: 0.78,
        targetStatusText: 'Squad Avg: 78g / 100g Target (78% Done)',
        collectiveXpReward: 500,
      );
    }

    return const SquadMissionSpec(
      type: SquadMissionType.consistencyRun,
      title: '🔥 3-Day Squad Consistency Run',
      progressPercent: 0.66,
      targetStatusText: 'Day 2 of 3 complete. All members logged activity!',
      collectiveXpReward: 400,
    );
  }

  /// Generates 6-character uppercase squad invite code
  String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
