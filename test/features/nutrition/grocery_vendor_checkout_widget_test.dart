import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/nutrition/screens/grocery_optimization_screen.dart';

void main() {
  testWidgets('§P16-E GroceryOptimizationScreen displays Blinkit, Zepto, and BigBasket checkout buttons',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: GroceryOptimizationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Grocery Optimizer 2.0'), findsOneWidget);
    expect(find.text('Instant 10-Minute Cart Checkout:'), findsOneWidget);
    expect(find.byKey(const Key('btn_checkout_blinkit')), findsOneWidget);
    expect(find.byKey(const Key('btn_checkout_zepto')), findsOneWidget);
    expect(find.byKey(const Key('btn_checkout_bigbasket')), findsOneWidget);

    // Tap Blinkit
    await tester.ensureVisible(find.byKey(const Key('btn_checkout_blinkit')));
    await tester.tap(find.byKey(const Key('btn_checkout_blinkit')));
    await tester.pumpAndSettle();

    expect(find.text('Opening Blinkit with pre-filled cart & affiliate tag...'), findsOneWidget);
  });
}
