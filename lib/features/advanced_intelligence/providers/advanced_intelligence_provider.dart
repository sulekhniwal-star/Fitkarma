import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/adaptive_metabolism_engine.dart';
import '../../../core/brain/environmental_health_engine.dart';
import '../../../core/brain/womens_health_engine.dart';

class AdvancedIntelligenceState {
  final AdaptiveMetabolismResult tdeeResult;
  final LongevityScoreResult longevityResult;
  final EnvironmentalHealthResult envResult;
  final WomensHealthPrescription womensPrescription;

  const AdvancedIntelligenceState({
    required this.tdeeResult,
    required this.longevityResult,
    required this.envResult,
    required this.womensPrescription,
  });

  AdvancedIntelligenceState copyWith({
    AdaptiveMetabolismResult? tdeeResult,
    LongevityScoreResult? longevityResult,
    EnvironmentalHealthResult? envResult,
    WomensHealthPrescription? womensPrescription,
  }) {
    return AdvancedIntelligenceState(
      tdeeResult: tdeeResult ?? this.tdeeResult,
      longevityResult: longevityResult ?? this.longevityResult,
      envResult: envResult ?? this.envResult,
      womensPrescription: womensPrescription ?? this.womensPrescription,
    );
  }
}

class AdvancedIntelligenceNotifier extends StateNotifier<AdvancedIntelligenceState> {
  final AdaptiveMetabolismEngine metabolismEngine;
  final EnvironmentalHealthEngine envEngine;
  final WomensHealthEngine womensEngine;

  AdvancedIntelligenceNotifier({
    required this.metabolismEngine,
    required this.envEngine,
    required this.womensEngine,
  }) : super(
          AdvancedIntelligenceState(
            tdeeResult: metabolismEngine.calculateDynamicTdee(
              baseTdee: 2200.0,
              averageCaloricIntake: 2100.0,
              weightDelta7DaysKg: -0.3,
            ),
            longevityResult: metabolismEngine.calculateLongevityScore(
              readinessScore: 85,
              sleepScore: 82,
              vo2MaxEstimate: 45.0,
              aqi: 120,
            ),
            envResult: envEngine.evaluateEnvironmentalSafety(
              aqi: 165, // Triggers indoor shift
              uvIndex: 9.0,
              humidityPercent: 75.0,
            ),
            womensPrescription: womensEngine.calculatePrescription(
              phase: MenstrualPhase.follicular,
            ),
          ),
        );

  void updateCyclePhase(MenstrualPhase phase) {
    final rx = womensEngine.calculatePrescription(phase: phase);
    state = state.copyWith(womensPrescription: rx);
  }
}

final advancedIntelligenceProvider =
    StateNotifierProvider<AdvancedIntelligenceNotifier, AdvancedIntelligenceState>((ref) {
  return AdvancedIntelligenceNotifier(
    metabolismEngine: const AdaptiveMetabolismEngine(),
    envEngine: const EnvironmentalHealthEngine(),
    womensEngine: const WomensHealthEngine(),
  );
});
