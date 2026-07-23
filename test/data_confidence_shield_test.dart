import 'package:fitkarma/features/food/data_confidence_shield_banner.dart';
import 'package:fitkarma/features/food/data_confidence_shield_controller.dart';
import 'package:fitkarma/features/food/data_confidence_shield_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
  container: container,
  child: const MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(child: DataConfidenceShieldBanner()),
    ),
  ),
);

void main() {
  group('DataConfidenceShieldEngine Unit Tests', () {
    const engine = DataConfidenceShieldEngine();
    final now = DateTime.now();

    test(
      '100% full compliance (7/7 days valid logging, protein, water) yields 100% reliability (isLockoutActive = false)',
      () {
        final logs = List.generate(
          7,
          (i) => DailyLogQualityRecord(
            date: now.subtract(Duration(days: i)),
            mealsLoggedCount: 3,
            wasProteinTargetMet: true,
            wasWaterTargetMet: true,
          ),
        );

        final result = engine.evaluateLoggingQuality(past7DayLogs: logs);

        expect(result.reliabilityScorePct, 100.0);
        expect(result.isLockoutActive, isFalse);
        expect(result.statusTier, contains('High Confidence'));
        expect(result.shieldMessage, contains('targets unlocked'));
      },
    );

    test(
      'Low compliance (<70%) triggers target lockout and low-confidence warning',
      () {
        final lowLogs = List.generate(
          7,
          (i) => DailyLogQualityRecord(
            date: now.subtract(Duration(days: i)),
            mealsLoggedCount: i < 3 ? 3 : 1, // Only 3 days valid
            wasProteinTargetMet: i < 2, // 2 days protein
            wasWaterTargetMet: i < 2, // 2 days water
          ),
        );

        final result = engine.evaluateLoggingQuality(past7DayLogs: lowLogs);

        // (3/7 * 40) + (2/7 * 30) + (2/7 * 30) = 17.14 + 8.57 + 8.57 = 34.3%
        expect(result.reliabilityScorePct, lessThan(70.0));
        expect(result.isLockoutActive, isTrue);
        expect(result.statusTier, contains('Target Lock Active'));
        expect(result.shieldMessage, contains('Metabolic target lock active'));
      },
    );

    test(
      'Weight plateau with low compliance displays explicit plateau safety message',
      () {
        final lowLogs = List.generate(
          7,
          (i) => DailyLogQualityRecord(
            date: now.subtract(Duration(days: i)),
            mealsLoggedCount: 2,
            wasProteinTargetMet: false,
            wasWaterTargetMet: true,
          ),
        );

        final result = engine.evaluateLoggingQuality(
          past7DayLogs: lowLogs,
          weightPlateauWeeks: 3.0,
        );

        expect(result.isLockoutActive, isTrue);
        expect(result.shieldMessage, contains('weight loss has plateaued'));
        expect(
          result.shieldMessage,
          contains('cannot safely lower your calories'),
        );
      },
    );
  });

  group('DataConfidenceShieldBanner UI & Controller Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets(
      'renders DataConfidenceShieldBanner with reliability score text and badge',
      (tester) async {
        await tester.pumpWidget(_buildApp(container));
        await tester.pump();

        expect(
          find.byKey(const Key('data_confidence_shield_banner')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('shield_reliability_score_text')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('shield_lockout_badge')), findsOneWidget);
      },
    );

    testWidgets('updating logs to full compliance unlocks target lock badge', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      final now = DateTime.now();
      final fullLogs = List.generate(
        7,
        (i) => DailyLogQualityRecord(
          date: now.subtract(Duration(days: i)),
          mealsLoggedCount: 3,
          wasProteinTargetMet: true,
          wasWaterTargetMet: true,
        ),
      );

      container
          .read(dataConfidenceShieldProvider.notifier)
          .updateLogs(fullLogs);
      await tester.pump();

      final state = container.read(dataConfidenceShieldProvider);
      expect(state.result.isLockoutActive, isFalse);
      expect(find.textContaining('Unlocked'), findsOneWidget);
    });
  });
}
