import '../models/advanced_intelligence_models.dart';

class LongevityScoreEngine {
  const LongevityScoreEngine();

  /// Computes composite Longevity Score (0-100) and lifespan projection
  LongevityAssessment computeLongevityScore({
    required String id,
    required String userId,
    required double restingHeartRate,
    required double hrvRmssd,
    required double fastingGlucoseMgDl,
    required double systolicBp,
    required int maxDesiBaithakReps, // Pushup/Squat functional strength metric
    required double weeklyActiveHours,
    required int dailyPranayamaMinutes,
  }) {
    // 1. Cardiometabolic Pillar (0-100)
    double cardioScore = 100.0;
    if (fastingGlucoseMgDl > 125) {
      cardioScore -= 30;
    } else if (fastingGlucoseMgDl > 99) {
      cardioScore -= 15;
    }
    if (systolicBp >= 140) {
      cardioScore -= 25;
    } else if (systolicBp >= 120) {
      cardioScore -= 10;
    }
    cardioScore = cardioScore.clamp(20.0, 100.0);

    // 2. Cellular Recovery Pillar (0-100)
    double recoveryScore = 100.0;
    if (restingHeartRate > 75) {
      recoveryScore -= 20;
    } else if (restingHeartRate > 65) {
      recoveryScore -= 10;
    }
    if (hrvRmssd < 30) {
      recoveryScore -= 25;
    } else if (hrvRmssd < 50) {
      recoveryScore -= 10;
    }
    recoveryScore = recoveryScore.clamp(20.0, 100.0);

    // 3. Functional Strength Pillar (0-100)
    double strengthScore = 50.0;
    if (maxDesiBaithakReps >= 50) {
      strengthScore += 50.0;
    } else if (maxDesiBaithakReps >= 30) {
      strengthScore += 30.0;
    } else if (maxDesiBaithakReps >= 15) {
      strengthScore += 15.0;
    }
    strengthScore = strengthScore.clamp(20.0, 100.0);

    // 4. Lifestyle & Stress Modulation (0-100)
    double lifestyleScore = 50.0;
    if (weeklyActiveHours >= 4.0) lifestyleScore += 25.0;
    if (dailyPranayamaMinutes >= 15) lifestyleScore += 25.0;
    lifestyleScore = lifestyleScore.clamp(20.0, 100.0);

    final pillars = LongevityPillars(
      cardiometabolic: cardioScore,
      cellularRecovery: recoveryScore,
      functionalStrength: strengthScore,
      lifestyleHabits: lifestyleScore,
    );

    // Weighted composite score
    final overallScore = (cardioScore * 0.35 +
            recoveryScore * 0.25 +
            strengthScore * 0.20 +
            lifestyleScore * 0.20)
        .round()
        .clamp(0, 100);

    // Lifespan extension relative to Indian baseline (69.8 years)
    // High score (>85) correlates with +6 to +8 healthy healthspan years
    final lifespanGain = ((overallScore - 50) / 50.0 * 8.0).clamp(-4.0, 8.5);

    String lever;
    String leverHi;
    if (cardioScore <= recoveryScore && cardioScore <= strengthScore) {
      lever = 'Optimize fasting glycemic index & daily post-meal brisk walking.';
      leverHi = 'भोजन के बाद शतपावली और कम ग्लाइसेमिक डाइट से ब्लड शुगर नियंत्रित करें।';
    } else if (strengthScore <= recoveryScore) {
      lever = 'Increase muscular strength via Desi Dand & progressive bodyweight calisthenics.';
      leverHi = 'प्रतिदिन देसी दंड और बैठक से मांसपेशियों की ताकत बढ़ाएं।';
    } else {
      lever = 'Enhance parasympathetic HRV tone with 15 mins daily Anulom Vilom pranayama.';
      leverHi = 'प्रतिदिन १५ मिनट अनुलोम-विलोम प्राणायाम से तनाव और हृदय गति को शांत करें।';
    }

    return LongevityAssessment(
      id: id,
      userId: userId,
      overallLongevityScore: overallScore,
      pillars: pillars,
      projectedLifespanGainYears: double.parse(lifespanGain.toStringAsFixed(1)),
      primaryLongevityLever: lever,
      primaryLongevityLeverHindi: leverHi,
      assessedAt: DateTime.now(),
    );
  }
}
