import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/transformation_engine.dart';
import '../models/transformation_memory.dart';

class TransformationState {
  final double currentWeightKg;
  final WeightForecastRange forecast90Days;
  final RelapseInterventionResult relapseIntervention;
  final List<TransformationMemory> monthlySnapshots;
  final List<ProgressPhotoEntry> photoVault;

  const TransformationState({
    this.currentWeightKg = 75.0,
    required this.forecast90Days,
    required this.relapseIntervention,
    this.monthlySnapshots = const [
      TransformationMemory(
          monthYear: 'May 2026',
          weightKg: 78.5,
          bodyFatPercentage: 22.0,
          averageReadinessScore: 78),
      TransformationMemory(
          monthYear: 'Jun 2026',
          weightKg: 76.8,
          bodyFatPercentage: 20.5,
          averageReadinessScore: 82),
      TransformationMemory(
          monthYear: 'Jul 2026',
          weightKg: 75.0,
          bodyFatPercentage: 19.2,
          averageReadinessScore: 85),
    ],
    this.photoVault = const [],
  });

  TransformationState copyWith({
    double? currentWeightKg,
    WeightForecastRange? forecast90Days,
    RelapseInterventionResult? relapseIntervention,
    List<TransformationMemory>? monthlySnapshots,
    List<ProgressPhotoEntry>? photoVault,
  }) {
    return TransformationState(
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      forecast90Days: forecast90Days ?? this.forecast90Days,
      relapseIntervention: relapseIntervention ?? this.relapseIntervention,
      monthlySnapshots: monthlySnapshots ?? this.monthlySnapshots,
      photoVault: photoVault ?? this.photoVault,
    );
  }
}

class TransformationNotifier extends StateNotifier<TransformationState> {
  final TransformationEngine _engine;

  TransformationNotifier(this._engine)
      : super(
          TransformationState(
            forecast90Days: const TransformationEngine().calculate90DayForecast(
              currentWeightKg: 75.0,
              dailyCalorieDeficit: 400.0,
            ),
            relapseIntervention:
                const TransformationEngine().evaluateRelapseTier(0),
          ),
        );

  void simulateMissedDays(int missedDays) {
    final intervention = _engine.evaluateRelapseTier(missedDays);
    state = state.copyWith(relapseIntervention: intervention);
  }
}

final transformationProvider =
    StateNotifierProvider<TransformationNotifier, TransformationState>((ref) {
  return TransformationNotifier(const TransformationEngine());
});
