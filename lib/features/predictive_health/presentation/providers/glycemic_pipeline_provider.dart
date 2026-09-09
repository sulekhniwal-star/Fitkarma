import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/glycemic_pipeline_engine.dart';
import '../../domain/glycemic_pipeline_models.dart';

final glycemicPipelineProvider =
    StateNotifierProvider<GlycemicPipelineNotifier, RetrospectiveGlycemicReport>((ref) {
  return GlycemicPipelineNotifier();
});

class GlycemicPipelineNotifier extends StateNotifier<RetrospectiveGlycemicReport> {
  GlycemicPipelineNotifier() : super(_buildInitialReport());

  static final GlycemicPipelineEngine _engine = const GlycemicPipelineEngine();

  static RetrospectiveGlycemicReport _buildInitialReport() {
    final now = DateTime.now();

    // 14 days of realistic retrospective glucose telemetry (every 2 hours)
    final samples = <HistoricalGlucoseSample>[];
    for (int day = 13; day >= 0; day--) {
      final date = now.subtract(Duration(days: day));

      // Fasting dawn
      samples.add(HistoricalGlucoseSample(
        timestamp: DateTime(date.year, date.month, date.day, 6, 0),
        glucoseValueMgDl: 86.0 + (day % 4) * 2.0,
        associatedMealOrEvent: 'Fasting Baseline',
      ));
      // Post-Breakfast
      samples.add(HistoricalGlucoseSample(
        timestamp: DateTime(date.year, date.month, date.day, 9, 30),
        glucoseValueMgDl: 112.0 + (day % 3) * 4.0,
        associatedMealOrEvent: 'Oats & Almond Milk',
      ));
      // Post-Lunch
      samples.add(HistoricalGlucoseSample(
        timestamp: DateTime(date.year, date.month, date.day, 13, 45),
        glucoseValueMgDl: 122.0 + (day % 5) * 3.0,
        associatedMealOrEvent: 'Quinoa Khichdi & Salad',
      ));
      // Afternoon
      samples.add(HistoricalGlucoseSample(
        timestamp: DateTime(date.year, date.month, date.day, 17, 0),
        glucoseValueMgDl: 92.0 + (day % 2) * 3.0,
        associatedMealOrEvent: 'Green Tea & Walnuts',
      ));
      // Post-Dinner
      samples.add(HistoricalGlucoseSample(
        timestamp: DateTime(date.year, date.month, date.day, 20, 30),
        glucoseValueMgDl: 118.0 + (day % 4) * 3.5,
        associatedMealOrEvent: 'Steamed Moong & Veg Soup',
      ));
      // Nocturnal
      samples.add(HistoricalGlucoseSample(
        timestamp: DateTime(date.year, date.month, date.day, 2, 0),
        glucoseValueMgDl: 82.0 + (day % 3) * 2.0,
        associatedMealOrEvent: 'Deep Sleep Basal',
      ));
    }

    final recentExcursions = [
      PostprandialExcursion(
        mealName: 'Quinoa Khichdi & Ghee',
        mealTime: now.subtract(const Duration(hours: 22)),
        baselineGlucose: 88.0,
        peakGlucose: 124.0,
        deltaGlucose: 36.0,
        recoveryHours: 1.5,
        isSpikeExcursion: true,
      ),
      PostprandialExcursion(
        mealName: 'Spiced Moong Dal & Spinach',
        mealTime: now.subtract(const Duration(hours: 15)),
        baselineGlucose: 85.0,
        peakGlucose: 110.0,
        deltaGlucose: 25.0,
        recoveryHours: 1.1,
        isSpikeExcursion: false,
      ),
      PostprandialExcursion(
        mealName: 'Ragi Idli & Sambar',
        mealTime: now.subtract(const Duration(hours: 4)),
        baselineGlucose: 87.0,
        peakGlucose: 116.0,
        deltaGlucose: 29.0,
        recoveryHours: 1.2,
        isSpikeExcursion: false,
      ),
    ];

    return _engine.processRetrospectiveGlucoseTelemetry(
      samples: samples,
      mealExcursions: recentExcursions,
      executionTime: now,
    );
  }

  void recalculateWithCustomDataset(List<HistoricalGlucoseSample> customSamples, List<PostprandialExcursion> excursions) {
    state = _engine.processRetrospectiveGlucoseTelemetry(
      samples: customSamples,
      mealExcursions: excursions,
      executionTime: DateTime.now(),
    );
  }
}
