import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/preventive_intelligence_engine.dart';

class HealthTrackingState {
  final int steps;
  final double sleepHours;
  final double systolicBp;
  final double diastolicBp;
  final double glucoseMgDl;
  final List<HealthRiskAlert> activeAlerts;

  const HealthTrackingState({
    this.steps = 8420,
    this.sleepHours = 7.5,
    this.systolicBp = 120.0,
    this.diastolicBp = 80.0,
    this.glucoseMgDl = 95.0,
    this.activeAlerts = const [],
  });

  HealthTrackingState copyWith({
    int? steps,
    double? sleepHours,
    double? systolicBp,
    double? diastolicBp,
    double? glucoseMgDl,
    List<HealthRiskAlert>? activeAlerts,
  }) {
    return HealthTrackingState(
      steps: steps ?? this.steps,
      sleepHours: sleepHours ?? this.sleepHours,
      systolicBp: systolicBp ?? this.systolicBp,
      diastolicBp: diastolicBp ?? this.diastolicBp,
      glucoseMgDl: glucoseMgDl ?? this.glucoseMgDl,
      activeAlerts: activeAlerts ?? this.activeAlerts,
    );
  }
}

class HealthTrackingNotifier extends StateNotifier<HealthTrackingState> {
  final PreventiveIntelligenceEngine _engine;

  HealthTrackingNotifier(this._engine) : super(const HealthTrackingState()) {
    _evaluateAlerts();
  }

  void logBloodPressure(double systolic, double diastolic) {
    state = state.copyWith(systolicBp: systolic, diastolicBp: diastolic);
    _evaluateAlerts();
  }

  void logGlucose(double glucose) {
    state = state.copyWith(glucoseMgDl: glucose);
    _evaluateAlerts();
  }

  void updateSteps(int steps) {
    state = state.copyWith(steps: steps);
    _evaluateAlerts();
  }

  void _evaluateAlerts() {
    final alerts = _engine.evaluateRiskPatterns(
      systolicBp: state.systolicBp,
      diastolicBp: state.diastolicBp,
      fastingGlucoseMgDl: state.glucoseMgDl,
      postprandialGlucoseMgDl: state.glucoseMgDl,
      hrvDropRatio: 0.10,
      cumulativeSleepDeficitHours: 2.0,
      consecutiveSedentaryDays: 1,
      rhrSpikeBpm: 3,
    );

    state = state.copyWith(activeAlerts: alerts);
  }
}

final healthTrackingProvider =
    StateNotifierProvider<HealthTrackingNotifier, HealthTrackingState>((ref) {
  return HealthTrackingNotifier(const PreventiveIntelligenceEngine());
});
