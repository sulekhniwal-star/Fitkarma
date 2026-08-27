enum MenstrualPhase {
  menstrual(name: 'Menstrual', regionalName: 'माहवारी चरण', dayRange: 'Days 1–5'),
  follicular(name: 'Follicular', regionalName: 'फॉलिक्युलर चरण', dayRange: 'Days 6–13'),
  ovulatory(name: 'Ovulatory', regionalName: 'ओव्यूलेशन चरण', dayRange: 'Days 14–16'),
  luteal(name: 'Luteal', regionalName: 'ल्यूटियल चरण', dayRange: 'Days 17–28');

  final String name;
  final String regionalName;
  final String dayRange;

  const MenstrualPhase({
    required this.name,
    required this.regionalName,
    required this.dayRange,
  });
}

enum LifeStageMode {
  regularCycle,    // Standard cycle tracking
  pcosCalibrator,  // PCOS / PCOD insulin-resistance mode
  fertilityWindow, // Fertility & conception planning
  menopauseCare,   // Peri-menopause & bone-density tracking
}

class WomensHealthProfile {
  final int cycleLengthDays; // typically 28 (21 - 35)
  final int periodLengthDays; // typically 5 (3 - 7)
  final int currentCycleDay; // 1 to cycleLengthDays
  final MenstrualPhase currentPhase;
  final LifeStageMode lifeStageMode;
  final bool isPcosDiagnosed;
  final int calorieOffset; // e.g. +150 kcal during luteal
  final double trainingLoadMultiplier; // e.g. 1.10 during follicular, 0.80 in menstrual
  final String trainingRecommendation;
  final String nutritionRecommendation;
  final List<String> wellnessTips;

  const WomensHealthProfile({
    required this.cycleLengthDays,
    required this.periodLengthDays,
    required this.currentCycleDay,
    required this.currentPhase,
    required this.lifeStageMode,
    required this.isPcosDiagnosed,
    required this.calorieOffset,
    required this.trainingLoadMultiplier,
    required this.trainingRecommendation,
    required this.nutritionRecommendation,
    required this.wellnessTips,
  });

  factory WomensHealthProfile.fromMap(Map<String, dynamic> map) {
    final phaseName = map['currentPhase'] as String? ?? 'follicular';
    final phase = MenstrualPhase.values.firstWhere(
      (e) => e.name == phaseName,
      orElse: () => MenstrualPhase.follicular,
    );

    final modeName = map['lifeStageMode'] as String? ?? 'regularCycle';
    final mode = LifeStageMode.values.firstWhere(
      (e) => e.name == modeName,
      orElse: () => LifeStageMode.regularCycle,
    );

    return WomensHealthProfile(
      cycleLengthDays: (map['cycleLengthDays'] as num?)?.toInt() ?? 28,
      periodLengthDays: (map['periodLengthDays'] as num?)?.toInt() ?? 5,
      currentCycleDay: (map['currentCycleDay'] as num?)?.toInt() ?? 10,
      currentPhase: phase,
      lifeStageMode: mode,
      isPcosDiagnosed: map['isPcosDiagnosed'] as bool? ?? false,
      calorieOffset: (map['calorieOffset'] as num?)?.toInt() ?? 0,
      trainingLoadMultiplier: (map['trainingLoadMultiplier'] as num?)?.toDouble() ?? 1.0,
      trainingRecommendation: map['trainingRecommendation'] as String? ?? 'Progressive strength training focus.',
      nutritionRecommendation: map['nutritionRecommendation'] as String? ?? 'Balanced high-protein meals with complex carbs.',
      wellnessTips: List<String>.from(map['wellnessTips'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cycleLengthDays': cycleLengthDays,
      'periodLengthDays': periodLengthDays,
      'currentCycleDay': currentCycleDay,
      'currentPhase': currentPhase.name,
      'lifeStageMode': lifeStageMode.name,
      'isPcosDiagnosed': isPcosDiagnosed,
      'calorieOffset': calorieOffset,
      'trainingLoadMultiplier': trainingLoadMultiplier,
      'trainingRecommendation': trainingRecommendation,
      'nutritionRecommendation': nutritionRecommendation,
      'wellnessTips': wellnessTips,
    };
  }
}

class WomensHealthEngine {
  /// Pure Dart deterministic calculation of menstrual phase and physiological adaptations
  static WomensHealthProfile evaluateProfile({
    int cycleLengthDays = 28,
    int periodLengthDays = 5,
    int currentCycleDay = 10,
    LifeStageMode mode = LifeStageMode.regularCycle,
    bool isPcos = false,
  }) {
    final MenstrualPhase phase;
    int calorieOffset = 0;
    double trainingMultiplier = 1.0;
    String trainingAdvice = '';
    String nutritionAdvice = '';
    final List<String> tips = [];

    // 1. Determine Menstrual Phase
    if (currentCycleDay <= periodLengthDays) {
      phase = MenstrualPhase.menstrual;
      calorieOffset = 0;
      trainingMultiplier = 0.75;
      trainingAdvice = 'Low-intensity mobility, restorative yoga, and gentle walks. Listen to your body and avoid heavy spinal loading.';
      nutritionAdvice = 'Focus on iron-rich Indian foods (spinach, beetroot, jaggery, lentils), warm soups, and herbal teas (ginger/ajwain).';
      tips.add('Prioritize sleep and magnesium-rich hydration.');
    } else if (currentCycleDay <= 13) {
      phase = MenstrualPhase.follicular;
      calorieOffset = 0;
      trainingMultiplier = 1.10;
      trainingAdvice = 'Estrogen is rising — peak strength & progressive overload capacity. Best window for PR attempts and intense lifting.';
      nutritionAdvice = 'High insulin sensitivity — lean protein, complex grains (millets, oats), and cruciferous vegetables for estrogen clearance.';
      tips.add('Great time to increase training volume.');
    } else if (currentCycleDay <= 16) {
      phase = MenstrualPhase.ovulatory;
      calorieOffset = 50;
      trainingMultiplier = 1.15;
      trainingAdvice = 'Peak power output and athletic performance. Maintain knee and joint stability (estrogen-induced ligament laxity awareness).';
      nutritionAdvice = 'Hydrate with electrolytes, include anti-inflammatory berries, citrus fruits, and zinc-rich seeds (pumpkin/sunflower).';
      tips.add('Optimal window for high-intensity intervals (HIIT).');
    } else {
      phase = MenstrualPhase.luteal;
      calorieOffset = 150; // Basal metabolic rate increases by ~100-200 kcal
      trainingMultiplier = 0.90;
      trainingAdvice = 'Progesterone dominates — focus on moderate steady-state cardio, strength maintenance, and higher recovery intervals.';
      nutritionAdvice = 'Slightly higher caloric need (+150 kcal). Focus on healthy fats (ghee, nuts), dark chocolate, and avoid excess salt to prevent bloating.';
      tips.add('Support serotonin with complex carbs and restful evenings.');
    }

    // 2. PCOS / PCOD Adjustments
    if (isPcos || mode == LifeStageMode.pcosCalibrator) {
      nutritionAdvice = 'PCOS Protocol: Low-glycemic Indian meals, cinnamon & fenugreek (methi) water, spearmint tea for androgen balance, and high-fiber lentils.';
      trainingAdvice = 'Resistance strength training prioritized over excessive cardio to maximize insulin sensitivity without elevating cortisol.';
      tips.add('Pair all carbs with healthy fats and protein to prevent insulin spikes.');
    }

    // 3. Menopause Care Adjustments
    if (mode == LifeStageMode.menopauseCare) {
      nutritionAdvice = 'Menopause Protocol: Phytoestrogen-rich foods (tofu, flaxseeds), calcium + D3 rich meals, and cooling herbs to manage temperature fluctuations.';
      trainingAdvice = 'Weight-bearing resistance training is paramount to stimulate bone mineral density and protect muscle mass.';
      tips.add('Incorporate balance, core stability, and joint mobility drills.');
    }

    return WomensHealthProfile(
      cycleLengthDays: cycleLengthDays,
      periodLengthDays: periodLengthDays,
      currentCycleDay: currentCycleDay,
      currentPhase: phase,
      lifeStageMode: mode,
      isPcosDiagnosed: isPcos,
      calorieOffset: calorieOffset,
      trainingLoadMultiplier: trainingMultiplier,
      trainingRecommendation: trainingAdvice,
      nutritionRecommendation: nutritionAdvice,
      wellnessTips: tips,
    );
  }
}
