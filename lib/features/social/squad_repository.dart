/// §P9-B Squad System — Persistence Repository
///
/// In-memory repository for persisting SquadGroups, SquadMembers, SquadMissions,
/// and SquadChallenges matching §P9-B spec.
library;

import 'package:fitkarma/features/social/squad_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SquadRepository {
  final SquadEngine _engine = const SquadEngine();

  final SquadGroup _squad = SquadGroup(
    squadId: 'sq_noida_shakers',
    squadName: 'Noida Ground Shakers',
    creatorId: 'user_me',
    collectiveStreakDays: 14,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  );

  final List<SquadMemberItem> _members = const [
    SquadMemberItem(
      userId: 'user_me',
      squadId: 'sq_noida_shakers',
      name: 'You',
      readinessScore: 88.0,
      hasLoggedToday: true,
      isCurrentUser: true,
    ),
    SquadMemberItem(
      userId: 'user_priya',
      squadId: 'sq_noida_shakers',
      name: 'Priya',
      readinessScore: 84.0,
      hasLoggedToday: true,
    ),
    SquadMemberItem(
      userId: 'user_amit',
      squadId: 'sq_noida_shakers',
      name: 'Amit',
      readinessScore: 68.0,
      hasLoggedToday: true,
    ),
    SquadMemberItem(
      userId: 'user_rohan',
      squadId: 'sq_noida_shakers',
      name: 'Rohan',
      readinessScore: 82.0,
      hasLoggedToday: false,
    ),
    SquadMemberItem(
      userId: 'user_sneha',
      squadId: 'sq_noida_shakers',
      name: 'Sneha',
      readinessScore: 48.0,
      hasLoggedToday: false,
    ),
  ];

  SquadMissionData _activeMission = const SquadMissionData(
    id: 'mission_1',
    squadId: 'sq_noida_shakers',
    title: 'Team Protein Challenge',
    description: 'Hit 100g daily protein average per member',
    targetMetricValue: 100.0,
    currentAverageValue: 78.0,
    unit: 'g / member',
  );

  SquadGroup get squad => _squad;
  List<SquadMemberItem> get members => List.unmodifiable(_members);
  SquadMissionData get activeMission => _activeMission;

  double get averageReadiness => _engine.computeAverageReadiness(_members);
  bool get isChallengeEligible => _engine.isChallengeEligible(_members);

  /// Nudges a specific lagging member.
  void sendNudge(String userId) {
    // In-memory nudge log action
  }

  /// Updates active mission progress.
  void updateMissionProgress(double newAverage) {
    _activeMission = SquadMissionData(
      id: _activeMission.id,
      squadId: _activeMission.squadId,
      title: _activeMission.title,
      description: _activeMission.description,
      targetMetricValue: _activeMission.targetMetricValue,
      currentAverageValue: newAverage,
      unit: _activeMission.unit,
    );
  }
}

final squadRepositoryProvider = Provider<SquadRepository>((_) {
  return SquadRepository();
});
