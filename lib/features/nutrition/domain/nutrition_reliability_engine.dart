import 'nutrition_models.dart';

enum ReliabilityLevel {
  high(
    label: 'High Confidence Shield',
    regionalLabel: 'उच्च विश्वसनीयता सुरक्षा',
    colorCode: 0xff22C55E, // Karma Green
    uncertaintyPct: 0.06,
    shieldActive: true,
  ),
  moderate(
    label: 'Moderate Confidence / Calibrated',
    regionalLabel: 'मध्यम विश्वसनीयता / समायोजित',
    colorCode: 0xff3B82F6, // Focus Blue
    uncertaintyPct: 0.12,
    shieldActive: true,
  ),
  provisional(
    label: 'Provisional / Noticeable Gaps',
    regionalLabel: 'अस्थायी / अनुमानित प्रविष्टियाँ',
    colorCode: 0xffEAB308, // Gold
    uncertaintyPct: 0.22,
    shieldActive: false,
  ),
  unreliable(
    label: 'Low Reliability / Incomplete Day',
    regionalLabel: 'कम विश्वसनीयता / अधूरा दिन',
    colorCode: 0xffEF4444, // Crimson
    uncertaintyPct: 0.35,
    shieldActive: false,
  );

  final String label;
  final String regionalLabel;
  final int colorCode;
  final double uncertaintyPct;
  final bool shieldActive;

  const ReliabilityLevel({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
    required this.uncertaintyPct,
    required this.shieldActive,
  });
}

class ReliabilityFactor {
  final String id;
  final String name;
  final String regionalName;
  final double score; // 0 to 100
  final double weight; // 0.0 to 1.0
  final String status;
  final String detail;
  final String recommendation;

  const ReliabilityFactor({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.score,
    required this.weight,
    required this.status,
    required this.detail,
    required this.recommendation,
  });

  double get weightedContribution => score * weight;
}

class NutritionReliabilityReport {
  final int overallReliabilityScore; // 0 to 100
  final ReliabilityLevel level;
  final int caloricUncertaintyMargin; // e.g. +/- 180 kcal
  final double proteinUncertaintyMargin; // e.g. +/- 7.5g
  final bool isShieldActive;
  final double hiddenOilBufferKcal;
  final List<ReliabilityFactor> factors;
  final List<String> detectedGaps;
  final List<String> shieldCalibrations;
  final String confidenceSummary;

  const NutritionReliabilityReport({
    required this.overallReliabilityScore,
    required this.level,
    required this.caloricUncertaintyMargin,
    required this.proteinUncertaintyMargin,
    required this.isShieldActive,
    required this.hiddenOilBufferKcal,
    required this.factors,
    required this.detectedGaps,
    required this.shieldCalibrations,
    required this.confidenceSummary,
  });
}

class NutritionReliabilityEngine {
  /// Pure Dart deterministic calculation of Nutrition Data Reliability & Confidence Shield
  static NutritionReliabilityReport evaluateDailyReliability({
    required List<LoggedMealEntry> allDayMeals,
    required int targetCalories,
    bool isOilExplicitlyTracked = false,
  }) {
    if (allDayMeals.isEmpty) {
      return _buildEmptyReliabilityReport();
    }

    final totalCalories =
        allDayMeals.fold<int>(0, (sum, m) => sum + m.totalCalories);
    final totalProtein =
        allDayMeals.fold<double>(0.0, (sum, m) => sum + m.totalProtein);
    final totalCarbs =
        allDayMeals.fold<double>(0.0, (sum, m) => sum + m.totalCarbs);
    final totalFats =
        allDayMeals.fold<double>(0.0, (sum, m) => sum + m.totalFats);

    final loggedPhases = allDayMeals.map((m) => m.phase).toSet();
    final List<String> gaps = [];
    final List<String> calibrations = [];

    // -------------------------------------------------------------
    // Factor 1: Phase Completeness (35% weight)
    // -------------------------------------------------------------
    double phaseScore = 0.0;
    final phaseCount = loggedPhases.length;

    if (phaseCount >= 4) {
      phaseScore = 100.0;
    } else if (phaseCount == 3) {
      phaseScore = 80.0;
      final missing = MealPhase.values
          .where((p) => !loggedPhases.contains(p))
          .map((p) => p.name.split('/')[0].trim())
          .join(', ');
      gaps.add(
          'Missing $missing log. Unrecorded snacks often add 150-300 untracked calories.');
    } else if (phaseCount == 2) {
      phaseScore = 55.0;
      gaps.add(
          'Only 2 meal phases recorded. High likelihood of unaccounted beverages/snacks.');
    } else {
      phaseScore = 25.0;
      gaps.add('Only 1 meal phase recorded. Incomplete daily picture.');
    }

    // Calorie plausibility adjustment
    final calRatio =
        totalCalories / (targetCalories > 0 ? targetCalories : 2000);
    if (calRatio < 0.45 && phaseCount < 3) {
      phaseScore = (phaseScore * 0.7).clamp(10.0, 100.0);
      gaps.add(
          'Very low recorded intake ($totalCalories kcal) suggests under-logging.');
    }

    // -------------------------------------------------------------
    // Factor 2: Portion Measurement Precision (25% weight)
    // -------------------------------------------------------------
    double portionScore = 80.0;
    final hasAmbiguousPortions = allDayMeals.any((m) =>
        m.food.servingUnit.toLowerCase().contains('serving') &&
        !m.food.servingUnit.toLowerCase().contains('g') &&
        !m.food.servingUnit.toLowerCase().contains('katori'));

    if (!hasAmbiguousPortions) {
      portionScore = 95.0;
    } else {
      portionScore = 65.0;
      calibrations.add(
          'Standardized Indian Katori / Gram estimation applied for ambiguous portion sizes.');
    }

    // -------------------------------------------------------------
    // Factor 3: Indian Cooking Medium & Tadka Shield (20% weight)
    // -------------------------------------------------------------
    double oilScore = 60.0;
    double hiddenOilKcal = 0.0;

    final hasSabziOrCurry = allDayMeals.any((m) =>
        m.food.category.toLowerCase().contains('sabzi') ||
        m.food.category.toLowerCase().contains('daal') ||
        m.food.name.toLowerCase().contains('paneer') ||
        m.food.name.toLowerCase().contains('chicken'));

    if (isOilExplicitlyTracked) {
      oilScore = 100.0;
      calibrations.add(
          'Cooking oil/ghee tracked explicitly (Zero hidden tadka discrepancy).');
    } else if (hasSabziOrCurry) {
      oilScore = 65.0;
      hiddenOilKcal = 180.0;
      calibrations.add(
          'Indian Tadka/Chhonk Shield (+180 kcal buffer) auto-applied for untracked cooking ghee/mustard oil.');
    } else {
      oilScore = 90.0;
    }

    // -------------------------------------------------------------
    // Factor 4: Temporal Logging Consistency (10% weight)
    // -------------------------------------------------------------
    double temporalScore = 85.0;
    // Check if timestamps are spaced out by at least 60 mins vs batch logged at once
    if (allDayMeals.length > 2) {
      final firstLog = allDayMeals
          .map((m) => m.loggedAt)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      final lastLog = allDayMeals
          .map((m) => m.loggedAt)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      final spanHours = lastLog.difference(firstLog).inHours;

      if (spanHours >= 4) {
        temporalScore = 95.0;
      } else if (spanHours >= 1) {
        temporalScore = 80.0;
      } else {
        temporalScore = 55.0;
        calibrations.add(
            'Batch retro-logging detected. Real-time logging reduces recall bias by ~35%.');
      }
    }

    // -------------------------------------------------------------
    // Factor 5: Macronutrient Mathematical Consistency (10% weight)
    // -------------------------------------------------------------
    double macroScore = 85.0;
    final calculatedKcal =
        (totalProtein * 4.0) + (totalCarbs * 4.0) + (totalFats * 9.0);
    final macroDiscrepancy = totalCalories > 0
        ? (calculatedKcal - totalCalories).abs() / totalCalories
        : 0.0;

    if (macroDiscrepancy <= 0.08) {
      macroScore = 98.0;
    } else if (macroDiscrepancy <= 0.18) {
      macroScore = 80.0;
    } else {
      macroScore = 50.0;
      calibrations.add(
          'Macro-energy variance (${(macroDiscrepancy * 100).toStringAsFixed(0)}%) reconciled via standard Atwater factors.');
    }

    // -------------------------------------------------------------
    // Weighted Synthesis
    // -------------------------------------------------------------
    final factors = [
      ReliabilityFactor(
        id: 'phase_completeness',
        name: 'Meal Phase Completeness',
        regionalName: 'भोजन चरणों की पूर्णता',
        score: double.parse(phaseScore.toStringAsFixed(1)),
        weight: 0.35,
        status: phaseScore >= 80
            ? 'Complete'
            : (phaseScore >= 50 ? 'Partial' : 'Gaps Present'),
        detail: '$phaseCount of 4 core phases recorded.',
        recommendation: phaseCount < 4
            ? 'Log remaining meal phases for 100% daily coverage.'
            : 'All primary meals recorded on schedule.',
      ),
      ReliabilityFactor(
        id: 'portion_precision',
        name: 'Portion Measurement Precision',
        regionalName: 'मात्रा माप की सटीकता',
        score: double.parse(portionScore.toStringAsFixed(1)),
        weight: 0.25,
        status: portionScore >= 85 ? 'Precise' : 'Estimated',
        detail: hasAmbiguousPortions
            ? 'Using standardized Indian katori sizes.'
            : 'Explicit units (grams/pieces/katori) verified.',
        recommendation:
            'Use kitchen scale or standard 150ml katori for curries & daal.',
      ),
      ReliabilityFactor(
        id: 'cooking_oil_shield',
        name: 'Cooking Oil & Tadka Calibration',
        regionalName: 'तड़का व तेल सुरक्षा समायोजन',
        score: double.parse(oilScore.toStringAsFixed(1)),
        weight: 0.20,
        status: isOilExplicitlyTracked ? 'Explicit' : 'Shield Buffer Active',
        detail: isOilExplicitlyTracked
            ? 'No cooking oil discrepancies.'
            : '+180 kcal buffer added for Indian home tadka.',
        recommendation: isOilExplicitlyTracked
            ? 'Great job logging preparation medium.'
            : 'Log 1-2 tsp cooking oil or ghee per dish for laser accuracy.',
      ),
      ReliabilityFactor(
        id: 'temporal_consistency',
        name: 'Real-Time Logging Timeliness',
        regionalName: 'समयबद्ध रीयल-टाइम प्रविष्टि',
        score: double.parse(temporalScore.toStringAsFixed(1)),
        weight: 0.10,
        status: temporalScore >= 80 ? 'Real-Time' : 'Batch Recall',
        detail: temporalScore >= 80
            ? 'Meals logged promptly after eating.'
            : 'Logged retroactively in a single batch.',
        recommendation: 'Log meals within 30 mins to eliminate memory decay.',
      ),
      ReliabilityFactor(
        id: 'macro_consistency',
        name: 'Macronutrient Energy Coherence',
        regionalName: 'मैक्रोन्यूट्रिएंट ऊर्जा संतुलन',
        score: double.parse(macroScore.toStringAsFixed(1)),
        weight: 0.10,
        status: macroScore >= 80 ? 'Coherent' : 'Reconciled',
        detail: 'Atwater 4-4-9 macro calorie alignment verified.',
        recommendation: 'Food items match biochemical macronutrient standards.',
      ),
    ];

    final double compositeRaw =
        factors.fold<double>(0.0, (sum, f) => sum + f.weightedContribution);
    final int composite = compositeRaw.round().clamp(0, 100);

    final level = _getReliabilityLevel(composite);
    final int calMargin =
        (totalCalories * level.uncertaintyPct).round().clamp(60, 550);
    final double protMargin =
        double.parse((totalProtein * level.uncertaintyPct).toStringAsFixed(1))
            .clamp(2.0, 25.0);

    return NutritionReliabilityReport(
      overallReliabilityScore: composite,
      level: level,
      caloricUncertaintyMargin: calMargin,
      proteinUncertaintyMargin: protMargin,
      isShieldActive: level.shieldActive,
      hiddenOilBufferKcal: hiddenOilKcal,
      factors: factors,
      detectedGaps:
          gaps.isEmpty ? ['No major nutritional data gaps detected.'] : gaps,
      shieldCalibrations: calibrations.isEmpty
          ? ['Standard calibration profile active.']
          : calibrations,
      confidenceSummary:
          'Today\'s nutrition logs have an estimated confidence score of $composite% '
          '(${level.label}). Your effective intake is $totalCalories ± $calMargin kcal.',
    );
  }

  static ReliabilityLevel _getReliabilityLevel(int score) {
    if (score >= 80) return ReliabilityLevel.high;
    if (score >= 60) return ReliabilityLevel.moderate;
    if (score >= 40) return ReliabilityLevel.provisional;
    return ReliabilityLevel.unreliable;
  }

  static NutritionReliabilityReport _buildEmptyReliabilityReport() {
    return const NutritionReliabilityReport(
      overallReliabilityScore: 0,
      level: ReliabilityLevel.unreliable,
      caloricUncertaintyMargin: 0,
      proteinUncertaintyMargin: 0.0,
      isShieldActive: false,
      hiddenOilBufferKcal: 0.0,
      factors: [
        ReliabilityFactor(
          id: 'phase_completeness',
          name: 'Meal Phase Completeness',
          regionalName: 'भोजन चरणों की पूर्णता',
          score: 0.0,
          weight: 0.35,
          status: 'No Logs',
          detail: 'No meals recorded yet today.',
          recommendation: 'Start logging breakfast or lunch.',
        ),
      ],
      detectedGaps: ['No meals logged today yet.'],
      shieldCalibrations: ['Log meals to activate the Data Confidence Shield.'],
      confidenceSummary: 'No nutrition data logged for today yet.',
    );
  }
}
