enum CyclePhase {
  menstrual, // Days 1 - 5
  follicular, // Days 6 - 13
  ovulatory, // Days 14 - 16
  luteal, // Days 17 - 28+
}

class CycleProfile {
  final int cycleLengthDays;
  final int currentCycleDay;
  final CyclePhase currentPhase;
  final bool hasPCOS;
  final String phaseSummary;
  final String phaseSummaryHindi;
  final String trainingRecommendation;
  final String nutritionRecommendation;

  const CycleProfile({
    required this.cycleLengthDays,
    required this.currentCycleDay,
    required this.currentPhase,
    required this.hasPCOS,
    required this.phaseSummary,
    required this.phaseSummaryHindi,
    required this.trainingRecommendation,
    required this.nutritionRecommendation,
  });
}

/// WomensHealthEngine — Cycle-aware training and PCOS calibrator
class WomensHealthEngine {
  const WomensHealthEngine();

  CyclePhase getPhase(int dayOfCycle) {
    if (dayOfCycle <= 5) return CyclePhase.menstrual;
    if (dayOfCycle <= 13) return CyclePhase.follicular;
    if (dayOfCycle <= 16) return CyclePhase.ovulatory;
    return CyclePhase.luteal;
  }

  CycleProfile evaluateCycle({
    required int cycleLengthDays,
    required int currentCycleDay,
    required bool hasPCOS,
  }) {
    final phase = getPhase(currentCycleDay);

    String summary;
    String summaryHindi;
    String training;
    String nutrition;

    switch (phase) {
      case CyclePhase.menstrual:
        summary = 'Menstrual Phase (Days 1–5): Hormones at baseline, restorative phase.';
        summaryHindi = 'मासिक धर्म चरण (दिन १-५): शरीर को विश्राम और हल्के व्यायाम की आवश्यकता है।';
        training = 'Low-impact walking, restorative yoga, and gentle mobility flows.';
        nutrition = 'Iron & magnesium rich Indian foods: Palak dal, roasted pumpkin seeds, jaggery.';
        break;
      case CyclePhase.follicular:
        summary = 'Follicular Phase (Days 6–13): Estrogen rising, insulin sensitivity peaks.';
        summaryHindi = 'फॉलिक्युलर चरण (दिन ६-१३): ऊर्जा में वृद्धि, स्ट्रेंथ ट्रेनिंग के लिए आदर्श।';
        training = 'Prime time for progressive overload, heavy compound lifts, and HIIT.';
        nutrition = 'Complex carbs well tolerated: Ragi rotis, brown rice, sprouted legumes.';
        break;
      case CyclePhase.ovulatory:
        summary = 'Ovulatory Phase (Days 14–16): Peak estrogen & testosterone, peak power output.';
        summaryHindi = 'ओव्यूलेशन चरण (दिन १४-१६): शारीरिक शक्ति और सहनशक्ति उच्चतम स्तर पर।';
        training = 'Maximum strength output, explosive movements, and personal record (PR) testing.';
        nutrition = 'Anti-inflammatory foods: Turmeric milk (Haldi doodh), berries, chia seeds.';
        break;
      case CyclePhase.luteal:
        summary = 'Luteal Phase (Days 17–28): Progesterone dominant, metabolic rate slightly elevated.';
        summaryHindi = 'ल्यूटियल चरण (दिन १७-२८): मेटाबॉलिज्म तेज, स्थिर मध्यम व्यायाम बेहतर।';
        training = 'Moderate hypertrophy, tempo lifting, and steady-state Zone 2 cardio.';
        nutrition = 'Higher healthy fats & fiber to curb PMS cravings: Walnuts, flaxseeds, paneer.';
        break;
    }

    if (hasPCOS) {
      nutrition += ' [PCOS Calibrator: Strictly low-GI complex carbs, cinnamon water & methi infusion recommended].';
    }

    return CycleProfile(
      cycleLengthDays: cycleLengthDays,
      currentCycleDay: currentCycleDay,
      currentPhase: phase,
      hasPCOS: hasPCOS,
      phaseSummary: summary,
      phaseSummaryHindi: summaryHindi,
      trainingRecommendation: training,
      nutritionRecommendation: nutrition,
    );
  }
}
