import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SquadReadinessTier { high, moderate, low }

class SquadMemberStatus {
  final String userId;
  final String name;
  final SquadReadinessTier readinessTier;
  final bool hasLoggedToday;

  const SquadMemberStatus({
    required this.userId,
    required this.name,
    required this.readinessTier,
    required this.hasLoggedToday,
  });
}

class ActiveSquadMission {
  final String missionTitle;
  final double progressPercent; // 0.0 to 1.0
  final String targetStatusText;

  const ActiveSquadMission({
    required this.missionTitle,
    required this.progressPercent,
    required this.targetStatusText,
  });
}

class SquadState {
  final String squadId;
  final String squadName;
  final int collectiveStreakDays;
  final double averageReadinessScore;
  final bool isChallengeEligible; // True if >= 60% members are High readiness
  final List<SquadMemberStatus> members;
  final ActiveSquadMission? activeMission;
  final String nudgeMessage;

  const SquadState({
    required this.squadId,
    required this.squadName,
    required this.collectiveStreakDays,
    required this.averageReadinessScore,
    required this.isChallengeEligible,
    required this.members,
    this.activeMission,
    this.nudgeMessage = '',
  });

  factory SquadState.initial() {
    return SquadState(
      squadId: 'sq_01',
      squadName: 'Noida Fitness Warriors',
      collectiveStreakDays: 14,
      averageReadinessScore: 82.5,
      isChallengeEligible: true,
      members: const [
        SquadMemberStatus(userId: 'u1', name: 'You (Rahul)', readinessTier: SquadReadinessTier.high, hasLoggedToday: true),
        SquadMemberStatus(userId: 'u2', name: 'Priya M.', readinessTier: SquadReadinessTier.high, hasLoggedToday: true),
        SquadMemberStatus(userId: 'u3', name: 'Sneha K.', readinessTier: SquadReadinessTier.low, hasLoggedToday: false),
        SquadMemberStatus(userId: 'u4', name: 'Amit S.', readinessTier: SquadReadinessTier.moderate, hasLoggedToday: true),
      ],
      activeMission: const ActiveSquadMission(
        missionTitle: '⚡ 50,000 Step Squad Sprint',
        progressPercent: 0.78,
        targetStatusText: 'Current Total: 39,000 / 50,000 Steps (78% Done)',
      ),
      nudgeMessage: '',
    );
  }

  SquadState copyWith({
    String? squadId,
    String? squadName,
    int? collectiveStreakDays,
    double? averageReadinessScore,
    bool? isChallengeEligible,
    List<SquadMemberStatus>? members,
    ActiveSquadMission? activeMission,
    String? nudgeMessage,
  }) {
    return SquadState(
      squadId: squadId ?? this.squadId,
      squadName: squadName ?? this.squadName,
      collectiveStreakDays: collectiveStreakDays ?? this.collectiveStreakDays,
      averageReadinessScore: averageReadinessScore ?? this.averageReadinessScore,
      isChallengeEligible: isChallengeEligible ?? this.isChallengeEligible,
      members: members ?? this.members,
      activeMission: activeMission ?? this.activeMission,
      nudgeMessage: nudgeMessage ?? this.nudgeMessage,
    );
  }
}

/// SquadStateNotifier Riverpod Provider per §P9-A spec
class SquadStateNotifier extends StateNotifier<SquadState> {
  SquadStateNotifier() : super(SquadState.initial());

  void sendSquadNudge(String memberName, String action) {
    state = state.copyWith(
      nudgeMessage: 'Sent "$action" nudge to $memberName 🔥',
    );
  }

  void proposeChallenge(String challengeTitle) {
    if (!state.isChallengeEligible) {
      state = state.copyWith(
        nudgeMessage: 'Squad readiness is too low for a new challenge (requires >= 60% high readiness).',
      );
      return;
    }
    state = state.copyWith(
      activeMission: ActiveSquadMission(
        missionTitle: challengeTitle,
        progressPercent: 0.0,
        targetStatusText: 'Challenge started! Log workouts to progress.',
      ),
      nudgeMessage: 'Proposed new challenge: $challengeTitle 🚀',
    );
  }
}

final squadStateProvider =
    StateNotifierProvider<SquadStateNotifier, SquadState>((ref) {
  return SquadStateNotifier();
});
