class HealthSnapshot {
  const HealthSnapshot({
    required this.bmi,
    required this.tdee,
    required this.dailyCalorieTarget,
    required this.dailyProteinTargetG,
    required this.dailyHydrationTargetL,
    required this.dailyStepTarget,
    required this.avgSteps7Days,
    required this.avgSleepMinutes7Days,
    required this.avgWaterCups7Days,
    required this.avgReadinessScore7Days,
    required this.avgHeartRate7Days,
    required this.localRisks,
  });

  final double bmi;
  final double tdee;
  final double dailyCalorieTarget;
  final double dailyProteinTargetG;
  final double dailyHydrationTargetL;
  final int dailyStepTarget;

  // 7-day averages/telemetry
  final double avgSteps7Days;
  final double avgSleepMinutes7Days;
  final double avgWaterCups7Days;
  final double avgReadinessScore7Days;
  final double avgHeartRate7Days;

  // Risk alerts detected locally
  final List<String> localRisks;

  Map<String, dynamic> toJson() {
    return {
      'bmi': bmi,
      'tdee': tdee,
      'dailyCalorieTarget': dailyCalorieTarget,
      'dailyProteinTargetG': dailyProteinTargetG,
      'dailyHydrationTargetL': dailyHydrationTargetL,
      'dailyStepTarget': dailyStepTarget,
      'avgSteps7Days': avgSteps7Days,
      'avgSleepMinutes7Days': avgSleepMinutes7Days,
      'avgWaterCups7Days': avgWaterCups7Days,
      'avgReadinessScore7Days': avgReadinessScore7Days,
      'avgHeartRate7Days': avgHeartRate7Days,
      'localRisks': localRisks,
    };
  }
}
