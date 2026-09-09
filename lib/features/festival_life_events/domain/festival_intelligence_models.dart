import 'package:flutter/foundation.dart';

/// Supported Pan-Indian Festivals and Cultural Celebrations
enum IndianFestival {
  diwali(
    name: 'Diwali (Deepavali)',
    regionalName: 'दीपावली (रोशनी का महापर्व)',
    season: 'Autumn / Kartik',
    primaryFocus: 'Feasting & Family Celebrations',
    isFastingCentric: false,
  ),
  holi(
    name: 'Holi',
    regionalName: 'होली (रंगोत्सव एवं वसंत उत्सव)',
    season: 'Spring / Phalguna',
    primaryFocus: 'High Activity & Sweets',
    isFastingCentric: false,
  ),
  navratri(
    name: 'Navratri (Chaitra / Sharad)',
    regionalName: 'नवरात्रि (नौ दिवसीय व्रत एवं साधना)',
    season: 'Spring / Autumn',
    primaryFocus: 'Satvik Fasting & Garba/Dandiya',
    isFastingCentric: true,
  ),
  ramadanEid(
    name: 'Ramadan & Eid-ul-Fitr',
    regionalName: 'रमज़ान व ईद-उल-फ़ित्र',
    season: 'Lunar Hijri Calendar',
    primaryFocus: 'Intermittent Fasting & Suhoor/Iftar',
    isFastingCentric: true,
  ),
  durgaPuja(
    name: 'Durga Puja',
    regionalName: 'दुर्गा पूजा (शरदोत्सव)',
    season: 'Autumn / Ashwin',
    primaryFocus: 'Pandal Hopping & Festive Bhog',
    isFastingCentric: false,
  ),
  ganeshChaturthi(
    name: 'Ganesh Chaturthi',
    regionalName: 'गणेश चतुर्थी (मोदक एवं उत्सव)',
    season: 'Bhadrapada / Late Monsoon',
    primaryFocus: 'Modak Moderation & Processions',
    isFastingCentric: false,
  ),
  pongalSankranti(
    name: 'Makar Sankranti / Pongal / Lohri',
    regionalName: 'मकर संक्रांति / पोंगल / लोहड़ी',
    season: 'Winter / Pausha',
    primaryFocus: 'Harvest Feasting & Sesame/Jaggery',
    isFastingCentric: false,
  ),
  onam(
    name: 'Onam',
    regionalName: 'ओणम (भव्य ओणसद्या)',
    season: 'Chingam / Autumn',
    primaryFocus: 'Onasadya Grand Feast',
    isFastingCentric: false,
  ),
  karwaChauthEkadashi(
    name: 'Karwa Chauth / Nirjala Ekadashi',
    regionalName: 'करवा चौथ / एकादशी व्रत',
    season: 'Lunar Fasting Days',
    primaryFocus: 'Nirjala / Phalahari Fasting',
    isFastingCentric: true,
  );

  final String name;
  final String regionalName;
  final String season;
  final String primaryFocus;
  final bool isFastingCentric;

  const IndianFestival({
    required this.name,
    required this.regionalName,
    required this.season,
    required this.primaryFocus,
    required this.isFastingCentric,
  });
}

/// Dynamic Festival Adaptation Strategy for Multi-Pillars
@immutable
class PillarAdaptationStrategy {
  final String pillarName;
  final String regionalPillarName;
  final String headlineAction;
  final String detailedProtocol;
  final String regionalDetailedProtocol;
  final String keyMetricAdjustment;

  const PillarAdaptationStrategy({
    required this.pillarName,
    required this.regionalPillarName,
    required this.headlineAction,
    required this.detailedProtocol,
    required this.regionalDetailedProtocol,
    required this.keyMetricAdjustment,
  });
}

/// 3-Day Post-Festival Metabolic Reset Step
@immutable
class ResetProtocolDay {
  final int dayNumber;
  final String focusTheme;
  final String dietaryProtocol;
  final String workoutProtocol;
  final String ayurvedicDigestiveRemedy;

  const ResetProtocolDay({
    required this.dayNumber,
    required this.focusTheme,
    required this.dietaryProtocol,
    required this.workoutProtocol,
    required this.ayurvedicDigestiveRemedy,
  });
}

/// Comprehensive Festival Intelligence Plan Report
@immutable
class FestivalIntelligencePlan {
  final IndianFestival activeFestival;
  final bool isFestivalModeActive;
  final int daysUntilFestival;
  final int festivalDurationDays;
  final int calorieDeltaTarget; // e.g. +400 kcal for Diwali or -300 kcal for Vrat
  final List<PillarAdaptationStrategy> pillarStrategies;
  final List<ResetProtocolDay> postFestivalResetProtocol;
  final String mindfulFeastingTip;
  final String regionalMindfulFeastingTip;
  final String aiCoachToneOverride; // e.g. "Festive Cheer & Non-Guilt Mindset"
  final DateTime generatedAt;

  const FestivalIntelligencePlan({
    required this.activeFestival,
    required this.isFestivalModeActive,
    required this.daysUntilFestival,
    required this.festivalDurationDays,
    required this.calorieDeltaTarget,
    required this.pillarStrategies,
    required this.postFestivalResetProtocol,
    required this.mindfulFeastingTip,
    required this.regionalMindfulFeastingTip,
    required this.aiCoachToneOverride,
    required this.generatedAt,
  });
}
