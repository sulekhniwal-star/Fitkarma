import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/festival_engine.dart';
import '../models/festival_model.dart';

class FestivalState {
  final List<FestivalEvent> festivals;
  final FastingModeConfig fastingConfig;
  final bool isSurvivalModeActive;

  const FestivalState({
    required this.festivals,
    this.fastingConfig = const FastingModeConfig(),
    this.isSurvivalModeActive = false,
  });

  FestivalState copyWith({
    List<FestivalEvent>? festivals,
    FastingModeConfig? fastingConfig,
    bool? isSurvivalModeActive,
  }) {
    return FestivalState(
      festivals: festivals ?? this.festivals,
      fastingConfig: fastingConfig ?? this.fastingConfig,
      isSurvivalModeActive: isSurvivalModeActive ?? this.isSurvivalModeActive,
    );
  }
}

class FestivalNotifier extends StateNotifier<FestivalState> {
  final FestivalEngine engine;

  FestivalNotifier(this.engine)
      : super(
          FestivalState(
            festivals: SeededFestivalCalendar.festivals,
          ),
        );

  void toggleNavratriFasting() {
    final active = !state.fastingConfig.isNavratriFastingActive;
    state = state.copyWith(
      fastingConfig: FastingModeConfig(
        isNavratriFastingActive: active,
        isRamadanModeActive: state.fastingConfig.isRamadanModeActive,
      ),
    );
  }

  void toggleRamadanMode() {
    final active = !state.fastingConfig.isRamadanModeActive;
    state = state.copyWith(
      fastingConfig: FastingModeConfig(
        isNavratriFastingActive: state.fastingConfig.isNavratriFastingActive,
        isRamadanModeActive: active,
      ),
    );
  }
}

final festivalProvider = StateNotifierProvider<FestivalNotifier, FestivalState>((ref) {
  return FestivalNotifier(const FestivalEngine());
});
