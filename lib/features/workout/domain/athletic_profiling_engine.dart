enum AthleticPersona {
  pehlwanPowerhouse(
    title: 'Akhara Pehlwan / Functional Powerhouse',
    regionalTitle: 'अखाड़ा पहलवान / कार्यात्मक शक्ति',
    colorCode: 0xffFF9100, // Energy Orange
    description: 'High bodyweight calisthenic endurance, rotational core torque, and joint durability.',
  ),
  hypertrophyArchitect(
    title: 'Hypertrophy Architect / Muscle Builder',
    regionalTitle: 'मांसपेशी शिल्पी (हाइपरट्रॉफी)',
    colorCode: 0xff22C55E, // Karma Green
    description: 'Specialized in mechanical tension, controlled tempo, and optimal volume accumulation.',
  ),
  strengthAthlete(
    title: 'Compound Strength & Neural Power',
    regionalTitle: 'कंपाउंड शक्ति एवं न्यूरल पावर',
    colorCode: 0xff3B82F6, // Focus Blue
    description: 'High 1RM force production, heavy compound lift proficiency, and neuromuscular efficiency.',
  ),
  metabolicWarrior(
    title: 'Metabolic Conditioning Warrior',
    regionalTitle: 'कंडीशनिंग एवं सहनशक्ति योद्धा',
    colorCode: 0xff7C4DFF, // AI Purple
    description: 'High work capacity, short rest tolerance, and cardiovascular/muscular endurance synergy.',
  );

  final String title;
  final String regionalTitle;
  final int colorCode;
  final String description;

  const AthleticPersona({
    required this.title,
    required this.regionalTitle,
    required this.colorCode,
    required this.description,
  });
}

class AthleticVectorScore {
  final String name;
  final String regionalName;
  final int score; // 0 to 100
  final String status;

  const AthleticVectorScore({
    required this.name,
    required this.regionalName,
    required this.score,
    required this.status,
  });
}

class AthleticProfileReport {
  final AthleticPersona primaryPersona;
  final int adherenceScore; // 0 to 100%
  final int currentStreakDays;
  final int completedWorkouts30Days;
  final int scheduledWorkouts30Days;
  final List<AthleticVectorScore> radarVectors;
  final String athleteSummary;
  final String timeCrunchedRecommendation;

  const AthleticProfileReport({
    required this.primaryPersona,
    required this.adherenceScore,
    required this.currentStreakDays,
    required this.completedWorkouts30Days,
    required this.scheduledWorkouts30Days,
    required this.radarVectors,
    required this.athleteSummary,
    required this.timeCrunchedRecommendation,
  });
}

class AthleticProfilingEngine {
  /// Pure Dart deterministic calculation of Athletic Profiling, Radar Vectors, and Training Adherence
  static AthleticProfileReport evaluateAthleticProfile({
    required int completedWorkouts30Days,
    required int scheduledWorkouts30Days,
    required int currentStreakDays,
    required double totalTonnage30Days,
    bool includesIndianTraditionalMovements = true,
  }) {
    final int scheduled = scheduledWorkouts30Days > 0 ? scheduledWorkouts30Days : 20;
    final int completed = completedWorkouts30Days.clamp(0, scheduled);

    // 1. Adherence Score Calculation
    final int adherenceScore = ((completed / scheduled) * 100.0).round().clamp(0, 100);

    // 2. Athletic Vectors (0 - 100)
    // Vector 1: Max Strength & 1RM Output
    final int strengthScore = (75 + (adherenceScore * 0.20)).round().clamp(50, 98);

    // Vector 2: Work Capacity & Tonnage
    final int workCapacityScore = (totalTonnage30Days > 30000 ? 92 : (totalTonnage30Days > 15000 ? 82 : 68));

    // Vector 3: Rotational & Joint Mobility
    final int mobilityScore = includesIndianTraditionalMovements ? 94 : 72;

    // Vector 4: Adherence & Streak Resilience
    final int consistencyScore = adherenceScore;

    // Vector 5: Neuromuscular Recovery Speed
    final int recoveryScore = (currentStreakDays >= 10 ? 90 : (currentStreakDays >= 5 ? 80 : 65));

    final vectors = [
      AthleticVectorScore(
        name: 'Max Strength & 1RM',
        regionalName: 'अधिकतम शक्ति क्षमता',
        score: strengthScore,
        status: strengthScore >= 85 ? 'Elite' : 'Strong',
      ),
      AthleticVectorScore(
        name: 'Hypertrophic Work Capacity',
        regionalName: 'वॉल्यूम वहन क्षमता',
        score: workCapacityScore,
        status: workCapacityScore >= 85 ? 'High Volume' : 'Moderate',
      ),
      AthleticVectorScore(
        name: 'Rotational & Multi-Planar Mobility',
        regionalName: 'घूर्णन एवं जोड़ लचीलापन',
        score: mobilityScore,
        status: mobilityScore >= 85 ? 'Agile Akhara' : 'Standard',
      ),
      AthleticVectorScore(
        name: '30-Day Training Adherence',
        regionalName: '३०-दिवसीय निरंतरता',
        score: consistencyScore,
        status: consistencyScore >= 85 ? 'Consistent' : 'Developing',
      ),
      AthleticVectorScore(
        name: 'Neuromuscular Recovery Speed',
        regionalName: 'पुनर्प्राप्ति वेग',
        score: recoveryScore,
        status: recoveryScore >= 85 ? 'Rapid' : 'Adequate',
      ),
    ];

    // 3. Persona Assignment Logic
    final AthleticPersona persona;
    if (includesIndianTraditionalMovements && mobilityScore >= 85) {
      persona = AthleticPersona.pehlwanPowerhouse;
    } else if (workCapacityScore >= 85) {
      persona = AthleticPersona.hypertrophyArchitect;
    } else if (strengthScore >= 85) {
      persona = AthleticPersona.strengthAthlete;
    } else {
      persona = AthleticPersona.metabolicWarrior;
    }

    return AthleticProfileReport(
      primaryPersona: persona,
      adherenceScore: adherenceScore,
      currentStreakDays: currentStreakDays,
      completedWorkouts30Days: completed,
      scheduledWorkouts30Days: scheduled,
      radarVectors: vectors,
      athleteSummary: 'Your 30-day training profile classifies you as a "${persona.title}". '
          'You have achieved an outstanding $adherenceScore% adherence with a $currentStreakDays-day active streak.',
      timeCrunchedRecommendation: 'Time-Crunched Protocol (20-min alternative): 4 rounds of Desi Dand (15 reps), '
          'Desi Baithak (25 reps), and Mudgar Swings (30s) if full session is impossible today.',
    );
  }
}
