import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/premium/screens/coach_marketplace_screen.dart';
import 'package:fitkarma/features/premium/providers/marketplace_provider.dart';

void main() {
  testWidgets(
      'CoachMarketplaceScreen renders tab switcher, escrow banner, and coach list',
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
          home: CoachMarketplaceScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // App Bar & Tabs
    expect(find.text('Creator & Coach Marketplace'), findsOneWidget);
    expect(find.text('Specialist Coaches'), findsOneWidget);
    expect(find.text('Blueprint Store'), findsOneWidget);

    // Escrow Protection Guarantee
    expect(
      find.textContaining('7-Day Escrow Protection'),
      findsOneWidget,
    );

    // Coach Cards
    expect(find.text('Dr. Ananya Iyer'), findsOneWidget);
    expect(find.text('Rohit Deshmukh'), findsOneWidget);
    expect(find.text('₹2999 / mo'), findsOneWidget);
    expect(find.text('Book Coach'), findsWidgets);
  });

  testWidgets('Switching to Blueprint Store tab displays program store items',
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
          home: CoachMarketplaceScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Blueprint Store tab
    await tester.tap(find.text('Blueprint Store'));
    await tester.pumpAndSettle();

    // Verify Blueprint Items
    expect(find.text('Community Blueprints'), findsOneWidget);
    expect(find.text('Navratri Fasting & Fat Loss Blueprint'), findsOneWidget);
    expect(find.text('Desk Athlete to 10K Blueprint'), findsOneWidget);
    expect(find.text('12-Week Desi Gym Hypertrophy Matrix'), findsOneWidget);
    expect(find.text('Get Blueprint (₹499)'), findsOneWidget);
  });

  testWidgets('Booking coach triggers escrow purchase', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: CoachMarketplaceScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap first Book Coach button
    await tester.tap(find.text('Book Coach').first);
    await tester.pumpAndSettle();

    expect(container.read(marketplaceProvider).activeAssignments.length,
        equals(1));
    expect(find.textContaining('Secured 1:1 coaching'), findsOneWidget);
  });
}
