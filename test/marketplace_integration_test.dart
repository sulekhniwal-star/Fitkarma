/// §P13-B Creator & Coach Marketplace — Unit, Integration & Widget Tests

import 'package:fitkarma/features/marketplace/coach_matching_engine.dart';
import 'package:fitkarma/features/marketplace/marketplace_azure_service.dart';
import 'package:fitkarma/features/marketplace/marketplace_controller.dart';
import 'package:fitkarma/features/marketplace/marketplace_models.dart';
import 'package:fitkarma/features/marketplace/marketplace_store_screen.dart';
import 'package:fitkarma/features/marketplace/royalty_distribution_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const matchingEngine = CoachMatchingEngine();
  const royaltyEngine = RoyaltyDistributionEngine();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: MarketplaceStoreScreen(),
      ),
    );
  }

  group('§P13-B CoachMatchingEngine Unit Tests', () {
    test('ranks coaches with PCOS management specialty higher for PCOS goals', () {
      final coaches = MarketplaceAzureService.seedCoaches;
      final matches = matchingEngine.match(
        clientGoals: ['pcos', 'weight_loss'],
        allCoaches: coaches,
      );

      expect(matches, isNotEmpty);
      expect(matches.first.coach.creatorId, equals('coach_1')); // Dr. Ananya (PCOS specialist)
      expect(matches.first.matchScore, greaterThan(80.0));
    });
  });

  group('§P13-B RoyaltyDistributionEngine Unit Tests (ADR-040 Split)', () {
    test('calculates 80/20 platform fee split correctly', () {
      final split = royaltyEngine.calculateSplit(1000.0);

      expect(split.grossAmountInr, equals(1000.0));
      expect(split.creatorEarningsInr, equals(800.0)); // 80%
      expect(split.platformFeeInr, equals(200.0)); // 20%
    });

    test('records transaction and updates wallet ledger balance', () {
      const initialWallet = WalletLedger(
        walletId: 'w_1',
        creatorId: 'c_1',
        balanceInr: 1000.0,
        totalEarningsInr: 1000.0,
        pendingPayoutInr: 1000.0,
        entries: [],
      );

      final updatedWallet = royaltyEngine.recordTransaction(
        currentWallet: initialWallet,
        transactionType: 'program_sale',
        grossAmountInr: 500.0, // 80% = +400 INR
      );

      expect(updatedWallet.balanceInr, equals(1400.0));
      expect(updatedWallet.entries.length, equals(1));
      expect(updatedWallet.entries.first.creatorEarningsInr, equals(400.0));
      expect(updatedWallet.entries.first.platformFeeInr, equals(100.0));
    });
  });

  group('§P13-B MarketplaceNotifier & Azure Function Bridge Integration Tests', () {
    test('onboardCreator adds new verified coach and updates matches', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(marketplaceProvider.notifier);

      notifier.onboardCreator(
        name: 'Coach Priya',
        bio: 'Marathon runner & endurance trainer',
        certifications: ['ACE CPT'],
        specialties: [CoachSpecialty.runningMarathon],
        rateInr: 1999.0,
      );

      final state = container.read(marketplaceProvider);

      expect(state.isCoachOnboarded, isTrue);
      expect(state.coaches.any((c) => c.name == 'Coach Priya'), isTrue);
      expect(state.successMessage, contains('Verified Creator Profile created'));
    });

    test('hireCoach creates assignment and credits 80% split to wallet', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(marketplaceProvider.notifier);
      final initialBalance = container.read(marketplaceProvider).creatorWallet.balanceInr;

      await notifier.hireCoach('coach_1');
      final state = container.read(marketplaceProvider);

      expect(state.activeAssignments, isNotEmpty);
      expect(state.creatorWallet.balanceInr, equals(initialBalance + (2999.0 * 0.8)));
      expect(state.successMessage, contains('80% split credited'));
    });

    test('purchaseProgram credits 80/20 royalty split via wallet ledger', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(marketplaceProvider.notifier);
      final program = MarketplaceAzureService.seedPrograms.first; // ₹499
      final initialBalance = container.read(marketplaceProvider).creatorWallet.balanceInr;

      notifier.purchaseProgram(program);
      final state = container.read(marketplaceProvider);

      expect(state.creatorWallet.balanceInr, equals(initialBalance + (499.0 * 0.8)));
      expect(state.successMessage, contains('Purchased'));
    });
  });

  group('§P13-B MarketplaceStoreScreen Widget Tests', () {
    testWidgets('renders Marketplace title, tabs, matched coaches, and program store', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('🏛️ Creator & Coach Marketplace'), findsOneWidget);
      expect(find.text('🎯 Coaches'), findsOneWidget);
      expect(find.text('📦 Program Store'), findsOneWidget);
      expect(find.text('💼 Wallet (80/20)'), findsOneWidget);
      expect(find.text('Dr. Ananya Sharma'), findsOneWidget);

      // Switch to Program Store tab
      await tester.tap(find.text('📦 Program Store'));
      await tester.pumpAndSettle();

      expect(find.text('📦 Program Store (Creator Blueprints)'), findsOneWidget);
      expect(find.text('8-Week PCOS & Hormonal Balance Reset'), findsOneWidget);
    });

    testWidgets('taps Hire Coach and verifies SnackBar feedback', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hire Coach').first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Hired Dr. Ananya Sharma'), findsOneWidget);
    });
  });
}
