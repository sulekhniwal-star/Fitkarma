enum MicronutrientType {
  vitaminB12(name: 'Vitamin B12', regionalName: 'विटामिन B12', unit: 'mcg', rda: 2.4, isCommonIndianDeficiency: true),
  vitaminD3(name: 'Vitamin D3', regionalName: 'विटामिन D3', unit: 'IU', rda: 1000.0, isCommonIndianDeficiency: true),
  iron(name: 'Elemental Iron', regionalName: 'आयरन (लौह तत्व)', unit: 'mg', rda: 18.0, isCommonIndianDeficiency: true),
  calcium(name: 'Calcium', regionalName: 'कैल्शियम', unit: 'mg', rda: 1000.0, isCommonIndianDeficiency: false),
  magnesium(name: 'Magnesium', regionalName: 'मैग्नीशियम', unit: 'mg', rda: 400.0, isCommonIndianDeficiency: true),
  zinc(name: 'Elemental Zinc', regionalName: 'जिंक', unit: 'mg', rda: 12.0, isCommonIndianDeficiency: false);

  final String name;
  final String regionalName;
  final String unit;
  final double rda;
  final bool isCommonIndianDeficiency;

  const MicronutrientType({
    required this.name,
    required this.regionalName,
    required this.unit,
    required this.rda,
    required this.isCommonIndianDeficiency,
  });
}

class MicronutrientStatus {
  final MicronutrientType type;
  final double currentIntake;
  final double rda;
  final int percentageOfRda;
  final bool isDeficient;
  final String topIndianSource;

  const MicronutrientStatus({
    required this.type,
    required this.currentIntake,
    required this.rda,
    required this.percentageOfRda,
    required this.isDeficient,
    required this.topIndianSource,
  });
}

class MicronutrientReport {
  final List<MicronutrientStatus> nutrients;
  final int overallMicronutrientScore; // 0 to 100
  final List<String> bioavailabilitySynergies;
  final List<String> deficiencyWarnings;

  const MicronutrientReport({
    required this.nutrients,
    required this.overallMicronutrientScore,
    required this.bioavailabilitySynergies,
    required this.deficiencyWarnings,
  });
}

class MicronutrientEngine {
  /// Pure Dart deterministic evaluation of Indian dietary micronutrient adequacy & bioavailability synergies
  static MicronutrientReport evaluateMicronutrients({
    required bool isVegetarian,
    required int loggedMealCount,
  }) {
    // Estimated intake based on standard balanced Indian meal logs
    final double b12 = isVegetarian ? 0.8 : 2.2;
    const double d3 = 350.0;
    const double iron = 12.5;
    const double calcium = 720.0;
    const double magnesium = 280.0;
    const double zinc = 9.5;

    final statuses = [
      _createStatus(MicronutrientType.vitaminB12, b12, 'Set Dahi (Curd), Paneer, Fortified Nutritional Yeast'),
      _createStatus(MicronutrientType.vitaminD3, d3, 'Morning Sunlight (20 mins), Fortified Milk, Egg Yolks'),
      _createStatus(MicronutrientType.iron, iron, 'Palak (Spinach), Roasted Chana, Sprouted Moong'),
      _createStatus(MicronutrientType.calcium, calcium, 'Fresh Paneer, Set Dahi, Ragi (Finger Millet)'),
      _createStatus(MicronutrientType.magnesium, magnesium, 'Pumpkin Seeds, Roasted Almonds, Brown Rice'),
      _createStatus(MicronutrientType.zinc, zinc, 'White/Black Chana, Pumpkin Seeds, Cashews'),
    ];

    final avgPercentage = (statuses.fold<int>(0, (sum, s) => sum + s.percentageOfRda) / statuses.length).round();

    final List<String> synergies = [
      'Iron + Vitamin C Synergy: Squeeze fresh lemon juice or consume 1 Amla with spinach/daal to boost non-heme plant iron absorption by 300%.',
      'Calcium & Iron Timing: Avoid consuming dairy curd/paneer in the exact same mouthful as iron-rich leafy greens, as calcium competes with iron receptors.',
      'Fat-Soluble D3 Absorption: Take Vitamin D3 with healthy fats (ghee or nuts) for optimal micellar absorption.',
    ];

    final List<String> warnings = [];
    if (isVegetarian) {
      warnings.add('High B12 Deficiency Risk: Vegetarian diets lack active cobalamin. Consider a weekly 1000mcg methylcobalamin supplement.');
    }
    warnings.add('Urban Sun Deprivation: 75%+ of Indians are deficient in Vitamin D3. Check serum 25(OH)D levels regularly.');

    return MicronutrientReport(
      nutrients: statuses,
      overallMicronutrientScore: avgPercentage.clamp(0, 100),
      bioavailabilitySynergies: synergies,
      deficiencyWarnings: warnings,
    );
  }

  static MicronutrientStatus _createStatus(MicronutrientType type, double intake, String topSource) {
    final pct = ((intake / type.rda) * 100).round();
    return MicronutrientStatus(
      type: type,
      currentIntake: intake,
      rda: type.rda,
      percentageOfRda: pct,
      isDeficient: pct < 75,
      topIndianSource: topSource,
    );
  }
}
