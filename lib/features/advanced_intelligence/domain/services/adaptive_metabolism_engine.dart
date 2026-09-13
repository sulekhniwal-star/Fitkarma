import '../models/advanced_intelligence_models.dart';

class AdaptiveMetabolismEngine {
  const AdaptiveMetabolismEngine();

  /// Evaluates metabolic rate adaptation and plateau dynamics over multi-week deficit
  AdaptiveMetabolismReport calculateMetabolicAdaptation({
    required String id,
    required String userId,
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
    required double currentIntakeKcal,
    required double weightDeltaPast3WeeksKg,
    required int weeksInDeficit,
  }) {
    // 1. Harris-Benedict / Mifflin-St Jeor BMR for Asian Indians
    final baselineBmr = isMale
        ? (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5
        : (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;

    // Standard baseline TDEE (activity multiplier ~1.375 moderate)
    final baselineTdee = baselineBmr * 1.375;

    // 2. Compute metabolic adaptation index based on weeks in continuous deficit
    // Prolonged deficits (>6 weeks) trigger down-regulation of NEAT and leptin
    double adaptationFactor = 1.0;
    if (weeksInDeficit >= 12) {
      adaptationFactor = 0.88; // 12% metabolic slowdown
    } else if (weeksInDeficit >= 6) {
      adaptationFactor = 0.93; // 7% slowdown
    } else if (weeksInDeficit >= 3) {
      adaptationFactor = 0.97;
    }

    final estimatedTdee = baselineTdee * adaptationFactor;

    // 3. Determine Plateau Status
    PlateauStatus plateauStatus;
    int weeksStalled = 0;
    RefeedType refeedType = RefeedType.none;
    String strategy;
    String strategyHi;

    if (weightDeltaPast3WeeksKg.abs() < 0.2 && weeksInDeficit >= 3) {
      plateauStatus = PlateauStatus.plateaued;
      weeksStalled = 3;
      refeedType = RefeedType.fullCaloricReset;
      strategy = 'Metabolic stall detected. Prescribing a 2-day maintenance refeed (high complex carb + protein) to restore leptin and thyroid T3.';
      strategyHi = 'मेटाबोलिक रुकावट (Plateau)। लेप्टिन हॉर्मोन रीसेट करने हेतु २ दिन मेंटेनेंस कार्ब रीफीड लें।';
    } else if (weightDeltaPast3WeeksKg.abs() < 0.5 && weeksInDeficit >= 2) {
      plateauStatus = PlateauStatus.stalling;
      weeksStalled = 2;
      refeedType = RefeedType.moderateCarbRefeed;
      strategy = 'Slight metabolic slowdown. Add 200 kcal clean carbohydrates (Sweet potato, brown rice, oats) on workout days.';
      strategyHi = 'धीमी प्रगति। वर्कआउट के दिन २०० कैलोरी अतिरिक्त पौष्टिक कार्ब्स जोड़ें।';
    } else {
      plateauStatus = PlateauStatus.progressing;
      weeksStalled = 0;
      refeedType = RefeedType.none;
      strategy = 'Fat oxidation rate optimal. Maintain current deficit and progressive training volume.';
      strategyHi = 'फैट लॉस की गति बेहतरीन है। वर्तमान डाइट और वर्कआउट जारी रखें।';
    }

    return AdaptiveMetabolismReport(
      id: id,
      userId: userId,
      baselineBmr: baselineBmr,
      estimatedTdee: estimatedTdee,
      currentCalorieTarget: currentIntakeKcal,
      metabolicAdaptationFactor: adaptationFactor,
      plateauStatus: plateauStatus,
      weeksStalled: weeksStalled,
      recommendedRefeed: refeedType,
      strategyDescription: strategy,
      strategyDescriptionHindi: strategyHi,
      calculatedAt: DateTime.now(),
    );
  }
}
