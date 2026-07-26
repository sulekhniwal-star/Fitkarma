class HealthSnapshot {
  const HealthSnapshot({
    this.proteinTrend = 'stable',
    this.sleepTrend = 'optimal',
    this.weightChangeLast4w = 0.0,
    this.currentStreak = 1,
    this.readinessScore = 80,
    this.healthScore = 85,
    this.activeRisk = false,
    this.primaryConcern = 'none',
    this.programPhase = 'maintenance',
    this.daysToGoal = 30,
    this.dailyProteinTargetG = 120.0,
    this.dailyCalorieTarget = 2000.0,
    this.dailyHydrationTargetL = 3.0,
    this.dailyStepTarget = 10000,
    this.localRisks = const [],
    this.bmi = 22.5,
    this.tdee = 2200.0,
    this.avgSteps7Days = 8200.0,
    this.avgSleepMinutes7Days = 460.0,
    this.avgWaterCups7Days = 8.0,
    this.avgReadinessScore7Days = 78.0,
    this.avgHeartRate7Days = 72.0,
  });

  final String proteinTrend;
  final String sleepTrend;
  final double weightChangeLast4w;
  final int currentStreak;
  final int readinessScore;
  final int healthScore;
  final bool activeRisk;
  final String primaryConcern;
  final String programPhase;
  final int daysToGoal;

  final double dailyProteinTargetG;
  final double dailyCalorieTarget;
  final double dailyHydrationTargetL;
  final int dailyStepTarget;
  final List<String> localRisks;
  final double bmi;
  final double tdee;
  final double avgSteps7Days;
  final double avgSleepMinutes7Days;
  final double avgWaterCups7Days;
  final double avgReadinessScore7Days;
  final double avgHeartRate7Days;

  Map<String, dynamic> toJson() {
    return {
      'proteinTrend': proteinTrend,
      'sleepTrend': sleepTrend,
      'weightChangeLast4w': weightChangeLast4w,
      'currentStreak': currentStreak,
      'readinessScore': readinessScore,
      'healthScore': healthScore,
      'activeRisk': activeRisk,
      'primaryConcern': primaryConcern,
      'programPhase': programPhase,
      'daysToGoal': daysToGoal,
      'dailyProteinTargetG': dailyProteinTargetG,
      'dailyCalorieTarget': dailyCalorieTarget,
      'dailyHydrationTargetL': dailyHydrationTargetL,
      'dailyStepTarget': dailyStepTarget,
      'localRisks': localRisks,
      'bmi': bmi,
      'tdee': tdee,
      'avgSteps7Days': avgSteps7Days,
      'avgSleepMinutes7Days': avgSleepMinutes7Days,
      'avgWaterCups7Days': avgWaterCups7Days,
      'avgReadinessScore7Days': avgReadinessScore7Days,
      'avgHeartRate7Days': avgHeartRate7Days,
    };
  }
}

