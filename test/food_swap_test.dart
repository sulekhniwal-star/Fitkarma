import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/food_swap_dialog.dart';
import 'package:fitkarma/features/food/food_swap_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(body: FoodSwapDialog(initialQuery: 'Samosa')),
      ),
    );

void main() {
  group('FoodSwapEngine Unit Tests', () {
    const engine = FoodSwapEngine();

    test('findBestSwap finds Samosa -> Air-Fried Samosa (-150 kcal delta)', () {
      final swap = engine.findBestSwap('Deep-Fried Samosa');

      expect(swap, isNotNull);
      expect(swap!.alternativeName, 'Air-Fried Samosa');
      expect(swap.calorieDelta, -150.0);
      expect(swap.satietyGain, 30.0);
    });

    test('findBestSwap finds Paneer Butter Masala -> High-Pro Paneer Makhani (-220 kcal, +12g pro)', () {
      final swap = engine.findBestSwap('Paneer Butter Masala');

      expect(swap, isNotNull);
      expect(swap!.alternativeName, 'High-Protein Paneer Makhani');
      expect(swap.calorieDelta, -220.0);
      expect(swap.proteinDelta, 12.0);
    });

    test('findBestSwap finds Gulab Jamun -> Whey Protein Sattu Kheer (-180 kcal, +18g pro)', () {
      final swap = engine.findBestSwap('Gulab Jamun');

      expect(swap, isNotNull);
      expect(swap!.alternativeName, 'Whey Protein Sattu Kheer');
      expect(swap.calorieDelta, -180.0);
      expect(swap.proteinDelta, 18.0);
    });

    test('findSubstitutesForLoggedFoods identifies logged street food swap opportunities', () {
      final logged = [
        const FoodItem(id: '1', name: 'Butter Naan', calories: 320, protein: 6, carbs: 45, fat: 12, mealType: 'Dinner'),
        const FoodItem(id: '2', name: 'Chole Bhature', calories: 650, protein: 15, carbs: 75, fat: 30, mealType: 'Lunch'),
      ];

      final swaps = engine.findSubstitutesForLoggedFoods(logged);

      expect(swaps.length, 2);
      expect(swaps.any((s) => s.alternativeName == 'Tandoori Roti'), isTrue);
      expect(swaps.any((s) => s.alternativeName == 'Air-Fried Kulcha & Baked Chole'), isTrue);
    });
  });

  group('FoodSwapDialog UI & Controller Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders FoodSwapDialog with side-by-side comparison and metric badges', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      expect(find.byKey(const Key('food_swap_comparison_card')), findsOneWidget);
      expect(find.text('Air-Fried Samosa'), findsOneWidget);
      expect(find.text('-150 kcal'), findsOneWidget);
      expect(find.byKey(const Key('swap_prep_tip_text')), findsOneWidget);
      expect(find.byKey(const Key('apply_swap_btn')), findsOneWidget);
    });

    testWidgets('tapping Apply Swap adds alternative food to foodProvider', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      await tester.tap(find.byKey(const Key('apply_swap_btn')));
      await tester.pump();

      final foodState = container.read(foodProvider);
      expect(foodState.loggedItems.any((i) => i.name == 'Air-Fried Samosa'), isTrue);
    });
  });
}
