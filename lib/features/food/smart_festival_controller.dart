/// §P5-K Smart Festival Controller & §P12-A Festival Intelligence Integration
///
/// Riverpod Notifier managing festival date detection, target pre-compensation adjustments,
/// and Health OS Brain synchronization (`DailyIntelligencePackages.showFestivalBanner`).
library;

import 'package:fitkarma/features/food/smart_festival_nutrition_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class FestivalNutritionState {
  const FestivalNutritionState({
    this.activeEvent,
    this.relativeDay = FestivalDayRelative.none,
    this.adjustedTargets = const FestivalAdjustedTargets(
      adjustedCalories: 2000,
      adjustedProteinG: 110,
      adjustedCarbsG: 220,
      adjustedFatG: 65,
      adjustedWaterL: 2.5,
      bannerMessage: '',
      satietyNudge: '',
      recommendedCardioMin: 0,
      relativeDay: FestivalDayRelative.none,
    ),
    this.hasActiveAdaptation = false,
  });

  final FestivalEvent? activeEvent;
  final FestivalDayRelative relativeDay;
  final FestivalAdjustedTargets adjustedTargets;
  final bool hasActiveAdaptation;

  FestivalNutritionState copyWith({
    FestivalEvent? activeEvent,
    FestivalDayRelative? relativeDay,
    FestivalAdjustedTargets? adjustedTargets,
    bool? hasActiveAdaptation,
  }) {
    return FestivalNutritionState(
      activeEvent: activeEvent ?? this.activeEvent,
      relativeDay: relativeDay ?? this.relativeDay,
      adjustedTargets: adjustedTargets ?? this.adjustedTargets,
      hasActiveAdaptation: hasActiveAdaptation ?? this.hasActiveAdaptation,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final smartFestivalEngineProvider = Provider<SmartFestivalNutritionEngine>((
  ref,
) {
  return const SmartFestivalNutritionEngine();
});

class FestivalNutritionNotifier extends Notifier<FestivalNutritionState> {
  @override
  FestivalNutritionState build() {
    final engine = ref.watch(smartFestivalEngineProvider);
    final (event, relativeDay) = engine.detectFestival(DateTime.now());

    if (event != null && relativeDay != FestivalDayRelative.none) {
      final adjusted = engine.adjustTargets(
        baseline: const BaselineNutritionTargets(),
        event: event,
        relativeDay: relativeDay,
      );
      return FestivalNutritionState(
        activeEvent: event,
        relativeDay: relativeDay,
        adjustedTargets: adjusted,
        hasActiveAdaptation: true,
      );
    }

    return const FestivalNutritionState();
  }

  /// Evaluates festival calendar for [targetDate] and updates target overrides & banner messages.
  void checkFestivalForDate(
    DateTime targetDate, {
    BaselineNutritionTargets baseline = const BaselineNutritionTargets(),
    List<FestivalEvent>? customCalendar,
  }) {
    final engine = ref.read(smartFestivalEngineProvider);
    final (event, relativeDay) = engine.detectFestival(
      targetDate,
      customCalendar: customCalendar,
    );

    if (event != null && relativeDay != FestivalDayRelative.none) {
      final adjusted = engine.adjustTargets(
        baseline: baseline,
        event: event,
        relativeDay: relativeDay,
      );

      state = state.copyWith(
        activeEvent: event,
        relativeDay: relativeDay,
        adjustedTargets: adjusted,
        hasActiveAdaptation: true,
      );
    } else {
      state = state.copyWith(
        activeEvent: null,
        relativeDay: FestivalDayRelative.none,
        adjustedTargets: FestivalAdjustedTargets(
          adjustedCalories: baseline.calories,
          adjustedProteinG: baseline.proteinG,
          adjustedCarbsG: baseline.carbsG,
          adjustedFatG: baseline.fatG,
          adjustedWaterL: baseline.waterL,
          bannerMessage: '',
          satietyNudge: '',
          recommendedCardioMin: 0,
          relativeDay: FestivalDayRelative.none,
        ),
        hasActiveAdaptation: false,
      );
    }
  }
}

final festivalNutritionProvider =
    NotifierProvider<FestivalNutritionNotifier, FestivalNutritionState>(
      FestivalNutritionNotifier.new,
    );
