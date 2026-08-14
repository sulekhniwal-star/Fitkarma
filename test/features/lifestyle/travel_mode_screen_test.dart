import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/lifestyle/screens/travel_mode_screen.dart';
import 'package:fitkarma/features/lifestyle/providers/travel_mode_provider.dart';
import 'package:fitkarma/core/brain/travel_intelligence_engine.dart';

void main() {
  testWidgets('TravelModeScreen renders Active Travel Mode cards per §P12-E wireframe',
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
          home: TravelModeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Active Travel Banner & Route
    expect(find.text('Travel Mode Active'), findsOneWidget);
    expect(find.text('Delhi → Mumbai (Domestic)'), findsOneWidget);
    expect(find.text('Your Plan is Adapted:'), findsOneWidget);

    // Verify Workout Card
    expect(find.text('Workout: 30-min hotel bodyweight session'), findsOneWidget);
    expect(find.text('Push-ups'), findsOneWidget);
    expect(find.text('Squats'), findsOneWidget);
    expect(find.text('Lunges'), findsOneWidget);
    expect(find.text('Plank'), findsOneWidget);

    // Verify Nutrition Card
    expect(find.text('Nutrition: +150 kcal buffer for eating out'), findsOneWidget);
    expect(find.text('Grilled paneer'), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('End Travel Mode'), findsOneWidget);
    expect(find.text('Extend by 1 day'), findsOneWidget);
  });

  testWidgets('Extending travel mode increments extended days tag', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TravelModeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap "Extend by 1 day"
    await tester.tap(find.text('Extend by 1 day'));
    await tester.pumpAndSettle();

    expect(find.text('+1d Extended'), findsOneWidget);
  });

  testWidgets('Ending travel mode switches to Inactive View', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TravelModeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap "End Travel Mode"
    await tester.tap(find.text('End Travel Mode'));
    await tester.pumpAndSettle();

    expect(find.text('Travel Mode Inactive'), findsOneWidget);
    expect(find.text('Activate Travel Mode'), findsOneWidget);
  });

  testWidgets('International travel renders Jet Lag Protocol Card', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final container = ProviderContainer();
    container.read(travelModeProvider.notifier).startTravelMode(
          TravelContext(
            mode: TravelMode.international,
            origin: 'Mumbai',
            destination: 'London',
            direction: TravelDirection.west,
            departureDate: DateTime.now(),
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: TravelModeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Jet Lag Protocol (West)'), findsOneWidget);
    expect(find.textContaining('Avoid caffeine 6h before new sleep time'), findsOneWidget);
  });
}
