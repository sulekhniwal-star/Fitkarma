enum AdherenceTier {
  elite(
    title: 'Sadhana Elite (Pristine Adherence)',
    regionalTitle: 'साधना सिद्धि (उत्कृष्ट अनुशासन)',
    minScore: 85,
    maxScore: 100,
    colorCode: 0xFF00E676,
    coachMessage:
        'Pristine biological execution. Maximum rate of body recomposition and metabolic vitality.',
  ),
  disciplined(
    title: 'Abhyasi Balance (Solid Discipline)',
    regionalTitle: 'अभ्यासी संतुलन (दृढ़ अनुशासन)',
    minScore: 70,
    maxScore: 84,
    colorCode: 0xFF00B0FF,
    coachMessage:
        'Strong foundational compliance. Progressive overload and cardiovascular adaptations are on track.',
  ),
  warning(
    title: 'Drifting Adherence (Minor Deviations)',
    regionalTitle: 'विचलन चेतावनी (आंशिक असंतुलन)',
    minScore: 50,
    maxScore: 69,
    colorCode: 0xFFFF9100,
    coachMessage:
        'Nutrition or recovery has drifted over the last 3 days. Focus on sleep and post-meal Shatpawali.',
  ),
  intervention(
    title: 'Critical De-load (Requires Adjustment)',
    regionalTitle: 'सुधार अनिवार्य (तत्काल समायोजन)',
    minScore: 0,
    maxScore: 49,
    colorCode: 0xFFFF5252,
    coachMessage:
        'Elevated lifestyle friction detected. AI Coach recommends automated de-load and habit simplification.',
  );

  final String title;
  final String regionalTitle;
  final int minScore;
  final int maxScore;
  final int colorCode;
  final String coachMessage;

  const AdherenceTier({
    required this.title,
    required this.regionalTitle,
    required this.minScore,
    required this.maxScore,
    required this.colorCode,
    required this.coachMessage,
  });
}

class PillarAdherenceScore {
  final String name;
  final String regionalName;
  final double score; // 0.0 to 100.0
  final double weight; // e.g. 0.30
  final String keyMetricLabel;
  final String statusSummary;

  const PillarAdherenceScore({
    required this.name,
    required this.regionalName,
    required this.score,
    required this.weight,
    required this.keyMetricLabel,
    required this.statusSummary,
  });
}

class DailyAdherenceSnapshot {
  final DateTime date;
  final double compositeScore;
  final AdherenceTier tier;
  final PillarAdherenceScore nutrition;
  final PillarAdherenceScore training;
  final PillarAdherenceScore recovery;
  final PillarAdherenceScore circadianHabits;

  const DailyAdherenceSnapshot({
    required this.date,
    required this.compositeScore,
    required this.tier,
    required this.nutrition,
    required this.training,
    required this.recovery,
    required this.circadianHabits,
  });
}

class AdherenceReport {
  final double currentScore;
  final double weeklyAverageScore;
  final double monthlyAverageScore;
  final AdherenceTier currentTier;
  final double consistencyStabilityIndex; // 0.0 to 100.0 (100 - 2 * stdDev)
  final List<DailyAdherenceSnapshot> weeklyHistory;
  final PillarAdherenceScore nutritionPillar;
  final PillarAdherenceScore trainingPillar;
  final PillarAdherenceScore recoveryPillar;
  final PillarAdherenceScore circadianPillar;
  final String primaryRecommendation;
  final String regionalRecommendation;

  const AdherenceReport({
    required this.currentScore,
    required this.weeklyAverageScore,
    required this.monthlyAverageScore,
    required this.currentTier,
    required this.consistencyStabilityIndex,
    required this.weeklyHistory,
    required this.nutritionPillar,
    required this.trainingPillar,
    required this.recoveryPillar,
    required this.circadianPillar,
    required this.primaryRecommendation,
    required this.regionalRecommendation,
  });
}
