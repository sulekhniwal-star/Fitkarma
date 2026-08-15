import 'dart:math' as math;

class CgmReadingData {
  final String id;
  final DateTime timestamp;
  final double glucoseMgDl;

  const CgmReadingData({
    required this.id,
    required this.timestamp,
    required this.glucoseMgDl,
  });
}

class RetrospectiveFoodLog {
  final String localId;
  final String foodName;
  final DateTime consumeTime;
  final double carbsGrams;
  final int processingTier;
  final bool hasGlycemicAnalysis;
  final double? glycemicSpike;
  final double? mealQualityScore;

  const RetrospectiveFoodLog({
    required this.localId,
    required this.foodName,
    required this.consumeTime,
    required this.carbsGrams,
    this.processingTier = 2,
    this.hasGlycemicAnalysis = false,
    this.glycemicSpike,
    this.mealQualityScore,
  });
}

class GlycemicMatchResult {
  final bool isAnalysisComplete;
  final double? baselineGlucose;
  final double? peakGlucose;
  final double? glycemicSpike;

  GlycemicMatchResult.incomplete()
      : isAnalysisComplete = false,
        baselineGlucose = null,
        peakGlucose = null,
        glycemicSpike = null;

  GlycemicMatchResult.complete({
    required this.baselineGlucose,
    required this.peakGlucose,
    required this.glycemicSpike,
  }) : isAnalysisComplete = true;
}

/// Pure-Dart Retrospective Glucose Matcher per §P10-L spec
/// Evaluates late-arriving CGM batches against 150-minute food consumption windows.
class RetrospectiveGlucoseMatcher {
  const RetrospectiveGlucoseMatcher();

  GlycemicMatchResult processMealWindow({
    required DateTime mealConsumeTime,
    required List<CgmReadingData> syncedReadings,
  }) {
    // 1. Baseline Window (-30 mins to 0 mins relative to meal)
    final preMealStart = mealConsumeTime.subtract(const Duration(minutes: 30));
    final baselineReadings = syncedReadings
        .where((r) =>
            r.timestamp.isAfter(preMealStart) &&
            r.timestamp.isBefore(mealConsumeTime))
        .map((r) => r.glucoseMgDl)
        .toList();

    // 2. Post-Meal Window (0 mins to 120 mins post-meal)
    final postMealEnd = mealConsumeTime.add(const Duration(minutes: 120));
    final postMealReadings = syncedReadings
        .where((r) =>
            r.timestamp.isAfter(mealConsumeTime) &&
            r.timestamp.isBefore(postMealEnd))
        .map((r) => r.glucoseMgDl)
        .toList();

    // 3. Confirm target dataset density (>=2 baseline, >=4 post-meal readings)
    if (baselineReadings.length < 2 || postMealReadings.length < 4) {
      return GlycemicMatchResult.incomplete();
    }

    // 4. Deterministic tracking mathematics
    final double avgBaseline =
        baselineReadings.reduce((a, b) => a + b) / baselineReadings.length;
    final double maxPeak = postMealReadings.reduce(math.max);
    final double calculatedSpike = maxPeak - avgBaseline;

    return GlycemicMatchResult.complete(
      baselineGlucose: avgBaseline,
      peakGlucose: maxPeak,
      glycemicSpike: calculatedSpike.clamp(0.0, 300.0),
    );
  }

  double recalculateQualityWithSpike(RetrospectiveFoodLog meal, double spike) {
    final double processingPenalty = meal.processingTier * 12.0;
    final double spikePenalty = spike > 45.0 ? 25.0 : 0.0;
    return (100.0 - processingPenalty - spikePenalty).clamp(1.0, 100.0);
  }
}
