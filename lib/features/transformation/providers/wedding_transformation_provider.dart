import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WeddingPhase { foundation, peakShred, finalTaper }

class WeddingTransformationState {
  final DateTime weddingDate;
  final int daysRemaining;
  final WeddingPhase currentPhase;
  final double calorieTarget;
  final double proteinTargetG;
  final double hydrationTargetLiters;
  final bool hasSkinNutritionChecked;
  final bool hasStressChecked;
  final bool isLoading;

  const WeddingTransformationState({
    required this.weddingDate,
    required this.daysRemaining,
    required this.currentPhase,
    required this.calorieTarget,
    required this.proteinTargetG,
    required this.hydrationTargetLiters,
    required this.hasSkinNutritionChecked,
    required this.hasStressChecked,
    required this.isLoading,
  });

  factory WeddingTransformationState.initial() {
    final defaultDate = DateTime.now().add(const Duration(days: 60));
    final daysLeft = defaultDate.difference(DateTime.now()).inDays;

    return WeddingTransformationState(
      weddingDate: defaultDate,
      daysRemaining: daysLeft,
      currentPhase: WeddingPhase.peakShred,
      calorieTarget: 1750.0,
      proteinTargetG: 125.0,
      hydrationTargetLiters: 3.5,
      hasSkinNutritionChecked: false,
      hasStressChecked: false,
      isLoading: false,
    );
  }

  WeddingTransformationState copyWith({
    DateTime? weddingDate,
    int? daysRemaining,
    WeddingPhase? currentPhase,
    double? calorieTarget,
    double? proteinTargetG,
    double? hydrationTargetLiters,
    bool? hasSkinNutritionChecked,
    bool? hasStressChecked,
    bool? isLoading,
  }) {
    return WeddingTransformationState(
      weddingDate: weddingDate ?? this.weddingDate,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      currentPhase: currentPhase ?? this.currentPhase,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      hydrationTargetLiters: hydrationTargetLiters ?? this.hydrationTargetLiters,
      hasSkinNutritionChecked: hasSkinNutritionChecked ?? this.hasSkinNutritionChecked,
      hasStressChecked: hasStressChecked ?? this.hasStressChecked,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WeddingTransformationNotifier extends StateNotifier<WeddingTransformationState> {
  WeddingTransformationNotifier() : super(WeddingTransformationState.initial());

  void setWeddingDate(DateTime newDate) {
    final daysLeft = newDate.difference(DateTime.now()).inDays;

    WeddingPhase phase = WeddingPhase.foundation;
    double calories = 2000.0;
    double protein = 110.0;
    double hydration = 3.0;

    if (daysLeft < 30) {
      phase = WeddingPhase.finalTaper;
      calories = 1900.0;
      protein = 100.0;
      hydration = 3.5;
    } else if (daysLeft < 90) {
      phase = WeddingPhase.peakShred;
      calories = 1750.0;
      protein = 125.0;
      hydration = 3.5;
    }

    state = state.copyWith(
      weddingDate: newDate,
      daysRemaining: daysLeft,
      currentPhase: phase,
      calorieTarget: calories,
      proteinTargetG: protein,
      hydrationTargetLiters: hydration,
    );
  }

  void toggleSkinNutrition(bool value) {
    state = state.copyWith(hasSkinNutritionChecked: value);
  }

  void toggleStressCheck(bool value) {
    state = state.copyWith(hasStressChecked: value);
  }
}

final weddingTransformationProvider = StateNotifierProvider<WeddingTransformationNotifier, WeddingTransformationState>((ref) {
  return WeddingTransformationNotifier();
});
