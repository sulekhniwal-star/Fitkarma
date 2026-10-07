import 'package:flutter/material.dart';
import 'package:fitkarma/core/theme/app_colors.dart';

enum EscalationUrgency { none, low, high }

class ProactiveInsight {
  final String triggerKey;
  final String title;
  final String titleHindi;
  final String suggestion;
  final String suggestionHindi;
  final String promptShortcut;
  final bool requiresCoachEscalation;
  final Color glowColor;
  final IconData icon;

  const ProactiveInsight({
    required this.triggerKey,
    required this.title,
    required this.titleHindi,
    required this.suggestion,
    required this.suggestionHindi,
    required this.promptShortcut,
    this.requiresCoachEscalation = false,
    this.glowColor = AppColors.primaryCyan,
    this.icon = Icons.insights_rounded,
  });
}

/// ProactiveInsightsEngine — Evaluates live health triggers, readiness tiers & escalation criteria
class ProactiveInsightsEngine {
  const ProactiveInsightsEngine();

  List<ProactiveInsight> evaluateTriggers({
    required int? readinessScore,
    double sleepDebtHours = 0.0,
    int soreMuscleCount = 0,
    bool hasPcos = false,
    String? cyclePhase,
    bool isEliteTier = false,
    int todaySteps = 0,
    int stepGoal = 10000,
    double consumedCalories = 0,
    double targetCalories = 0,
    double consumedProteinGrams = 0,
    double targetProteinGrams = 0,
    int workoutDurationMinutes = 0,
  }) {
    final List<ProactiveInsight> insights = [];

    // 1. Live Readiness Tier Insights
    if (readinessScore != null) {
      if (readinessScore >= 85) {
        // Prime / Peak Readiness (e.g. 90)
        insights.add(
          ProactiveInsight(
            triggerKey: 'prime_readiness',
            title: 'Peak Readiness Detected ($readinessScore/100)',
            titleHindi: 'सर्वोच्च शारीरिक तत्परता ($readinessScore/100)',
            suggestion: 'Your readiness is at $readinessScore (Prime). Autonomic balance is fully restored — ideal day for heavy compound lifts, PR attempts, or high-intensity training.',
            suggestionHindi: 'आपका तत्परता स्कोर $readinessScore (सर्वोत्तम) है। आज भारी वजन उठाने, पर्सनल रिकॉर्ड बनाने या उच्च तीव्रता की कसरत के लिए आदर्श दिन है।',
            promptShortcut: 'How can I maximize my workout with my $readinessScore readiness score today?',
            glowColor: AppColors.primaryEmerald,
            icon: Icons.bolt_rounded,
          ),
        );
      } else if (readinessScore >= 70) {
        // Productive Readiness
        insights.add(
          ProactiveInsight(
            triggerKey: 'optimal_readiness',
            title: 'Productive Energy Window ($readinessScore/100)',
            titleHindi: 'उत्पादक ऊर्जा स्तर ($readinessScore/100)',
            suggestion: 'Your readiness is at $readinessScore. Solid physiological capacity to progress training volume and hit daily nutritional targets.',
            suggestionHindi: 'आपका तत्परता स्कोर $readinessScore है। सामान्य प्रोग्रेसिव ट्रेनिंग और दैनिक पोषण लक्ष्यों को पूरा करने के लिए उपयुक्त समय।',
            promptShortcut: 'Suggest a progressive workout for my $readinessScore readiness level today.',
            glowColor: AppColors.primaryCyan,
            icon: Icons.trending_up_rounded,
          ),
        );
      } else if (readinessScore >= 55) {
        // Moderate Readiness
        insights.add(
          ProactiveInsight(
            triggerKey: 'moderate_readiness',
            title: 'Moderate Recovery Balance ($readinessScore/100)',
            titleHindi: 'मध्यम रिकवरी स्तर ($readinessScore/100)',
            suggestion: 'Your readiness is at $readinessScore. Maintain steady aerobic capacity and focus on pristine lifting form without overloading.',
            suggestionHindi: 'आपका तत्परता स्कोर $readinessScore है। अत्यधिक वजन उठाने के बजाय सही तकनीक और स्थिर एरोबिक व्यायाम पर ध्यान दें।',
            promptShortcut: 'How should I adjust my workout intensity for moderate readiness?',
            glowColor: AppColors.accentAmber,
            icon: Icons.speed_rounded,
          ),
        );
      } else {
        // Acute Low Readiness (< 55)
        insights.add(
          ProactiveInsight(
            triggerKey: 'low_readiness',
            title: 'Readiness Dip Detected',
            titleHindi: 'शारीरिक तत्परता में गिरावट',
            suggestion: 'Your readiness is at $readinessScore. Switch today’s heavy training to a 30-min mobility & recovery protocol.',
            suggestionHindi: 'आपका तत्परता स्कोर $readinessScore है। आज भारी वजन उठाने के बजाय हल्की स्ट्रेचिंग और योग करें।',
            promptShortcut: 'How should I modify my workout for low readiness today?',
            requiresCoachEscalation: isEliteTier,
            glowColor: AppColors.accentCoral,
            icon: Icons.offline_bolt_rounded,
          ),
        );
      }
    } else {
      // Pending Check-in
      insights.add(
        const ProactiveInsight(
          triggerKey: 'calibration_needed',
          title: 'Daily Calibration Pending',
          titleHindi: 'दैनिक स्वास्थ्य चेक-इन शेष है',
          suggestion: 'Complete your morning recovery check-in (sleep, resting pulse, soreness) to compute your live readiness score and unlock personalized AI coaching.',
          suggestionHindi: 'लाइव तत्परता स्कोर जानने और व्यक्तिगत एआई कोचिंग के लिए अपना मॉर्निंग चेक-इन पूरा करें।',
          promptShortcut: 'Help me calculate my daily readiness score and plan my workout.',
          glowColor: AppColors.primaryCyan,
          icon: Icons.favorite_rounded,
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
          glowColor: AppColors.accentAmber,
          icon: Icons.bedtime_rounded,
        ),
      );
    }

    // 3. Multi-Region Muscle Soreness Trigger
    if (soreMuscleCount >= 3) {
      insights.add(
        const ProactiveInsight(
          triggerKey: 'systemic_soreness',
          title: 'Widespread DOMS Recorded',
          titleHindi: 'मांसपेशियों में अत्यधिक दर्द',
          suggestion: 'Multiple muscle groups are sore. Prioritize 2.5L water with electrolytes and 20g whey/sattu.',
          suggestionHindi: 'मांसपेशियों की रिकवरी के लिए पर्याप्त पानी, इलेक्ट्रोलाइट्स और प्रोटीन लें।',
          promptShortcut: 'Suggest high-protein Indian foods to speed up muscle recovery.',
          glowColor: AppColors.accentPurple,
          icon: Icons.healing_rounded,
        ),
      );
    }

    // 4. PCOS / Luteal Phase Craving Trigger
    if (cyclePhase == 'luteal' && hasPcos) {
      insights.add(
        const ProactiveInsight(
          triggerKey: 'pcos_luteal_craving',
          title: 'Luteal Phase Metabolic Calibration',
          titleHindi: 'ल्यूटियल चरण आहार संतुलन',
          suggestion: 'Progesterone is rising. Curb sugar cravings with roasted makhana, dark chocolate, and cinnamon tea.',
          suggestionHindi: 'क्रेविंग से बचने के लिए भुने मखाने, डार्क चॉकलेट और दालचीनी की चाय लें।',
          promptShortcut: 'Give me low-GI Indian snacks to control PMS cravings.',
          glowColor: AppColors.accentPurple,
          icon: Icons.restaurant_rounded,
        ),
      );
    }

    // 5. Daily Step Goal Milestone
    if (todaySteps > 0 && todaySteps >= stepGoal) {
      insights.add(
        ProactiveInsight(
          triggerKey: 'step_goal_crushed',
          title: 'Daily Step Goal Achieved! 🎯',
          titleHindi: 'दैनिक स्टेप लक्ष्य पूरा!',
          suggestion: 'You hit $todaySteps / $stepGoal steps today! High NEAT energy expenditure boosts your metabolic rate.',
          suggestionHindi: 'आपने आज $todaySteps कदम पूरे कर लिए हैं! उत्कृष्ट सक्रियता।',
          promptShortcut: 'How does high daily step count accelerate my fat loss?',
          glowColor: AppColors.primaryEmerald,
          icon: Icons.emoji_events_rounded,
        ),
      );
    }

    return insights;
  }
}
