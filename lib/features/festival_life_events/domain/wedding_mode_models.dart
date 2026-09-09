import 'package:flutter/foundation.dart';

/// Wedding role archetype
enum WeddingRole {
  bride(name: 'Bride (वधू)', regionalName: 'वधू (दुल्हन)', focus: 'Bridal Posture, Skin Glow & Waist Taper'),
  groom(name: 'Groom (वर)', regionalName: 'वर (दूल्हा)', focus: 'Sherwani V-Taper, Posture & Shoulder Width'),
  closeFamily(name: 'Close Family / Parents', regionalName: 'परिवार के मुख्य सदस्य', focus: 'All-Day Stamina, Mobility & Joint Health'),
  bridalParty(name: 'Bridesmaid / Groomsman', regionalName: 'सहेली / बाराती मित्र', focus: 'Sangeet Choreography Stamina & Lean Tone');

  final String name;
  final String regionalName;
  final String focus;

  const WeddingRole({
    required this.name,
    required this.regionalName,
    required this.focus,
  });
}

/// Countdown timeline phase
enum WeddingTimelinePhase {
  foundation(name: 'Foundation & Recomposition (Weeks 12–8)', regionalName: 'प्रारंभिक शारीरिक पुनर्गठन चरण'),
  definition(name: 'Sculpting & Definition (Weeks 7–4)', regionalName: 'कसावट व मांसपेशी परिष्कार चरण'),
  refinement(name: 'Skin Glow & Posture Refinement (Weeks 3–2)', regionalName: 'त्वचा कांति व मुद्रा सुधार चरण'),
  peakWeek(name: 'Peak Week & Anti-Bloat Protocol (Final 7 Days)', regionalName: 'अंतिम ७ दिवसीय पीक वीक प्रोटोकॉल');

  final String name;
  final String regionalName;

  const WeddingTimelinePhase({
    required this.name,
    required this.regionalName,
  });
}

/// A specific wedding pillar action item
@immutable
class WeddingPillarItem {
  final String pillar;
  final String actionTitle;
  final String regionalActionTitle;
  final String detailedStrategy;
  final String regionalDetailedStrategy;

  const WeddingPillarItem({
    required this.pillar,
    required this.actionTitle,
    required this.regionalActionTitle,
    required this.detailedStrategy,
    required this.regionalDetailedStrategy,
  });
}

/// Comprehensive Wedding Transformation Plan Report
@immutable
class WeddingTransformationReport {
  final WeddingRole role;
  final WeddingTimelinePhase currentPhase;
  final int daysUntilWedding;
  final DateTime weddingDate;
  final double targetWeightKg;
  final double currentWeightKg;
  final double targetBodyFatPercent;
  final List<WeddingPillarItem> activePillarActions;
  final String peakWeekDeBloatTip;
  final String regionalPeakWeekDeBloatTip;
  final String ojasSkinRadianceProtocol;
  final String regionalOjasSkinRadianceProtocol;
  final String sangeetStaminaRecommendation;
  final DateTime generatedAt;

  const WeddingTransformationReport({
    required this.role,
    required this.currentPhase,
    required this.daysUntilWedding,
    required this.weddingDate,
    required this.targetWeightKg,
    required this.currentWeightKg,
    required this.targetBodyFatPercent,
    required this.activePillarActions,
    required this.peakWeekDeBloatTip,
    required this.regionalPeakWeekDeBloatTip,
    required this.ojasSkinRadianceProtocol,
    required this.regionalOjasSkinRadianceProtocol,
    required this.sangeetStaminaRecommendation,
    required this.generatedAt,
  });
}
