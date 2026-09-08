import 'package:flutter/foundation.dart';

/// Relationship to primary user
enum FamilyRelationType {
  father(label: 'Father (Pitaji)', regionalLabel: 'पिताजी', iconName: 'elderly'),
  mother(label: 'Mother (Mataji)', regionalLabel: 'माताजी', iconName: 'elderly_woman'),
  spouse(label: 'Spouse (Jeevansathi)', regionalLabel: 'जीवनसाथी', iconName: 'favorite'),
  sibling(label: 'Sibling (Bhai/Behen)', regionalLabel: 'भाई / बहन', iconName: 'people'),
  child(label: 'Child (Beta/Beti)', regionalLabel: 'बेटा / बेटी', iconName: 'child_care');

  final String label;
  final String regionalLabel;
  final String iconName;

  const FamilyRelationType({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
  });
}

/// Cardiometabolic status rating for family member
enum FamilyVitalsStatus {
  optimal(
    title: 'Optimal & Stable',
    regionalTitle: 'संतुलित एवं सामान्य',
    colorCode: 0xFF00E676,
  ),
  attention(
    title: 'Attention / Walk Pending',
    regionalTitle: 'शतपावली / सक्रियता अपेक्षित',
    colorCode: 0xFFFF9100,
  ),
  alert(
    title: 'Clinical Alert / High BP',
    regionalTitle: 'चिकित्सकीय सावधानी (उच्च रक्तचाप)',
    colorCode: 0xFFFF5252,
  );

  final String title;
  final String regionalTitle;
  final int colorCode;

  const FamilyVitalsStatus({
    required this.title,
    required this.regionalTitle,
    required this.colorCode,
  });
}

/// Individual Family Member Profile & Vitals State
@immutable
class FamilyMemberProfile {
  final String id;
  final String name;
  final FamilyRelationType relation;
  final int age;
  final int todaySteps;
  final int dailyStepTarget;
  final bool completedShatpawaliToday;
  final int? latestSystolicBp;
  final int? latestDiastolicBp;
  final double? latestFastingGlucoseMgDl;
  final double? estimatedHbA1c;
  final int? restingHeartRateBpm;
  final DateTime lastVitalsLoggedAt;
  final FamilyVitalsStatus status;
  final String caregiverNote;
  final String regionalCaregiverNote;

  const FamilyMemberProfile({
    required this.id,
    required this.name,
    required this.relation,
    required this.age,
    required this.todaySteps,
    required this.dailyStepTarget,
    required this.completedShatpawaliToday,
    this.latestSystolicBp,
    this.latestDiastolicBp,
    this.latestFastingGlucoseMgDl,
    this.estimatedHbA1c,
    this.restingHeartRateBpm,
    required this.lastVitalsLoggedAt,
    required this.status,
    required this.caregiverNote,
    required this.regionalCaregiverNote,
  });

  double get stepProgressFraction => (todaySteps / (dailyStepTarget == 0 ? 1 : dailyStepTarget)).clamp(0.0, 1.0);
  bool get hasBpLogged => latestSystolicBp != null && latestDiastolicBp != null;

  FamilyMemberProfile copyWith({
    int? todaySteps,
    bool? completedShatpawaliToday,
    int? latestSystolicBp,
    int? latestDiastolicBp,
    FamilyVitalsStatus? status,
    String? caregiverNote,
    String? regionalCaregiverNote,
  }) {
    return FamilyMemberProfile(
      id: id,
      name: name,
      relation: relation,
      age: age,
      todaySteps: todaySteps ?? this.todaySteps,
      dailyStepTarget: dailyStepTarget,
      completedShatpawaliToday: completedShatpawaliToday ?? this.completedShatpawaliToday,
      latestSystolicBp: latestSystolicBp ?? this.latestSystolicBp,
      latestDiastolicBp: latestDiastolicBp ?? this.latestDiastolicBp,
      latestFastingGlucoseMgDl: latestFastingGlucoseMgDl,
      estimatedHbA1c: estimatedHbA1c,
      restingHeartRateBpm: restingHeartRateBpm,
      lastVitalsLoggedAt: DateTime.now(),
      status: status ?? this.status,
      caregiverNote: caregiverNote ?? this.caregiverNote,
      regionalCaregiverNote: regionalCaregiverNote ?? this.regionalCaregiverNote,
    );
  }
}

/// Caring Nudge Action (Seva Nudge)
@immutable
class FamilyCareNudge {
  final String id;
  final String targetMemberId;
  final String targetMemberName;
  final String nudgeType; // "Shatpawali Prompt", "BP Reminder", "Hydration Nudge"
  final String message;
  final String regionalMessage;
  final DateTime sentAt;

  const FamilyCareNudge({
    required this.id,
    required this.targetMemberId,
    required this.targetMemberName,
    required this.nudgeType,
    required this.message,
    required this.regionalMessage,
    required this.sentAt,
  });
}

/// Seasonal Ayurvedic Kitchen Medicine recommendation for family health
@immutable
class SeasonalFamilyAyurvedaTip {
  final String title;
  final String regionalTitle;
  final String description;
  final String regionalDescription;
  final String keyIngredients;
  final String benefitCategory; // "Digestion & Gas Relief", "Joint Health", "Immunity"

  const SeasonalFamilyAyurvedaTip({
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.regionalDescription,
    required this.keyIngredients,
    required this.benefitCategory,
  });
}

/// Complete Family Health Hub state
@immutable
class FamilyHealthHubState {
  final double familyHouseholdHealthScore; // 0.0 to 100.0
  final int totalFamilyStepsToday;
  final List<FamilyMemberProfile> familyMembers;
  final List<FamilyCareNudge> recentNudges;
  final SeasonalFamilyAyurvedaTip seasonalTip;

  const FamilyHealthHubState({
    required this.familyHouseholdHealthScore,
    required this.totalFamilyStepsToday,
    required this.familyMembers,
    required this.recentNudges,
    required this.seasonalTip,
  });

  FamilyHealthHubState copyWith({
    double? familyHouseholdHealthScore,
    int? totalFamilyStepsToday,
    List<FamilyMemberProfile>? familyMembers,
    List<FamilyCareNudge>? recentNudges,
    SeasonalFamilyAyurvedaTip? seasonalTip,
  }) {
    return FamilyHealthHubState(
      familyHouseholdHealthScore: familyHouseholdHealthScore ?? this.familyHouseholdHealthScore,
      totalFamilyStepsToday: totalFamilyStepsToday ?? this.totalFamilyStepsToday,
      familyMembers: familyMembers ?? this.familyMembers,
      recentNudges: recentNudges ?? this.recentNudges,
      seasonalTip: seasonalTip ?? this.seasonalTip,
    );
  }
}
