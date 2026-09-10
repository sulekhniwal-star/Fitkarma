import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/family_engine.dart';
import '../../domain/family_models.dart';

final familyHealthProvider =
    StateNotifierProvider<FamilyHealthNotifier, FamilyHealthHubState>((ref) {
  return FamilyHealthNotifier();
});

class FamilyHealthNotifier extends StateNotifier<FamilyHealthHubState> {
  FamilyHealthNotifier() : super(_buildInitialState());

  static FamilyHealthHubState _buildInitialState() {
    final members = [
      FamilyMemberProfile(
        id: 'fam_pitaji',
        name: 'Father (Pitaji)',
        relation: FamilyRelationType.father,
        age: 64,
        todaySteps: 6400,
        dailyStepTarget: 6000,
        completedShatpawaliToday: true,
        latestSystolicBp: 122,
        latestDiastolicBp: 78,
        latestFastingGlucoseMgDl: 104.0,
        estimatedHbA1c: 5.6,
        restingHeartRateBpm: 68,
        lastVitalsLoggedAt: DateTime.now().subtract(const Duration(hours: 4)),
        status: FamilyVitalsStatus.optimal,
        caregiverNote:
            'Blood Pressure in optimal normal range (<125/80). Completed morning & post-lunch strolls.',
        regionalCaregiverNote:
            'रक्तचाप पूर्णतः सामान्य स्तर पर। प्रातः व दोपहर की चहलकदमी पूर्ण।',
      ),
      FamilyMemberProfile(
        id: 'fam_mataji',
        name: 'Mother (Mataji)',
        relation: FamilyRelationType.mother,
        age: 59,
        todaySteps: 4100,
        dailyStepTarget: 5000,
        completedShatpawaliToday: false,
        latestSystolicBp: 128,
        latestDiastolicBp: 82,
        latestFastingGlucoseMgDl: 112.0,
        estimatedHbA1c: 5.7,
        restingHeartRateBpm: 72,
        lastVitalsLoggedAt: DateTime.now().subtract(const Duration(hours: 7)),
        status: FamilyVitalsStatus.attention,
        caregiverNote:
            '900 steps remaining to reach daily 5k baseline. Evening Shatpawali prompt recommended.',
        regionalCaregiverNote:
            'दैनिक ५,००० कदम के लिए ९०० कदम शेष। रात्रि शतपावली हेतु स्मरण अपेक्षित।',
      ),
      FamilyMemberProfile(
        id: 'fam_jeevansathi',
        name: 'Spouse (Pooja)',
        relation: FamilyRelationType.spouse,
        age: 28,
        todaySteps: 9800,
        dailyStepTarget: 10000,
        completedShatpawaliToday: true,
        latestSystolicBp: 116,
        latestDiastolicBp: 74,
        latestFastingGlucoseMgDl: 92.0,
        estimatedHbA1c: 5.1,
        restingHeartRateBpm: 60,
        lastVitalsLoggedAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: FamilyVitalsStatus.optimal,
        caregiverNote:
            'Excellent activity & hydration. On track for 10k daily step goal.',
        regionalCaregiverNote:
            'उत्कृष्ट गतिशीलता व जल सेवन। १०,००० कदमों का लक्ष्य पूर्ण होने के समीप।',
      ),
    ];

    const seasonalTip = SeasonalFamilyAyurvedaTip(
      title: 'Warm Ajwain & Saunf Digestive Infusion',
      regionalTitle: 'अजवाइन व सौंफ पाचक काढ़ा (वरिष्ठ जनों हेतु)',
      description:
          'A gentle carminative decoction after dinner alleviates gas, improves nutrient assimilation, and supports deep sleep in elders.',
      regionalDescription:
          'रात्रि भोजन के उपरांत अजवाइन व सौंफ का हल्का गुनगुना जल पाचन अग्नि को बढ़ाता है व आरामदायक निद्रा प्रदान करता है।',
      keyIngredients:
          'Ajwain (Carom seeds), Saunf (Fennel), Pinch of Kala Namak',
      benefitCategory: 'Digestion & Gas Relief',
    );

    final score = FamilyHealthEngine.calculateHouseholdHealthScore(members);
    final totalSteps = FamilyHealthEngine.calculateTotalFamilySteps(members);

    return FamilyHealthHubState(
      familyHouseholdHealthScore: score,
      totalFamilyStepsToday: totalSteps,
      familyMembers: members,
      recentNudges: const [],
      seasonalTip: seasonalTip,
    );
  }

  void sendSevaNudge({
    required String memberId,
    required String memberName,
    required String nudgeType,
    required String message,
    required String regionalMessage,
  }) {
    final newNudge = FamilyCareNudge(
      id: 'nudge_${DateTime.now().millisecondsSinceEpoch}',
      targetMemberId: memberId,
      targetMemberName: memberName,
      nudgeType: nudgeType,
      message: message,
      regionalMessage: regionalMessage,
      sentAt: DateTime.now(),
    );

    state = state.copyWith(
      recentNudges: [newNudge, ...state.recentNudges],
    );
  }

  void logMemberBp(String memberId, int systolic, int diastolic) {
    final updated = state.familyMembers.map((m) {
      if (m.id == memberId) {
        final newStatus = FamilyHealthEngine.evaluateMemberStatus(
          todaySteps: m.todaySteps,
          dailyTarget: m.dailyStepTarget,
          completedShatpawali: m.completedShatpawaliToday,
          systolicBp: systolic,
          diastolicBp: diastolic,
        );
        return m.copyWith(
          latestSystolicBp: systolic,
          latestDiastolicBp: diastolic,
          status: newStatus,
        );
      }
      return m;
    }).toList();

    final score = FamilyHealthEngine.calculateHouseholdHealthScore(updated);

    state = state.copyWith(
      familyMembers: updated,
      familyHouseholdHealthScore: score,
    );
  }
}
