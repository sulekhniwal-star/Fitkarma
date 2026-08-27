enum InsightUrgency { low, medium, high, alert }
enum InsightType { milestonePr, sleepDeficit, environmentalAlert, nutritionDeficit, circadianWindDown }

class ProactiveInsight {
  final String id;
  final String title;
  final String regionalTitle;
  final String message;
  final InsightType type;
  final InsightUrgency urgency;
  final String actionLabel;
  final DateTime triggeredAt;

  const ProactiveInsight({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.message,
    required this.type,
    required this.urgency,
    required this.actionLabel,
    required this.triggeredAt,
  });
}

class ProactiveInsightEngine {
  /// Pure Dart deterministic evaluation of real-time biometric and environmental triggers
  static List<ProactiveInsight> evaluateTriggers({
    required DateTime currentTime,
    required int readinessScore,
    required double sleepHours,
    required int deepSleepMinutes,
    required int aqi,
    required double heatIndexC,
    required int currentProteinGrams,
    required int targetProteinGrams,
    bool isPrAchievedToday = false,
  }) {
    final List<ProactiveInsight> insights = [];

    // 1. PR / Milestone Hit Trigger
    if (isPrAchievedToday) {
      insights.add(
        ProactiveInsight(
          id: 'insight_pr_${currentTime.day}',
          title: 'Personal Record Smashed!',
          regionalTitle: 'नया व्यक्तिगत रिकॉर्ड!',
          message: 'Exceptional strength output today! Ensure adequate post-workout nutrition with 35-40g protein and restful sleep tonight.',
          type: InsightType.milestonePr,
          urgency: InsightUrgency.medium,
          actionLabel: 'View Workout Summary',
          triggeredAt: currentTime,
        ),
      );
    }

    // 2. Severe Sleep Deficit Trigger
    if (sleepHours < 5.5 || (readinessScore < 45 && sleepHours < 6.5)) {
      insights.add(
        ProactiveInsight(
          id: 'insight_sleep_${currentTime.day}',
          title: 'Recovery Protection Active',
          regionalTitle: 'रिकवरी सुरक्षा मोड',
          message: 'Sleep was abbreviated (${sleepHours.toStringAsFixed(1)} hrs). We recommend reducing today\'s workout volume by 25% and shifting to active recovery.',
          type: InsightType.sleepDeficit,
          urgency: InsightUrgency.high,
          actionLabel: 'Adjust Daily Mission',
          triggeredAt: currentTime,
        ),
      );
    }

    // 3. Environmental Safety Trigger (Hazardous AQI or Extreme Heat)
    if (aqi > 250) {
      insights.add(
        ProactiveInsight(
          id: 'insight_aqi_${currentTime.day}',
          title: 'Hazardous Air Quality Warning',
          regionalTitle: 'वायु प्रदूषण चेतावनी',
          message: 'AQI level is elevated ($aqi). Strictly avoid outdoor running and high-intensity cardio outdoors. Train in a ventilated indoor environment.',
          type: InsightType.environmentalAlert,
          urgency: InsightUrgency.alert,
          actionLabel: 'Switch to Indoor Workout',
          triggeredAt: currentTime,
        ),
      );
    } else if (heatIndexC > 38.0) {
      insights.add(
        ProactiveInsight(
          id: 'insight_heat_${currentTime.day}',
          title: 'Extreme Heat Index Warning',
          regionalTitle: 'अत्यधिक गर्मी चेतावनी',
          message: 'Feels like ${heatIndexC.round()}°C today. Increase hydration by at least +750 ml and avoid midday sun exposure.',
          type: InsightType.environmentalAlert,
          urgency: InsightUrgency.high,
          actionLabel: 'Log Water',
          triggeredAt: currentTime,
        ),
      );
    }

    // 4. Evening Protein Deficit Nudge (after 5 PM)
    if (currentTime.hour >= 17 && currentProteinGrams < (targetProteinGrams * 0.55)) {
      final remainingProtein = targetProteinGrams - currentProteinGrams;
      insights.add(
        ProactiveInsight(
          id: 'insight_protein_${currentTime.day}',
          title: 'Evening Protein Catch-up',
          regionalTitle: 'शाम का प्रोटीन अनुस्मारक',
          message: 'You need $remainingProtein g more protein to hit today\'s target. Consider paneer bhurji, soya chunks, roasted chana, or a protein shake with dinner.',
          type: InsightType.nutritionDeficit,
          urgency: InsightUrgency.medium,
          actionLabel: 'Log Dinner Meal',
          triggeredAt: currentTime,
        ),
      );
    }

    // 5. Circadian Wind-down (after 9 PM)
    if (currentTime.hour >= 21) {
      insights.add(
        ProactiveInsight(
          id: 'insight_winddown_${currentTime.day}',
          title: 'Circadian Wind-Down Window',
          regionalTitle: 'रात्रि विश्राम समय',
          message: 'It\'s 9:00 PM. Dim blue screens, prepare warm haldi doodh or chamomile tea, and engage in 5 mins of Pranayama for deep sleep.',
          type: InsightType.circadianWindDown,
          urgency: InsightUrgency.low,
          actionLabel: 'Start 5m Pranayama',
          triggeredAt: currentTime,
        ),
      );
    }

    return insights;
  }
}
