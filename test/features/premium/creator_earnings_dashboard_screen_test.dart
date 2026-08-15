import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/premium/screens/creator_earnings_dashboard_screen.dart';
import 'package:fitkarma/features/premium/providers/affiliate_provider.dart';

void main() {
  testWidgets(
      'CreatorEarningsDashboardScreen renders §P13-C wireframe components properly',
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
          home: CreatorEarningsDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Title
    expect(find.text('Creator Earnings & Referral Center'), findsWidgets);

    // Balance & Payout date
    expect(find.text('Available Balance:'), findsOneWidget);
    expect(find.text('₹8420'), findsOneWidget);
    expect(find.text('Next Payout Date:'), findsOneWidget);
    expect(find.text('June 15, 2026'), findsOneWidget);

    // Lifetime Referrals
    expect(find.text('Lifetime Referrals:'), findsOneWidget);
    expect(find.text('Total Clicks:'), findsOneWidget);
    expect(find.text('4,210'), findsOneWidget);
    expect(find.text('Free Signups:'), findsOneWidget);
    expect(find.text('1,820'), findsOneWidget);
    expect(find.text('Pro Conversions:'), findsOneWidget);
    expect(find.text('214  (11.7% conversion rate)'), findsOneWidget);

    // Monthly Payout History
    expect(find.text('Monthly Payout History:'), findsOneWidget);
    expect(find.text('• May 2026:   ₹4820'), findsOneWidget);
    expect(find.text('• Apr 2026:   ₹3600'), findsOneWidget);
    expect(find.text('[✓ Paid]'), findsWidgets);

    // Actions
    expect(find.text('Request Instant Bank Transfer'), findsOneWidget);
    expect(find.text('Share Referral Link: fitkarma.com/ref/sharma10'),
        findsOneWidget);
  });

  testWidgets('Tapping Request Instant Bank Transfer triggers payout',
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
          home: CreatorEarningsDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Instant Transfer
    await tester.tap(find.text('Request Instant Bank Transfer'));
    await tester.pumpAndSettle();

    // Balance resets to ₹0
    expect(find.text('₹0'), findsOneWidget);
    expect(container.read(affiliateProvider).stats.availableBalanceInr,
        equals(0.0));
  });
}
