import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/ai_roast_engine.dart';

class AiRoastState {
  final CoachTone selectedTone;
  final bool isRoastEnabled;
  final bool isCrisisSafetyDisabled;
  final RoastNudge activeNudge;

  const AiRoastState({
    required this.selectedTone,
    required this.isRoastEnabled,
    required this.isCrisisSafetyDisabled,
    required this.activeNudge,
  });

  factory AiRoastState.initial() {
    const engine = AiRoastEngine();
    final nudge = engine.generateNudge(
      tone: CoachTone.roast,
      caloriesConsumed: 2600,
      calorieTarget: 2000,
      loggedMealsCount: 3,
      daysUnlogged: 0,
      isDistressOrHighStressDetected: false,
    );

    return AiRoastState(
      selectedTone: CoachTone.roast,
      isRoastEnabled: true,
      isCrisisSafetyDisabled: false,
      activeNudge: nudge,
    );
  }

  AiRoastState copyWith({
    CoachTone? selectedTone,
    bool? isRoastEnabled,
    bool? isCrisisSafetyDisabled,
    RoastNudge? activeNudge,
  }) {
    return AiRoastState(
      selectedTone: selectedTone ?? this.selectedTone,
      isRoastEnabled: isRoastEnabled ?? this.isRoastEnabled,
      isCrisisSafetyDisabled: isCrisisSafetyDisabled ?? this.isCrisisSafetyDisabled,
      activeNudge: activeNudge ?? this.activeNudge,
    );
  }
}

class AiRoastNotifier extends StateNotifier<AiRoastState> {
  AiRoastNotifier() : super(AiRoastState.initial());

  void setCoachTone(CoachTone tone) {
    const engine = AiRoastEngine();
    final nudge = engine.generateNudge(
      tone: tone,
      caloriesConsumed: 2600,
      calorieTarget: 2000,
      loggedMealsCount: 3,
      daysUnlogged: 0,
      isDistressOrHighStressDetected: state.isCrisisSafetyDisabled,
    );

    state = state.copyWith(
      selectedTone: tone,
      isRoastEnabled: tone == CoachTone.roast,
      activeNudge: nudge,
    );
  }

  void triggerHighStressSafetyProtocol(bool isHighStress) {
    const engine = AiRoastEngine();
    final nudge = engine.generateNudge(
      tone: state.selectedTone,
      caloriesConsumed: 2600,
      calorieTarget: 2000,
      loggedMealsCount: 3,
      daysUnlogged: 0,
      isDistressOrHighStressDetected: isHighStress,
    );

    state = state.copyWith(
      isCrisisSafetyDisabled: isHighStress,
      activeNudge: nudge,
    );
  }
}

final aiRoastProvider = StateNotifierProvider<AiRoastNotifier, AiRoastState>((ref) {
  return AiRoastNotifier();
});
