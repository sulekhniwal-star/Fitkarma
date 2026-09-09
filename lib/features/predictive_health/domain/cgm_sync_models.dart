import 'package:flutter/foundation.dart';

/// Directional glycemic velocity trend
enum GlucoseTrendDirection {
  rapidlyRising(symbol: '↑↑', label: 'Rising Rapidly (> 2 mg/dL/min)', colorCode: 0xFFFF5252),
  rising(symbol: '↑', label: 'Rising (1 - 2 mg/dL/min)', colorCode: 0xFFFFB300),
  steady(symbol: '→', label: 'Stable & Flat (± 1 mg/dL/min)', colorCode: 0xFF00E676),
  falling(symbol: '↓', label: 'Falling (1 - 2 mg/dL/min)', colorCode: 0xFF448AFF),
  rapidlyFalling(symbol: '↓↓', label: 'Falling Rapidly (> 2 mg/dL/min)', colorCode: 0xFF9C27B0);

  final String symbol;
  final String label;
  final int colorCode;

  const GlucoseTrendDirection({
    required this.symbol,
    required this.label,
    required this.colorCode,
  });
}

/// Clinical Glycemic Range classification
enum GlucoseRangeTier {
  hypo(label: 'Low / Hypoglycemic (< 70 mg/dL)', regionalLabel: 'निम्न शर्करा (हाइपोग्लाइसीमिया)', colorCode: 0xFF9C27B0),
  inRange(label: 'Optimal In-Range (70 - 140 mg/dL)', regionalLabel: 'आदर्श शर्करा सीमा (७०-१४०)', colorCode: 0xFF00E676),
  elevated(label: 'Elevated (141 - 180 mg/dL)', regionalLabel: 'बढ़ा हुआ शर्करा स्तर', colorCode: 0xFFFFB300),
  spikeHigh(label: 'Acute Spike (> 180 mg/dL)', regionalLabel: 'अत्यधिक शर्करा स्पाइक', colorCode: 0xFFFF5252);

  final String label;
  final String regionalLabel;
  final int colorCode;

  const GlucoseRangeTier({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
  });
}

/// Individual continuous glucose data point
@immutable
class GlucoseTelemetryPoint {
  final DateTime timestamp;
  final double glucoseValue; // mg/dL
  final GlucoseTrendDirection trend;
  final GlucoseRangeTier rangeTier;
  final String? eventTag; // e.g. "Breakfast", "Lunch", "Shatpawali Walk", "Workout"

  const GlucoseTelemetryPoint({
    required this.timestamp,
    required this.glucoseValue,
    required this.trend,
    required this.rangeTier,
    this.eventTag,
  });
}

/// Postprandial Meal Glycemic Event Evaluation
@immutable
class MealGlycemicSpikeEvent {
  final String id;
  final String mealName;
  final String regionalMealName;
  final DateTime mealTime;
  final double baselineGlucose;
  final double peakGlucose;
  final double spikeDelta; // peak - baseline
  final bool shatpawaliCompleted;
  final String clinicalAssessment;
  final String regionalClinicalAssessment;

  const MealGlycemicSpikeEvent({
    required this.id,
    required this.mealName,
    required this.regionalMealName,
    required this.mealTime,
    required this.baselineGlucose,
    required this.peakGlucose,
    required this.spikeDelta,
    required this.shatpawaliCompleted,
    required this.clinicalAssessment,
    required this.regionalClinicalAssessment,
  });
}

/// Actionable glycemic stabilization protocol
@immutable
class GlycemicOptimizationProtocol {
  final String id;
  final String title;
  final String regionalTitle;
  final String mechanism;
  final String regionalMechanism;
  final String instruction;
  final String expectedSpikeReduction;
  final int karmaReward;

  const GlycemicOptimizationProtocol({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.mechanism,
    required this.regionalMechanism,
    required this.instruction,
    required this.expectedSpikeReduction,
    required this.karmaReward,
  });
}

/// Comprehensive Continuous Biomarker (CGM) Sync Report
@immutable
class ContinuousGlucoseReport {
  final String sensorId; // e.g. "CGM_ULTRA_8492"
  final String sensorModel; // e.g. "Freestyle Libre 3 / Ultrahuman M1"
  final DateTime lastSyncTime;
  final double currentGlucoseMgDl;
  final GlucoseTrendDirection currentTrend;
  final double meanGlucose24h;
  final double timeInRangePercent; // TIR 70-140 mg/dL (target > 85%)
  final double timeBelowRangePercent; // TBR < 70 mg/dL
  final double timeAboveRangePercent; // TAR > 140 mg/dL
  final double glycemicVariabilityCvPercent; // Coefficient of Variation (target < 20%)
  final double estimatedGmiHbA1c; // Glucose Management Indicator
  final List<GlucoseTelemetryPoint> telemetryStream24h;
  final List<MealGlycemicSpikeEvent> detectedMealSpikes;
  final List<GlycemicOptimizationProtocol> activeProtocols;
  final String glycemicStabilityScore; // e.g. "94/100 (Optimal)"
  final String clinicalSummary;
  final String regionalClinicalSummary;

  const ContinuousGlucoseReport({
    required this.sensorId,
    required this.sensorModel,
    required this.lastSyncTime,
    required this.currentGlucoseMgDl,
    required this.currentTrend,
    required this.meanGlucose24h,
    required this.timeInRangePercent,
    required this.timeBelowRangePercent,
    required this.timeAboveRangePercent,
    required this.glycemicVariabilityCvPercent,
    required this.estimatedGmiHbA1c,
    required this.telemetryStream24h,
    required this.detectedMealSpikes,
    required this.activeProtocols,
    required this.glycemicStabilityScore,
    required this.clinicalSummary,
    required this.regionalClinicalSummary,
  });
}
