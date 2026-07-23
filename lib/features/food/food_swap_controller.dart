/// §P5-R Food Swap Controller
///
/// Riverpod Notifier evaluating logged food items from `foodProvider` against
/// `FoodSwapEngine` and offering interactive swap actions.
library;

import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/food_swap_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class FoodSwapState {
  const FoodSwapState({
    this.activeSubstitute,
    this.availableLoggedSwaps = const [],
    this.searchQuery = '',
  });

  final SmartSubstitute? activeSubstitute;
  final List<SmartSubstitute> availableLoggedSwaps;
  final String searchQuery;

  FoodSwapState copyWith({
    SmartSubstitute? activeSubstitute,
    List<SmartSubstitute>? availableLoggedSwaps,
    String? searchQuery,
  }) {
    return FoodSwapState(
      activeSubstitute: activeSubstitute ?? this.activeSubstitute,
      availableLoggedSwaps: availableLoggedSwaps ?? this.availableLoggedSwaps,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final foodSwapEngineProvider = Provider<FoodSwapEngine>((ref) {
  return const FoodSwapEngine();
});

class FoodSwapNotifier extends Notifier<FoodSwapState> {
  @override
  FoodSwapState build() {
    final engine = ref.watch(foodSwapEngineProvider);
    final foodState = ref.watch(foodProvider);

    final loggedSwaps = engine.findSubstitutesForLoggedFoods(
      foodState.loggedItems,
    );

    return FoodSwapState(
      activeSubstitute: loggedSwaps.isNotEmpty ? loggedSwaps.first : null,
      availableLoggedSwaps: loggedSwaps,
    );
  }

  /// Searches the swap registry for a specific query string.
  void searchSwap(String query) {
    final engine = ref.read(foodSwapEngineProvider);
    final match = engine.findBestSwap(query);

    state = state.copyWith(searchQuery: query, activeSubstitute: match);
  }

  /// Sets active substitute explicitly.
  void selectSubstitute(SmartSubstitute substitute) {
    state = state.copyWith(activeSubstitute: substitute);
  }
}

final foodSwapProvider = NotifierProvider<FoodSwapNotifier, FoodSwapState>(
  FoodSwapNotifier.new,
);
