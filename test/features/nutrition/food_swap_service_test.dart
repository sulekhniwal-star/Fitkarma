import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/food_swap_service.dart';
import 'package:fitkarma/features/nutrition/screens/indian_food_swap_screen.dart';

void main() {
  group('§P5-R Indian Food Substitution & Swap Engine Tests', () {
    const service = FoodSwapService();

    test(
        'checkSubstitution returns correct smart swap & deltas for Deep-Fried Samosa per §P5-R spec',
        () {
      final sub = service.checkSubstitution('samosa_fried');

      expect(sub, isNotNull);
      expect(sub!.alternativeName, equals('Air-Fried Samosa'));
      expect(sub.calorieDelta, equals(-150.0));
      expect(sub.swapInstructions, contains('air-fry at 180°C'));
    });

    test(
        'checkSubstitution returns correct smart swap & deltas for Paneer Butter Masala (-220 kcal, +12g protein)',
        () {
      final sub = service.checkSubstitution('paneer_butter_masala');

      expect(sub, isNotNull);
      expect(sub!.alternativeName, equals('High-Pro Paneer Makhani'));
      expect(sub.calorieDelta, equals(-220.0));
      expect(sub.proteinDelta, equals(12.0));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'IndianFoodSwapScreen renders craving selector, smart swap card, and delta badges',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: IndianFoodSwapScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Smart Indian Food Swaps'), findsOneWidget);
      expect(find.text('Craving & Caved Food Selector'), findsOneWidget);
      expect(find.text('High-Adherence Smart Swap'), findsOneWidget);
      expect(find.text('Air-Fried Samosa'), findsOneWidget);
    });
  });
}
