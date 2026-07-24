/// §P10-H Continuous Biomarker Tracking (CGM Sync) — Sync Engine & Retrospective Pipeline (§P10-L)
///
/// Ingests live continuous glucose readings (GlucoseReading, GlucoseTrend, SensorStatus),
/// detects glucose spikes (> 40 mg/dL rise within 90 mins), correlates preceding food logs
/// in a 2-hour window, and generates retrospective glycemic optimization insights matching §P10-H & §P10-L specs.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models (§P10-H Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum GlucoseTrend {
  rapidlyRising('↗↗ Rapidly Rising', '🔥'),
  rising('↗ Rising', '📈'),
  flat('→ Flat', '➡️'),
  falling('↘ Falling', '📉'),
  rapidlyFalling('↘↘ Rapidly Falling', '💧');

  const GlucoseTrend(this.displayName, this.indicatorEmoji);

  final String displayName;
  final String indicatorEmoji;
}

enum SensorStatus {
  active('Sensor Active', '🟩'),
  warmingUp('Warming Up', '🟨'),
  error('Sensor Error', '🟥'),
  expired('Sensor Expired', '⬛');

  const SensorStatus(this.displayName, this.indicatorEmoji);

  final String displayName;
  final String indicatorEmoji;
}

class GlucoseReading {
  const GlucoseReading({
    required this.readingId,
    required this.timestamp,
    required this.glucoseValueMgDl,
    required this.trendDirection,
    required this.status,
  });

  final String readingId;
  final DateTime timestamp;
  final double glucoseValueMgDl;
  final GlucoseTrend trendDirection;
  final SensorStatus status;
}

class CorrelatedMealEntry {
  const CorrelatedMealEntry({
    required this.foodName,
    required this.consumeTime,
    required this.carbsGrams,
  });

  final String foodName;
  final DateTime consumeTime;
  final double carbsGrams;
}

class CgmSpikeEvent {
  const CgmSpikeEvent({
    required this.spikeTime,
    required this.startingGlucose,
    required this.peakGlucose,
    required this.glucoseDelta,
    required this.correlatedMeal,
    required this.aiInsight,
  });

  final DateTime spikeTime;
  final double startingGlucose;
  final double peakGlucose;
  final double glucoseDelta;
  final CorrelatedMealEntry correlatedMeal;
  final String aiInsight;
}

/// Structured report generated when a batch of CGM readings arrives (§P10-L RGPP).
class LateArrivingBatchReport {
  const LateArrivingBatchReport({
    required this.isLateArrivingBatch,
    required this.maxLatencyMinutes,
    required this.lateReadingCount,
    required this.totalReadingCount,
    required this.earliestTimestamp,
    required this.latestTimestamp,
    required this.hasSufficientDensity,
  });

  final bool isLateArrivingBatch;
  final int maxLatencyMinutes;
  final int lateReadingCount;
  final int totalReadingCount;
  final DateTime earliestTimestamp;
  final DateTime latestTimestamp;
  final bool hasSufficientDensity;
}

/// Result of matching a late-arriving CGM reading batch to a logged meal (§P10-L RGPP).
class RetroactiveMatchResult {
  const RetroactiveMatchResult({
    required this.meal,
    required this.baselineGlucose,
    required this.peakGlucose,
    required this.spikeDelta,
    required this.syncLatencyMinutes,
    required this.isRetroactivelyLinked,
    required this.retrospectiveInsight,
    this.matchingConfidence = 1.0,
  });

  final CorrelatedMealEntry meal;
  final double baselineGlucose;
  final double peakGlucose;
  final double spikeDelta;
  final int syncLatencyMinutes;
  final bool isRetroactivelyLinked;
  final String retrospectiveInsight;
  final double matchingConfidence;
}

// ─────────────────────────────────────────────────────────────────────────────
// CgmSyncEngine (§P10-H & §P10-L Specifications)
// ─────────────────────────────────────────────────────────────────────────────

class CgmSyncEngine {
  const CgmSyncEngine();

  /// §P10-L — Detects late-arriving CGM batches with sync latency >= 15 minutes.
  LateArrivingBatchReport detectLateArrivingBatch(
    List<GlucoseReading> batch, {
    DateTime? syncTime,
  }) {
    final now = syncTime ?? DateTime.now();
    if (batch.isEmpty) {
      return LateArrivingBatchReport(
        isLateArrivingBatch: false,
        maxLatencyMinutes: 0,
        lateReadingCount: 0,
        totalReadingCount: 0,
        earliestTimestamp: now,
        latestTimestamp: now,
        hasSufficientDensity: false,
      );
    }

    int lateCount = 0;
    int maxLatency = 0;
    DateTime earliest = batch.first.timestamp;
    DateTime latest = batch.first.timestamp;

    for (final reading in batch) {
      if (reading.timestamp.isBefore(earliest)) earliest = reading.timestamp;
      if (reading.timestamp.isAfter(latest)) latest = reading.timestamp;

      final latency = now.difference(reading.timestamp).inMinutes;
      if (latency >= 15) {
        lateCount++;
        if (latency > maxLatency) maxLatency = latency;
      }
    }

    return LateArrivingBatchReport(
      isLateArrivingBatch: lateCount > 0,
      maxLatencyMinutes: maxLatency,
      lateReadingCount: lateCount,
      totalReadingCount: batch.length,
      earliestTimestamp: earliest,
      latestTimestamp: latest,
      hasSufficientDensity: batch.length >= 2,
    );
  }

  /// §P10-L — Retroactive Food-Window Linking Algorithm.
  /// Matches historical/late-arriving CGM batches to preceding meal logs in a 24-hour window.
  List<RetroactiveMatchResult> executeRetroactiveFoodLinking({
    required List<GlucoseReading> batch,
    required List<CorrelatedMealEntry> unlinkedMeals,
    DateTime? syncTime,
    Duration lookbackWindow = const Duration(hours: 24),
  }) {
    if (batch.isEmpty || unlinkedMeals.isEmpty) return const [];
    final now = syncTime ?? DateTime.now();

    // Sort readings chronologically
    final sortedReadings = List<GlucoseReading>.from(batch)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final results = <RetroactiveMatchResult>[];

    for (final meal in unlinkedMeals) {
      final mealAge = now.difference(meal.consumeTime);
      if (mealAge > lookbackWindow || mealAge.isNegative) continue;

      // Find pre-meal baseline readings: [meal.consumeTime - 30m, meal.consumeTime + 15m]
      final baselineReadings = sortedReadings.where((r) {
        final diff = r.timestamp.difference(meal.consumeTime).inMinutes;
        return diff >= -30 && diff <= 15;
      }).toList();

      // Find post-meal response readings: [meal.consumeTime, meal.consumeTime + 120m]
      final postMealReadings = sortedReadings.where((r) {
        final diff = r.timestamp.difference(meal.consumeTime).inMinutes;
        return diff >= 0 && diff <= 120;
      }).toList();

      if (postMealReadings.isEmpty) continue;

      // Calculate true baseline
      final baseline = baselineReadings.isNotEmpty
          ? baselineReadings
              .map((r) => r.glucoseValueMgDl)
              .reduce((a, b) => a + b) /
              baselineReadings.length
          : postMealReadings.first.glucoseValueMgDl;

      // Calculate peak
      final peak = postMealReadings
          .map((r) => r.glucoseValueMgDl)
          .reduce((a, b) => a > b ? a : b);

      final spikeDelta = peak - baseline;
      final maxLatency = now.difference(postMealReadings.last.timestamp).inMinutes;
      final confidence = (baselineReadings.isNotEmpty && postMealReadings.length >= 3)
          ? 1.0
          : 0.7;

      final insight = _generateRetrospectiveGlycemicInsight(meal.foodName, spikeDelta);

      results.add(RetroactiveMatchResult(
        meal: meal,
        baselineGlucose: baseline,
        peakGlucose: peak,
        spikeDelta: spikeDelta,
        syncLatencyMinutes: maxLatency,
        isRetroactivelyLinked: true,
        retrospectiveInsight: insight,
        matchingConfidence: confidence,
      ));
    }

    return results;
  }

  /// Detects glucose spikes and correlates with pre-meal logs in a 2-hour window (§P10-H & §P10-L spec).
  List<CgmSpikeEvent> detectSpikesAndCorrelate({
    required List<GlucoseReading> readings,
    required List<CorrelatedMealEntry> mealLogs,
  }) {
    final spikes = <CgmSpikeEvent>[];
    if (readings.length < 2) return spikes;

    for (int i = 1; i < readings.length; i++) {
      final prev = readings[i - 1];
      final current = readings[i];

      final delta = current.glucoseValueMgDl - prev.glucoseValueMgDl;
      final minutesDiff = current.timestamp.difference(prev.timestamp).inMinutes;

      // Spike condition: glucose rises > 40 mg/dL within 90 mins (§P10-H spec)
      if (delta > 40.0 && minutesDiff <= 90 && minutesDiff >= 0) {
        // Find foods eaten in the 2 hours preceding the spike
        final preMeals = mealLogs.where((log) {
          return log.consumeTime.isBefore(current.timestamp) &&
              log.consumeTime.isAfter(current.timestamp.subtract(const Duration(hours: 2)));
        }).toList();

        if (preMeals.isNotEmpty) {
          final meal = preMeals.first;
          final insight = _generateRetrospectiveGlycemicInsight(meal.foodName, delta);

          spikes.add(CgmSpikeEvent(
            spikeTime: current.timestamp,
            startingGlucose: prev.glucoseValueMgDl,
            peakGlucose: current.glucoseValueMgDl,
            glucoseDelta: delta,
            correlatedMeal: meal,
            aiInsight: insight,
          ));
        }
      }
    }

    return spikes;
  }

  /// Retrospective Glycemic Processing Pipeline (§P10-L Specification).
  String _generateRetrospectiveGlycemicInsight(String foodName, double delta) {
    if (foodName.toLowerCase().contains('rice') || foodName.toLowerCase().contains('thali')) {
      return '$foodName alone triggers rapid digestion (+${delta.round()} mg/dL). '
          'Next time, add 150g salad (fiber) or paneer (protein) before eating the rice to reduce the spike by ~30%.';
    } else if (foodName.toLowerCase().contains('juice') || foodName.toLowerCase().contains('soda')) {
      return '$foodName delivers liquid sugars rapidly (+${delta.round()} mg/dL). '
          'Opt for whole fruit or pair with almonds to buffer glucose absorption.';
    } else {
      return '$foodName triggered a +${delta.round()} mg/dL glycemic spike. '
          'Consider adding fiber or protein to blunt future postprandial glucose curves.';
    }
  }
}
