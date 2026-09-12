enum EscalationUrgency { none, low, high }

class ProactiveInsight {
  final String triggerKey;
  final String title;
  final String titleHindi;
  final String suggestion;
  final String suggestionHindi;
  final String promptShortcut;
  final bool requiresCoachEscalation;

  const ProactiveInsight({
    required this.triggerKey,
    required this.title,
    required this.titleHindi,
    required this.suggestion,
    required this.suggestionHindi,
    required this.promptShortcut,
    this.requiresCoachEscalation = false,
  });
}

/// ProactiveInsightsEngine — Evaluates acute health triggers & escalation criteria
class ProactiveInsightsEngine {
  const ProactiveInsightsEngine();

  List<ProactiveInsight> evaluateTriggers({
    required int readinessScore,
    required double sleepDebtHours,
    required int soreMuscleCount,
    required bool hasPcos,
    required String? cyclePhase,
    required bool isEliteTier,
  }) {
    final List<ProactiveInsight> insights = [];

    // 1. Acute Readiness Drop Trigger
    if (readinessScore < 55) {
      insights.add(
        ProactiveInsight(
          triggerKey: 'low_readiness',
          title: 'Readiness Dip Detected',
          titleHindi: 'शारीरिक तत्परता में गिरावट',
          suggestion: 'Your readiness is at $readinessScore. Switch today’s heavy training to a 30-min mobility & recovery protocol.',
          suggestionHindi: 'आपका तत्परता स्कोर $readinessScore है। आज भारी वजन उठाने के बजाय हल्की स्ट्रेचिंग करें।',
          promptShortcut: 'How should I modify my workout for low readiness today?',
          requiresCoachEscalation: isEliteTier,
        ),
      );
    }

    // 2. Sleep Debt Accumulation Trigger
    if (sleepDebtHours > 1.5) {
      insights.add(
        ProactiveInsight(
          triggerKey: 'sleep_debt',
          title: 'Sleep Debt Alert',
          titleHindi: 'नींद की कमी चेतावनी',
          suggestion: '${sleepDebtHours.toStringAsFixed(1)}h sleep debt accumulated. Try 10 mins of Anulom Vilom Pranayama before bed.',
          suggestionHindi: 'नींद की कमी पूरी करने के लिए रात को 10 मिनट अनुलोम-विलोम प्राणायाम करें।',
          promptShortcut: 'What is the best evening routine to recover from sleep debt?',
        ),
      );
    }

    // 3. Multi-Region Muscle Soreness Trigger
    if (soreMuscleCount >= 3) {
      insights.add(
        ProactiveInsight(
          triggerKey: 'systemic_soreness',
          title: 'Widespread DOMS Recorded',
          titleHindi: 'मांसपेशियों में अत्यधिक दर्द',
          suggestion: 'Multiple muscle groups are sore. Prioritize 2.5L water with electrolytes and 20g whey/sattu.',
          suggestionHindi: 'मांसपेशियों की रिकवरी के लिए पर्याप्त पानी, इलेक्ट्रोलाइट्स और प्रोटीन लें।',
          promptShortcut: 'Suggest high-protein Indian foods to speed up muscle recovery.',
        ),
      );
    }

    // 4. PCOS / Luteal Phase Craving Trigger
    if (cyclePhase == 'luteal' && hasPcos) {
      insights.add(
        ProactiveInsight(
          triggerKey: 'pcos_luteal_craving',
          title: 'Luteal Phase Metabolic Calibration',
          titleHindi: 'ल्यूटियल चरण आहार संतुलन',
          suggestion: 'Progesterone is rising. Curb sugar cravings with roasted makhana, dark chocolate, and cinnamon tea.',
          suggestionHindi: 'क्रेविंग से बचने के लिए भुने मखाने, डार्क चॉकलेट और दालचीनी की चाय लें।',
          promptShortcut: 'Give me low-GI Indian snacks to control PMS cravings.',
        ),
      );
    }

    return insights;
  }
}
