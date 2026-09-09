import 'package:flutter/foundation.dart';
import 'longevity_score_models.dart';

/// The 9 Fundamental Biological Hallmarks of Aging
enum HallmarkOfAging {
  mitochondrialHealth(
    name: 'Mitochondrial Bioenergetics & Autophagy',
    regionalName: 'माइटोकॉन्ड्रियल ऊर्जा व ऑटोफैगी',
    weight: 0.18,
    antiAgingMechanism: 'Promotes cellular mitophagy and ATP synthesis via Zone 2 cardio & polyphenols.',
  ),
  telomereIntegrity(
    name: 'Telomere Length & Cellular Senescence',
    regionalName: 'टेलोमेयर सुरक्षा व कोशिकीय क्षय निवारण',
    weight: 0.15,
    antiAgingMechanism: 'Preserves DNA end-caps and halts senescent SASP inflammatory secretions.',
  ),
  proteostasisAndAges(
    name: 'Proteostasis & Glycation Protection',
    regionalName: 'प्रोटीन संरचना व ग्लाइकेशन (AGEs) सुरक्षा',
    weight: 0.15,
    antiAgingMechanism: 'Eliminates misfolded protein aggregates and blunts glucose-induced advanced glycation.',
  ),
  epigeneticStability(
    name: 'Epigenetic Methylation Stability',
    regionalName: 'एपिजेनेटिक डीएनए मिथाइलेशन स्थिरता',
    weight: 0.14,
    antiAgingMechanism: 'Maintains optimal DNA methylation patterns with B12, folate, and low chronic cortisol.',
  ),
  inflammaging(
    name: 'Chronic Low-Grade Inflammaging',
    regionalName: 'दीर्घकालिक सूक्ष्म सूजन (इन्फ्लेमेजिंग)',
    weight: 0.14,
    antiAgingMechanism: 'Suppresses systemic hs-CRP and TNF-alpha via turmeric, omega-3, and gut microbiome diversity.',
  ),
  nutrientSensing(
    name: 'Deregulated Nutrient Sensing & mTOR/AMPK',
    regionalName: 'पोषक तत्व संवेदन व मेटाबॉलिक स्विच',
    weight: 0.12,
    antiAgingMechanism: 'Balances AMPK activation (fasting/exercise) with controlled mTOR hypertrophy.',
  ),
  stemCellRegeneration(
    name: 'Stem Cell Reserve & Slow-Wave Repair',
    regionalName: 'स्टेम सेल नवीनीकरण व गहरी नींद',
    weight: 0.12,
    antiAgingMechanism: 'Enhances tissue rejuvenation during deep NREM Stage 3 growth hormone pulses.',
  );

  final String name;
  final String regionalName;
  final double weight;
  final String antiAgingMechanism;

  const HallmarkOfAging({
    required this.name,
    required this.regionalName,
    required this.weight,
    required this.antiAgingMechanism,
  });
}

/// Evaluated Hallmark of Aging with biological age impact
@immutable
class HallmarkEvaluation {
  final HallmarkOfAging hallmark;
  final double score; // 0 to 100
  final double biologicalAgeDeltaYears; // e.g. -1.8 years (protective) or +2.2 years (accelerated)
  final String primaryBiomarker;
  final String statusSummary;
  final String regionalStatusSummary;

  const HallmarkEvaluation({
    required this.hallmark,
    required this.score,
    required this.biologicalAgeDeltaYears,
    required this.primaryBiomarker,
    required this.statusSummary,
    required this.regionalStatusSummary,
  });

  bool get isProtective => biologicalAgeDeltaYears <= 0;
}

/// South Asian Phenotype Specific Longevity Risk Factors
@immutable
class SouthAsianPhenotypeRisk {
  final double visceralAdiposityIndex; // Estimated visceral fat loading
  final double atherogenicIndexRatio; // TG to HDL ratio
  final bool hasElevatedLpA;
  final double sarcopenicRiskIndex; // Muscle mass relative to height/weight
  final String clinicalInterpretation;
  final String regionalClinicalInterpretation;

  const SouthAsianPhenotypeRisk({
    required this.visceralAdiposityIndex,
    required this.atherogenicIndexRatio,
    required this.hasElevatedLpA,
    required this.sarcopenicRiskIndex,
    required this.clinicalInterpretation,
    required this.regionalClinicalInterpretation,
  });
}

/// 90-Day Cellular Longevity Roadmap Phase
@immutable
class LongevityRoadmapPhase {
  final int phaseNumber;
  final String title;
  final String regionalTitle;
  final String timeline;
  final List<String> cellularActions;
  final List<String> regionalCellularActions;
  final String ayurvedicRasayana;
  final String regionalAyurvedicRasayana;

  const LongevityRoadmapPhase({
    required this.phaseNumber,
    required this.title,
    required this.regionalTitle,
    required this.timeline,
    required this.cellularActions,
    required this.regionalCellularActions,
    required this.ayurvedicRasayana,
    required this.regionalAyurvedicRasayana,
  });
}

/// Deepened Longevity & Cellular Resilience Comprehensive Report
@immutable
class DeepenedLongevityReport {
  final LongevityReport baseReport;
  final double compositeCellularResilienceScore; // 0 to 100
  final List<HallmarkEvaluation> hallmarkEvaluations;
  final SouthAsianPhenotypeRisk southAsianRisk;
  final List<LongevityRoadmapPhase> cellularRoadmap;
  final String primaryLongevityPillarSummary;
  final String regionalPrimaryLongevityPillarSummary;
  final DateTime synthesizedAt;

  const DeepenedLongevityReport({
    required this.baseReport,
    required this.compositeCellularResilienceScore,
    required this.hallmarkEvaluations,
    required this.southAsianRisk,
    required this.cellularRoadmap,
    required this.primaryLongevityPillarSummary,
    required this.regionalPrimaryLongevityPillarSummary,
    required this.synthesizedAt,
  });
}
