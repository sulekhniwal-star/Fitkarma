import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/ai_roast_engine.dart';
import '../../domain/ai_roast_models.dart';

final aiRoastProvider =
    StateNotifierProvider<AiRoastNotifier, AiRoastSystemReport>((ref) {
  return AiRoastNotifier();
});

class AiRoastNotifier extends StateNotifier<AiRoastSystemReport> {
  AiRoastNotifier() : super(_buildInitialReport());

  static final AiRoastEngine _engine = const AiRoastEngine();

  static AiRoastSystemReport _buildInitialReport() {
    final initialRoast = _engine.generateRoast(
      persona: RoastPersona.desiGymBro,
      intensity: RoastIntensity.desiToughLove,
      trigger: RoastTriggerEvent.missedWorkout,
    );

    return AiRoastSystemReport(
      isRoastModeEnabled: true,
      activePersona: RoastPersona.desiGymBro,
      activeIntensity: RoastIntensity.desiToughLove,
      currentRoast: initialRoast,
      recentRoastVault: [initialRoast],
      totalRoastsSurvived: 14,
      excuseDebunkRatePercent: 92.5,
      lastRefreshed: DateTime.now(),
    );
  }

  void updatePersona(RoastPersona persona) {
    final newRoast = _engine.generateRoast(
      persona: persona,
      intensity: state.activeIntensity,
      trigger: state.currentRoast.trigger,
    );

    state = AiRoastSystemReport(
      isRoastModeEnabled: state.isRoastModeEnabled,
      activePersona: persona,
      activeIntensity: state.activeIntensity,
      currentRoast: newRoast,
      recentRoastVault: [newRoast, ...state.recentRoastVault],
      totalRoastsSurvived: state.totalRoastsSurvived + 1,
      excuseDebunkRatePercent: state.excuseDebunkRatePercent,
      lastRefreshed: DateTime.now(),
    );
  }

  void updateIntensity(RoastIntensity intensity) {
    final newRoast = _engine.generateRoast(
      persona: state.activePersona,
      intensity: intensity,
      trigger: state.currentRoast.trigger,
    );

    state = AiRoastSystemReport(
      isRoastModeEnabled: state.isRoastModeEnabled,
      activePersona: state.activePersona,
      activeIntensity: intensity,
      currentRoast: newRoast,
      recentRoastVault: [newRoast, ...state.recentRoastVault],
      totalRoastsSurvived: state.totalRoastsSurvived + 1,
      excuseDebunkRatePercent: state.excuseDebunkRatePercent,
      lastRefreshed: DateTime.now(),
    );
  }

  void triggerScenarioRoast(RoastTriggerEvent trigger) {
    final newRoast = _engine.generateRoast(
      persona: state.activePersona,
      intensity: state.activeIntensity,
      trigger: trigger,
    );

    state = AiRoastSystemReport(
      isRoastModeEnabled: state.isRoastModeEnabled,
      activePersona: state.activePersona,
      activeIntensity: state.activeIntensity,
      currentRoast: newRoast,
      recentRoastVault: [newRoast, ...state.recentRoastVault],
      totalRoastsSurvived: state.totalRoastsSurvived + 1,
      excuseDebunkRatePercent: state.excuseDebunkRatePercent,
      lastRefreshed: DateTime.now(),
    );
  }

  void toggleRoastMode(bool isEnabled) {
    state = AiRoastSystemReport(
      isRoastModeEnabled: isEnabled,
      activePersona: state.activePersona,
      activeIntensity: state.activeIntensity,
      currentRoast: state.currentRoast,
      recentRoastVault: state.recentRoastVault,
      totalRoastsSurvived: state.totalRoastsSurvived,
      excuseDebunkRatePercent: state.excuseDebunkRatePercent,
      lastRefreshed: DateTime.now(),
    );
  }
}
