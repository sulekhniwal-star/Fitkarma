import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/transformation_engine.dart';
import '../../domain/transformation_models.dart';

final transformationProvider =
    StateNotifierProvider<TransformationNotifier, TransformationJourneyReport>((ref) {
  return TransformationNotifier();
});

class TransformationNotifier extends StateNotifier<TransformationJourneyReport> {
  TransformationNotifier() : super(_buildInitialReport());

  static TransformationJourneyReport _buildInitialReport() {
    final baselineDate = DateTime.now().subtract(const Duration(days: 48));
    final currentDate = DateTime.now();

    final baselineSnapshot = TransformationSnapshot(
      id: 'snap_baseline',
      recordedAt: baselineDate,
      journeyDayNumber: 1,
      bodyweightKg: 78.5,
      waistCircumferenceCm: 91.0,
      heightCm: 174.0,
      restingHeartRateBpm: 76.0,
      systolicBp: 132,
      diastolicBp: 86,
      estimatedHbA1c: 5.8,
      vo2MaxEstimate: 36.5,
      averageDailySteps: 5400,
      weeklyStrengthVolumeKg: 8500.0,
      proteinGramsPerKg: 0.75,
      doshaEquilibriumScore: 62.0,
      cumulativeKarmaPoints: 120,
    );

    final currentSnapshot = TransformationSnapshot(
      id: 'snap_current',
      recordedAt: currentDate,
      journeyDayNumber: 49,
      bodyweightKg: 72.8,
      waistCircumferenceCm: 81.5,
      heightCm: 174.0,
      restingHeartRateBpm: 61.0,
      systolicBp: 120,
      diastolicBp: 78,
      estimatedHbA1c: 5.4,
      vo2MaxEstimate: 44.2,
      averageDailySteps: 10600,
      weeklyStrengthVolumeKg: 16400.0,
      proteinGramsPerKg: 1.40,
      doshaEquilibriumScore: 86.0,
      cumulativeKarmaPoints: 3450,
    );

    return TransformationJourneyEngine.compileReport(
      baseline: baselineSnapshot,
      current: currentSnapshot,
    );
  }

  void addSnapshot(TransformationSnapshot snapshot) {
    state = TransformationJourneyEngine.compileReport(
      baseline: state.baselineSnapshot,
      current: snapshot,
    );
  }
}
