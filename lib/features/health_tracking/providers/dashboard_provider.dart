import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../environmental_health/domain/environmental_health_engine.dart';

class DashboardSummaryState {
  final int karmaPoints;
  final int streakDays;
  final int stepsCurrent;
  final int stepsTarget;
  final double sleepHours;
  final int sleepScore;
  final double hydrationCurrentLiters;
  final double hydrationTargetLiters;
  final double currentStrain;
  final double targetStrainMax;
  final int caloriesConsumed;
  final int caloriesTarget;
  final int proteinConsumedGrams;
  final int proteinTargetGrams;
  final EnvironmentalHealthSnapshot? environmentalSnapshot;

  const DashboardSummaryState({
    this.karmaPoints = 420,
    this.streakDays = 7,
    this.stepsCurrent = 8240,
    this.stepsTarget = 10000,
    this.sleepHours = 7.5,
    this.sleepScore = 84,
    this.hydrationCurrentLiters = 2.25,
    this.hydrationTargetLiters = 3.0,
    this.currentStrain = 13.4,
    this.targetStrainMax = 16.0,
    this.caloriesConsumed = 1650,
    this.caloriesTarget = 2100,
    this.proteinConsumedGrams = 115,
    this.proteinTargetGrams = 135,
    this.environmentalSnapshot,
  });

  DashboardSummaryState copyWith({
    int? karmaPoints,
    int? streakDays,
    int? stepsCurrent,
    int? stepsTarget,
    double? sleepHours,
    int? sleepScore,
    double? hydrationCurrentLiters,
    double? hydrationTargetLiters,
    double? currentStrain,
    double? targetStrainMax,
    int? caloriesConsumed,
    int? caloriesTarget,
    int? proteinConsumedGrams,
    int? proteinTargetGrams,
    EnvironmentalHealthSnapshot? environmentalSnapshot,
  }) {
    return DashboardSummaryState(
      karmaPoints: karmaPoints ?? this.karmaPoints,
      streakDays: streakDays ?? this.streakDays,
      stepsCurrent: stepsCurrent ?? this.stepsCurrent,
      stepsTarget: stepsTarget ?? this.stepsTarget,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepScore: sleepScore ?? this.sleepScore,
      hydrationCurrentLiters: hydrationCurrentLiters ?? this.hydrationCurrentLiters,
      hydrationTargetLiters: hydrationTargetLiters ?? this.hydrationTargetLiters,
      currentStrain: currentStrain ?? this.currentStrain,
      targetStrainMax: targetStrainMax ?? this.targetStrainMax,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      proteinConsumedGrams: proteinConsumedGrams ?? this.proteinConsumedGrams,
      proteinTargetGrams: proteinTargetGrams ?? this.proteinTargetGrams,
      environmentalSnapshot: environmentalSnapshot ?? this.environmentalSnapshot,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardSummaryState> {
  DashboardNotifier() : super(const DashboardSummaryState());

  void addWater(double liters) {
    final updated = state.hydrationCurrentLiters + liters;
    state = state.copyWith(hydrationCurrentLiters: double.parse(updated.toStringAsFixed(2)));
  }

  void addSteps(int count) {
    state = state.copyWith(stepsCurrent: state.stepsCurrent + count);
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardSummaryState>((ref) {
  return DashboardNotifier();
});
