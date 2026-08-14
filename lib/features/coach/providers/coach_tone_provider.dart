import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/ai_roast_mode_engine.dart';

/// §P12-D Coach Tone State Model
class CoachToneState {
  final CoachTone selectedTone;
  final bool isRoastOptedIn;
  final bool isDistressDetected;
  final String? distressTriggerReason;
  final AiRoastModeEngine engine;

  const CoachToneState({
    this.selectedTone = CoachTone.motivational,
    this.isRoastOptedIn = false,
    this.isDistressDetected = false,
    this.distressTriggerReason,
    this.engine = const AiRoastModeEngine(),
  });

  /// The effective tone resolved with safety & distress safeguards
  CoachTone get effectiveTone => engine.resolveEffectiveTone(
        selectedTone: selectedTone,
        isDistressDetected: isDistressDetected,
      );

  /// Whether Roast mode is currently suppressed by crisis/distress detection
  bool get isRoastSuppressedByCrisis =>
      selectedTone == CoachTone.roast && isDistressDetected;

  ToneInstruction get instruction => engine.getInstruction(
        selectedTone: selectedTone,
        isDistressDetected: isDistressDetected,
      );

  CoachToneState copyWith({
    CoachTone? selectedTone,
    bool? isRoastOptedIn,
    bool? isDistressDetected,
    String? distressTriggerReason,
    bool clearDistressReason = false,
  }) {
    return CoachToneState(
      selectedTone: selectedTone ?? this.selectedTone,
      isRoastOptedIn: isRoastOptedIn ?? this.isRoastOptedIn,
      isDistressDetected: isDistressDetected ?? this.isDistressDetected,
      distressTriggerReason: clearDistressReason
          ? null
          : (distressTriggerReason ?? this.distressTriggerReason),
      engine: engine,
    );
  }
}

/// §P12-D Coach Tone Notifier (Pure Dart State Management)
class CoachToneNotifier extends StateNotifier<CoachToneState> {
  CoachToneNotifier() : super(const CoachToneState());

  /// Sets the selected tone. If setting to Roast, ensures opt-in flag is confirmed.
  void setTone(CoachTone tone) {
    if (tone == CoachTone.roast && !state.isRoastOptedIn) {
      // Must explicitly opt-in to Roast mode
      state = state.copyWith(
        selectedTone: CoachTone.roast,
        isRoastOptedIn: true,
      );
      return;
    }

    state = state.copyWith(selectedTone: tone);
  }

  /// Explicitly confirms opt-in for Roast Mode
  void optInToRoast() {
    state = state.copyWith(
      selectedTone: CoachTone.roast,
      isRoastOptedIn: true,
    );
  }

  /// Scans user input or health state for acute distress triggers
  bool evaluateDistressTrigger({
    String? userMessage,
    bool isIllnessActive = false,
    bool isSleepCrisis = false,
    bool isExtremeStress = false,
  }) {
    final distressed = state.engine.detectDistress(
      userMessage: userMessage,
      isIllnessActive: isIllnessActive,
      isSleepCrisis: isSleepCrisis,
      isExtremeStress: isExtremeStress,
    );

    if (distressed) {
      final reason = isIllnessActive
          ? 'Active illness detected'
          : isSleepCrisis
              ? 'Acute sleep crisis'
              : isExtremeStress
                  ? 'High physiological stress'
                  : 'Distress / crisis language detected';

      state = state.copyWith(
        isDistressDetected: true,
        distressTriggerReason: reason,
      );
    }

    return distressed;
  }

  /// Manually clears distress safeguard
  void clearDistress() {
    state = state.copyWith(
      isDistressDetected: false,
      clearDistressReason: true,
    );
  }
}

final coachToneProvider =
    StateNotifierProvider<CoachToneNotifier, CoachToneState>(
  (ref) => CoachToneNotifier(),
);
