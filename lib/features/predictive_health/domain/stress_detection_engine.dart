import 'dart:math' as math;
import 'stress_detection_models.dart';

/// Pure Dart Deterministic Engine for Inferred Autonomic Stress & Vagal Dynamics
class StressDetectionEngine {
  const StressDetectionEngine();

  /// Infer real-time and 24-hour autonomic stress report
  InferredStressReport inferStressState({
    required double currentRmssd, // ms (e.g. 38.0)
    required double baselineRmssd, // ms (e.g. 52.0)
    required double currentRestingHeartRate, // bpm (e.g. 74.0)
    required double baselineRestingHeartRate, // bpm (e.g. 60.0)
    required double currentRespirationRate, // breaths/min (e.g. 17.5)
    required double baselineRespirationRate, // breaths/min (e.g. 13.5)
    required int nocturnalRestlessnessCount, // micro-arousals (e.g. 4)
    required int daytimeSedentaryPulseSpikes, // count of spikes >12bpm (e.g. 3)
    DateTime? evaluationTime,
  }) {
    final now = evaluationTime ?? DateTime.now();

    // 1. Evaluate Individual Stress Signals
    final signals = <InferredStressSignal>[];

    // Signal A: HRV Suppression (Vagal Withdrawal)
    final hrvRatio = currentRmssd / (baselineRmssd <= 0 ? 1.0 : baselineRmssd);
    double hrvStressPts = 0.0;
    if (hrvRatio < 0.65) {
      hrvStressPts = 32.0;
    } else if (hrvRatio < 0.82) {
      hrvStressPts = 20.0;
    } else if (hrvRatio < 0.95) {
      hrvStressPts = 10.0;
    } else {
      hrvStressPts = 2.0;
    }

    signals.add(
      InferredStressSignal(
        signalType: StressSignalType.hrvSuppression,
        measuredValue: currentRmssd,
        unit: 'ms rMSSD',
        baselineValue: baselineRmssd,
        stressPointsContribution: hrvStressPts,
        insight: hrvRatio < 0.80
            ? 'Vagal tone is suppressed by ${((1 - hrvRatio) * 100).toInt()}% vs personal baseline.'
            : 'Heart rate variability reflects stable parasympathetic braking.',
        regionalInsight: hrvRatio < 0.80
            ? 'हृदय परिवर्तनशीलता (HRV) सामान्य स्तर से ${((1 - hrvRatio) * 100).toInt()}% कम है।'
            : 'वेगल तंत्रिका संतुलन सामान्य व स्थिर अवस्था में है।',
      ),
    );

    // Signal B: Sedentary Heart Rate Surges
    final rhrDelta = currentRestingHeartRate - baselineRestingHeartRate;
    double rhrStressPts = 0.0;
    if (rhrDelta > 15.0 || daytimeSedentaryPulseSpikes >= 5) {
      rhrStressPts = 26.0;
    } else if (rhrDelta > 8.0 || daytimeSedentaryPulseSpikes >= 3) {
      rhrStressPts = 16.0;
    } else if (rhrDelta > 3.0) {
      rhrStressPts = 7.0;
    } else {
      rhrStressPts = 1.0;
    }

    signals.add(
      InferredStressSignal(
        signalType: StressSignalType.sedentaryPulseSpike,
        measuredValue: currentRestingHeartRate,
        unit: 'bpm',
        baselineValue: baselineRestingHeartRate,
        stressPointsContribution: rhrStressPts,
        insight: rhrDelta > 6
            ? 'Resting pulse is elevated by +${rhrDelta.toInt()} bpm without physical movement.'
            : 'Resting cardiac workload is within optimal baseline parameters.',
        regionalInsight: rhrDelta > 6
            ? 'अक्रिय अवस्था में भी हृदय गति +${rhrDelta.toInt()} bpm अधिक दर्ज हुई।'
            : 'हृदय गति सामान्य व शांत स्तर पर है।',
      ),
    );

    // Signal C: Respiration Rate Elevation
    final respDelta = currentRespirationRate - baselineRespirationRate;
    double respStressPts = 0.0;
    if (currentRespirationRate >= 20.0 || respDelta > 5.0) {
      respStressPts = 22.0;
    } else if (currentRespirationRate >= 16.5 || respDelta > 2.5) {
      respStressPts = 12.0;
    } else {
      respStressPts = 3.0;
    }

    signals.add(
      InferredStressSignal(
        signalType: StressSignalType.respirationRate,
        measuredValue: currentRespirationRate,
        unit: 'br/min',
        baselineValue: baselineRespirationRate,
        stressPointsContribution: respStressPts,
        insight: currentRespirationRate >= 17.0
            ? 'Subtle hyperventilation pattern indicative of sympathetic fight-or-flight.'
            : 'Diaphragmatic breathing rhythm is calm and paced.',
        regionalInsight: currentRespirationRate >= 17.0
            ? 'तीव्र उथली सांस तनाव प्रतिक्रिया का संकेत दे रही है।'
            : 'सांस लेने की गति शांत व संतुलित है।',
      ),
    );

    // Signal D: Nocturnal Restlessness
    double sleepStressPts = 0.0;
    if (nocturnalRestlessnessCount >= 7) {
      sleepStressPts = 18.0;
    } else if (nocturnalRestlessnessCount >= 4) {
      sleepStressPts = 10.0;
    } else {
      sleepStressPts = 2.0;
    }

    signals.add(
      InferredStressSignal(
        signalType: StressSignalType.sleepFragmentation,
        measuredValue: nocturnalRestlessnessCount.toDouble(),
        unit: 'arousals',
        baselineValue: 2.0,
        stressPointsContribution: sleepStressPts,
        insight: nocturnalRestlessnessCount >= 4
            ? '$nocturnalRestlessnessCount micro-arousals elevated overnight sympathetic tone.'
            : 'Minimal nighttime restless movement preserved deep recovery.',
        regionalInsight: nocturnalRestlessnessCount >= 4
            ? 'रात में $nocturnalRestlessnessCount बार नींद टूटने से तनाव बढ़ा।'
            : 'रात में शांत व निर्बाध नींद रही।',
      ),
    );

    // 2. Calculate Composite Current Stress Score (0 to 100)
    final rawComposite =
        hrvStressPts + rhrStressPts + respStressPts + sleepStressPts;
    final currentStressScore = _round(rawComposite.clamp(5.0, 98.0));
    final currentTier = _tierForScore(currentStressScore);

    // 3. Generate 24-Hour Intraday Timeline
    final timeline = _generate24HourTimeline(
      currentHour: now.hour,
      currentScore: currentStressScore,
      currentRhr: currentRestingHeartRate,
      currentRmssd: currentRmssd,
    );

    // Calculate daily metrics from timeline
    final dailyScores = timeline.map((e) => e.stressScore).toList();
    final dailyAvgScore =
        _round(dailyScores.reduce((a, b) => a + b) / dailyScores.length);

    int peakHour = 14;
    double maxHourScore = -1.0;
    int calmHour = 5;
    double minHourScore = 999.0;
    double highStressMins = 0.0;

    for (final reading in timeline) {
      if (reading.stressScore > maxHourScore) {
        maxHourScore = reading.stressScore;
        peakHour = reading.hour;
      }
      if (reading.stressScore < minHourScore) {
        minHourScore = reading.stressScore;
        calmHour = reading.hour;
      }
      if (reading.stressScore >= 51.0) {
        highStressMins += 60.0;
      }
    }

    // 4. Actionable Vagal Protocols
    final protocols = _generateVagalProtocols(currentStressScore, currentTier);

    // 5. Clinical Autonomic Summary
    final summary = _generateSummary(
        currentStressScore, currentTier, peakHour, calmHour, currentRmssd);
    final regionalSummary = _generateRegionalSummary(
        currentStressScore, currentTier, peakHour, calmHour, currentRmssd);

    return InferredStressReport(
      currentStressScore: currentStressScore,
      currentTier: currentTier,
      dailyAverageStressScore: dailyAvgScore,
      peakStressHour: peakHour,
      calmestHour: calmHour,
      totalHighStressMinutes: highStressMins,
      activeSignals: signals,
      intradayTimeline24h: timeline,
      recommendedProtocols: protocols,
      clinicalAutonomicSummary: summary,
      regionalClinicalAutonomicSummary: regionalSummary,
      assessedAt: now,
    );
  }

  // --- Internal Timeline & Math Helpers ---

  List<HourlyStressReading> _generate24HourTimeline({
    required int currentHour,
    required double currentScore,
    required double currentRhr,
    required double currentRmssd,
  }) {
    final timeline = <HourlyStressReading>[];

    for (int h = 0; h < 24; h++) {
      final hourLabel = '${h.toString().padLeft(2, '0')}:00';

      // Circadian curve baseline (Lowest during deep sleep 03-06, cortisol peak at 09-10, afternoon peak 14-16, wind-down 21-23)
      double hourFactor;
      if (h >= 1 && h <= 5) {
        hourFactor = 0.28; // Deep sleep minimum
      } else if (h >= 6 && h <= 8) {
        hourFactor = 0.55; // Awakening transition
      } else if (h >= 9 && h <= 11) {
        hourFactor = 0.88; // Morning cognitive peak
      } else if (h >= 12 && h <= 13) {
        hourFactor = 0.70; // Post-lunch lull
      } else if (h >= 14 && h <= 17) {
        hourFactor = 0.95; // Afternoon demanding block
      } else if (h >= 18 && h <= 20) {
        hourFactor = 0.65; // Evening wind-down
      } else {
        hourFactor = 0.40; // Pre-sleep restoration
      }

      // If this is the current hour, clamp exactly to currentScore
      double score;
      if (h == currentHour) {
        score = currentScore;
      } else {
        score = _round((currentScore * hourFactor + 12.0 * math.sin(h * 0.4))
            .clamp(10.0, 95.0));
      }

      final tier = _tierForScore(score);
      final rhr = _round(
          (currentRhr * (0.85 + (score / 100.0) * 0.25)).clamp(50.0, 110.0));
      final rmssd = _round(
          (currentRmssd * (1.35 - (score / 100.0) * 0.65)).clamp(18.0, 85.0));

      timeline.add(
        HourlyStressReading(
          hour: h,
          hourLabel: hourLabel,
          stressScore: score,
          tier: tier,
          averageHeartRate: rhr,
          averageRmssd: rmssd,
        ),
      );
    }

    return timeline;
  }

  StressLevelTier _tierForScore(double score) {
    if (score <= 25.0) {
      return StressLevelTier.calm;
    }
    if (score <= 50.0) {
      return StressLevelTier.eustress;
    }
    if (score <= 75.0) {
      return StressLevelTier.elevated;
    }
    return StressLevelTier.acuteOverload;
  }

  List<VagalRecoveryProtocol> _generateVagalProtocols(
      double score, StressLevelTier tier) {
    final protocols = <VagalRecoveryProtocol>[];

    if (score >= 51.0) {
      protocols.add(
        const VagalRecoveryProtocol(
          id: 'vagal_478_breathing',
          title: '4-7-8 Parasympathetic Vagal Reset',
          regionalTitle: '४-७-८ वेगल तंत्रिका शांति प्राणायाम',
          description:
              'Prolonged 8-second exhale stimulates pulmonary stretch receptors and drops acute heart rate.',
          regionalDescription:
              '८ सेकंड तक सांस छोड़ना हृदय गति को तुरंत शांत करता है।',
          breathingCadence: 'Inhale 4s • Hold 7s • Exhale 8s',
          durationMinutes: 5,
          karmaReward: 40,
        ),
      );
    }

    protocols.add(
      const VagalRecoveryProtocol(
        id: 'vagal_bhramari',
        title: 'Bhramari Pranayama (Humming Vagal Nerve Tone)',
        regionalTitle: 'भ्रामरी प्राणायाम (गुंजन ध्वनि से शांति)',
        description:
            'Vocal acoustic resonance stimulates the vagus nerve and triggers nitric oxide release in nasal sinuses.',
        regionalDescription:
            'भ्रामरी गुंजन नाइट्रिक ऑक्साइड बढ़ाता है और मन को गहरी शांति देता है।',
        breathingCadence: 'Deep Inhale 4s • Humming Exhale 10s',
        durationMinutes: 4,
        karmaReward: 35,
      ),
    );

    protocols.add(
      const VagalRecoveryProtocol(
        id: 'vagal_box_breathing',
        title: 'Sama Vritti / 4x4 Box Breathing',
        regionalTitle: 'सम वृत्ति (४x४ बॉक्स श्वास नियंत्रण)',
        description:
            'Equalized breath pacing restores balance between sympathetic alertness and parasympathetic calm.',
        regionalDescription:
            'समान गति से श्वास लेना मस्तिष्क को एकाग्र व तनावमुक्त करता है।',
        breathingCadence: 'Inhale 4s • Hold 4s • Exhale 4s • Hold 4s',
        durationMinutes: 5,
        karmaReward: 30,
      ),
    );

    return protocols;
  }

  String _generateSummary(
      double score, StressLevelTier tier, int peakH, int calmH, double hrv) {
    final peakLabel = '${peakH.toString().padLeft(2, '0')}:00';

    if (tier == StressLevelTier.calm || tier == StressLevelTier.eustress) {
      return 'Autonomic tone reflects stable parasympathetic control (Current Score ${score.toInt()}/100). Physiological reactivity peaked at $peakLabel but recovered promptly to baseline HRV (${hrv.toInt()} ms).';
    }
    if (tier == StressLevelTier.elevated) {
      return 'Elevated sympathetic dominance detected (Current Score ${score.toInt()}/100) with sustained daytime acceleration around $peakLabel. Perform a 5-minute 4-7-8 breathing reset to restore vagal tone.';
    }
    return 'ACUTE AUTONOMIC OVERLOAD: Vagal tone severely suppressed (Score ${score.toInt()}/100) with compounded sedentary tachycardia. Discontinue screen work and perform 5 minutes of Bhramari Pranayama immediately.';
  }

  String _generateRegionalSummary(
      double score, StressLevelTier tier, int peakH, int calmH, double hrv) {
    final peakLabel = '${peakH.toString().padLeft(2, '0')}:00';

    if (tier == StressLevelTier.calm || tier == StressLevelTier.eustress) {
      return 'शरीर में तनाव का स्तर सामान्य व संतुलित है (स्कोर ${score.toInt()}/100)। $peakLabel पर थोड़ी वृद्धि के बाद शरीर स्वतः शांत हो गया।';
    }
    if (tier == StressLevelTier.elevated) {
      return 'तनाव में वृद्धि दर्ज की गई है (स्कोर ${score.toInt()}/100)। $peakLabel के आसपास मस्तिष्क पर दबाव अधिक रहा। ५ मिनट का प्राणायाम लाभकारी रहेगा।';
    }
    return 'अत्यधिक तनाव चेतावनी: वेगल नर्व पर भारी दबाव (स्कोर ${score.toInt()}/100)। तुरंत कार्य रोककर भ्रामरी या ४-७-८ प्राणायाम करें।';
  }

  double _round(double val) {
    return (val * 10).round() / 10.0;
  }
}
