/// §P5-F Grocery Controller
///
/// Riverpod Notifier managing monthly budget setting, optimized grocery list state,
/// interactive item checkmarks, quick-commerce vendor selection (Blinkit/Zepto/Instamart per §P16-E),
/// and checkout payload creation.
library;

import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/grocery_optimization_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class GroceryState {
  const GroceryState({
    this.monthlyBudgetInr = 3000.0,
    this.dailyProteinTargetG = 110,
    this.optimizedList,
    this.selectedVendor = VendorPartner.blinkit,
    this.isCheckoutSimulated = false,
    this.checkoutPayload = '',
  });

  final double monthlyBudgetInr;
  final int dailyProteinTargetG;
  final OptimizedGroceryList? optimizedList;
  final VendorPartner selectedVendor;
  final bool isCheckoutSimulated;
  final String checkoutPayload;

  GroceryState copyWith({
    double? monthlyBudgetInr,
    int? dailyProteinTargetG,
    OptimizedGroceryList? optimizedList,
    VendorPartner? selectedVendor,
    bool? isCheckoutSimulated,
    String? checkoutPayload,
  }) {
    return GroceryState(
      monthlyBudgetInr: monthlyBudgetInr ?? this.monthlyBudgetInr,
      dailyProteinTargetG: dailyProteinTargetG ?? this.dailyProteinTargetG,
      optimizedList: optimizedList ?? this.optimizedList,
      selectedVendor: selectedVendor ?? this.selectedVendor,
      isCheckoutSimulated: isCheckoutSimulated ?? this.isCheckoutSimulated,
      checkoutPayload: checkoutPayload ?? this.checkoutPayload,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final groceryOptimizationEngineProvider = Provider<GroceryOptimizationEngine>((
  ref,
) {
  return const GroceryOptimizationEngine();
});

class GroceryNotifier extends Notifier<GroceryState> {
  static const String _userId = 'local_user';

  @override
  GroceryState build() {
    final engine = ref.watch(groceryOptimizationEngineProvider);
    final rawSeedItems = GroceryOptimizationEngine.getSeedWeeklyIngredients();
    final optimized = engine.optimize(
      rawList: rawSeedItems,
      monthlyBudgetInr: 3000.0,
      dailyProteinTargetG: 110,
    );

    // Async load user budget from database if available
    _loadUserBudget();

    return GroceryState(
      monthlyBudgetInr: 3000.0,
      dailyProteinTargetG: 110,
      optimizedList: optimized,
      selectedVendor: VendorPartner.blinkit,
    );
  }

  /// Updates monthly grocery budget, persists to database, and re-optimizes the list.
  Future<void> setMonthlyBudget(double budgetInr) async {
    state = state.copyWith(monthlyBudgetInr: budgetInr);
    _reoptimize();

    // Persist to Drift Users table
    final db = ref.read(databaseProvider);
    await db.updateUserProfile(
      userId: _userId,
      monthlyGroceryBudgetInr: budgetInr,
    );
  }

  /// Toggles an item's purchased checkmark state.
  void toggleItemPurchased(String itemId) {
    final currentList = state.optimizedList;
    if (currentList == null) return;

    final updatedItems = currentList.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isPurchased: !item.isPurchased);
      }
      return item;
    }).toList();

    state = state.copyWith(
      optimizedList: OptimizedGroceryList(
        items: updatedItems,
        totalCostInr: currentList.totalCostInr,
        weeklyCostLimitInr: currentList.weeklyCostLimitInr,
        monthlyBudgetInr: currentList.monthlyBudgetInr,
        isWithinBudget: currentList.isWithinBudget,
        hasSwaps: currentList.hasSwaps,
        swapsAppliedCount: currentList.swapsAppliedCount,
        totalSavedInr: currentList.totalSavedInr,
        budgetWarning: currentList.budgetWarning,
      ),
    );
  }

  /// Sets selected quick-commerce vendor (Blinkit, Zepto, Swiggy Instamart per §P16-E).
  void setSelectedVendor(VendorPartner vendor) {
    state = state.copyWith(selectedVendor: vendor);
  }

  /// Generates the vendor checkout deep-link manifest payload (§P16-E).
  String buildVendorCheckoutPayload() {
    final list = state.optimizedList;
    if (list == null) return '';

    final vendorName = switch (state.selectedVendor) {
      VendorPartner.blinkit => 'Blinkit',
      VendorPartner.zepto => 'Zepto',
      VendorPartner.swiggyInstamart => 'Swiggy Instamart',
    };

    final manifestLines = list.items
        .map(
          (item) => '- ${item.name} (${item.unit}) ~ ₹${item.priceInr.round()}',
        )
        .join('\n');

    return '''
Vendor: $vendorName
Items (${list.items.length}):
$manifestLines
Est. Total: ₹${list.totalCostInr.round()}
''';
  }

  /// Simulates 1-tap quick commerce vendor checkout (§P16-E).
  void simulateVendorCheckout() {
    final payload = buildVendorCheckoutPayload();
    state = state.copyWith(isCheckoutSimulated: true, checkoutPayload: payload);
  }

  void resetCheckoutSimulation() {
    state = state.copyWith(isCheckoutSimulated: false, checkoutPayload: '');
  }

  void _reoptimize() {
    final engine = ref.read(groceryOptimizationEngineProvider);
    final rawSeedItems = GroceryOptimizationEngine.getSeedWeeklyIngredients();
    final optimized = engine.optimize(
      rawList: rawSeedItems,
      monthlyBudgetInr: state.monthlyBudgetInr,
      dailyProteinTargetG: state.dailyProteinTargetG,
    );
    state = state.copyWith(optimizedList: optimized);
  }

  Future<void> _loadUserBudget() async {
    try {
      final db = ref.read(databaseProvider);
      final user = await (db.select(
        db.users,
      )..where((t) => t.id.equals(_userId))).getSingleOrNull();

      if (user != null && user.monthlyGroceryBudgetInr > 0) {
        setMonthlyBudget(user.monthlyGroceryBudgetInr);
      }
    } catch (_) {
      // Fall back to default state
    }
  }
}

final groceryProvider = NotifierProvider<GroceryNotifier, GroceryState>(
  GroceryNotifier.new,
);
