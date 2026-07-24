/// §P9-A Social Screen — Notifier & State Management
///
/// Holds squad details, member readiness status lists, team average metrics,
/// active squad missions, and selected tab states matching §P9-A specification.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models (§P9-A Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum MemberReadinessLevel {
  high('High (Restored)', '🟩'),
  moderate('Moderate (Fatigued)', '🟨'),
  low('Low (Sleep Debt)', '🟥');

  const MemberReadinessLevel(this.label, this.indicatorEmoji);

  final String label;
  final String indicatorEmoji;
}

class SquadMemberStatus {
  const SquadMemberStatus({
    required this.id,
    required this.name,
    required this.readinessLevel,
    required this.readinessScore,
    required this.isCurrentUser,
  });

  final String id;
  final String name;
  final MemberReadinessLevel readinessLevel;
  final double readinessScore;
  final bool isCurrentUser;
}

class ActiveSquadMission {
  const ActiveSquadMission({
    required this.id,
    required this.title,
    required this.currentAverage,
    required this.targetPerMember,
    required this.unit,
  });

  final String id;
  final String title;
  final double currentAverage;
  final double targetPerMember;
  final String unit;

  double get percentComplete =>
      (currentAverage / targetPerMember).clamp(0.0, 1.0);

  int get percentCompleteInt => (percentComplete * 100).round();
}

class SquadState {
  const SquadState({
    required this.squadId,
    required this.squadName,
    required this.collectiveStreakDays,
    required this.averageReadinessScore,
    required this.isChallengeEligible,
    required this.members,
    required this.activeMission,
    required this.selectedTabIndex,
  });

  final String squadId;
  final String squadName;
  final int collectiveStreakDays;
  final double averageReadinessScore;
  final bool isChallengeEligible;
  final List<SquadMemberStatus> members;
  final ActiveSquadMission? activeMission;
  final int selectedTabIndex;

  SquadState copyWith({
    String? squadId,
    String? squadName,
    int? collectiveStreakDays,
    double? averageReadinessScore,
    bool? isChallengeEligible,
    List<SquadMemberStatus>? members,
    ActiveSquadMission? activeMission,
    int? selectedTabIndex,
  }) {
    return SquadState(
      squadId: squadId ?? this.squadId,
      squadName: squadName ?? this.squadName,
      collectiveStreakDays: collectiveStreakDays ?? this.collectiveStreakDays,
      averageReadinessScore: averageReadinessScore ?? this.averageReadinessScore,
      isChallengeEligible: isChallengeEligible ?? this.isChallengeEligible,
      members: members ?? this.members,
      activeMission: activeMission ?? this.activeMission,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class SocialNotifier extends Notifier<SquadState> {
  @override
  SquadState build() {
    const sampleMembers = [
      SquadMemberStatus(
        id: 'user_me',
        name: 'You',
        readinessLevel: MemberReadinessLevel.high,
        readinessScore: 88,
        isCurrentUser: true,
      ),
      SquadMemberStatus(
        id: 'user_priya',
        name: 'Priya',
        readinessLevel: MemberReadinessLevel.high,
        readinessScore: 84,
        isCurrentUser: false,
      ),
      SquadMemberStatus(
        id: 'user_amit',
        name: 'Amit',
        readinessLevel: MemberReadinessLevel.moderate,
        readinessScore: 68,
        isCurrentUser: false,
      ),
      SquadMemberStatus(
        id: 'user_rohan',
        name: 'Rohan',
        readinessLevel: MemberReadinessLevel.high,
        readinessScore: 82,
        isCurrentUser: false,
      ),
      SquadMemberStatus(
        id: 'user_sneha',
        name: 'Sneha',
        readinessLevel: MemberReadinessLevel.low,
        readinessScore: 48,
        isCurrentUser: false,
      ),
    ];

    const sampleMission = ActiveSquadMission(
      id: 'mission_1',
      title: 'Team Protein Target',
      currentAverage: 78,
      targetPerMember: 100,
      unit: 'g / member',
    );

    return const SquadState(
      squadId: 'sq_noida_shakers',
      squadName: 'Noida Ground Shakers',
      collectiveStreakDays: 14,
      averageReadinessScore: 74.0,
      isChallengeEligible: true,
      members: sampleMembers,
      activeMission: sampleMission,
      selectedTabIndex: 0,
    );
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }
}

final socialProvider =
    NotifierProvider<SocialNotifier, SquadState>(SocialNotifier.new);
