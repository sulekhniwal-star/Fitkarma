import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitkarma/features/food/food_screen.dart';
import 'package:fitkarma/features/food/food_controller.dart';

void main() {
  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: FoodScreen(),
      ),
    );
  }

  testWidgets('FoodScreen shows low protein alert, logs items, updates macros, and hides alert when target met', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    // 1. Initial State: Only Masala Dosa logged (6g protein)
    // Target protein is 110g, so 6g is way below 70% (77g).
    // Protein alert banner should be visible.
    expect(find.byKey(const Key('food_protein_alert_banner')), findsOneWidget);
    expect(find.textContaining('Protein low — add paneer or eggs to your next meal'), findsOneWidget);

    // 2. Breakfast section is expanded initially
    expect(find.text('Masala Dosa'), findsOneWidget);

    final breakfastHeader = find.descendant(
      of: find.byKey(const Key('food_meal_section_Breakfast')),
      matching: find.text('Breakfast'),
    );
    // Tap to collapse
    await tester.tap(breakfastHeader);
    await tester.pumpAndSettle();
    expect(find.text('Masala Dosa'), findsNothing);

    // Tap to expand again
    await tester.tap(breakfastHeader);
    await tester.pumpAndSettle();
    expect(find.text('Masala Dosa'), findsOneWidget);

    // 3. Search and log 'Paneer Butter Masala' (14g protein)
    final searchInput = find.byKey(const Key('food_search_input'));
    expect(searchInput, findsOneWidget);
    await tester.enterText(searchInput, 'Paneer');
    await tester.pumpAndSettle();

    // Result tile for Paneer Butter Masala should appear
    final resultTile = find.byKey(const Key('food_search_result_Paneer Butter Masala'));
    expect(resultTile, findsOneWidget);
    await tester.tap(resultTile);
    await tester.pumpAndSettle();

    // Total protein: 6g + 14g = 20g (still below 77g threshold).
    expect(find.byKey(const Key('food_protein_alert_banner')), findsOneWidget);

    // 4. Log a high protein item: 'Chicken Tikka' (30g protein) three times to exceed 77g (20 + 90 = 110g)
    for (int i = 0; i < 3; i++) {
      await tester.enterText(searchInput, 'Chicken');
      await tester.pumpAndSettle();

      final chickenResult = find.byKey(const Key('food_search_result_Chicken Tikka'));
      expect(chickenResult, findsOneWidget);
      await tester.tap(chickenResult);
      await tester.pumpAndSettle();
    }

    // Now total protein = 6 + 14 + 30 * 3 = 110g.
    // 110g >= 77g (70% of 110g target).
    // The alert banner should disappear.
    expect(find.byKey(const Key('food_protein_alert_banner')), findsNothing);

    // Verify list of dinner items contains 'Chicken Tikka' (rendered under Dinner collapsible)
    // Dinner section is expanded initially so we can assert directly without tapping
    expect(find.text('Chicken Tikka'), findsNWidgets(3));
  });
}
