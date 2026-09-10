import 'package:flutter/foundation.dart';
import 'body_analytics_models.dart';

/// Estimation method model type
enum CompositionEstimationModel {
  ensembleConsensus(
    name: 'Multi-Method Ensemble Consensus',
    regionalName: 'बहु-पद्धति समन्वित अनुमान',
    description:
        'Weighted synthesis of anthropometric, biometric, and regression equations.',
  ),
  usNavyCircumference(
    name: 'US Navy Anthropometric Model',
    regionalName: 'अमेरिकी नौसेना माप पद्धति',
    description:
        'Logarithmic circumference formula based on waist, neck, and hip ratios.',
  ),
  ymcaBodyFatModel(
    name: 'YMCA Anthropometric Model',
    regionalName: 'YMCA कमर-भार सूत्र',
    description:
        'Clinical linear model utilizing waist circumference and body weight.',
  ),
  deurenbergRegression(
    name: 'Deurenberg Clinical Equation',
    regionalName: 'ड्यूरेनबर्ग क्लिनिकल समीकरण',
    description:
        'Age- and sex-adjusted BMI non-linear body fat regression model.',
  ),
  gallagherClinical(
    name: 'Gallagher Dual-Energy Surrogate',
    regionalName: 'गैलाघर बायोमार्कर सूत्र',
    description:
        'Cardiometabolic calibrated body fat index adjusted for ethnicity.',
  );

  final String name;
  final String regionalName;
  final String description;

  const CompositionEstimationModel({
    required this.name,
    required this.regionalName,
    required this.description,
  });
}

/// Individual Model Estimate Result
@immutable
class SingleModelEstimate {
  final CompositionEstimationModel model;
  final double estimatedBodyFatPercent;
  final double estimatedLeanMassKg;
  final double estimatedFatMassKg;
  final double modelWeighting; // 0.0 to 1.0 in ensemble

  const SingleModelEstimate({
    required this.model,
    required this.estimatedBodyFatPercent,
    required this.estimatedLeanMassKg,
    required this.estimatedFatMassKg,
    required this.modelWeighting,
  });
}

/// Comprehensive Wearable-Free Body Composition Report
@immutable
class WearableFreeCompositionReport {
  final double ensembleBodyFatPercent;
  final double ensembleLeanMassKg;
  final double ensembleFatMassKg;
  final double ensembleBoneMassKg;
  final double ensembleTotalBodyWaterPercent;
  final double
      confidenceScorePercent; // e.g. 92% based on model agreement / low variance
  final double modelVarianceStdDev; // Standard deviation between the 4 models
  final List<SingleModelEstimate> individualEstimates;
  final BodyCompositionZone zone;
  final bool
      southAsianSpecificCutoffsApplied; // ICMR / WHO Asian BMI/Adiposity guidelines
  final String clinicalInterpretation;
  final String regionalInterpretation;
  final DateTime estimatedAt;

  const WearableFreeCompositionReport({
    required this.ensembleBodyFatPercent,
    required this.ensembleLeanMassKg,
    required this.ensembleFatMassKg,
    required this.ensembleBoneMassKg,
    required this.ensembleTotalBodyWaterPercent,
    required this.confidenceScorePercent,
    required this.modelVarianceStdDev,
    required this.individualEstimates,
    required this.zone,
    required this.southAsianSpecificCutoffsApplied,
    required this.clinicalInterpretation,
    required this.regionalInterpretation,
    required this.estimatedAt,
  });
}
