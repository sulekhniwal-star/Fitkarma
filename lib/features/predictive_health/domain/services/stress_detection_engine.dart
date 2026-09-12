import '../models/predictive_health_models.dart';

class StressDetectionEngine {
  const StressDetectionEngine();

  /// Infers autonomic nervous system stress and sympathovagal balance from nocturnal biometrics
  StressIndex evaluateStress({
    required double todayNocturnalHrvMs,
    required double baselineHrvMs,
    required double todayRestingHrBpm,
    required double baselineRestingHrBpm,
    required double sleepEfficiencyPct, // 0.0 to 1.0
  }) {
    double stressScore = 30.0; // Base baseline

    // HRV Suppression (Drop of >15% below baseline indicates sympathetic overdrive)
    final hrvDeltaRatio = (baselineHrvMs - todayNocturnalHrvMs) / (baselineHrvMs > 0 ? baselineHrvMs : 1.0);
    if (hrvDeltaRatio > 0.25) {
      stressScore += 35.0;
    } else if (hrvDeltaRatio > 0.10) {
      stressScore += 18.0;
    } else if (hrvDeltaRatio < -0.10) {
      stressScore -= 15.0; // High parasympathetic tone / well rested
    }

    // Resting HR elevation above baseline
    final hrDelta = todayRestingHrBpm - baselineRestingHrBpm;
    if (hrDelta >= 8.0) {
      stressScore += 25.0;
    } else if (hrDelta >= 4.0) {
      stressScore += 12.0;
    } else if (hrDelta <= -2.0) {
      stressScore -= 10.0;
    }

    // Sleep Fragmentation
    if (sleepEfficiencyPct < 0.80) {
      stressScore += 15.0;
    }

    stressScore = stressScore.clamp(0.0, 100.0);

    StressLevel level;
    String guidance;
    String guidanceHi;

    if (stressScore >= 75.0) {
      level = StressLevel.high;
      guidance = 'High physiological stress. Avoid intense HIIT/max-effort lifting. Prioritize Yoga Nidra and early sleep.';
      guidanceHi = 'शारीरिक तनाव अधिक है। भारी वर्कआउट से बचें। योग निद्रा और समय पर सोने को प्राथमिकता दें।';
    } else if (stressScore >= 50.0) {
      level = StressLevel.moderate;
      guidance = 'Moderate sympathetic activation. Keep workouts at moderate RPE 6–7 with adequate intra-set rest.';
      guidanceHi = 'मध्यम तनाव स्तर। वर्कआउट को मध्यम तीव्रता पर रखें और सेट्स के बीच पर्याप्त विश्राम लें।';
    } else if (stressScore >= 25.0) {
      level = StressLevel.mild;
      guidance = 'Normal healthy recovery state. Great day for regular structured training.';
      guidanceHi = 'सामान्य स्वस्थ रिकवरी। नियमित वर्कआउट के लिए उत्तम दिन।';
    } else {
      level = StressLevel.restored;
      guidance = 'Optimal parasympathetic restoration! Nervous system is primed for high physical performance.';
      guidanceHi = 'उत्कृष्ट रिकवरी! आपका तंत्रिका तंत्र उच्च प्रदर्शन और गहन वर्कआउट के लिए तैयार है।';
    }

    return StressIndex(
      score: double.parse(stressScore.toStringAsFixed(1)),
      level: level,
      nocturnalHrvMs: todayNocturnalHrvMs,
      restingHrBpm: todayRestingHrBpm,
      baselineHrvMs: baselineHrvMs,
      recoveryGuidance: guidance,
      recoveryGuidanceHindi: guidanceHi,
    );
  }
}
