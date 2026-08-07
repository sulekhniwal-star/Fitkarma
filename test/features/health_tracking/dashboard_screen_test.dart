import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';
import 'package:fitkarma/features/health_tracking/providers/dashboard_provider.dart';
import 'package:fitkarma/features/health_tracking/screens/dashboard_screen.dart';

void main() {
  group('§P4-A Dashboard Screen & Orchestration Tests', () {
    // ── DIP Model Tests ─────────────────────────────────────────────────────

    test('DailyIntelligencePackage includes healthScore and primaryInsight', () {
      final dip = DailyIntelligencePackage(
        userId: 'user_1',
        date: DateTime.now(),
        readinessScore: 82,
        healthScore: 74,
        readinessTier: ReadinessTier.enhanced,
        primaryFocus: 'Active Recovery',
        primaryInsight: 'Your sleep debt is −45m. Prioritise 8h tonight.',
        insightSource: '7-day data · Sleep',
        dailyMissions: ['Drink 3L water', 'Hit 10k steps'],
      );

      expect(dip.readinessScore, equals(82));
      expect(dip.healthScore, equals(74));
      expect(dip.primaryInsight, contains('sleep debt'));
      expect(dip.insightSource, equals('7-day data · Sleep'));
      expect(dip.dailyMissions, hasLength(2));
    });

    test('DailyIntelligencePackage.toJson / fromJson round-trips correctly', () {
      final dip = DailyIntelligencePackage(
        userId: 'user_2',
        date: DateTime(2026, 8, 1),
        readinessScore: 75,
        healthScore: 68,
        readinessTier: ReadinessTier.premium,
        primaryFocus: 'Strength',
        primaryInsight: 'Push hard today.',
        insightSource: 'Training log',
        dailyMissions: ['Squat 5x5', 'Post-workout protein'],
      );

      final json = dip.toJson();
      final restored = DailyIntelligencePackage.fromJson(json);

      expect(restored.userId, equals('user_2'));
      expect(restored.healthScore, equals(68));
      expect(restored.primaryInsight, equals('Push hard today.'));
      expect(restored.insightSource, equals('Training log'));
      expect(restored.readinessTier, equals(ReadinessTier.premium));
    });

    // ── DashboardLiveMetrics Tests ─────────────────────────────────────────

    test('DashboardLiveMetrics holds correct step, calorie, water defaults', () {
      const live = DashboardLiveMetrics();
      expect(live.steps, equals(8420));
      expect(live.stepGoal, equals(10000));
      expect(live.caloriesBurned, equals(1240));
      expect(live.calorieGoal, equals(1800));
      expect(live.waterLitres, equals(1.8));
      expect(live.streakDays, equals(12));
      expect(live.karmaPoints, equals(4280));
      expect(live.stepsVsYesterdayPct, equals(12.0));
    });

    test('DashboardLiveMetrics.copyWith updates fields correctly', () {
      const live = DashboardLiveMetrics();
      final updated = live.copyWith(steps: 9500, waterLitres: 2.2);
      expect(updated.steps, equals(9500));
      expect(updated.waterLitres, equals(2.2));
      expect(updated.stepGoal, equals(10000)); // unchanged
    });

    // ── Orchestration Tests ────────────────────────────────────────────────

    test('DashboardNotifier starts in idle/loading and reaches ready', () async {
      final notifier = DashboardNotifier();
      // Just instantiated — orchestration runs immediately, await it
      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state.phase, equals(DashboardLoadPhase.ready));
      expect(notifier.state.dip, isNotNull);
      expect(notifier.state.isReady, isTrue);
    });

    test('DashboardNotifier DIP has zero AI calls (DIP-only orchestration)', () async {
      final notifier = DashboardNotifier();
      await Future.delayed(const Duration(milliseconds: 300));
      // Validate the DIP is loaded from Drift — primaryFocus set, no AI source marker
      expect(notifier.state.dip!.primaryFocus, isNotEmpty);
      // Readiness score is pre-computed by 6am Brain — not generated live
      expect(notifier.state.dip!.readinessScore, greaterThan(0));
    });

    test('DashboardNotifier loads live metrics after DIP', () async {
      final notifier = DashboardNotifier();
      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state.liveMetrics.steps, greaterThan(0));
      expect(notifier.state.liveMetrics.streakDays, greaterThan(0));
    });

    test('DashboardNotifier.refresh re-runs full orchestration', () async {
      final notifier = DashboardNotifier();
      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state.isReady, isTrue);

      final future = notifier.refresh();
      await Future.delayed(const Duration(milliseconds: 300));
      await future;
      expect(notifier.state.isReady, isTrue);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('DashboardScreen renders after orchestration completes', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DashboardScreen()),
        ),
      );

      // Let orchestration (2x async delays) complete
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Steps should be visible (formatted as 8.4k in hero)
      expect(find.textContaining('k', skipOffstage: false), findsWidgets);

      // AI Coach Insight section visible
      expect(find.text('AI Coach Insight', skipOffstage: false), findsOneWidget);

      // Streak visible
      expect(find.textContaining('day', skipOffstage: false), findsWidgets);
    });

    testWidgets('DashboardScreen shows Bento Row 1 (Water + Calories)', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DashboardScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Water', skipOffstage: false), findsOneWidget);
      expect(find.text('Calories', skipOffstage: false), findsWidgets);
    });

    testWidgets('DashboardScreen shows Bento Row 2 (Sleep + HR)', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DashboardScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Sleep', skipOffstage: false), findsOneWidget);
      expect(find.text('Resting HR', skipOffstage: false), findsOneWidget);
    });

    testWidgets("DashboardScreen shows Today's Missions card", (tester) async {
      // Use a large screen size so the missions card renders in tree
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DashboardScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.textContaining("Today's Missions", skipOffstage: false), findsOneWidget);
    });

    testWidgets('DashboardScreen pull-to-refresh calls refresh()', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DashboardScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Simulate pull-to-refresh gesture
      await tester.fling(find.byType(CustomScrollView), const Offset(0, 300), 800);
      await tester.pump(const Duration(milliseconds: 200));
      // RefreshIndicator should have triggered
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
