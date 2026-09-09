import 'package:flutter/foundation.dart';

/// Longevity resilience tiers (Healthspan potential)
enum LongevityTier {
  centenarian(
    label: 'Centenarian Potential (Deerghayu / Shataayu)',
    regionalLabel: 'शतायु दीर्घायु संभावना (उत्कृष्ट स्तर)',
    scoreRange: '90 - 100',
    colorCode: 0xFF00E676,
    projectedHealthspanBonus: '+8 to +12 Years',
    regionalProjectedHealthspanBonus: '+८ से +१२ वर्ष अतिरिक्त स्वस्थ जीवन',
  ),
  optimal(
    label: 'Optimal Healthspan (Aarogya)',
    regionalLabel: 'उत्तम स्वास्थ्य व दीर्घायु (आरोग्य)',
    scoreRange: '75 - 89',
    colorCode: 0xFF448AFF,
    projectedHealthspanBonus: '+4 to +7 Years',
    regionalProjectedHealthspanBonus: '+४ से +७ वर्ष अतिरिक्त स्वस्थ जीवन',
  ),
  moderate(
    label: 'Moderate Lifespan (Madhyam)',
    regionalLabel: 'मध्यम स्वास्थ्य गति (सुधार संभव)',
    scoreRange: '55 - 74',
    colorCode: 0xFFFFB300,
    projectedHealthspanBonus: '0 to +3 Years',
    regionalProjectedHealthspanBonus: '० से +३ वर्ष स्वास्थ्य संभावना',
  ),
  compromised(
    label: 'Accelerated Senescence (Satark)',
    regionalLabel: 'तीव्र क्षय जोखिम (सतर्कता आवश्यक)',
    scoreRange: '0 - 54',
    colorCode: 0xFFFF5252,
    projectedHealthspanBonus: '-4 to -8 Years (Reversible)',
    regionalProjectedHealthspanBonus: '-४ से -८ वर्ष संभावित कमी (सुधार योग्य)',
  );

  final String label;
  final String regionalLabel;
  final String scoreRange;
  final int colorCode;
  final String projectedHealthspanBonus;
  final String regionalProjectedHealthspanBonus;

  const LongevityTier({
    required this.label,
    required this.regionalLabel,
    required this.scoreRange,
    required this.colorCode,
    required this.projectedHealthspanBonus,
    required this.regionalProjectedHealthspanBonus,
  });
}

/// Core Longevity Pillar Subsystem
enum LongevityPillarType {
  cardiovascular(name: 'Cardiovascular Elasticity', regionalName: 'हृदय व धमनी लचीलापन', iconName: 'favorite', weight: 0.20),
  metabolic(name: 'Metabolic & Glycemic Reserve', regionalName: 'उपापचयी व शर्करा संतुलन', iconName: 'bolt', weight: 0.20),
  cardiorespiratory(name: 'VO2 Max & Muscle Mass', regionalName: 'VO2 Max व मांसपेशी भंडार', iconName: 'fitness_center', weight: 0.20),
  cellularRecovery(name: 'Circadian & Sleep Architecture', regionalName: 'गहरी नींद व कोशिकीय मरम्मत', iconName: 'nights_stay', weight: 0.15),
  antiInflammatory(name: 'Nutritional Anti-Inflammatory', regionalName: 'सूजन-रोधी पोषण व आंत स्वास्थ्य', iconName: 'restaurant', weight: 0.15),
  ayurvedicVagal(name: 'Dinacharya & Autonomic Harmony', regionalName: 'दिनचर्या व स्वायत्त संतुलन', iconName: 'spa', weight: 0.10);

  final String name;
  final String regionalName;
  final String iconName;
  final double weight;

  const LongevityPillarType({
    required this.name,
    required this.regionalName,
    required this.iconName,
    required this.weight,
  });
}

/// Pillar evaluated score & insight
@immutable
class LongevityPillarScore {
  final LongevityPillarType pillar;
  final double score; // 0 to 100
  final String primaryStrength;
  final String regionalPrimaryStrength;
  final String optimizationOpportunity;
  final String regionalOptimizationOpportunity;

  const LongevityPillarScore({
    required this.pillar,
    required this.score,
    required this.primaryStrength,
    required this.regionalPrimaryStrength,
    required this.optimizationOpportunity,
    required this.regionalOptimizationOpportunity,
  });
}

/// High-impact deterministic longevity accelerator
@immutable
class LongevityAccelerator {
  final String id;
  final LongevityPillarType pillar;
  final String title;
  final String regionalTitle;
  final String scientificRationale;
  final String regionalScientificRationale;
  final double projectedHealthspanYearsGained; // e.g. +2.4 years
  final String implementationEase; // "Effortless", "Moderate", "High Focus"
  final int karmaReward;

  const LongevityAccelerator({
    required this.id,
    required this.pillar,
    required this.title,
    required this.regionalTitle,
    required this.scientificRationale,
    required this.regionalScientificRationale,
    required this.projectedHealthspanYearsGained,
    required this.implementationEase,
    required this.karmaReward,
  });
}

/// Comprehensive Longevity & Healthspan Report
@immutable
class LongevityReport {
  final double compositeScore; // 0 to 100
  final LongevityTier tier;
  final double chronologicalAge;
  final double biologicalAge;
  final double projectedHealthspanAge; // e.g. 84.5 years
  final double healthspanBonusYears; // projectedHealthspanAge - baseline (e.g. +7.5 years)
  final List<LongevityPillarScore> pillarScores;
  final List<LongevityAccelerator> topAccelerators;
  final String primaryLongevityAsset;
  final String regionalPrimaryLongevityAsset;
  final String primaryVulnerability;
  final String regionalPrimaryVulnerability;
  final DateTime calculatedAt;

  const LongevityReport({
    required this.compositeScore,
    required this.tier,
    required this.chronologicalAge,
    required this.biologicalAge,
    required this.projectedHealthspanAge,
    required this.healthspanBonusYears,
    required this.pillarScores,
    required this.topAccelerators,
    required this.primaryLongevityAsset,
    required this.regionalPrimaryLongevityAsset,
    required this.primaryVulnerability,
    required this.regionalPrimaryVulnerability,
    required this.calculatedAt,
  });
}
