import 'dart:math';
import 'body_analytics_models.dart';
import 'wearable_free_composition_models.dart';

/// Pure Dart Deterministic Engine for Wearable-Free & Sensor-Free Body Composition Estimation
class WearableFreeCompositionEngine {
  const WearableFreeCompositionEngine();

  /// Estimates comprehensive multi-compartment body composition using 4 clinical surrogate models
  WearableFreeCompositionReport computeWearableFreeComposition({
    required double weightKg,
    required double heightCm,
    required int age,
    required AnthropometricSex sex,
    required double waistCm,
    required double neckCm,
    double? hipsCm,
    bool applySouthAsianCalibrations = true,
    DateTime? executionTime,
  }) {
    final now = executionTime ?? DateTime.now();
    final heightM = heightCm / 100.0;
    final bmi = heightM > 0 ? weightKg / (heightM * heightM) : 22.0;
    final effectiveHipsCm = hipsCm ?? (sex == AnthropometricSex.female ? waistCm * 1.3 : waistCm * 1.15);

    // 1. Model 1: US Navy Anthropometric Model
    double usNavyBf;
    if (sex == AnthropometricSex.male) {
      final diff = max(1.0, waistCm - neckCm);
      final denominator = 1.0324 - (0.19077 * (log(diff) / ln10)) + (0.15456 * (log(heightCm) / ln10));
      usNavyBf = denominator > 0 ? (495.0 / denominator) - 450.0 : 18.0;
    } else {
      final sum = max(1.0, waistCm + effectiveHipsCm - neckCm);
      final denominator = 1.29579 - (0.35004 * (log(sum) / ln10)) + (0.22100 * (log(heightCm) / ln10));
      usNavyBf = denominator > 0 ? (495.0 / denominator) - 450.0 : 24.0;
    }
    usNavyBf = usNavyBf.clamp(5.0, 50.0);

    // 2. Model 2: YMCA Anthropometric Model (Converted from inches/lbs)
    final waistInches = waistCm / 2.54;
    final weightLbs = weightKg * 2.20462;
    double ymcaBf;
    if (sex == AnthropometricSex.male) {
      ymcaBf = (((4.15 * waistInches) - (0.082 * weightLbs) - 98.42) / weightLbs) * 100.0;
    } else {
      ymcaBf = (((4.15 * waistInches) - (0.082 * weightLbs) - 76.76) / weightLbs) * 100.0;
    }
    ymcaBf = ymcaBf.clamp(5.0, 50.0);

    // 3. Model 3: Deurenberg Clinical Equation
    final sexFactor = sex == AnthropometricSex.male ? 1 : 0;
    double deurenbergBf = (1.20 * bmi) + (0.23 * age) - (10.8 * sexFactor) - 5.4;
    deurenbergBf = deurenbergBf.clamp(5.0, 50.0);

    // 4. Model 4: Gallagher Clinical Dual-Energy Surrogate
    double gallagherBf;
    if (sex == AnthropometricSex.male) {
      gallagherBf = ((1.46 * bmi) + (0.14 * age) - 21.6 + (applySouthAsianCalibrations ? 1.5 : 0.0)).clamp(5.0, 50.0);
    } else {
      gallagherBf = ((1.46 * bmi) + (0.14 * age) - 10.0 + (applySouthAsianCalibrations ? 1.5 : 0.0)).clamp(5.0, 50.0);
    }

    // 5. Individual Model Summaries
    final modelEstimates = [
      _buildSingleEstimate(CompositionEstimationModel.usNavyCircumference, usNavyBf, weightKg, 0.35),
      _buildSingleEstimate(CompositionEstimationModel.ymcaBodyFatModel, ymcaBf, weightKg, 0.25),
      _buildSingleEstimate(CompositionEstimationModel.deurenbergRegression, deurenbergBf, weightKg, 0.20),
      _buildSingleEstimate(CompositionEstimationModel.gallagherClinical, gallagherBf, weightKg, 0.20),
    ];

    // 6. Weighted Ensemble Consensus
    final weightedSum = modelEstimates.fold<double>(
      0.0,
      (acc, m) => acc + (m.estimatedBodyFatPercent * m.modelWeighting),
    );
    final ensembleBf = weightedSum.clamp(5.0, 50.0);

    // Standard deviation between models
    final meanBf = modelEstimates.fold<double>(0.0, (acc, m) => acc + m.estimatedBodyFatPercent) / modelEstimates.length;
    final variance = modelEstimates.fold<double>(0.0, (acc, m) => acc + pow(m.estimatedBodyFatPercent - meanBf, 2)) / modelEstimates.length;
    final stdDev = sqrt(variance);

    // Confidence score based on low variance between models
    final confidenceScore = (100.0 - (stdDev * 3.0)).clamp(70.0, 98.0);

    // Mass Breakdown
    final fatMassKg = weightKg * (ensembleBf / 100.0);
    final leanMassKg = weightKg - fatMassKg;
    final boneMassKg = weightKg * (sex == AnthropometricSex.male ? 0.046 : 0.042);
    final tbwPercent = ((leanMassKg * 0.73) / weightKg) * 100.0;

    // Classification Zone
    final whtr = heightCm > 0 ? waistCm / heightCm : 0.48;
    BodyCompositionZone zone;
    if (sex == AnthropometricSex.male) {
      if (ensembleBf < 14.0) {
        zone = BodyCompositionZone.athleticLean;
      } else if (ensembleBf <= 21.0 && whtr <= 0.50) {
        zone = BodyCompositionZone.fitHealthy;
      } else if (leanMassKg / weightKg < 0.68) {
        zone = BodyCompositionZone.sarcopenicRisk;
      } else {
        zone = BodyCompositionZone.elevatedAdiposity;
      }
    } else {
      if (ensembleBf < 21.0) {
        zone = BodyCompositionZone.athleticLean;
      } else if (ensembleBf <= 28.0 && whtr <= 0.50) {
        zone = BodyCompositionZone.fitHealthy;
      } else if (leanMassKg / weightKg < 0.62) {
        zone = BodyCompositionZone.sarcopenicRisk;
      } else {
        zone = BodyCompositionZone.elevatedAdiposity;
      }
    }

    String interpretation;
    String regInterpretation;
    if (stdDev < 2.5) {
      interpretation = 'High model concordance (${confidenceScore.toInt()}% confidence). Low variance across all 4 clinical equations.';
      regInterpretation = 'सभी ४ नैदानिक समीकरणों में उच्च समानता (${confidenceScore.toInt()}% विश्वसनीयता)।';
    } else {
      interpretation = 'Moderate variance across models. Anthropometric measurements remain primary anchor.';
      regInterpretation = 'मॉडल परिणामों में मध्यम अंतर। शारीरिक माप मुख्य आधार हैं।';
    }

    return WearableFreeCompositionReport(
      ensembleBodyFatPercent: double.parse(ensembleBf.toStringAsFixed(1)),
      ensembleLeanMassKg: double.parse(leanMassKg.toStringAsFixed(1)),
      ensembleFatMassKg: double.parse(fatMassKg.toStringAsFixed(1)),
      ensembleBoneMassKg: double.parse(boneMassKg.toStringAsFixed(2)),
      ensembleTotalBodyWaterPercent: double.parse(tbwPercent.toStringAsFixed(1)),
      confidenceScorePercent: double.parse(confidenceScore.toStringAsFixed(1)),
      modelVarianceStdDev: double.parse(stdDev.toStringAsFixed(2)),
      individualEstimates: modelEstimates,
      zone: zone,
      southAsianSpecificCutoffsApplied: applySouthAsianCalibrations,
      clinicalInterpretation: interpretation,
      regionalInterpretation: regInterpretation,
      estimatedAt: now,
    );
  }

  SingleModelEstimate _buildSingleEstimate(
    CompositionEstimationModel model,
    double bodyFat,
    double weightKg,
    double weighting,
  ) {
    final fatMass = weightKg * (bodyFat / 100.0);
    final leanMass = weightKg - fatMass;
    return SingleModelEstimate(
      model: model,
      estimatedBodyFatPercent: double.parse(bodyFat.toStringAsFixed(1)),
      estimatedLeanMassKg: double.parse(leanMass.toStringAsFixed(1)),
      estimatedFatMassKg: double.parse(fatMass.toStringAsFixed(1)),
      modelWeighting: weighting,
    );
  }
}
