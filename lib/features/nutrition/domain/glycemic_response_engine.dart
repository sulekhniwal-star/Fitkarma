import 'nutrition_models.dart';

enum GlycemicRiskTier {
  low(label: 'Low Impact / Steady Energy', colorCode: 0xff22C55E, maxExcursionMgDl: 25),
  moderate(label: 'Moderate Impact / Mild Rise', colorCode: 0xff3B82F6, maxExcursionMgDl: 45),
  high(label: 'High Spike Risk / Rapid Insulin Surge', colorCode: 0xffEF4444, maxExcursionMgDl: 80);

  final String label;
  final int colorCode;
  final int maxExcursionMgDl;

  const GlycemicRiskTier({
    required this.label,
    required this.colorCode,
    required this.maxExcursionMgDl,
  });
}

class GlycemicEvaluationReport {
  final double rawGlycemicLoad;
  final double bufferedGlycemicLoad;
  final GlycemicRiskTier riskTier;
  final double personalFoodScore; // 1.0 to 10.0
  final int predictedGlucoseRiseMgDl;
  final List<String> bufferingInterventions;
  final String sequencingPrescription;

  const GlycemicEvaluationReport({
    required this.rawGlycemicLoad,
    required this.bufferedGlycemicLoad,
    required this.riskTier,
    required this.personalFoodScore,
    required this.predictedGlucoseRiseMgDl,
    required this.bufferingInterventions,
    required this.sequencingPrescription,
  });
}

class GlycemicResponseEngine {
  /// Pure Dart deterministic calculation of Glycemic Load, glucose excursion, and Personal Food Score
  static GlycemicEvaluationReport evaluateMealGlycemicResponse({
    required List<LoggedMealEntry> entries,
    bool isSaladEatenFirst = false,
    bool isPostMealWalkPlanned = false,
  }) {
    if (entries.isEmpty) {
      return const GlycemicEvaluationReport(
        rawGlycemicLoad: 0.0,
        bufferedGlycemicLoad: 0.0,
        riskTier: GlycemicRiskTier.low,
        personalFoodScore: 8.0,
        predictedGlucoseRiseMgDl: 10,
        bufferingInterventions: ['Log meals to simulate glucose excursion curves.'],
        sequencingPrescription: 'Sequence meals: Fiber first, Protein second, Carbs last.',
      );
    }

    final totalCarbs = entries.fold<double>(0.0, (sum, e) => sum + e.totalCarbs);
    final totalProtein = entries.fold<double>(0.0, (sum, e) => sum + e.totalProtein);
    final totalFats = entries.fold<double>(0.0, (sum, e) => sum + e.totalFats);
    final totalFiber = entries.fold<double>(0.0, (sum, e) => sum + e.totalFiber);

    // Assume average Indian mixed meal GI is ~65 (Rotis, Rice, Lentils)
    const double baseGi = 65.0;
    final double rawGl = (baseGi * totalCarbs) / 100.0;

    // Buffer factors
    double bufferMultiplier = 1.0;
    final List<String> appliedBuffers = [];

    if (totalFiber >= 6.0) {
      bufferMultiplier *= 0.85;
      appliedBuffers.add('High Fiber Buffer: ${totalFiber.toStringAsFixed(1)}g fiber slows enzymatic carbohydrate breakdown (-15% GL).');
    }
    if (totalProtein >= 25.0 || totalFats >= 15.0) {
      bufferMultiplier *= 0.80;
      appliedBuffers.add('Protein & Lipid Co-ingestion: Delays gastric emptying into the duodenum (-20% peak glucose).');
    }
    if (isSaladEatenFirst) {
      bufferMultiplier *= 0.70;
      appliedBuffers.add('Meal Sequencing Applied: Raw fiber lining the small intestine reduces postprandial spike amplitude (-30%).');
    }
    if (isPostMealWalkPlanned) {
      bufferMultiplier *= 0.75;
      appliedBuffers.add('Shatpawali Walk (+1,000 steps): Active muscle GLUT4 translocation clears glucose independent of insulin (-25%).');
    }

    final double bufferedGl = double.parse((rawGl * bufferMultiplier).toStringAsFixed(1));

    // Risk tier assignment
    final GlycemicRiskTier tier;
    if (bufferedGl <= 12.0) {
      tier = GlycemicRiskTier.low;
    } else if (bufferedGl <= 20.0) {
      tier = GlycemicRiskTier.moderate;
    } else {
      tier = GlycemicRiskTier.high;
    }

    // Predicted glucose excursion rise in mg/dL
    final int predictedRise = (bufferedGl * 2.8).round().clamp(10, 95);

    // Personal Food Score: 1.0 (worst) to 10.0 (optimal)
    final double rawScore = 10.0 - (bufferedGl * 0.35);
    final double personalScore = double.parse(rawScore.clamp(2.0, 10.0).toStringAsFixed(1));

    return GlycemicEvaluationReport(
      rawGlycemicLoad: double.parse(rawGl.toStringAsFixed(1)),
      bufferedGlycemicLoad: bufferedGl,
      riskTier: tier,
      personalFoodScore: personalScore,
      predictedGlucoseRiseMgDl: predictedRise,
      bufferingInterventions: appliedBuffers.isEmpty
          ? ['Add raw cucumber/salad or take a 15-minute Shatpawali walk to blunt this meal\'s glycemic rise.']
          : appliedBuffers,
      sequencingPrescription: 'Optimal Indian Meal Sequencing: Eat Cucumbers/Kakdi Salad first ➔ Paneer/Daal/Eggs second ➔ Rotis/Rice last.',
    );
  }
}
