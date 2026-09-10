import 'package:flutter/foundation.dart';

/// Tier level of the Squad based on collective discipline and streak longevity
enum SquadTier {
  arambha(
    tierNumber: 1,
    title: 'Arambha Squad (Initiates)',
    regionalTitle: 'आरंभिक दल (प्राथमिक स्तर)',
    multiplier: 1.0,
    requiredStreakDays: 0,
    badgeColorCode: 0xFFFF9100,
  ),
  abhyasi(
    tierNumber: 2,
    title: 'Pacesetter Squad (Prerak)',
    regionalTitle: 'गतिशील साधक दल',
    multiplier: 1.15,
    requiredStreakDays: 7,
    badgeColorCode: 0xFF00B0FF,
  ),
  vanguard(
    tierNumber: 3,
    title: 'Vanguard Squad (Agrani)',
    regionalTitle: 'अग्रणी दल (उच्च निष्ठा)',
    multiplier: 1.25,
    requiredStreakDays: 14,
    badgeColorCode: 0xFF00E676,
  ),
  mahasangha(
    tierNumber: 4,
    title: 'Mahasangha (Luminary)',
    regionalTitle: 'महासंग दल (सर्वोच्च सिद्धि)',
    multiplier: 1.35,
    requiredStreakDays: 30,
    badgeColorCode: 0xFFFFD700,
  );

  final int tierNumber;
  final String title;
  final String regionalTitle;
  final double multiplier;
  final int requiredStreakDays;
  final int badgeColorCode;

  const SquadTier({
    required this.tierNumber,
    required this.title,
    required this.regionalTitle,
    required this.multiplier,
    required this.requiredStreakDays,
    required this.badgeColorCode,
  });
}

/// Member role within the squad
enum SquadMemberRole {
  captain(title: 'Captain (Karyakarta)', regionalTitle: 'दल नायक'),
  pacesetter(title: 'Pacesetter (Agrani)', regionalTitle: 'गति प्रणेता'),
  member(title: 'Sadhak (Member)', regionalTitle: 'साधक');

  final String title;
  final String regionalTitle;

  const SquadMemberRole({
    required this.title,
    required this.regionalTitle,
  });
}

/// Individual squad member state and daily check-in summary
@immutable
class SquadMemberDetail {
  final String memberId;
  final String name;
  final String avatarInitials;
  final SquadMemberRole role;
  final String locationCity;
  final int todaySteps;
  final int dailyStepTarget;
  final bool hasCompletedShatpawali;
  final bool hasCompletedWorkout;
  final bool hasLoggedNutrition;
  final bool hasCheckedInToday;
  final int todayKarmaGenerated;
  final int individualStreakDays;

  const SquadMemberDetail({
    required this.memberId,
    required this.name,
    required this.avatarInitials,
    required this.role,
    required this.locationCity,
    required this.todaySteps,
    required this.dailyStepTarget,
    required this.hasCompletedShatpawali,
    required this.hasCompletedWorkout,
    required this.hasLoggedNutrition,
    required this.hasCheckedInToday,
    required this.todayKarmaGenerated,
    required this.individualStreakDays,
  });

  double get stepProgressFraction =>
      (todaySteps / dailyStepTarget).clamp(0.0, 1.0);

  int get completedRingsCount {
    int count = 0;
    if (todaySteps >= dailyStepTarget) count++;
    if (hasCompletedShatpawali) count++;
    if (hasCompletedWorkout) count++;
    if (hasLoggedNutrition) count++;
    return count;
  }
}

/// Active collective squad challenge (Sanghathon)
@immutable
class SquadChallengeGoal {
  final String id;
  final String title;
  final String regionalTitle;
  final String description;
  final double targetQuantity;
  final double currentQuantity;
  final String unit;
  final DateTime deadline;
  final int karmaRewardPool;

  const SquadChallengeGoal({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.targetQuantity,
    required this.currentQuantity,
    required this.unit,
    required this.deadline,
    required this.karmaRewardPool,
  });

  double get progressFraction =>
      (currentQuantity / targetQuantity).clamp(0.0, 1.0);
  double get progressPercentage => progressFraction * 100.0;
}

/// Comprehensive Squad Detail state
@immutable
class SquadDetail {
  final String squadId;
  final String squadName;
  final String regionalSquadName;
  final String manifesto;
  final String regionalManifesto;
  final String creatorId;
  final SquadTier tier;
  final int currentStreakDays;
  final int bestStreakDays;
  final int availableSanjeevaniShields; // Streak rescue pass count
  final int totalCollectiveKarma;
  final List<SquadMemberDetail> members;
  final SquadChallengeGoal activeChallenge;

  const SquadDetail({
    required this.squadId,
    required this.squadName,
    required this.regionalSquadName,
    required this.manifesto,
    required this.regionalManifesto,
    required this.creatorId,
    required this.tier,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.availableSanjeevaniShields,
    required this.totalCollectiveKarma,
    required this.members,
    required this.activeChallenge,
  });

  int get totalMembersCount => members.length;
  int get checkedInMembersCount =>
      members.where((m) => m.hasCheckedInToday).length;
  double get squadCheckInRate => totalMembersCount > 0
      ? (checkedInMembersCount / totalMembersCount) * 100.0
      : 0.0;
  bool get isSquadStreakCompleteToday =>
      checkedInMembersCount == totalMembersCount;

  SquadDetail copyWith({
    SquadTier? tier,
    int? currentStreakDays,
    int? bestStreakDays,
    int? availableSanjeevaniShields,
    int? totalCollectiveKarma,
    List<SquadMemberDetail>? members,
    SquadChallengeGoal? activeChallenge,
  }) {
    return SquadDetail(
      squadId: squadId,
      squadName: squadName,
      regionalSquadName: regionalSquadName,
      manifesto: manifesto,
      regionalManifesto: regionalManifesto,
      creatorId: creatorId,
      tier: tier ?? this.tier,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      bestStreakDays: bestStreakDays ?? this.bestStreakDays,
      availableSanjeevaniShields:
          availableSanjeevaniShields ?? this.availableSanjeevaniShields,
      totalCollectiveKarma: totalCollectiveKarma ?? this.totalCollectiveKarma,
      members: members ?? this.members,
      activeChallenge: activeChallenge ?? this.activeChallenge,
    );
  }
}
