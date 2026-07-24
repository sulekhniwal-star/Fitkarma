/// §P7-F Demographic Cohort Insights — Service Layer
///
/// Integrates rolling user health metrics with anonymized cohort pipeline.
library;

import 'package:fitkarma/features/karma/cohort_aggregation_pipeline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CohortInsightsService {
  final CohortAggregationPipeline _pipeline = const CohortAggregationPipeline();

  /// Fetches anonymized cohort insights for user demographic profile.
  CohortInsights getInsights({
    required String ageGroup,
    required String gender,
    required String region,
    required String dietType,
    required String primaryGoal,
    required int sampleCohortSize,
    required double avgSteps,
    required double avgProtein,
    required double avgReadiness,
  }) {
    final payload = AnonymizedCohortPayload(
      ageGroup: ageGroup,
      gender: gender,
      region: region,
      dietType: dietType,
      primaryGoal: primaryGoal,
    );

    return _pipeline.aggregate(
      payload: payload,
      sampleCohortSize: sampleCohortSize,
      userAvgSteps: avgSteps,
      userAvgProtein: avgProtein,
      userAvgReadiness: avgReadiness,
    );
  }
}

final cohortInsightsServiceProvider = Provider<CohortInsightsService>((_) {
  return CohortInsightsService();
});
