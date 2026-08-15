import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/health_tracking/models/sleep_debt_engine.dart';
import 'package:fitkarma/features/health_tracking/providers/sleep_provider.dart';
import 'package:fitkarma/features/health_tracking/screens/sleep_screen.dart';
import 'package:fitkarma/core/brain/sleep_engine.dart';

void main() {
  group('§P4-C Sleep Screen & Debt Modeling Tests', () {
    const engine = SleepDebtEngine();

    // ── SleepDebtEngine: calculateRolling7DayDebt ─────────────────────────

    test('calculateRolling7DayDebt: 7 nights at exactly 480 min = 0 debt', () {
      final minutes = List.filled(7, 480);
      expect(engine.calculateRolling7DayDebt(minutes), equals(0));
    });

    test('calculateRolling7DayDebt: 7 nights at 450 min = 210 min debt', () {
      // 7 × (480 − 450) = 7 × 30 = 210
      final minutes = List.filled(7, 450);
      expect(engine.calculateRolling7DayDebt(minutes), equals(210));
    });

    test('calculateRolling7DayDebt: surplus nights produce negative debt', () {
      // 7 × (480 − 510) = 7 × −30 = −210
      final minutes = List.filled(7, 510);
      expect(engine.calculateRolling7DayDebt(minutes), equals(-210));
    });

    test('calculateRolling7DayDebt: mixed nights sum correctly', () {
      // [435, 465, 410, 480, 450, 395, 435]
      // deltas: 45+15+70+0+30+85+45 = 290
      final minutes = [435, 465, 410, 480, 450, 395, 435];
      expect(engine.calculateRolling7DayDebt(minutes), equals(290));
    });

    test('calculateRolling7DayDebt: fewer than 7 entries pads with baseline',
        () {
      // 3 nights at 450 → padded with 4×480, debt = 3×30 + 4×0 = 90
      final minutes = [450, 450, 450];
      expect(engine.calculateRolling7DayDebt(minutes), equals(90));
    });

    test('calculateRolling7DayDebt: only last 7 of more than 7 entries used',
        () {
      // 8 entries: ignore first [480], use last 7 at 450
      final minutes = [480, 450, 450, 450, 450, 450, 450, 450];
      expect(engine.calculateRolling7DayDebt(minutes), equals(210));
    });

    // ── SleepDebtEngine: classifyDebt ─────────────────────────────────────

    test('classifyDebt: 0 = None', () {
      expect(engine.classifyDebt(0), equals(SleepDebtLevel.none));
    });

    test('classifyDebt: negative = None (surplus)', () {
      expect(engine.classifyDebt(-30), equals(SleepDebtLevel.none));
    });

    test('classifyDebt: 30 = Low', () {
      expect(engine.classifyDebt(30), equals(SleepDebtLevel.low));
    });

    test('classifyDebt: 60 = Low (boundary)', () {
      expect(engine.classifyDebt(60), equals(SleepDebtLevel.low));
    });

    test('classifyDebt: 61 = Moderate', () {
      expect(engine.classifyDebt(61), equals(SleepDebtLevel.moderate));
    });

    test('classifyDebt: 180 = Moderate (boundary)', () {
      expect(engine.classifyDebt(180), equals(SleepDebtLevel.moderate));
    });

    test('classifyDebt: 300 = High', () {
      expect(engine.classifyDebt(300), equals(SleepDebtLevel.high));
    });

    test('classifyDebt: 361 = Severe', () {
      expect(engine.classifyDebt(361), equals(SleepDebtLevel.severe));
    });

    // ── SleepDebtEngine: formatDebt ────────────────────────────────────────

    test('formatDebt: 0 = "0m"', () {
      expect(engine.formatDebt(0), equals('0m'));
    });

    test('formatDebt: 30 = "−30m" (owes 30 minutes)', () {
      expect(engine.formatDebt(30), equals('−30m'));
    });

    test('formatDebt: 90 = "−1h 30m"', () {
      expect(engine.formatDebt(90), equals('−1h 30m'));
    });

    test('formatDebt: 60 = "−1h" (no trailing m)', () {
      expect(engine.formatDebt(60), equals('−1h'));
    });

    test('formatDebt: −30 = "+30m" (surplus)', () {
      expect(engine.formatDebt(-30), equals('+30m'));
    });

    // ── SleepDebtEngine: classifyQuality ──────────────────────────────────

    test('classifyQuality: 7.75h/8h need + 40% restorative = excellent', () {
      final q = engine.classifyQuality(
        actualHours: 7.75,
        needHours: 8.0,
        deepPct: 0.20,
        remPct: 0.20,
      );
      expect(q, equals(SleepQuality.excellent));
    });

    test('classifyQuality: 7h/8h + 34% restorative = good', () {
      final q = engine.classifyQuality(
        actualHours: 7.0,
        needHours: 8.0,
        deepPct: 0.16,
        remPct: 0.19,
      );
      expect(q, equals(SleepQuality.good));
    });

    test('classifyQuality: 6h/8h + 25% restorative = normal', () {
      final q = engine.classifyQuality(
        actualHours: 6.0,
        needHours: 8.0,
        deepPct: 0.13,
        remPct: 0.12,
      );
      expect(q, equals(SleepQuality.normal));
    });

    test('classifyQuality: 5h/8h = fair (low duration)', () {
      final q = engine.classifyQuality(
        actualHours: 5.0,
        needHours: 8.0,
        deepPct: 0.10,
        remPct: 0.10,
      );
      expect(q, equals(SleepQuality.fair));
    });

    test('classifyQuality: 4h/8h = poor', () {
      final q = engine.classifyQuality(
        actualHours: 4.0,
        needHours: 8.0,
        deepPct: 0.05,
        remPct: 0.05,
      );
      expect(q, equals(SleepQuality.poor));
    });

    // ── SleepStageBreakdown ────────────────────────────────────────────────

    test('SleepStageBreakdown.isValid for stages summing to 1.0', () {
      const stages = SleepStageBreakdown(
        awakePct: 0.05,
        remPct: 0.20,
        lightPct: 0.55,
        deepPct: 0.20,
      );
      expect(stages.isValid, isTrue);
    });

    test('SleepStageBreakdown.dominantStage is light for spec example', () {
      const stages = SleepStageBreakdown(
        awakePct: 0.05,
        remPct: 0.20,
        lightPct: 0.55,
        deepPct: 0.20,
      );
      expect(stages.dominantStage, equals(SleepStage.light));
    });

    // ── NightSleepRecord ───────────────────────────────────────────────────

    test('NightSleepRecord.durationLabel converts 7.25h to "7h 15m"', () {
      final record = NightSleepRecord(
        date: DateTime.now(),
        totalHours: 7.25,
        quality: SleepQuality.normal,
        stages: const SleepStageBreakdown(
          awakePct: 0.05,
          remPct: 0.20,
          lightPct: 0.55,
          deepPct: 0.20,
        ),
      );
      expect(record.durationLabel, equals('7h 15m'));
      expect(record.totalMinutes, equals(435));
    });

    // ── SleepNotifier ──────────────────────────────────────────────────────

    test('SleepNotifier initializes with last night = 7h 15m', () {
      final notifier = SleepNotifier(
        const SleepDebtEngine(),
        const SleepEngine(),
      );
      expect(notifier.state.lastNight.totalHours, equals(7.25));
      expect(notifier.state.lastNight.durationLabel, equals('7h 15m'));
    });

    test('SleepNotifier initializes with 7 HRV data points', () {
      final notifier = SleepNotifier(
        const SleepDebtEngine(),
        const SleepEngine(),
      );
      expect(notifier.state.hrvTrend, hasLength(7));
    });

    test('SleepNotifier.debtMinutes matches expected rolling sum', () {
      final notifier = SleepNotifier(
        const SleepDebtEngine(),
        const SleepEngine(),
      );
      // weekly: [435, 465, 410, 480, 450, 395, 435] → sum of (480−x) = 290
      expect(notifier.state.debtMinutes, equals(290));
      expect(notifier.state.debtLevel, equals(SleepDebtLevel.high));
    });

    test('SleepNotifier.logSleep with 8h updates debt toward surplus', () {
      final notifier = SleepNotifier(
        const SleepDebtEngine(),
        const SleepEngine(),
      );
      final prevDebt = notifier.state.debtMinutes;

      notifier.logSleep(
        hours: 8.5,
        stages: const SleepStageBreakdown(
          awakePct: 0.05,
          remPct: 0.22,
          lightPct: 0.52,
          deepPct: 0.21,
        ),
      );

      // Debt should decrease (more sleep = less debt)
      expect(notifier.state.debtMinutes, lessThan(prevDebt));
      expect(notifier.state.performance, isNotNull);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('SleepScreen renders "Sleep OS" title', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SleepScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sleep OS'), findsOneWidget);
    });

    testWidgets('SleepScreen shows last night duration in hero',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SleepScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('7h 15m'), findsWidgets);
    });

    testWidgets('SleepScreen shows Sleep Stages section', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SleepScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sleep Stages', skipOffstage: false), findsOneWidget);
    });

    testWidgets('SleepScreen shows all 4 stage legend chips', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SleepScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Awake:', skipOffstage: false), findsOneWidget);
      expect(find.textContaining('REM:', skipOffstage: false), findsOneWidget);
      expect(
          find.textContaining('Light:', skipOffstage: false), findsOneWidget);
      expect(find.textContaining('Deep:', skipOffstage: false), findsOneWidget);
    });

    testWidgets('SleepScreen shows HRV Trend section', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SleepScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('7-Day HRV Trend', skipOffstage: false), findsOneWidget);
    });

    testWidgets('SleepScreen shows debt chip with level label', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SleepScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Sleep Debt:', skipOffstage: false),
          findsOneWidget);
    });
  });
}
