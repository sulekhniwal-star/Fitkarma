import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/restaurant_intelligence_models.dart';
import 'package:fitkarma/features/nutrition/models/restaurant_database_service.dart';
import 'package:fitkarma/features/nutrition/screens/restaurant_menu_scan_screen.dart';

void main() {
  group('§P5-E Indian Restaurant Intelligence 2.0 Tests', () {
    final service = RestaurantDatabaseService();

    // ── Major Chain Menu Optimization Presets Tests ──────────────────────────

    test(
        'MajorChainPresetsDatabase contains seeded presets for top Indian chains',
        () {
      expect(MajorChainPresetsDatabase.presets.length, equals(5));

      final haldiram = MajorChainPresetsDatabase.presets
          .firstWhere((p) => p.chainName == "Haldiram's");
      expect(haldiram.bestProteinPick, contains('Paneer Tikka Platter'));
      expect(haldiram.avoidAlertItem, contains('Chole Bhature'));
      expect(haldiram.diabeticPcosPick, contains('Sprouted Moong'));
    });

    // ── Smart Item Recognition & OCR Parser Tests ─────────────────────────────

    test('parseMenuText matches OCR lines and assigns goal overlay colors', () {
      final rawLines = [
        'Paneer Tikka',
        'Chole Bhature',
        'Sprouted Moong Chaat',
        'Unknown Exotic Soup',
      ];

      final results = service.parseMenuText(rawLines);

      expect(results.length, equals(4));
      expect(
          results[0].colorOverlay,
          equals(MenuGoalOverlayCategory
              .greenHighProtein)); // Paneer Tikka > 20g Pro
      expect(
          results[1].colorOverlay,
          equals(MenuGoalOverlayCategory
              .redAvoidAlert)); // Chole Bhature deep fried
      expect(
          results[2].colorOverlay,
          equals(MenuGoalOverlayCategory
              .blueLowCalorie)); // Sprouted Moong < 300 kcal
      expect(results[3].colorOverlay,
          equals(MenuGoalOverlayCategory.neutral)); // Unmatched -> neutral
    });

    test(
        'matchDishInDatabase fuzzy matches OCR lines using token containment and Levenshtein distance',
        () {
      final match1 = service.matchDishInDatabase('Paneer Tikka Masala Platter');
      expect(match1?.name, equals('Paneer Tikka Masala'));

      final match2 = service.matchDishInDatabase('Butter Nan'); // Typo test
      expect(match2?.name, equals('Butter Naan'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'RestaurantMenuScanScreen renders OCR Scanner, Legend, and Chain Presets',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RestaurantMenuScanScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Restaurant Intelligence 2.0'), findsOneWidget);
      expect(find.text('Menu OCR Scanner'), findsOneWidget);
      expect(find.text('Goal Overlay Legend:'), findsOneWidget);
      expect(find.text('Major Indian Chain Optimization Presets:'),
          findsOneWidget);
      expect(find.text("Haldiram's"), findsWidgets);
    });
  });
}
