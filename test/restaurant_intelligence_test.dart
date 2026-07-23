import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/restaurant_controller.dart';
import 'package:fitkarma/features/food/restaurant_database_service.dart';
import 'package:fitkarma/features/food/restaurant_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _makeTestDb() => AppDatabase.executor(NativeDatabase.memory());

ProviderContainer _makeContainer(AppDatabase db) =>
    ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: RestaurantSearchScreen()),
    );

void main() {
  group('RestaurantDatabaseService', () {
    const service = RestaurantDatabaseService();

    test('search returns all seeded dishes when parameters are empty', () {
      final results = service.search();
      expect(results, isNotEmpty);
      expect(results.length, greaterThanOrEqualTo(10));
    });

    test('search filters dishes by restaurant chain name', () {
      final haldirams = service.search(restaurantName: "Haldiram's");
      expect(haldirams, isNotEmpty);
      expect(haldirams.every((item) => item.restaurantName == "Haldiram's"), isTrue);
    });

    test('search filters dishes by dish query substring', () {
      final paneerDishes = service.search(dishQuery: 'Paneer');
      expect(paneerDishes, isNotEmpty);
      expect(paneerDishes.every((item) => item.name.contains('Paneer')), isTrue);
    });

    test('computeGoalOverlay classifies green, blue, orange, red correctly', () {
      // High protein (> 20g) -> green
      const highPro = RestaurantMenuItem(
        id: '1', restaurantName: 'Test', name: 'Pro Item',
        calories: 350, proteinG: 24, carbsG: 20, fatG: 10, glycemicIndex: 30, isDeepFried: false, sugarG: 1,
      );
      expect(service.computeGoalOverlay(highPro), OverlayColor.green);

      // Low calorie (< 300 kcal) -> blue
      const lowCal = RestaurantMenuItem(
        id: '2', restaurantName: 'Test', name: 'Low Cal Item',
        calories: 180, proteinG: 8, carbsG: 20, fatG: 4, glycemicIndex: 30, isDeepFried: false, sugarG: 1,
      );
      expect(service.computeGoalOverlay(lowCal), OverlayColor.blue);

      // Deep fried -> red
      const fried = RestaurantMenuItem(
        id: '3', restaurantName: 'Test', name: 'Fried Item',
        calories: 800, proteinG: 10, carbsG: 90, fatG: 40, glycemicIndex: 65, isDeepFried: true, sugarG: 2,
      );
      expect(service.computeGoalOverlay(fried), OverlayColor.red);

      // Diabetic / PCOS safe (low GI <= 55) -> orange
      const diabeticSafe = RestaurantMenuItem(
        id: '4', restaurantName: 'Test', name: 'Diabetic Item',
        calories: 320, proteinG: 12, carbsG: 30, fatG: 10, glycemicIndex: 40, isDeepFried: false, sugarG: 2,
      );
      expect(service.computeGoalOverlay(diabeticSafe, isPcosOrDiabetic: true), OverlayColor.orange);
    });

    test('fuzzy OCR matcher finds dish via Levenshtein or substring match', () {
      final matchExact = service.matchDishInDatabase('Paneer Tikka');
      expect(matchExact, isNotNull);
      expect(matchExact!.name, 'Paneer Tikka');

      final matchSubstring = service.matchDishInDatabase('Special Paneer Tikka Platter');
      expect(matchSubstring, isNotNull);
      expect(matchSubstring!.name, 'Paneer Tikka');
    });

    test('parseMenuText converts raw OCR lines to overlays', () {
      final lines = ['Paneer Tikka', 'Chole Bhature', 'Random Unknown Dish'];
      final parsed = service.parseMenuText(lines);

      expect(parsed.length, 3);
      expect(parsed[0].colorOverlay, OverlayColor.green);
      expect(parsed[1].colorOverlay, OverlayColor.red);
      expect(parsed[2].matchedItem, isNull);
    });
  });

  group('RestaurantSearchScreen UI Tests', () {
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

    testWidgets('renders search screen with search bar, presets, and dish cards', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      expect(find.text('Restaurant Intelligence'), findsOneWidget);
      expect(find.byKey(const Key('restaurant_search_input')), findsOneWidget);
      expect(find.text('Major Chain Optimization Presets'), findsOneWidget);
      expect(find.text("Haldiram's"), findsWidgets);
    });

    testWidgets('filtering search query updates visible items', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      await tester.enterText(find.byKey(const Key('restaurant_search_input')), 'Soya');
      await tester.pump();

      expect(find.text('Grilled Soya Chaap'), findsOneWidget);
    });

    testWidgets('selecting chain filter chip filters items', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      container.read(restaurantProvider.notifier).setSelectedChain("McDonald's India");
      await tester.pump();

      expect(find.text('McProtein Egg Burger'), findsOneWidget);
    });

    testWidgets('OCR tab parses text input and shows results', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // Switch to OCR tab
      await tester.tap(find.text('Menu OCR Scanner'));
      await tester.pumpAndSettle();

      // Enter OCR text
      await tester.enterText(find.byKey(const Key('restaurant_ocr_input')), 'Paneer Tikka\nChole Bhature');
      await tester.tap(find.byKey(const Key('restaurant_parse_ocr_btn')));
      await tester.pump();

      expect(find.textContaining('Parsed Menu Overlays'), findsOneWidget);
    });

    testWidgets('logging restaurant dish adds item to foodProvider state', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      final beforeCount = container.read(foodProvider).loggedItems.length;

      // Log the first item
      final firstItem = container.read(restaurantProvider).items.first;
      container.read(restaurantProvider.notifier).logDish(firstItem);
      await tester.pump();

      final afterCount = container.read(foodProvider).loggedItems.length;
      expect(afterCount, beforeCount + 1);
    });
  });
}
