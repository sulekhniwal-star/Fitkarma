import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/grocery_controller.dart';
import 'package:fitkarma/features/food/grocery_list_screen.dart';
import 'package:fitkarma/features/food/grocery_optimization_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _makeTestDb() => AppDatabase.executor(NativeDatabase.memory());

ProviderContainer _makeContainer(AppDatabase db) =>
    ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: GroceryListScreen()),
    );

void main() {
  group('GroceryOptimizationEngine Unit Tests', () {
    const engine = GroceryOptimizationEngine();

    test('getSeedWeeklyIngredients returns baseline Indian high-protein ingredients', () {
      final items = GroceryOptimizationEngine.getSeedWeeklyIngredients();
      expect(items, isNotEmpty);
      expect(items.any((i) => i.name.contains('Greek Yogurt')), isTrue);
      expect(items.any((i) => i.name.contains('Paneer')), isTrue);
    });

    test('optimize keeps raw items when cost is within weekly budget limit', () {
      final rawItems = GroceryOptimizationEngine.getSeedWeeklyIngredients();
      // High monthly budget of ₹10,000/mo => ~₹2309/wk (raw items ~₹1865/wk)
      final result = engine.optimize(
        rawList: rawItems,
        monthlyBudgetInr: 10000.0,
        dailyProteinTargetG: 110,
      );

      expect(result.isWithinBudget, isTrue);
      expect(result.hasSwaps, isFalse);
      expect(result.swapsAppliedCount, 0);
      expect(result.budgetWarning, isNull);
    });

    test('optimize performs protein-per-rupee food swaps when budget is exceeded', () {
      final rawItems = GroceryOptimizationEngine.getSeedWeeklyIngredients();
      // Low monthly budget of ₹2,500/mo => ~₹577/wk (raw items ~₹1865/wk)
      final result = engine.optimize(
        rawList: rawItems,
        monthlyBudgetInr: 2500.0,
        dailyProteinTargetG: 110,
      );

      expect(result.hasSwaps, isTrue);
      expect(result.swapsAppliedCount, greaterThan(0));
      expect(result.items.any((i) => i.isSwappedSubstitute), isTrue);
      expect(result.totalSavedInr, greaterThan(0));
      expect(result.budgetWarning, isNotNull);
    });

    test('protein substitute maintains exact protein yield of original item', () {
      final rawItems = GroceryOptimizationEngine.getSeedWeeklyIngredients();
      final greekYogurt = rawItems.firstWhere((i) => i.id == 'ing_greek_yogurt');

      final result = engine.optimize(
        rawList: rawItems,
        monthlyBudgetInr: 2500.0,
        dailyProteinTargetG: 110,
      );

      final substitute = result.items.firstWhere((i) => i.isSwappedSubstitute);
      expect(substitute.proteinG, equals(greekYogurt.proteinG));
      expect(substitute.priceInr, lessThan(greekYogurt.priceInr));
    });
  });

  group('GroceryListScreen & Controller UI Tests', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = _makeTestDb();
      container = _makeContainer(db);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    testWidgets('renders grocery list screen with budget card and shopping list', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      expect(find.text('Grocery Optimization 2.0'), findsOneWidget);
      expect(find.text('Monthly Grocery Budget'), findsOneWidget);
      expect(find.byKey(const Key('grocery_monthly_budget_text')), findsOneWidget);
      expect(find.text('Aggregated Shopping List (7 Days)'), findsOneWidget);
    });

    testWidgets('updating monthly budget re-evaluates optimization state', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // Default budget 3000 -> has swaps
      final stateBefore = container.read(groceryProvider);
      expect(stateBefore.monthlyBudgetInr, 3000.0);

      // Increase budget to 12000 via controller
      await container.read(groceryProvider.notifier).setMonthlyBudget(12000.0);
      await tester.pump();

      final stateAfter = container.read(groceryProvider);
      expect(stateAfter.monthlyBudgetInr, 12000.0);
      expect(stateAfter.optimizedList!.hasSwaps, isFalse);
    });

    testWidgets('toggling item purchased checkbox updates item state', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      final firstItemId = container.read(groceryProvider).optimizedList!.items.first.id;
      final isPurchasedBefore = container.read(groceryProvider).optimizedList!.items.first.isPurchased;

      container.read(groceryProvider.notifier).toggleItemPurchased(firstItemId);
      await tester.pump();

      final isPurchasedAfter = container.read(groceryProvider).optimizedList!.items.first.isPurchased;
      expect(isPurchasedAfter, !isPurchasedBefore);
    });

    testWidgets('quick commerce vendor selection updates selected vendor and builds payload (§P16-E)', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // Select Zepto vendor
      container.read(groceryProvider.notifier).setSelectedVendor(VendorPartner.zepto);
      await tester.pump();

      expect(container.read(groceryProvider).selectedVendor, VendorPartner.zepto);

      // Simulate vendor checkout
      container.read(groceryProvider.notifier).simulateVendorCheckout();
      await tester.pump();

      expect(container.read(groceryProvider).isCheckoutSimulated, isTrue);
      expect(find.byKey(const Key('grocery_checkout_payload_box')), findsOneWidget);
      expect(find.textContaining('Vendor: Zepto'), findsOneWidget);
    });
  });
}
