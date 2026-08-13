enum GlucoseTrend { rapidlyRising, rising, flat, falling, rapidlyFalling }

enum SensorStatus { active, warmingUp, error, expired }

class GlucoseReading {
  final String readingId;
  final DateTime timestamp;
  final double glucoseValueMgDl;
  final GlucoseTrend trendDirection;
  final SensorStatus status;

  const GlucoseReading({
    required this.readingId,
    required this.timestamp,
    required this.glucoseValueMgDl,
    required this.trendDirection,
    this.status = SensorStatus.active,
  });
}

class CgmFoodLogSnapshot {
  final String foodName;
  final DateTime consumeTime;
  final double calories;

  const CgmFoodLogSnapshot({
    required this.foodName,
    required this.consumeTime,
    required this.calories,
  });
}

class GlucoseSpikeEvent {
  final DateTime spikeTime;
  final double startingGlucose;
  final double peakGlucose;
  final double glucoseDelta;
  final List<CgmFoodLogSnapshot> correlatedFoods;

  const GlucoseSpikeEvent({
    required this.spikeTime,
    required this.startingGlucose,
    required this.peakGlucose,
    required this.glucoseDelta,
    required this.correlatedFoods,
  });
}

/// Pure-Dart CGM Analysis & Spike Detection Engine per §P10-H spec
class CgmAnalysisEngine {
  const CgmAnalysisEngine();

  List<GlucoseSpikeEvent> detectSpikes(
    List<GlucoseReading> readings,
    List<CgmFoodLogSnapshot> foodLogs,
  ) {
    final spikes = <GlucoseSpikeEvent>[];
    final sortedReadings = List<GlucoseReading>.from(readings)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (int i = 1; i < sortedReadings.length; i++) {
      final prev = sortedReadings[i - 1];
      final current = sortedReadings[i];

      // Spike condition: glucose rises > 40 mg/dL within a 90-minute window
      final delta = current.glucoseValueMgDl - prev.glucoseValueMgDl;
      if (delta > 40.0 && current.timestamp.difference(prev.timestamp).inMinutes <= 90) {
        // Correlate foods consumed in the 2 hours preceding the spike peak
        final correlated = foodLogs.where((log) =>
          log.consumeTime.isBefore(current.timestamp) &&
          log.consumeTime.isAfter(current.timestamp.subtract(const Duration(hours: 2)))
        ).toList();

        spikes.add(GlucoseSpikeEvent(
          spikeTime: current.timestamp,
          startingGlucose: prev.glucoseValueMgDl,
          peakGlucose: current.glucoseValueMgDl,
          glucoseDelta: delta,
          correlatedFoods: correlated,
        ));
      }
    }

    return spikes;
  }
}
