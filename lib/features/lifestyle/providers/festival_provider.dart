import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/festival_adaptation_engine.dart';

class FestivalState {
  final List<Festival> upcomingFestivals;
  final Festival? activeFestival;
  final FestivalAdaptation activeAdaptation;
  final bool isSurvivalModeActive;
  final bool isFastingModeActive;

  const FestivalState({
    required this.upcomingFestivals,
    this.activeFestival,
    required this.activeAdaptation,
    this.isSurvivalModeActive = false,
    this.isFastingModeActive = false,
  });

  factory FestivalState.initial() {
    final seeded = FestivalCrossModuleEngine.getSeededFestivals(2026);
    // Default active festival for demonstration/testing (Diwali)
    final diwali = seeded.firstWhere((f) => f.type == FestivalType.diwali);
    const engine = FestivalCrossModuleEngine();
    final adaptation = engine.adapt(diwali);

    return FestivalState(
      upcomingFestivals: seeded,
      activeFestival: diwali,
      activeAdaptation: adaptation,
      isSurvivalModeActive: true,
      isFastingModeActive: false,
    );
  }

  FestivalState copyWith({
    List<Festival>? upcomingFestivals,
    Festival? activeFestival,
    FestivalAdaptation? activeAdaptation,
    bool? isSurvivalModeActive,
    bool? isFastingModeActive,
  }) {
    return FestivalState(
      upcomingFestivals: upcomingFestivals ?? this.upcomingFestivals,
      activeFestival: activeFestival ?? this.activeFestival,
      activeAdaptation: activeAdaptation ?? this.activeAdaptation,
      isSurvivalModeActive: isSurvivalModeActive ?? this.isSurvivalModeActive,
      isFastingModeActive: isFastingModeActive ?? this.isFastingModeActive,
    );
  }
}

class FestivalNotifier extends StateNotifier<FestivalState> {
  FestivalNotifier() : super(FestivalState.initial());

  void selectFestival(Festival festival) {
    const engine = FestivalCrossModuleEngine();
    final adaptation = engine.adapt(festival);
    final isSurvival = engine.isSurvivalModeActive(festival, DateTime.now());

    state = state.copyWith(
      activeFestival: festival,
      activeAdaptation: adaptation,
      isSurvivalModeActive: isSurvival || true, // Enable for UI preview when tapped
      isFastingModeActive: adaptation.isFastingActive,
    );
  }
}

final festivalProvider = StateNotifierProvider<FestivalNotifier, FestivalState>((ref) {
  return FestivalNotifier();
});
