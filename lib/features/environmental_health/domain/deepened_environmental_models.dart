import 'package:flutter/foundation.dart';
import 'environmental_health_engine.dart';

/// Multi-Pollutant Speciation Breakdown (Indian CPCB & WHO thresholds)
@immutable
class PollutantBreakdown {
  final double pm25; // Fine particulate matter (ug/m3) - Standard: <= 30 ug/m3
  final double pm10; // Coarse particulate matter (ug/m3) - Standard: <= 60 ug/m3
  final double no2; // Nitrogen Dioxide (ppb) - Traffic emissions
  final double so2; // Sulfur Dioxide (ppb) - Industrial / thermal power
  final double co; // Carbon Monoxide (ppm) - Incomplete combustion
  final double o3; // Ground-level Ozone (ppb) - Photochemical afternoon smog

  const PollutantBreakdown({
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.so2,
    required this.co,
    required this.o3,
  });

  bool get hasDangerousPm25 => pm25 > 60.0;
  bool get hasHighOzone => o3 > 70.0;
}

/// The 6 Ayurvedic Indian Seasons (Ritu-Charya Bioclimatic Adaptations)
enum RituSeason {
  shishira(
    name: 'Shishira (Late Winter)',
    regionalName: 'शिशिर ऋतु (माघ-फाल्गुन)',
    months: 'Jan – Feb',
    doshaDynamic: 'Vata accumulation with residual Kapha',
    regionalDoshaDynamic: 'वात संचय व कफ वृद्धि (शीत लहर)',
  ),
  vasanta(
    name: 'Vasanta (Spring)',
    regionalName: 'वसंत ऋतु (चैत्र-वैशाख)',
    months: 'Mar – Apr',
    doshaDynamic: 'Kapha liquefaction & allergen peak',
    regionalDoshaDynamic: 'कफ पिघलना व परागकण/एलर्जी प्रकोप',
  ),
  grishma(
    name: 'Grishma (Summer)',
    regionalName: 'ग्रीष्म ऋतु (ज्येष्ठ-आषाढ़)',
    months: 'May – Jun',
    doshaDynamic: 'Pitta accumulation & intense dehydration',
    regionalDoshaDynamic: 'पित्त संचय व तीव्र ऊष्मा/निर्जलीकरण',
  ),
  varsha(
    name: 'Varsha (Monsoon)',
    regionalName: 'वर्षा ऋतु (श्रावण-भाद्रपद)',
    months: 'Jul – Aug',
    doshaDynamic: 'Vata aggravation & digestive agni dampening',
    regionalDoshaDynamic: 'वात प्रकोप व मंदाग्नि (आर्द्रता वृद्धि)',
  ),
  sharad(
    name: 'Sharad (Autumn)',
    regionalName: 'शरद ऋतु (आश्विन-कार्तिक)',
    months: 'Sep – Oct',
    doshaDynamic: 'Pitta aggravation (October heat & sun flare)',
    regionalDoshaDynamic: 'पित्त प्रकोप (शरद धूप व पित्त शमन)',
  ),
  hemanta(
    name: 'Hemanta (Early Winter)',
    regionalName: 'हेमंत ऋतु (मार्गशीर्ष-पौष)',
    months: 'Nov – Dec',
    doshaDynamic: 'Strong digestive agni with thermal inversion smog',
    regionalDoshaDynamic: 'दीप्त जठराग्नि व शीतकालीन स्मॉग प्रकोप',
  );

  final String name;
  final String regionalName;
  final String months;
  final String doshaDynamic;
  final String regionalDoshaDynamic;

  const RituSeason({
    required this.name,
    required this.regionalName,
    required this.months,
    required this.doshaDynamic,
    required this.regionalDoshaDynamic,
  });
}

/// Seasonal Ritu-Charya Bioclimatic Guidance
@immutable
class RituCharyaGuidance {
  final RituSeason season;
  final String recommendedWorkoutWindow;
  final String regionalRecommendedWorkoutWindow;
  final String herbalRespiratoryShield;
  final String regionalHerbalRespiratoryShield;
  final String hydrationElectrolyteFormula;
  final String regionalHydrationElectrolyteFormula;
  final String postExposureAirwayCare;
  final String regionalPostExposureAirwayCare;

  const RituCharyaGuidance({
    required this.season,
    required this.recommendedWorkoutWindow,
    required this.regionalRecommendedWorkoutWindow,
    required this.herbalRespiratoryShield,
    required this.regionalHerbalRespiratoryShield,
    required this.hydrationElectrolyteFormula,
    required this.regionalHydrationElectrolyteFormula,
    required this.postExposureAirwayCare,
    required this.regionalPostExposureAirwayCare,
  });
}

/// Respiratory & Cardio-Pulmonary Exercise Stress Evaluation
enum TrainingEnvironmentMode {
  outdoorUnrestricted(label: 'Unrestricted Outdoor', regionalLabel: 'खुली हवा में व्यायाम सुरक्षित'),
  outdoorLowIntensityOnly(label: 'Outdoor Zone 1-2 Only', regionalLabel: 'केवल हल्का धीमा व्यायाम'),
  indoorAirPurifiedOnly(label: 'Indoor Air-Purified Only', regionalLabel: 'केवल एयर-प्यूरिफाइड इनडोर'),
  hazardousHalt(label: 'Hazardous — Rest / Light Mobility', regionalLabel: 'प्रतिकूल — केवल विश्राम/स्ट्रेचिंग');

  final String label;
  final String regionalLabel;

  const TrainingEnvironmentMode({
    required this.label,
    required this.regionalLabel,
  });
}

enum ProtectiveMaskTier {
  none(label: 'No Mask Required', regionalLabel: 'मास्क आवश्यक नहीं'),
  n95Recommended(label: 'N95 Respirator Recommended', regionalLabel: 'N95 मास्क अनुशंसित'),
  n99Mandatory(label: 'N99 / FFP3 Mandatory', regionalLabel: 'N99 मास्क अनिवार्य');

  final String label;
  final String regionalLabel;

  const ProtectiveMaskTier({
    required this.label,
    required this.regionalLabel,
  });
}

@immutable
class CardioPulmonaryStressIndex {
  final double stressScore; // 0 (pristine) to 100 (extreme cardiopulmonary strain)
  final double inhaledPm25MicrogramsPerHour; // Estimated PM2.5 mass deposited in lungs during 60-min run
  final TrainingEnvironmentMode recommendedMode;
  final ProtectiveMaskTier maskTier;
  final bool hasThermalInversionWarning;
  final String clinicalRationale;
  final String regionalClinicalRationale;

  const CardioPulmonaryStressIndex({
    required this.stressScore,
    required this.inhaledPm25MicrogramsPerHour,
    required this.recommendedMode,
    required this.maskTier,
    required this.hasThermalInversionWarning,
    required this.clinicalRationale,
    required this.regionalClinicalRationale,
  });
}

/// Wet-Bulb Globe Temperature & Sweat Rate Electrolyte Loss
@immutable
class ThermalStrainIndex {
  final double wbgtCelsius;
  final double estimatedSweatLossPerHourMl;
  final int sodiumLossMg;
  final int potassiumLossMg;
  final String heatIllnessRisk;
  final String regionalHeatIllnessRisk;

  const ThermalStrainIndex({
    required this.wbgtCelsius,
    required this.estimatedSweatLossPerHourMl,
    required this.sodiumLossMg,
    required this.potassiumLossMg,
    required this.heatIllnessRisk,
    required this.regionalHeatIllnessRisk,
  });
}

/// Deepened Multi-Vector Environmental Health Report
@immutable
class DeepenedEnvironmentalReport {
  final EnvironmentalHealthSnapshot baseSnapshot;
  final PollutantBreakdown pollutants;
  final RituCharyaGuidance rituCharya;
  final CardioPulmonaryStressIndex pulmonaryStress;
  final ThermalStrainIndex thermalStrain;
  final double environmentalSafetyIndex; // 0 to 100 (higher = safer)
  final String primaryActionAdvisory;
  final String regionalPrimaryActionAdvisory;
  final DateTime evaluatedAt;

  const DeepenedEnvironmentalReport({
    required this.baseSnapshot,
    required this.pollutants,
    required this.rituCharya,
    required this.pulmonaryStress,
    required this.thermalStrain,
    required this.environmentalSafetyIndex,
    required this.primaryActionAdvisory,
    required this.regionalPrimaryActionAdvisory,
    required this.evaluatedAt,
  });
}
