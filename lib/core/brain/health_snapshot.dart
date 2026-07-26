class HealthSnapshot {
  const HealthSnapshot({
    required this.proteinTrend,
    required this.sleepTrend,
    required this.weightChangeLast4w,
    required this.currentStreak,
    required this.readinessScore,
    required this.healthScore,
    required this.activeRisk,
    required this.primaryConcern,
    required this.programPhase,
    required this.daysToGoal,
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
    };
  }
}
