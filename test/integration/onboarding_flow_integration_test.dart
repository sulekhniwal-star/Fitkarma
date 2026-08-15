import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/onboarding/screens/onboarding_screen.dart';
import 'package:fitkarma/features/onboarding/providers/onboarding_provider.dart';

void main() {
  testWidgets('§P14-C Integration: Full Onboarding Flow (Welcome -> Blueprint)',
      (tester) async {
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
          home: OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Step 1: Welcome Step
    expect(find.text('Welcome to FitKarma'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 2: Biometrics Step
    expect(find.text('Your Biometrics'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 3: Goals Step
    expect(find.text('Primary Goal'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 4: Dietary Step
    expect(find.text('Dietary Preference'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 5: Ayurveda Dosha Step
    expect(find.text('Ayurveda Dosha Quiz'), findsOneWidget);
    expect(find.text('Generate Program Blueprint'), findsOneWidget);

    await tester.tap(find.text('Generate Program Blueprint'));
    await tester.pumpAndSettle();

    // Step 6: Blueprint Generated Step
    expect(find.text('Your Program Blueprint'), findsOneWidget);
    expect(find.text('Continue to Permissions'), findsOneWidget);

    await tester.tap(find.text('Continue to Permissions'));
    await tester.pumpAndSettle();

    // Step 7: Permissions Step
    expect(find.text('Health Data Sync'), findsOneWidget);
    expect(find.text('Complete Onboarding'), findsOneWidget);

    await tester.tap(find.text('Complete Onboarding'));
    await tester.pumpAndSettle();

    // Verify Onboarding State is complete at final step index 6
    expect(container.read(onboardingProvider).currentStep, equals(6));
  });
}
