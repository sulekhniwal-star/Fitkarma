/// §P10-G Longevity Score + Biological Age v1 — Riverpod Notifier
///
/// Riverpod state management for loading and calculating longevity score matching §P10-G spec.
library;

import 'package:fitkarma/features/predictive/longevity_calculator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LongevityNotifier extends Notifier<LongevityResult> {
  final LongevityScoreCalculator _calculator = const LongevityScoreCalculator();

  @override
  LongevityResult build() {
    const sampleInput = LongevityInputData(
      estimatedVo2Max: 46.5,
      age: 28,
      isMale: true,
      bodyFatPct: 16.5,
      avgSleepHours: 7.6,
      sleepQuality7dAvg: 82.0,
      avgDailySteps7d: 9200,
      workoutsPerWeek: 4,
      restingHr: 58.0,
      hrv: 64.0,
      baselineHrv: 55.0,
      hasClinicalData: true,
      hbA1c: 5.4,
      ldlMgDl: 115.0,
      hdlMgDl: 54.0,
      vitDNgMl: 38.0,
    );

    return _calculator.calculate(sampleInput);
  }

  void recalculate(LongevityInputData input) {
    state = _calculator.calculate(input);
  }
}

final longevityProvider =
    NotifierProvider<LongevityNotifier, LongevityResult>(LongevityNotifier.new);
