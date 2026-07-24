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

// ─────────────────────────────────────────────────────────────────────────────
// CgmSyncEngine (§P10-H & §P10-L Specifications)
// ─────────────────────────────────────────────────────────────────────────────

class CgmSyncEngine {
  const CgmSyncEngine();

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
