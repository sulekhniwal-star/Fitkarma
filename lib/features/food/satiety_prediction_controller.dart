/// §P5-P Satiety Prediction Controller
///
/// Riverpod Notifier evaluating satiety scores for logged items in `foodProvider`
/// and offering high-satiety meal swap recommendations.
library;

import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/satiety_prediction_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class SatietyPredictionState {
  const SatietyPredictionState({
    this.evaluations = const [],
    this.averageDailySatietyScore = 0.0,
    this.highSatietySwapRecommendations = const [],
  });

  final List<SatietyEvaluation> evaluations;
  final double averageDailySatietyScore;
  final List<String> highSatietySwapRecommendations;
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final satietyPredictionEngineProvider = Provider<SatietyPredictionEngine>((
  ref,
) {
  return const SatietyPredictionEngine();
});

class SatietyNotifier extends Notifier<SatietyPredictionState> {
  @override
  SatietyPredictionState build() {
    final engine = ref.watch(satietyPredictionEngineProvider);
    final foodState = ref.watch(foodProvider);

    final evaluations = <SatietyEvaluation>[];
    final swaps = <String>[];
    double totalScore = 0.0;

    for (final item in foodState.loggedItems) {
      final eval = engine.computeSatietyScore(
        foodName: item.name,
        calories: item.calories.toDouble(),
        proteinG: item.protein.toDouble(),
        fiberG: _estimateFiber(item.name),
        weightG: _estimateWeight(item.calories.toDouble()),
        processingTier: _estimateProcessingTier(item.name),
      );

      evaluations.add(eval);
      totalScore += eval.score;

      if (eval.recommendedHighSatietySwap != null) {
        swaps.add('${item.name}: ${eval.recommendedHighSatietySwap}');
      }
    }

    final avgScore = evaluations.isNotEmpty
        ? double.parse((totalScore / evaluations.length).toStringAsFixed(1))
        : 0.0;

    return SatietyPredictionState(
      evaluations: evaluations,
      averageDailySatietyScore: avgScore,
      highSatietySwapRecommendations: swaps,
    );
  }

  double _estimateFiber(String name) {
    final lc = name.toLowerCase();
    if (lc.contains('rajma') || lc.contains('chana') || lc.contains('dal'))
      return 10.0;
    if (lc.contains('roti') || lc.contains('oats') || lc.contains('salad'))
      return 4.0;
    return 1.0;
  }

  double _estimateWeight(double calories) {
    if (calories <= 0) return 100.0;
    // Average 1.2g per kcal for normal mixed meal
    return calories * 1.2;
  }

  int _estimateProcessingTier(String name) {
    final lc = name.toLowerCase();
    if (lc.contains('pizza') ||
        lc.contains('burger') ||
        lc.contains('chips') ||
        lc.contains('biscuits')) {
      return 3;
    }
    return 0;
  }
}

final satietyPredictionProvider =
    NotifierProvider<SatietyNotifier, SatietyPredictionState>(
      SatietyNotifier.new,
    );
