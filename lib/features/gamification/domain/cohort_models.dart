import 'package:flutter/foundation.dart';

/// Geographic tier classification for Indian demographic cohorts
enum IndianCityTier {
  tier1(
    label: 'Tier 1 Metros (Mumbai, NCR, BLR, HYD)',
    regionalLabel: 'प्रथम श्रेणी महानगर',
    averageStepVelocity: 7400,
    stressIndex: 0.72,
  ),
  tier2(
    label: 'Tier 2 Emerging (Pune, Ahmedabad, Jaipur, Chd)',
    regionalLabel: 'द्वितीय श्रेणी प्रमुख शहर',
    averageStepVelocity: 8200,
    stressIndex: 0.58,
  ),
  tier3(
    label: 'Tier 3 & Beyond (Pan-India Towns)',
    regionalLabel: 'तृतीय श्रेणी व अन्य नगर',
    averageStepVelocity: 8900,
    stressIndex: 0.45,
  );

  final String label;
  final String regionalLabel;
  final int averageStepVelocity;
  final double stressIndex;

  const IndianCityTier({
    required this.label,
    required this.regionalLabel,
    required this.averageStepVelocity,
    required this.stressIndex,
  });
}

/// Activity lifestyle profile clusters
enum ActivityPersonaCluster {
  techSedentary(
    label: 'Desk-Bound Knowledge Worker',
    regionalLabel: 'डेस्क-आधारित तकनीकी पेशेवर',
    baselineDailySteps: 6000,
    averageDailySittingHours: 9.5,
  ),
  activeExecutive(
    label: 'High-Velocity Executive',
    regionalLabel: 'सक्रिय व्यावसायिक अधिकारी',
    baselineDailySteps: 8500,
    averageDailySittingHours: 7.0,
  ),
  studentAthlete(
    label: 'Student / Young Athlete',
    regionalLabel: 'छात्र / युवा एथलीट',
    baselineDailySteps: 11000,
    averageDailySittingHours: 5.5,
  ),
  activeHomemaker(
    label: 'Active Homemaker / Caregiver',
    regionalLabel: 'सक्रिय गृहिणी / परिवार संचालक',
    baselineDailySteps: 9500,
    averageDailySittingHours: 4.5,
  );

  final String label;
  final String regionalLabel;
  final int baselineDailySteps;
  final double averageDailySittingHours;

  const ActivityPersonaCluster({
    required this.label,
    required this.regionalLabel,
    required this.baselineDailySteps,
    required this.averageDailySittingHours,
  });
}

/// Influence tier in the collective network (Sangha Influence)
enum NetworkInfluenceTier {
  seed(
    title: 'Seed Member (Arambha)',
    regionalTitle: 'आरंभिक साधक',
    multiplier: 1.0,
    description: 'Beginning your journey and drawing momentum from the Sangha.',
    regionalDescription: 'संघ से प्रेरणा लेकर साधना आरंभ कर रहे हैं।',
  ),
  catalyst(
    title: 'Habit Catalyst (Prerak)',
    regionalTitle: 'आदत प्रेरक',
    multiplier: 1.15,
    description: 'Your consistency is measurably elevating your peer cohort.',
    regionalDescription: 'आपकी निरंतरता साथियों को प्रत्यक्ष रूप से प्रेरित कर रही है।',
  ),
  vanguard(
    title: 'Pacesetter (Agrani)',
    regionalTitle: 'अग्रणी साधक',
    multiplier: 1.25,
    description: 'Driving top-decile health velocity across your city tier.',
    regionalDescription: 'अपने शहर वर्ग में शीर्ष गतिशीलता का नेतृत्व कर रहे हैं।',
  ),
  luminary(
    title: 'Sangha Luminary (Margdarshak)',
    regionalTitle: 'संघ मार्गदर्शक',
    multiplier: 1.40,
    description: 'Radiating profound positive social contagion throughout the community.',
    regionalDescription: 'समुदाय में सकारात्मक स्वास्थ्य क्रांति का मार्ग प्रशस्त कर रहे हैं।',
  );

  final String title;
  final String regionalTitle;
  final double multiplier;
  final String description;
  final String regionalDescription;

  const NetworkInfluenceTier({
    required this.title,
    required this.regionalTitle,
    required this.multiplier,
    required this.description,
    required this.regionalDescription,
  });
}

/// Demographic Cohort Dimension Profile
@immutable
class DemographicCohortGroup {
  final String cohortId;
  final String ageBracket; // e.g. "25-34 yrs"
  final String biologicalSex; // "Male", "Female", "All"
  final IndianCityTier cityTier;
  final ActivityPersonaCluster persona;
  final int activePeersCount;
  final double cohortAverageAdherence;
  final double cohortAverageKarma;

  const DemographicCohortGroup({
    required this.cohortId,
    required this.ageBracket,
    required this.biologicalSex,
    required this.cityTier,
    required this.persona,
    required this.activePeersCount,
    required this.cohortAverageAdherence,
    required this.cohortAverageKarma,
  });
}

/// Comparative Pillar Metric between User and Cohort
@immutable
class CohortPillarMetric {
  final String pillarId;
  final String title;
  final String regionalTitle;
  final double userValue;
  final double cohortAverage;
  final double top10PercentileValue;
  final String unit;
  final double userPercentile; // 0 to 100
  final bool higherIsBetter;

  const CohortPillarMetric({
    required this.pillarId,
    required this.title,
    required this.regionalTitle,
    required this.userValue,
    required this.cohortAverage,
    required this.top10PercentileValue,
    required this.unit,
    required this.userPercentile,
    this.higherIsBetter = true,
  });

  double get deltaFromCohortMean => userValue - cohortAverage;
  double get deltaPercentage => cohortAverage > 0 ? (deltaFromCohortMean / cohortAverage) * 100 : 0.0;
}

/// Realtime Anonymized Activity Event for Network Contagion Stream
@immutable
class AnonymizedPeerActivity {
  final String id;
  final String peerAlias; // e.g. "Athlete from Bengaluru"
  final String regionalPeerAlias;
  final String actionDescription;
  final String regionalActionDescription;
  final int karmaGenerated;
  final DateTime timestamp;
  final String iconName;

  const AnonymizedPeerActivity({
    required this.id,
    required this.peerAlias,
    required this.regionalPeerAlias,
    required this.actionDescription,
    required this.regionalActionDescription,
    required this.karmaGenerated,
    required this.timestamp,
    required this.iconName,
  });
}

/// Collective Milestone / Sangha Challenge
@immutable
class SanghaCollectiveGoal {
  final String id;
  final String title;
  final String regionalTitle;
  final String description;
  final String regionalDescription;
  final double targetQuantity;
  final double currentQuantity;
  final String unit;
  final DateTime deadline;
  final int participatingAthletes;

  const SanghaCollectiveGoal({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.regionalDescription,
    required this.targetQuantity,
    required this.currentQuantity,
    required this.unit,
    required this.deadline,
    required this.participatingAthletes,
  });

  double get progressFraction => (currentQuantity / targetQuantity).clamp(0.0, 1.0);
  double get progressPercentage => progressFraction * 100;
}

/// Comprehensive Demographic Cohort & Network Effects Report
@immutable
class DemographicCohortReport {
  final DemographicCohortGroup cohortGroup;
  final NetworkInfluenceTier networkInfluence;
  final double socialContagionIndex; // 0.0 to 100.0
  final double networkBonusMultiplier; // e.g. 1.15x Karma
  final List<CohortPillarMetric> pillarMetrics;
  final List<AnonymizedPeerActivity> recentPeerActivities;
  final SanghaCollectiveGoal activeCollectiveGoal;
  final String primaryPositiveNudge;
  final String regionalPrimaryPositiveNudge;

  const DemographicCohortReport({
    required this.cohortGroup,
    required this.networkInfluence,
    required this.socialContagionIndex,
    required this.networkBonusMultiplier,
    required this.pillarMetrics,
    required this.recentPeerActivities,
    required this.activeCollectiveGoal,
    required this.primaryPositiveNudge,
    required this.regionalPrimaryPositiveNudge,
  });
}
