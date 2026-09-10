import 'package:flutter/foundation.dart';

/// Roast Intensity / Severity Level
enum RoastIntensity {
  mildSarcasm(
    name: 'Mild Sarcasm & Witty Nudge',
    regionalName: 'हल्की चुटकी एवं मीठा ताना',
    description: 'Playful teasing with gentle accountability.',
  ),
  desiToughLove(
    name: 'Desi Tough Love (देसी डांट)',
    regionalName: 'देसी डांट एवं पारिवारिक फटकार',
    description: 'Classic Desi parent / strict elder sibling energy.',
  ),
  savageUnfiltered(
    name: 'Savage Unfiltered Roast (निर्मम रोस्ट)',
    regionalName: 'निर्मम रोस्ट (कड़वा सच)',
    description: 'Brutally honest, zero-excuse reality check.',
  );

  final String name;
  final String regionalName;
  final String description;

  const RoastIntensity({
    required this.name,
    required this.regionalName,
    required this.description,
  });
}

/// Roast Persona Archetype
enum RoastPersona {
  desiGymBro(
    name: 'Desi Gym Bro (अखाड़ा गुरु)',
    regionalName: 'अखाड़ा गुरु / जिम ब्रो',
    catchphrase: 'Bhai form dekh, phone nahi!',
  ),
  strictDesiParent(
    name: 'Strict Desi Mom/Dad (शर्मा जी के पापा)',
    regionalName: 'शर्मा जी के पापा / माताजी',
    catchphrase: 'Sharma ji ke bete ko dekha hai?',
  ),
  sarcasticVaidya(
    name: 'Sarcastic Ayurvedic Vaidya (कटुभाषी वैद्य)',
    regionalName: 'कटुभाषी वैद्य जी',
    catchphrase: 'Pitta bhadak gaya hai tera!',
  ),
  corporateHustler(
    name: 'Unforgiving Startup Founder (क्रंच मास्टर)',
    regionalName: 'अनफॉरगिविंग फाउंडर',
    catchphrase: 'Excuses don’t scale, execution does.',
  );

  final String name;
  final String regionalName;
  final String catchphrase;

  const RoastPersona({
    required this.name,
    required this.regionalName,
    required this.catchphrase,
  });
}

/// Scenario trigger for roast generation
enum RoastTriggerEvent {
  missedWorkout(
      name: 'Missed Workout / Snoozed Alarm',
      regionalName: 'व्यायाम छोड़ना व अलार्म स्नूज़'),
  lateNightJunkOrder(
      name: 'Late Night Swiggy/Zomato Binge',
      regionalName: 'देर रात जंक फूड डिलीवरी'),
  sedentarySlump(
      name: '3+ Hours Sedentary Screen Slump',
      regionalName: 'बिना हिले लगातार स्क्रीन देखना'),
  skippedWaterHydration(
      name: 'Zero Water Intake (<1L)',
      regionalName: 'पानी न पीना व निर्जलीकरण'),
  smashingGoals(
      name: 'Goal Smashed (Rare Praise)',
      regionalName: 'लक्ष्य प्राप्ति (सच्ची तारीफ)');

  final String name;
  final String regionalName;

  const RoastTriggerEvent({
    required this.name,
    required this.regionalName,
  });
}

/// Generated AI Roast Output
@immutable
class RoastMessageArtifact {
  final String id;
  final RoastPersona persona;
  final RoastIntensity intensity;
  final RoastTriggerEvent trigger;
  final String headlinePunchline;
  final String fullRoastEnglish;
  final String fullRoastHindi;
  final String actionableActionChallenge;
  final String regionalActionChallenge;
  final DateTime generatedAt;

  const RoastMessageArtifact({
    required this.id,
    required this.persona,
    required this.intensity,
    required this.trigger,
    required this.headlinePunchline,
    required this.fullRoastEnglish,
    required this.fullRoastHindi,
    required this.actionableActionChallenge,
    required this.regionalActionChallenge,
    required this.generatedAt,
  });
}

/// Comprehensive AI Roast System State Report
@immutable
class AiRoastSystemReport {
  final bool isRoastModeEnabled;
  final RoastPersona activePersona;
  final RoastIntensity activeIntensity;
  final RoastMessageArtifact currentRoast;
  final List<RoastMessageArtifact> recentRoastVault;
  final int totalRoastsSurvived;
  final double excuseDebunkRatePercent;
  final DateTime lastRefreshed;

  const AiRoastSystemReport({
    required this.isRoastModeEnabled,
    required this.activePersona,
    required this.activeIntensity,
    required this.currentRoast,
    required this.recentRoastVault,
    required this.totalRoastsSurvived,
    required this.excuseDebunkRatePercent,
    required this.lastRefreshed,
  });
}
