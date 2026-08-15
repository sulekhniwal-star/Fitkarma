import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/health_tracking/models/steps_sync_engine.dart';
import 'package:fitkarma/features/health_tracking/providers/steps_provider.dart';
import 'package:fitkarma/features/health_tracking/screens/steps_screen.dart';

void main() {
  group('§P4-B Steps Screen & Auto-Detection Sync Engine Tests', () {
    const engine = StepsSyncEngine();

    // ── Engine: deriveMetrics ────────────────────────────────────────────────

    test('deriveMetrics computes correct distance for 8420 steps', () {
      final m = engine.deriveMetrics(steps: 8420, goalSteps: 10000);
      // 8420 × 0.762m = 6.416km → rounded to 1dp = 6.4
      expect(m.distanceKm, closeTo(6.4, 0.1));
    });

    test('deriveMetrics computes active minutes: ~100 steps/min', () {
      final m = engine.deriveMetrics(steps: 5000, goalSteps: 10000);
      expect(m.activeMinutes, equals(50));
    });

    test('deriveMetrics computes calories burned (~0.04 kcal/step)', () {
      final m = engine.deriveMetrics(steps: 10000, goalSteps: 10000);
      expect(m.caloriesBurned, equals(400));
    });

    test('deriveMetrics progressFraction clamps at 1.0 beyond goal', () {
      final m = engine.deriveMetrics(steps: 12000, goalSteps: 10000);
      expect(m.progressFraction, equals(1.0));
    });

    test('deriveMetrics progressFraction is correct at 0 steps', () {
      final m = engine.deriveMetrics(steps: 0, goalSteps: 10000);
      expect(m.progressFraction, equals(0.0));
      expect(m.caloriesBurned, equals(0));
    });

    // ── Engine: buildHourlyDistribution ─────────────────────────────────────

    test('buildHourlyDistribution always returns 24 buckets', () {
      final buckets = engine.buildHourlyDistribution({8: 1200, 12: 800});
      expect(buckets, hasLength(24));
    });

    test('buildHourlyDistribution assigns 0 for hours not in input', () {
      final buckets = engine.buildHourlyDistribution({9: 500});
      final hour0 = buckets.firstWhere((b) => b.hour == 0);
      expect(hour0.steps, equals(0));
    });

    test('buildHourlyDistribution correctly maps hour 9 to 500 steps', () {
      final buckets = engine.buildHourlyDistribution({9: 500});
      final hour9 = buckets.firstWhere((b) => b.hour == 9);
      expect(hour9.steps, equals(500));
    });

    // ── Engine: syncStepsWithDeviceHealth ────────────────────────────────────

    test('syncStepsWithDeviceHealth writes to Drift when delta exists',
        () async {
      int? writtenSteps;
      final result = await engine.syncStepsWithDeviceHealth(
        readFromPlatform: (_, __) async => 9000,
        readFromDrift: (_) async => 8420, // cached
        writeToDrift: (_, steps) async => writtenSteps = steps,
      );

      expect(result, equals(9000));
      expect(writtenSteps, equals(9000));
    });

    test('syncStepsWithDeviceHealth skips Drift write when no delta', () async {
      bool written = false;
      final result = await engine.syncStepsWithDeviceHealth(
        readFromPlatform: (_, __) async => 8420,
        readFromDrift: (_) async => 8420, // same as platform
        writeToDrift: (_, __) async => written = true,
      );

      expect(result, isNull);
      expect(written, isFalse);
    });

    test('syncStepsWithDeviceHealth returns null when platform unavailable',
        () async {
      final result = await engine.syncStepsWithDeviceHealth(
        readFromPlatform: (_, __) async => null, // HealthConnect unavailable
        readFromDrift: (_) async => 5000,
        writeToDrift: (_, __) async {},
      );

      expect(result, isNull);
    });

    test('syncStepsWithDeviceHealth writes when no Drift cache exists',
        () async {
      int? writtenSteps;
      final result = await engine.syncStepsWithDeviceHealth(
        readFromPlatform: (_, __) async => 3500,
        readFromDrift: (_) async => null, // first sync today
        writeToDrift: (_, steps) async => writtenSteps = steps,
      );

      expect(result, equals(3500));
      expect(writtenSteps, equals(3500));
    });

    // ── Engine: generateCoachNudge ───────────────────────────────────────────

    test('generateCoachNudge says goal achieved when at 100%', () {
      final nudge = engine.generateCoachNudge(
        currentSteps: 10000,
        goalSteps: 10000,
        activeMinutes: 60,
      );
      expect(nudge, contains('Goal achieved'));
    });

    test('generateCoachNudge references remaining minutes at 85%+ progress',
        () {
      final nudge = engine.generateCoachNudge(
        currentSteps: 8700,
        goalSteps: 10000,
        activeMinutes: 52,
      );
      // 1300 remaining / 100 steps/min ≈ 13-minute walk
      expect(nudge, contains('minute walk'));
    });

    test('generateCoachNudge flags sedentary when below 20 active minutes', () {
      final nudge = engine.generateCoachNudge(
        currentSteps: 1200,
        goalSteps: 10000,
        activeMinutes: 10,
      );
      expect(nudge.toLowerCase(), contains('sedentary'));
    });

    // ── StepsRecord: progressFraction & remainingSteps ───────────────────────

    test('StepsSyncRecord.progressFraction is correct', () {
      final record = StepsSyncRecord(
        date: DateTime.now(),
        totalSteps: 5000,
        stepGoal: 10000,
        distanceKm: 3.8,
        activeMinutes: 50,
        caloriesBurned: 200,
        lastSyncedAt: DateTime.now(),
      );
      expect(record.progressFraction, equals(0.5));
      expect(record.remainingSteps, equals(5000));
    });

    test('StepsSyncRecord.remainingSteps clamps at 0 when goal exceeded', () {
      final record = StepsSyncRecord(
        date: DateTime.now(),
        totalSteps: 11000,
        stepGoal: 10000,
        distanceKm: 8.4,
        activeMinutes: 110,
        caloriesBurned: 440,
        lastSyncedAt: DateTime.now(),
      );
      expect(record.progressFraction, equals(1.0));
      expect(record.remainingSteps, equals(0));
    });

    // ── StepsNotifier ────────────────────────────────────────────────────────

    test('StepsNotifier initializes with sample data and synced status', () {
      final notifier = StepsNotifier(const StepsSyncEngine());
      expect(notifier.state.record.totalSteps, equals(8420));
      expect(notifier.state.record.syncStatus, equals(SyncStatus.synced));
      expect(notifier.state.coachNudge, isNotEmpty);
    });

    test('StepsNotifier.logManualSteps updates steps and regenerates nudge',
        () {
      final notifier = StepsNotifier(const StepsSyncEngine());
      notifier.logManualSteps(10000);

      expect(notifier.state.record.totalSteps, equals(10000));
      expect(notifier.state.coachNudge, contains('Goal achieved'));
    });

    test('StepsNotifier.triggerSync updates steps to 8850 (simulated delta)',
        () async {
      final notifier = StepsNotifier(const StepsSyncEngine());
      await notifier.triggerSync();

      expect(notifier.state.record.totalSteps, equals(8850));
      expect(notifier.state.record.syncStatus, equals(SyncStatus.synced));
      expect(notifier.state.isSyncing, isFalse);
    });

    test('StepsNotifier.triggerSync sets isSyncing=false after completion',
        () async {
      final notifier = StepsNotifier(const StepsSyncEngine());
      final future = notifier.triggerSync();
      await future;
      expect(notifier.state.isSyncing, isFalse);
    });

    // ── Widget Tests ─────────────────────────────────────────────────────────

    testWidgets('StepsScreen renders AppBar with "Steps Tracker"',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Steps Tracker'), findsOneWidget);
    });

    testWidgets('StepsScreen renders Daily Progress card', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Daily Progress'), findsOneWidget);
    });

    testWidgets('StepsScreen renders stat row (Distance, Active, Calories)',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Distance'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
    });

    testWidgets('StepsScreen renders Hourly Step Distribution section',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hourly Step Distribution'), findsOneWidget);
    });

    testWidgets('StepsScreen renders Coach insight card', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Coach'), findsOneWidget);
    });

    testWidgets('StepsScreen shows Sync chip in AppBar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Sync:'), findsOneWidget);
    });

    testWidgets('Tapping Sync button triggers sync and shows updated status',
        (tester) async {
      // Expand viewport so DataSourceCard is fully visible
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to the Sync button (DataSourceCard is near bottom)
      await tester.scrollUntilVisible(find.text('Sync'), 100);
      await tester.pumpAndSettle();

      // Tap Sync
      await tester.tap(find.text('Sync'));
      await tester.pump(const Duration(milliseconds: 50));

      // During sync: circular progress shows in the Sync chip
      expect(find.byType(CircularProgressIndicator, skipOffstage: false),
          findsWidgets);

      // After sync completes
      await tester.pumpAndSettle(const Duration(milliseconds: 600));
      expect(find.textContaining('Synced', skipOffstage: false), findsWidgets);
    });
  });
}
