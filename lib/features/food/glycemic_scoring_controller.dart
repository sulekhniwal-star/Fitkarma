/// §P5-M Glycemic Response & Personal Food Scoring Controller
///
/// Riverpod Notifier combining logged foods from `foodProvider` with `glucoseProvider` readings
/// via §P10-L Retrospective Glycemic Processing Pipeline.
library;

import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/glycemic_scoring_engine.dart';
import 'package:fitkarma/features/glucose/glucose_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class GlycemicScoringState {
  const GlycemicScoringState({
    this.evaluations = const [],
    this.averageGlycemicScore = 10.0,
    this.highSpikeCount = 0,
  });

  final List<FoodGlycemicEvaluation> evaluations;
  final double averageGlycemicScore;
  final int highSpikeCount;

  GlycemicScoringState copyWith({
    List<FoodGlycemicEvaluation>? evaluations,
    double? averageGlycemicScore,
    int? highSpikeCount,
  }) {
    return GlycemicScoringState(
      evaluations: evaluations ?? this.evaluations,
      averageGlycemicScore: averageGlycemicScore ?? this.averageGlycemicScore,
      highSpikeCount: highSpikeCount ?? this.highSpikeCount,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final retrospectivePipelineProvider = Provider<RetrospectiveGlycemicPipeline>((
  ref,
) {
  return const RetrospectiveGlycemicPipeline();
});

class GlycemicScoringNotifier extends Notifier<GlycemicScoringState> {
  @override
  GlycemicScoringState build() {
    final foodState = ref.watch(foodProvider);
    final glucoseState = ref.watch(glucoseProvider);
    final pipeline = ref.watch(retrospectivePipelineProvider);

    final evaluations = pipeline.processMealHistory(
      loggedMeals: foodState.loggedItems,
      glucoseReadings: glucoseState.history,
      defaultBaseline: glucoseState.fastingGlucose > 0
          ? glucoseState.fastingGlucose
          : 95.0,
    );

    double totalScore = 0.0;
    int highSpikes = 0;

    for (final eval in evaluations) {
      totalScore += eval.score;
      if (eval.score <= 5.0) {
        highSpikes++;
      }
    }

    final avgScore = evaluations.isNotEmpty
        ? double.parse((totalScore / evaluations.length).toStringAsFixed(1))
        : 10.0;

    return GlycemicScoringState(
      evaluations: evaluations,
      averageGlycemicScore: avgScore,
      highSpikeCount: highSpikes,
    );
  }
}

final glycemicScoringProvider =
    NotifierProvider<GlycemicScoringNotifier, GlycemicScoringState>(
      GlycemicScoringNotifier.new,
    );
