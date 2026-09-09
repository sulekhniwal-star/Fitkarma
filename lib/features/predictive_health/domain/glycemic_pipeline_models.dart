import 'package:flutter/foundation.dart';

/// Retrospective Glycemic Classification Zone
enum GlycemicStabilityZone {
  optimalStable(
    name: 'Optimal Homeostasis',
    regionalName: 'उत्कृष्ट शर्करा संतुलन (साम्य अवस्था)',
    description: 'Low glycemic variability (CV < 33%) with smooth circadian excursions.',
  ),
  moderateVolatility(
    name: 'Moderate Volatility',
    regionalName: 'मध्यम शर्करा उतार-चढ़ाव',
    description: 'Postprandial spikes or minor nocturnal dips; responsive to meal timing.',
  ),
  highDysglycemia(
    name: 'High Glycemic Volatility',
    regionalName: 'अत्यधिक शर्करा अस्थिरता (विषम अवस्था)',
    description: 'Frequent excursions > 140 mg/dL or nocturnal hypoglycemia risk.',
  );

  final String name;
  final String regionalName;
  final String description;

  const GlycemicStabilityZone({
    required this.name,
    required this.regionalName,
    required this.description,
  });
}

/// Chrono-glycemic time window
enum ChronoGlycemicWindow {
  dawnFasting(name: 'Dawn & Fasting (04:00 - 08:00)', regionalName: 'उषाकाल व प्रभात शर्करा'),
  postBreakfast(name: 'Post-Breakfast (08:00 - 12:00)', regionalName: 'प्रातराश उपरांत'),
  postLunch(name: 'Post-Lunch (12:00 - 16:00)', regionalName: 'मध्याह्न भोजन उपरांत'),
  postDinner(name: 'Post-Dinner (19:00 - 23:00)', regionalName: 'रात्रि भोजन उपरांत'),
  nocturnal(name: 'Nocturnal Basal (23:00 - 04:00)', regionalName: 'निशि काल शर्करा');

  final String name;
  final String regionalName;

  const ChronoGlycemicWindow({
    required this.name,
    required this.regionalName,
  });
}

/// A parsed retrospective glucose telemetry sample
@immutable
class HistoricalGlucoseSample {
  final DateTime timestamp;
  final double glucoseValueMgDl;
  final String? associatedMealOrEvent;

  const HistoricalGlucoseSample({
    required this.timestamp,
    required this.glucoseValueMgDl,
    this.associatedMealOrEvent,
  });
}

/// Analysis of a specific circadian / chronological time window
@immutable
class WindowGlycemicSummary {
  final ChronoGlycemicWindow window;
  final double meanGlucose;
  final double peakGlucose;
  final double standardDeviation;
  final double timeInRangePercent;
  final String clinicalObservation;
  final String regionalObservation;

  const WindowGlycemicSummary({
    required this.window,
    required this.meanGlucose,
    required this.peakGlucose,
    required this.standardDeviation,
    required this.timeInRangePercent,
    required this.clinicalObservation,
    required this.regionalObservation,
  });
}

/// Postprandial Excursion Event Detail
@immutable
class PostprandialExcursion {
  final String mealName;
  final DateTime mealTime;
  final double baselineGlucose;
  final double peakGlucose;
  final double deltaGlucose; // Peak - Baseline
  final double recoveryHours; // Time to return to baseline
  final bool isSpikeExcursion; // Delta > 35 mg/dL

  const PostprandialExcursion({
    required this.mealName,
    required this.mealTime,
    required this.baselineGlucose,
    required this.peakGlucose,
    required this.deltaGlucose,
    required this.recoveryHours,
    required this.isSpikeExcursion,
  });
}

/// Comprehensive Retrospective Glycemic Pipeline Report
@immutable
class RetrospectiveGlycemicReport {
  final int totalDaysAnalyzed;
  final int totalSamplesProcessed;
  final double overallMeanGlucose;
  final double standardDeviation;
  final double coefficientOfVariationPercent; // CV% = (SD / Mean) * 100
  final double glucoseManagementIndicatorGmi; // 3.31 + (0.02392 * Mean)
  final double timeInRangePercent; // 70-140 mg/dL
  final double timeAboveRangePercent; // > 140 mg/dL
  final double timeBelowRangePercent; // < 70 mg/dL
  final GlycemicStabilityZone stabilityZone;
  final List<WindowGlycemicSummary> circadianWindows;
  final List<PostprandialExcursion> recentExcursions;
  final String actionableMetabolicRecommendation;
  final String regionalMetabolicRecommendation;
  final DateTime generatedAt;

  const RetrospectiveGlycemicReport({
    required this.totalDaysAnalyzed,
    required this.totalSamplesProcessed,
    required this.overallMeanGlucose,
    required this.standardDeviation,
    required this.coefficientOfVariationPercent,
    required this.glucoseManagementIndicatorGmi,
    required this.timeInRangePercent,
    required this.timeAboveRangePercent,
    required this.timeBelowRangePercent,
    required this.stabilityZone,
    required this.circadianWindows,
    required this.recentExcursions,
    required this.actionableMetabolicRecommendation,
    required this.regionalMetabolicRecommendation,
    required this.generatedAt,
  });
}
