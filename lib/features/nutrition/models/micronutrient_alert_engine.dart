enum MicronutrientAlertSeverity { high, medium, low }

class MicroAlert {
  final String title;
  final String message;
  final MicronutrientAlertSeverity severity;

  const MicroAlert({
    required this.title,
    required this.message,
    required this.severity,
  });
}

class UserMicroTargets {
  final double targetIronMg;
  final double targetB12Mcg;
  final double targetD3Iu;
  final double targetCalciumMg;
  final double targetMagnesiumMg;
  final double targetZincMg;
  final double targetFolateMcg;
  final double targetOmega3G;

  const UserMicroTargets({
    required this.targetIronMg,
    required this.targetB12Mcg,
    required this.targetD3Iu,
    required this.targetCalciumMg,
    required this.targetMagnesiumMg,
    required this.targetZincMg,
    required this.targetFolateMcg,
    required this.targetOmega3G,
  });

  /// Derives demographic/dietary targets per §P5-I table
  factory UserMicroTargets.derive({
    required bool isFemale,
    required bool isVegetarian,
    required bool hasPcosOrFertilityGoal,
  }) {
    // 1. Iron: Standard 8 mg (M) / 18 mg (F). 1.8x for Non-Heme Veg (14.4 M / 32.4 F). 21 mg for PCOS/Female.
    double iron = isFemale ? 18.0 : 8.0;
    if (hasPcosOrFertilityGoal && isFemale) {
      iron = 21.0;
    } else if (isVegetarian) {
      iron = iron * 1.8;
    }

    // 2. Vitamin B12: 2.4 mcg standard, 3.0 mcg Veg
    double b12 = isVegetarian ? 3.0 : 2.4;

    // 3. Vitamin D3: 600 IU standard, 800 IU Veg, 1000 IU Female/PCOS
    double d3 = 600.0;
    if (hasPcosOrFertilityGoal || (isFemale && isVegetarian)) {
      d3 = 1000.0;
    } else if (isVegetarian) {
      d3 = 800.0;
    }

    // 4. Calcium: 1000 mg standard, 1200 mg Female/PCOS
    double calcium = (isFemale || hasPcosOrFertilityGoal) ? 1200.0 : 1000.0;

    // 5. Magnesium: 350 mg standard, 400 mg Female/PCOS
    double magnesium = (isFemale || hasPcosOrFertilityGoal) ? 400.0 : 350.0;

    // 6. Zinc: 11 mg standard, 15 mg Veg (Non-heme phytate binding adjustment)
    double zinc = isVegetarian ? 15.0 : 11.0;

    // 7. Folate: 400 mcg standard, 600 mcg Fertility/PCOS
    double folate = hasPcosOrFertilityGoal ? 600.0 : 400.0;

    // 8. Omega-3: 1.6g standard, 2.0g Veg (ALA conversion factor) / Female
    double omega3 = (isVegetarian || isFemale) ? 2.0 : 1.6;

    return UserMicroTargets(
      targetIronMg: iron,
      targetB12Mcg: b12,
      targetD3Iu: d3,
      targetCalciumMg: calcium,
      targetMagnesiumMg: magnesium,
      targetZincMg: zinc,
      targetFolateMcg: folate,
      targetOmega3G: omega3,
    );
  }
}

class DailyMicroLog {
  final double ironMg;
  final double b12Mcg;
  final double d3Iu;
  final double calciumMg;
  final double magnesiumMg;
  final double zincMg;
  final double folateMcg;
  final double omega3G;

  const DailyMicroLog({
    this.ironMg = 0.0,
    this.b12Mcg = 0.0,
    this.d3Iu = 0.0,
    this.calciumMg = 0.0,
    this.magnesiumMg = 0.0,
    this.zincMg = 0.0,
    this.folateMcg = 0.0,
    this.omega3G = 0.0,
  });
}

/// Pure-Dart Micronutrient Intelligence & Auto-Alert Trigger Engine per §P5-I spec
class MicronutrientAlertEngine {
  const MicronutrientAlertEngine();

  /// Evaluates multi-day micronutrient logs against demographic target profiles
  List<MicroAlert> evaluateLogs({
    required List<DailyMicroLog> logs,
    required UserMicroTargets targets,
    required bool isVegetarian,
    required bool isFemale,
  }) {
    final alerts = <MicroAlert>[];
    if (logs.isEmpty) return alerts;

    final avgIron = logs.fold(0.0, (sum, l) => sum + l.ironMg) / logs.length;
    final avgB12 = logs.fold(0.0, (sum, l) => sum + l.b12Mcg) / logs.length;
    final avgD3 = logs.fold(0.0, (sum, l) => sum + l.d3Iu) / logs.length;
    final avgZinc = logs.fold(0.0, (sum, l) => sum + l.zincMg) / logs.length;

    final ironPct = avgIron / targets.targetIronMg;
    final b12Pct = avgB12 / targets.targetB12Mcg;
    final d3Pct = avgD3 / targets.targetD3Iu;
    final zincPct = avgZinc / targets.targetZincMg;

    // Rule 1: Vegetarian B12 Depletion Risk (< 50% target)
    if (isVegetarian && b12Pct < 0.50) {
      alerts.add(MicroAlert(
        title: 'B12 Depletion Risk',
        message:
            'Your vegetarian diet yields only ${(b12Pct * 100).round()}% of Vitamin B12 targets. Consider adding fortified milk, curd, or an oral B12 supplement.',
        severity: MicronutrientAlertSeverity.high,
      ));
    }

    // Rule 2: Female / PCOS Iron Deficit Warning (< 60% target)
    if (isFemale && ironPct < 0.60) {
      alerts.add(MicroAlert(
        title: 'Iron Deficit Warning',
        message:
            'Your logged meals reach only ${(ironPct * 100).round()}% of iron targets. Pair plant-iron (spinach, chana) with Vitamin C (lemon juice) to double non-heme absorption.',
        severity: MicronutrientAlertSeverity.medium,
      ));
    }

    // Rule 3: Vitamin D3 Sunlight / Intake Alarm (< 40% target)
    if (d3Pct < 0.40) {
      alerts.add(MicroAlert(
        title: 'Vitamin D3 Sub-Optimal Intake',
        message:
            'Current D3 intake is at ${(d3Pct * 100).round()}% of target. Include 15-min morning sunlight exposure or D3-fortified foods.',
        severity: MicronutrientAlertSeverity.medium,
      ));
    }

    // Rule 4: Vegetarian Zinc Deficiency Warning (< 50% target)
    if (isVegetarian && zincPct < 0.50) {
      alerts.add(MicroAlert(
        title: 'Zinc Bioavailability Deficit',
        message:
            'Zinc intake is low on a plant-based diet. Soak legumes and seeds to reduce phytates and boost absorption.',
        severity: MicronutrientAlertSeverity.low,
      ));
    }

    return alerts;
  }
}
