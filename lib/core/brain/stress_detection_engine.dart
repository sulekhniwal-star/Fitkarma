enum TrendDirection { declining, stable, improving }

enum StressLevel { normal, moderate, elevated, high }

class StressHealthInputData {
  final TrendDirection hrv7dTrend;
  final double hrv;
  final double baselineHRV;
  final double restingHR;
  final double baselineHR;
  final double sleepQuality7dAvg; // 1.0 to 5.0 scale
  final int missedWorkoutsLast7Days;
  final double appOpenFrequencyDrop; // e.g. 0.45 = 45% drop
  final int lateNightLogsPerWeek;
  final int stressLevelLastWeek;

  const StressHealthInputData({
    required this.hrv7dTrend,
    required this.hrv,
    required this.baselineHRV,
    required this.restingHR,
    required this.baselineHR,
    required this.sleepQuality7dAvg,
    required this.missedWorkoutsLast7Days,
    required this.appOpenFrequencyDrop,
    required this.lateNightLogsPerWeek,
    required this.stressLevelLastWeek,
  });
}

class StressAssessment {
  final StressLevel level;
  final int signals;
  final bool trendingUp;
  final String recommendation;
  final List<String> detectedSignalDescriptions;

  const StressAssessment({
    required this.level,
    required this.signals,
    required this.trendingUp,
    required this.recommendation,
    required this.detectedSignalDescriptions,
  });
}

/// Pure-Dart Rule-Based Stress Detection Engine per §P10-E spec (No AI)
class StressDetectionEngine {
  const StressDetectionEngine();

  StressAssessment detect(StressHealthInputData data) {
    int stressSignals = 0;
    final signalDescs = <String>[];

    // 1. HRV declining (strongest physiological stress marker: +3 points)
    if (data.hrv7dTrend == TrendDirection.declining &&
        data.hrv < data.baselineHRV * 0.85) {
      stressSignals += 3;
      final pctDrop =
          (((data.baselineHRV - data.hrv) / data.baselineHRV) * 100).round();
      signalDescs.add('HRV: -$pctDrop% below baseline');
    }

    // 2. Resting HR elevated above baseline (+2 points)
    if (data.restingHR > data.baselineHR * 1.10) {
      stressSignals += 2;
      final bpmIncrease = (data.restingHR - data.baselineHR).round();
      signalDescs.add('Resting HR: +$bpmIncrease bpm above baseline');
    }

    // 3. Sleep quality declining (+2 points)
    if (data.sleepQuality7dAvg < 3.0) {
      stressSignals += 2;
      signalDescs.add('Sleep quality declining (<3.0 avg score)');
    }

    // 4. Missed workouts (behavioral signal: +1 point)
    if (data.missedWorkoutsLast7Days >= 2) {
      stressSignals += 1;
      signalDescs.add(
          'Missed workouts (${data.missedWorkoutsLast7Days} missed in last 7 days)');
    }

    // 5. App engagement drop (behavioral signal: +1 point)
    if (data.appOpenFrequencyDrop > 0.40) {
      stressSignals += 1;
      final pctDrop = (data.appOpenFrequencyDrop * 100).round();
      signalDescs.add('App engagement drop ($pctDrop% decrease in opens)');
    }

    // 6. Late-night food logging (behavioral + lifestyle signal: +1 point)
    if (data.lateNightLogsPerWeek >= 3) {
      stressSignals += 1;
      signalDescs.add(
          'Late-night food logging (${data.lateNightLogsPerWeek} logs after 11 PM)');
    }

    final level = switch (stressSignals) {
      >= 7 => StressLevel.high,
      >= 4 => StressLevel.elevated,
      >= 2 => StressLevel.moderate,
      _ => StressLevel.normal,
    };

    return StressAssessment(
      level: level,
      signals: stressSignals,
      trendingUp: data.stressLevelLastWeek < stressSignals,
      recommendation: _buildRecommendation(level),
      detectedSignalDescriptions: signalDescs,
    );
  }

  String _buildRecommendation(StressLevel level) {
    return switch (level) {
      StressLevel.high =>
        'High stress pattern detected! Switch to 20-min decompression workout, perform 5-min bedtime breathing, and consult AI Coach.',
      StressLevel.elevated =>
        'Elevated stress trending. Reduce training intensity by 20% and prioritize 8+ hours sleep.',
      StressLevel.moderate =>
        'Mild stress indicators present. Maintain active recovery & hydration.',
      StressLevel.normal =>
        'Autonomic nervous system operating in optimal recovery equilibrium.',
    };
  }
}
