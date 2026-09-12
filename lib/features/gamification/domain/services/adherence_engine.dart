import '../models/gamification_models.dart';

class AdherenceEngine {
  const AdherenceEngine();

  /// Calculate 0-100 Adherence Score across the 4 foundational pillars of Health OS
  AdherenceBreakdown calculateWeeklyAdherence({
    required int mealsLoggedThisWeek, // Target: 21 meals (3 per day)
    required int workoutsCompletedThisWeek, // Target: 4 workouts
    required int stepTargetDaysMetThisWeek, // Target: 5 days
    required int sleepTargetDaysMetThisWeek, // Target: 6 days
  }) {
    // 1. Nutrition Score (Target: 21 meals) -> 25% weight
    final nutritionPct = (mealsLoggedThisWeek / 21.0).clamp(0.0, 1.0) * 100.0;

    // 2. Workout Score (Target: 4 workouts) -> 35% weight
    final workoutPct = (workoutsCompletedThisWeek / 4.0).clamp(0.0, 1.0) * 100.0;

    // 3. Steps Score (Target: 5 days) -> 20% weight
    final stepsPct = (stepTargetDaysMetThisWeek / 5.0).clamp(0.0, 1.0) * 100.0;

    // 4. Sleep Score (Target: 6 days) -> 20% weight
    final sleepPct = (sleepTargetDaysMetThisWeek / 6.0).clamp(0.0, 1.0) * 100.0;

    final overall = ((workoutPct * 0.35) +
            (nutritionPct * 0.25) +
            (stepsPct * 0.20) +
            (sleepPct * 0.20))
        .round()
        .clamp(0, 100);

    String summary;
    String summaryHindi;

    if (overall >= 85) {
      summary = 'Elite Adherence: High consistency across all physical and metabolic disciplines.';
      summaryHindi = 'सर्वोत्तम निरंतरता: सभी व्यायाम, आहार व निद्रा लक्ष्यों का उत्कृष्ट पालन।';
    } else if (overall >= 65) {
      summary = 'Solid Adherence: Good momentum, minor lapses in meal logging or sleep consistency.';
      summaryHindi = 'मजबूत निरंतरता: भोजन दर्ज करने व निद्रा में थोड़ा और सुधार संभव है।';
    } else {
      summary = 'Re-alignment Needed: Focus on maintaining a 3-day streak on morning check-ins.';
      summaryHindi = 'नियमितता बढ़ाने की आवश्यकता: दैनिक चेक-इन से पुनः शुरुआत करें।';
    }

    return AdherenceBreakdown(
      overallScore: overall,
      nutritionScore: nutritionPct.round(),
      workoutScore: workoutPct.round(),
      stepsScore: stepsPct.round(),
      sleepScore: sleepPct.round(),
      summary: summary,
      summaryHindi: summaryHindi,
    );
  }
}
