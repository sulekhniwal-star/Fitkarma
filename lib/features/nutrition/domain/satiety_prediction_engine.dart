import 'nutrition_models.dart';

enum SatietyGrade {
  exceptional(
    label: 'Exceptional Fullness / 4.5h+ Satiety',
    regionalLabel: 'असाधारण तृप्ति (४.५+ घंटे)',
    colorCode: 0xff22C55E, // Karma Green
    grade: 'A+',
    minScore: 85,
  ),
  high(
    label: 'High Satiety / 3.5–4.5h Fullness',
    regionalLabel: 'उच्च तृप्ति (३.५–४.५ घंटे)',
    colorCode: 0xff3B82F6, // Focus Blue
    grade: 'A',
    minScore: 70,
  ),
  moderate(
    label: 'Moderate Fullness / 2–3h Satiety',
    regionalLabel: 'मध्यम तृप्ति (२–३ घंटे)',
    colorCode: 0xffEAB308, // Gold
    grade: 'B',
    minScore: 50,
  ),
  shortLived(
    label: 'Short-Lived / <2h Hunger Crash Risk',
    regionalLabel: 'अल्पकालिक तृप्ति / भूख का खतरा',
    colorCode: 0xffEF4444, // Alert Red
    grade: 'C',
    minScore: 0,
  );

  final String label;
  final String regionalLabel;
  final int colorCode;
  final String grade;
  final int minScore;

  const SatietyGrade({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
    required this.grade,
    required this.minScore,
  });
}

class SatietyBooster {
  final String title;
  final String regionalTitle;
  final int addedCalories;
  final int addedSatietyMinutes;
  final String physiologicalMechanism;

  const SatietyBooster({
    required this.title,
    required this.regionalTitle,
    required this.addedCalories,
    required this.addedSatietyMinutes,
    required this.physiologicalMechanism,
  });
}

class SatietyReport {
  final int satietyScore; // 0 to 100
  final SatietyGrade grade;
  final double predictedFullnessHours; // e.g. 4.2 hours
  final DateTime nextHungerHorizon; // e.g. 5:30 PM
  final double satietyEfficiencyPer100Kcal; // Fullness score per 100 kcal
  final double proteinFullnessWeight;
  final double fiberFullnessWeight;
  final double volumeWeight;
  final List<SatietyBooster> personalizedBoosters;
  final String biologicalMechanismSummary;

  const SatietyReport({
    required this.satietyScore,
    required this.grade,
    required this.predictedFullnessHours,
    required this.nextHungerHorizon,
    required this.satietyEfficiencyPer100Kcal,
    required this.proteinFullnessWeight,
    required this.fiberFullnessWeight,
    required this.volumeWeight,
    required this.personalizedBoosters,
    required this.biologicalMechanismSummary,
  });
}

class SatietyPredictionEngine {
  /// Pure Dart deterministic calculation of postprandial satiety duration and hunger horizon
  static SatietyReport predictMealSatiety({
    required List<LoggedMealEntry> entries,
    DateTime? mealTime,
  }) {
    final now = mealTime ?? DateTime.now();

    if (entries.isEmpty) {
      return _buildEmptySatietyReport(now);
    }

    final totalCalories =
        entries.fold<int>(0, (sum, e) => sum + e.totalCalories);
    final totalProtein =
        entries.fold<double>(0.0, (sum, e) => sum + e.totalProtein);
    final totalCarbs =
        entries.fold<double>(0.0, (sum, e) => sum + e.totalCarbs);
    final totalFiber =
        entries.fold<double>(0.0, (sum, e) => sum + e.totalFiber);

    final categories =
        entries.map((e) => e.food.category.toLowerCase()).toSet();
    final names = entries.map((e) => e.food.name.toLowerCase()).toList();

    // 1. Protein Satiety Vector (35% weight)
    // Protein stimulates CCK & PYY release in the duodenum
    final double proteinVector =
        (totalProtein / 30.0 * 100.0).clamp(10.0, 100.0);

    // 2. Dietary Fiber & Viscosity Vector (30% weight)
    // Soluble fiber creates viscous gel in stomach, delaying gastric emptying
    final double fiberVector = (totalFiber / 8.0 * 100.0).clamp(10.0, 100.0);

    // 3. Food Volume & Water Matrix (20% weight)
    // Whole vegetables / salads / broths vs calorie-dense fats
    double volumeVector = 50.0;
    if (categories.contains('sabzi') ||
        names.any((n) =>
            n.contains('salad') ||
            n.contains('cucumber') ||
            n.contains('kheera') ||
            n.contains('soup') ||
            n.contains('chaas'))) {
      volumeVector += 40.0;
    }
    if (categories.contains('daal') ||
        names.any((n) =>
            n.contains('dal') || n.contains('rajma') || n.contains('chole'))) {
      volumeVector += 15.0;
    }
    volumeVector = volumeVector.clamp(20.0, 100.0);

    // 4. Glycemic Crash Risk Penalty (15% weight)
    // Refined sugar/flour with low protein/fiber causes reactive hypoglycemia
    double glycemicStabilityVector = 85.0;
    final isHighRefinedCarb =
        (totalCarbs > 50 && totalFiber < 3.0 && totalProtein < 10.0);
    if (isHighRefinedCarb) {
      glycemicStabilityVector = 30.0;
    } else if (totalFiber >= 5.0 || totalProtein >= 20.0) {
      glycemicStabilityVector = 95.0;
    }

    // Composite Satiety Score (0 - 100)
    final double rawScore = (proteinVector * 0.35) +
        (fiberVector * 0.30) +
        (volumeVector * 0.20) +
        (glycemicStabilityVector * 0.15);

    final int satietyScore = rawScore.round().clamp(10, 100);
    final grade = _getGrade(satietyScore);

    // Fullness Duration Calculation:
    // Base: 1.5 hours + (satietyScore / 100 * 3.5 hours)
    // Ranges from ~1.8 hours (poor meal) to 5.0 hours (optimal high protein/fiber meal)
    final double fullnessHours =
        double.parse((1.5 + (satietyScore / 100.0 * 3.5)).toStringAsFixed(1));
    final int fullnessMinutes = (fullnessHours * 60).round();
    final nextHunger = now.add(Duration(minutes: fullnessMinutes));

    // Efficiency per 100 kcal
    final double efficiency = totalCalories > 0
        ? double.parse(
            ((satietyScore / totalCalories) * 100.0).toStringAsFixed(1))
        : 15.0;

    // Personalized Boosters based on deficits
    final List<SatietyBooster> boosters = [];
    if (totalProtein < 20.0) {
      boosters.add(const SatietyBooster(
        title: 'Add 150g Low-Fat Paneer or 2 Boiled Eggs',
        regionalTitle: '१५० ग्राम पनीर या २ उबले अंडे जोड़ें',
        addedCalories: 140,
        addedSatietyMinutes: 60,
        physiologicalMechanism:
            'Elevates leucine above 2.5g, triggering continuous PYY satiety hormone release.',
      ));
    }
    if (totalFiber < 5.0) {
      boosters.add(const SatietyBooster(
        title: 'Add 1 Bowl Raw Kheera/Kakdi Salad',
        regionalTitle: '१ कटोरी खीरा-ककड़ी सलाद जोड़ें',
        addedCalories: 25,
        addedSatietyMinutes: 45,
        physiologicalMechanism:
            'High water volume and raw insoluble cellulose stimulate gastric vagal stretch receptors.',
      ));
    }
    if (!names.any((n) =>
        n.contains('chaas') || n.contains('curd') || n.contains('dahi'))) {
      boosters.add(const SatietyBooster(
        title: '1 Glass Roasted Cumin Chaas (Buttermilk)',
        regionalTitle: '१ गिलास भुना जीरा छाछ',
        addedCalories: 35,
        addedSatietyMinutes: 40,
        physiologicalMechanism:
            'Increases intragastric volume and delivers bioavailable whey proteins without heavy fat.',
      ));
    }

    return SatietyReport(
      satietyScore: satietyScore,
      grade: grade,
      predictedFullnessHours: fullnessHours,
      nextHungerHorizon: nextHunger,
      satietyEfficiencyPer100Kcal: efficiency,
      proteinFullnessWeight: double.parse(proteinVector.toStringAsFixed(1)),
      fiberFullnessWeight: double.parse(fiberVector.toStringAsFixed(1)),
      volumeWeight: double.parse(volumeVector.toStringAsFixed(1)),
      personalizedBoosters: boosters.isEmpty
          ? [
              const SatietyBooster(
                title: 'Perfect Satiety Matrix',
                regionalTitle: 'उत्कृष्ट तृप्ति संतुलन',
                addedCalories: 0,
                addedSatietyMinutes: 0,
                physiologicalMechanism:
                    'Your meal delivers optimal protein, dietary fiber, and volume synergy.',
              )
            ]
          : boosters,
      biologicalMechanismSummary:
          'This meal provides approximately $fullnessHours hours of stable metabolic satiety. '
          'Satiety is sustained by ${totalProtein.toStringAsFixed(1)}g protein and ${totalFiber.toStringAsFixed(1)}g fiber.',
    );
  }

  static SatietyGrade _getGrade(int score) {
    if (score >= SatietyGrade.exceptional.minScore) {
      return SatietyGrade.exceptional;
    } else if (score >= SatietyGrade.high.minScore) {
      return SatietyGrade.high;
    } else if (score >= SatietyGrade.moderate.minScore) {
      return SatietyGrade.moderate;
    } else {
      return SatietyGrade.shortLived;
    }
  }

  static SatietyReport _buildEmptySatietyReport(DateTime now) {
    return SatietyReport(
      satietyScore: 0,
      grade: SatietyGrade.shortLived,
      predictedFullnessHours: 0.0,
      nextHungerHorizon: now,
      satietyEfficiencyPer100Kcal: 0.0,
      proteinFullnessWeight: 0.0,
      fiberFullnessWeight: 0.0,
      volumeWeight: 0.0,
      personalizedBoosters: const [
        SatietyBooster(
          title: 'Log Your Meal to Predict Fullness',
          regionalTitle: 'तृप्ति अवधि जानने के लिए भोजन दर्ज करें',
          addedCalories: 0,
          addedSatietyMinutes: 0,
          physiologicalMechanism:
              'Add your dishes to simulate gastric emptying and peptide hormone kinetics.',
        ),
      ],
      biologicalMechanismSummary:
          'No meal logged yet. Log dishes to compute postprandial satiety curve.',
    );
  }
}
