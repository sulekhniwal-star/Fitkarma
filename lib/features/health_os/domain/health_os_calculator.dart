import '../../../core/models/daily_intelligence_package.dart';

class HealthOsCalculator {
  /// Pure Dart deterministic calculation of the Daily Intelligence Package
  /// Used for immediate, zero-latency, 100% offline-capable calculations.
  static DailyIntelligencePackage computePackage({
    required String date,
    double sleepHours = 7.0,
    int sleepQuality = 80,
    int yesterdaySteps = 7500,
    int sorenessScore = 20,
    bool isIll = false,
    int baseCalories = 2000,
    int baseProtein = 120,
    int baseSteps = 8000,
    double heatIndex = 30.0,
  }) {
    // 1. Readiness Score Calculation (0 - 100)
    final sleepFactor = ((sleepHours / 8.0).clamp(0.0, 1.0) * 100 * 0.5) + (sleepQuality * 0.5);
    final recoveryFactor = (100 - sorenessScore).clamp(0, 100);
    final strainFactor = yesterdaySteps > 15000 ? 70 : (yesterdaySteps > 10000 ? 90 : 80);

    var readinessScore = ((sleepFactor * 0.40) + (recoveryFactor * 0.35) + (strainFactor * 0.25)).round();
    if (isIll) readinessScore = readinessScore.clamp(0, 30);

    // Readiness Zone
    ReadinessZone zone;
    if (readinessScore >= 80) {
      zone = ReadinessZone.optimal;
    } else if (readinessScore >= 60) {
      zone = ReadinessZone.moderate;
    } else if (readinessScore >= 40) {
      zone = ReadinessZone.recovery;
    } else {
      zone = ReadinessZone.rest;
    }

    // 2. Health Score
    final healthScore = ((readinessScore * 0.6) + 35).round().clamp(40, 100);

    // 3. Adaptive Targets & Safety Alerts
    var targetCalories = baseCalories;
    var targetProtein = baseProtein;
    var targetSteps = baseSteps;
    String workoutRecommendation = 'Standard Training Split';
    final List<String> safetyAlerts = [];

    if (isIll) {
      targetCalories = (baseCalories * 0.9).round();
      targetSteps = 3000;
      workoutRecommendation = 'Rest & Immune Recovery';
      safetyAlerts.add('Illness detected: Workout suspended. Prioritize hydration and rest.');
    } else if (zone == ReadinessZone.optimal) {
      targetCalories = (baseCalories * 1.05).round();
      targetSteps = (baseSteps * 1.1).round();
      workoutRecommendation = 'High-Intensity / Progressive Overload Focus';
    } else if (zone == ReadinessZone.recovery || zone == ReadinessZone.rest) {
      targetCalories = (baseCalories * 0.95).round();
      targetSteps = (baseSteps * 0.7).round().clamp(4000, 15000);
      workoutRecommendation = 'Active Mobility & Zone 2 Walk';
      safetyAlerts.add('Readiness is reduced. Focus on active recovery and sleep.');
    }

    if (heatIndex >= 38.0) {
      safetyAlerts.add('Extreme heat advisory: Hydrate aggressively and avoid outdoor noon workouts.');
    }

    return DailyIntelligencePackage(
      date: date,
      healthScore: healthScore,
      readinessScore: readinessScore,
      readinessZone: zone,
      targetCalories: targetCalories,
      targetProteinGrams: targetProtein,
      targetSteps: targetSteps,
      workoutRecommendation: workoutRecommendation,
      aiBriefing: 'Offline intelligence active. Your body readiness is calculated and optimized for today.',
      safetyAlerts: safetyAlerts,
      generatedAt: DateTime.now(),
    );
  }
}
