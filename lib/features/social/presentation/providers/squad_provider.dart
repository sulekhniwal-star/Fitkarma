import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/squad_models.dart';

final squadDetailProvider =
    StateNotifierProvider<SquadDetailNotifier, SquadDetail>((ref) {
  return SquadDetailNotifier();
});

class SquadDetailNotifier extends StateNotifier<SquadDetail> {
  SquadDetailNotifier() : super(_buildInitialSquad());

  static SquadDetail _buildInitialSquad() {
    final members = [
      const SquadMemberDetail(
        memberId: 'user_you',
        name: 'You (Aap)',
        avatarInitials: 'You',
        role: SquadMemberRole.captain,
        locationCity: 'Bengaluru',
        todaySteps: 10450,
        dailyStepTarget: 10000,
        hasCompletedShatpawali: true,
        hasCompletedWorkout: true,
        hasLoggedNutrition: true,
        hasCheckedInToday: true,
        todayKarmaGenerated: 125,
        individualStreakDays: 19,
      ),
      const SquadMemberDetail(
        memberId: 'user_arjun',
        name: 'Arjun Kulkarni',
        avatarInitials: 'AK',
        role: SquadMemberRole.pacesetter,
        locationCity: 'Pune',
        todaySteps: 9200,
        dailyStepTarget: 8000,
        hasCompletedShatpawali: true,
        hasCompletedWorkout: true,
        hasLoggedNutrition: true,
        hasCheckedInToday: true,
        todayKarmaGenerated: 95,
        individualStreakDays: 22,
      ),
      const SquadMemberDetail(
        memberId: 'user_priya',
        name: 'Priya Sharma',
        avatarInitials: 'PS',
        role: SquadMemberRole.member,
        locationCity: 'Bengaluru',
        todaySteps: 11200,
        dailyStepTarget: 10000,
        hasCompletedShatpawali: true,
        hasCompletedWorkout: false,
        hasLoggedNutrition: true,
        hasCheckedInToday: true,
        todayKarmaGenerated: 80,
        individualStreakDays: 19,
      ),
      const SquadMemberDetail(
        memberId: 'user_rohit',
        name: 'Rohit Verma',
        avatarInitials: 'RV',
        role: SquadMemberRole.member,
        locationCity: 'Mumbai',
        todaySteps: 8400,
        dailyStepTarget: 8000,
        hasCompletedShatpawali: true,
        hasCompletedWorkout: true,
        hasLoggedNutrition: true,
        hasCheckedInToday: true,
        todayKarmaGenerated: 110,
        individualStreakDays: 19,
      ),
      const SquadMemberDetail(
        memberId: 'user_neha',
        name: 'Neha Mathur',
        avatarInitials: 'NM',
        role: SquadMemberRole.member,
        locationCity: 'Delhi NCR',
        todaySteps: 6800,
        dailyStepTarget: 8000,
        hasCompletedShatpawali: false,
        hasCompletedWorkout: true,
        hasLoggedNutrition: true,
        hasCheckedInToday: true,
        todayKarmaGenerated: 65,
        individualStreakDays: 16,
      ),
    ];

    final challenge = SquadChallengeGoal(
      id: 'squad_challenge_1m_steps',
      title: 'Weekly 500,000 Step Squad Challenge',
      regionalTitle: 'साप्ताहिक ५ लाख कदम सामूहिक संकल्प',
      description: 'Collective step milestone for all 5 squad members this week.',
      targetQuantity: 500000,
      currentQuantity: 342000,
      unit: 'steps',
      deadline: DateTime.now().add(const Duration(days: 3)),
      karmaRewardPool: 1500,
    );

    return SquadDetail(
      squadId: 'squad_vayuprecision',
      squadName: 'Vayu Pacesetters (वायु साधक दल)',
      regionalSquadName: 'वायु साधक दल (५ सदस्य)',
      manifesto: 'We move daily, practice post-meal Shatpawali, and leave no member behind.',
      regionalManifesto: 'हम प्रतिदिन गतिशीलता बनाए रखते हैं, शतपावली करते हैं और किसी साथी को पीछे नहीं छोड़ते।',
      creatorId: 'user_you',
      tier: SquadTier.vanguard,
      currentStreakDays: 19,
      bestStreakDays: 24,
      availableSanjeevaniShields: 2,
      totalCollectiveKarma: 12450,
      members: members,
      activeChallenge: challenge,
    );
  }

  void checkInSelf() {
    final updatedMembers = state.members.map((m) {
      if (m.memberId == 'user_you') {
        return SquadMemberDetail(
          memberId: m.memberId,
          name: m.name,
          avatarInitials: m.avatarInitials,
          role: m.role,
          locationCity: m.locationCity,
          todaySteps: m.todaySteps + 100,
          dailyStepTarget: m.dailyStepTarget,
          hasCompletedShatpawali: true,
          hasCompletedWorkout: true,
          hasLoggedNutrition: true,
          hasCheckedInToday: true,
          todayKarmaGenerated: m.todayKarmaGenerated + 15,
          individualStreakDays: m.individualStreakDays + 1,
        );
      }
      return m;
    }).toList();

    state = state.copyWith(members: updatedMembers);
  }

  void useSanjeevaniShield() {
    if (state.availableSanjeevaniShields > 0) {
      state = state.copyWith(
        availableSanjeevaniShields: state.availableSanjeevaniShields - 1,
      );
    }
  }

  void cheerMember(String memberId) {
    final updatedMembers = state.members.map((m) {
      if (m.memberId == memberId) {
        return SquadMemberDetail(
          memberId: m.memberId,
          name: m.name,
          avatarInitials: m.avatarInitials,
          role: m.role,
          locationCity: m.locationCity,
          todaySteps: m.todaySteps,
          dailyStepTarget: m.dailyStepTarget,
          hasCompletedShatpawali: m.hasCompletedShatpawali,
          hasCompletedWorkout: m.hasCompletedWorkout,
          hasLoggedNutrition: m.hasLoggedNutrition,
          hasCheckedInToday: m.hasCheckedInToday,
          todayKarmaGenerated: m.todayKarmaGenerated + 5,
          individualStreakDays: m.individualStreakDays,
        );
      }
      return m;
    }).toList();

    state = state.copyWith(members: updatedMembers);
  }
}
