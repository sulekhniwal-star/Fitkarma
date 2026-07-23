/// §P5-E Restaurant Controller
///
/// Riverpod Notifier managing search queries, chain filters, OCR menu text parsing,
/// and dish logging into the food provider.
library;

import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/restaurant_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class RestaurantState {
  const RestaurantState({
    this.searchQuery = '',
    this.selectedChain = 'All',
    this.items = const [],
    this.chainPresets = const [],
    this.ocrText = '',
    this.ocrResults = const [],
    this.isPcosOrDiabetic = false,
  });

  final String searchQuery;
  final String selectedChain;
  final List<RestaurantMenuItem> items;
  final List<ChainPreset> chainPresets;
  final String ocrText;
  final List<ParsedMenuItemOverlay> ocrResults;
  final bool isPcosOrDiabetic;

  RestaurantState copyWith({
    String? searchQuery,
    String? selectedChain,
    List<RestaurantMenuItem>? items,
    List<ChainPreset>? chainPresets,
    String? ocrText,
    List<ParsedMenuItemOverlay>? ocrResults,
    bool? isPcosOrDiabetic,
  }) {
    return RestaurantState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedChain: selectedChain ?? this.selectedChain,
      items: items ?? this.items,
      chainPresets: chainPresets ?? this.chainPresets,
      ocrText: ocrText ?? this.ocrText,
      ocrResults: ocrResults ?? this.ocrResults,
      isPcosOrDiabetic: isPcosOrDiabetic ?? this.isPcosOrDiabetic,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final restaurantDatabaseServiceProvider = Provider<RestaurantDatabaseService>((
  ref,
) {
  return const RestaurantDatabaseService();
});

class RestaurantNotifier extends Notifier<RestaurantState> {
  @override
  RestaurantState build() {
    final service = ref.watch(restaurantDatabaseServiceProvider);
    final initialItems = service.search();
    return RestaurantState(
      items: initialItems,
      chainPresets: ChainPresetDataset.presets,
    );
  }

  /// Updates search query and filters items.
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Sets selected chain filter (e.g. "Haldiram's", "Bikanervala", "All").
  void setSelectedChain(String chain) {
    state = state.copyWith(selectedChain: chain);
    _applyFilters();
  }

  /// Toggles Diabetic / PCOS filter setting for overlays.
  void togglePcosOrDiabetic(bool value) {
    state = state.copyWith(isPcosOrDiabetic: value);
    if (state.ocrText.isNotEmpty) {
      parseOcrText(state.ocrText);
    }
  }

  /// Parses raw text lines from OCR menu scanner or manual input.
  void parseOcrText(String text) {
    final service = ref.read(restaurantDatabaseServiceProvider);
    final lines = text.split('\n');
    final results = service.parseMenuText(
      lines,
      isPcosOrDiabetic: state.isPcosOrDiabetic,
    );
    state = state.copyWith(ocrText: text, ocrResults: results);
  }

  /// Logs a restaurant dish into the main [FoodController].
  void logDish(RestaurantMenuItem item) {
    final foodItem = FoodItem(
      id: 'rest_${DateTime.now().millisecondsSinceEpoch}',
      name: '${item.name} (${item.restaurantName})',
      calories: item.calories.round(),
      protein: item.proteinG.round(),
      carbs: item.carbsG.round(),
      fat: item.fatG.round(),
      mealType: 'Lunch',
    );
    ref.read(foodProvider.notifier).addFood(foodItem);
  }

  void _applyFilters() {
    final service = ref.read(restaurantDatabaseServiceProvider);
    final filtered = service.search(
      restaurantName: state.selectedChain == 'All' ? null : state.selectedChain,
      dishQuery: state.searchQuery,
    );
    state = state.copyWith(items: filtered);
  }
}

final restaurantProvider =
    NotifierProvider<RestaurantNotifier, RestaurantState>(
      RestaurantNotifier.new,
    );
