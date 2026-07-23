import 'package:fitkarma/features/food/adaptive_hunger_controller.dart';
import 'package:fitkarma/features/food/adaptive_hunger_engine.dart';
import 'package:fitkarma/features/food/hunger_logging_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
  container: container,
  child: const MaterialApp(home: Scaffold(body: HungerLoggingDialog())),
);

void main() {
  group('AdaptiveHungerEngine Unit Tests', () {
    const engine = AdaptiveHungerEngine();

    test(
      'evaluateCravingRisk triggers 7 PM pre-emptive snacking alert on high-stress late-night sweet history',
      () {
        final historyLogs = [
          HungerCravingLog(
            id: '1',
            loggedAt: DateTime(2026, 7, 22, 21, 30),
            hungerScore: 4,
            cravingType: CravingType.sweet,
            stressLevel: 4.0,
          ),
        ];

        final ival = engine.evaluateCravingRisk(
          cravingLogs: historyLogs,
          currentStressLevel: 4.0,
          currentTime: DateTime(2026, 7, 23, 19, 0), // 7 PM
        );

        expect(ival.shouldTriggerNudge, isTrue);
        expect(ival.nudgeTitle, contains('Pre-Emptive Snacking Alert'));
        expect(ival.recommendedSnacks, isNotEmpty);
      },
    );

    test(
      'evaluateCravingRisk triggers high hunger warning when hungerScore == 5',
      () {
        final logs = [
          HungerCravingLog(
            id: '2',
            loggedAt: DateTime.now(),
            hungerScore: 5,
            cravingType: CravingType.salty,
          ),
        ];

        final ival = engine.evaluateCravingRisk(
          cravingLogs: logs,
          currentStressLevel: 2.0,
          currentTime: DateTime(2026, 7, 23, 14, 0),
        );

        expect(ival.shouldTriggerNudge, isTrue);
        expect(ival.nudgeTitle, contains('High Hunger Warning'));
      },
    );

    test(
      'evaluateCravingRisk returns shouldTriggerNudge false on normal calm days',
      () {
        final ival = engine.evaluateCravingRisk(
          cravingLogs: [],
          currentStressLevel: 1.5,
          currentTime: DateTime(2026, 7, 23, 12, 0),
        );

        expect(ival.shouldTriggerNudge, isFalse);
      },
    );
  });

  group('HungerLoggingDialog UI & Controller Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets(
      'renders HungerLoggingDialog with score selector, craving chips, and stress slider',
      (tester) async {
        await tester.pumpWidget(_buildApp(container));
        await tester.pump();

        expect(find.text('Log Hunger & Craving 🥪'), findsOneWidget);
        expect(find.byKey(const Key('hunger_score_chip_3')), findsOneWidget);
        expect(find.byKey(const Key('craving_chip_sweet')), findsOneWidget);
        expect(find.byKey(const Key('hunger_stress_slider')), findsOneWidget);
      },
    );

    testWidgets('selecting hunger score 4 and sweet craving logs to state', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      await tester.tap(find.byKey(const Key('hunger_score_chip_4')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('craving_chip_sweet')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('hunger_submit_btn')));
      await tester.pump();

      final state = container.read(hungerCravingProvider);
      expect(state.latestHungerScore, 4);
      expect(state.logs.last.cravingType, CravingType.sweet);
    });
  });
}
