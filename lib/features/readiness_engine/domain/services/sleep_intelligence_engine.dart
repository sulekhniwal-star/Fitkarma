class SleepAssessment {
  final double sleepDebtHours;
  final double restorativeStagePercent; // (Deep + REM) / Total
  final double sleepEfficiencyScore; // 0 - 100
  final String sleepInsight;
  final String sleepInsightHindi;

  const SleepAssessment({
    required this.sleepDebtHours,
    required this.restorativeStagePercent,
    required this.sleepEfficiencyScore,
    required this.sleepInsight,
    required this.sleepInsightHindi,
  });
}

/// SleepIntelligenceEngine — Evaluates sleep debt and sleep stage restorative quality
class SleepIntelligenceEngine {
  const SleepIntelligenceEngine();

  SleepAssessment assessSleep({
    required double sleepDurationHours,
    required double sleepTargetHours,
    double? deepSleepMinutes,
    double? remSleepMinutes,
  }) {
    // 1. Calculate Sleep Debt
    final rawDebt = sleepTargetHours - sleepDurationHours;
    final sleepDebt = rawDebt > 0 ? rawDebt : 0.0;

    // 2. Restorative Stage Quotient
    double restorativePercent = 0.45; // Default 45% if stages not available
    if (deepSleepMinutes != null && remSleepMinutes != null && sleepDurationHours > 0) {
      final totalSleepMinutes = sleepDurationHours * 60.0;
      restorativePercent = ((deepSleepMinutes + remSleepMinutes) / totalSleepMinutes).clamp(0.1, 0.75);
    }

    // 3. Sleep Efficiency Score (0-100)
    // 60% based on duration ratio, 40% based on restorative quotient
    final durationScore = (sleepDurationHours / sleepTargetHours).clamp(0.0, 1.1) * 60.0;
    final stageScore = (restorativePercent / 0.45).clamp(0.0, 1.2) * 40.0;
    final efficiency = (durationScore + stageScore).clamp(20.0, 100.0);

    String insight;
    String insightHindi;

    if (sleepDebt > 1.5) {
      insight = 'Accumulated ${sleepDebt.toStringAsFixed(1)}h sleep debt. Your nervous system requires an earlier bedtime tonight.';
      insightHindi = 'लगभग ${sleepDebt.toStringAsFixed(1)} घंटे की नींद की कमी। आज रात जल्दी सोने की सलाह है।';
    } else if (restorativePercent >= 0.45) {
      insight = 'Optimal deep & REM sleep architecture. Cellular repair and memory consolidation completed.';
      insightHindi = 'गहरी नींद (Deep & REM) की उत्कृष्ट गुणवत्ता। मांसपेशियों की रिकवरी पूर्ण हुई।';
    } else {
      insight = 'Adequate sleep duration with standard restorative cycles.';
      insightHindi = 'संतोषजनक नींद की अवधि।';
    }

    return SleepAssessment(
      sleepDebtHours: double.parse(sleepDebt.toStringAsFixed(1)),
      restorativeStagePercent: double.parse((restorativePercent * 100).toStringAsFixed(1)),
      sleepEfficiencyScore: double.parse(efficiency.toStringAsFixed(1)),
      sleepInsight: insight,
      sleepInsightHindi: insightHindi,
    );
  }
}
