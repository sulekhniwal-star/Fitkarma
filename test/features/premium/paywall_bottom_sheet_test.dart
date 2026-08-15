import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/premium/screens/paywall_bottom_sheet.dart';
import 'package:fitkarma/features/premium/models/subscription_model.dart';
import 'package:fitkarma/features/premium/providers/premium_provider.dart';

void main() {
  testWidgets(
      'PaywallBottomSheet renders §P13-A wireframe layout and India pricing',
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
          home: Scaffold(
            body: PaywallBottomSheet(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Header
    expect(find.text('Unlock FitKarma Pro'), findsOneWidget);
    expect(
        find.text('Supercharge your health journey with Pro:'), findsOneWidget);

    // Feature Checkmarks
    expect(find.text('Unlimited AI Coach Chats'), findsOneWidget);
    expect(find.text('90-Day Predictive Health Insights & Charts'),
        findsOneWidget);
    expect(find.text('Comprehensive Monthly Health Reports'), findsOneWidget);
    expect(find.text('Advanced Body Composition & Measurements Engine'),
        findsOneWidget);
    expect(find.text('Unlimited Meal Photo Analyses'), findsOneWidget);
    expect(find.text('Squad Creation & Challenge Host'), findsOneWidget);

    // Pricing Cards
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('₹299 / month'), findsOneWidget);

    expect(find.text('Quarterly'), findsOneWidget);
    expect(find.text('₹699 / quarter'), findsOneWidget);
    expect(find.text('Saves 22%'), findsOneWidget);

    expect(find.text('Annual'), findsOneWidget);
    expect(find.text('₹1,999 / year'), findsOneWidget);
    expect(find.text('Saves 44% (Best Value)'), findsOneWidget);

    // Actions
    expect(find.textContaining('Start Free Trial'), findsOneWidget);
    expect(find.text('Continue with Free Plan'), findsOneWidget);
  });

  testWidgets('Selecting a pricing plan updates selectedPackage and CTA price',
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
          home: Scaffold(
            body: PaywallBottomSheet(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Default CTA is annual (₹1,999 / year)
    expect(find.text('Start Free Trial (₹1,999 / year)'), findsOneWidget);

    // Tap Monthly plan
    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();

    expect(find.text('Start Free Trial (₹299 / month)'), findsOneWidget);
  });

  testWidgets(
      'PaywallBottomSheet displays trigger banner when trigger is provided',
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
          home: Scaffold(
            body: PaywallBottomSheet(trigger: PaywallTrigger.squadCreation),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Squad creation is a Pro feature (Free tier: Join only)'),
      findsOneWidget,
    );
  });
}
