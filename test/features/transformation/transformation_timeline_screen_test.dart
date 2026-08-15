import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/transformation/providers/transformation_journey_provider.dart';
import 'package:fitkarma/features/transformation/screens/transformation_timeline_screen.dart';

void main() {
  group('§P8-B Transformation Timeline Screen & Notifier Tests', () {
    test(
        'TransformationJourneyNotifier calculates 90-day prediction bounds (ADR-025)',
        () {
      final container = ProviderContainer();
      final state = container.read(transformationJourneyProvider);

      expect(state.weightHistory.isNotEmpty, isTrue);
      expect(state.arePhotosUnlocked, isFalse);
      expect(state.projectedWeightMin, lessThan(72.0));
      expect(state.projectedWeightMax, lessThanOrEqualTo(72.0));
      expect(state.completedProgramWeeks, equals(11));

      container.dispose();
    });

    test(
        'authenticateBiometrics unlocks progress photos when authentication succeeds',
        () {
      final container = ProviderContainer();
      final notifier = container.read(transformationJourneyProvider.notifier);

      notifier.authenticateBiometrics(mockSuccess: true);
      expect(container.read(transformationJourneyProvider).arePhotosUnlocked,
          isTrue);

      container.dispose();
    });

    test(
        'addWeightCheckpoint updates weight history and recalculates projected bounds',
        () {
      final container = ProviderContainer();
      final notifier = container.read(transformationJourneyProvider.notifier);

      notifier.addWeightCheckpoint(70.0);

      final state = container.read(transformationJourneyProvider);
      expect(state.weightHistory.last.weightKg, equals(70.0));
      expect(state.projectedWeightMin, lessThan(70.0));

      container.dispose();
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'TransformationTimelineScreen renders weight projection BentoCard, forecast stats, and biometric photo lock',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: TransformationTimelineScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Transformation Journey'), findsOneWidget);
      expect(find.text('Weight Projection & 90-Day Range'), findsOneWidget);
      expect(find.textContaining('Projected Zone:'), findsOneWidget);
      expect(find.text('Target Prediction (At Current Pace):'), findsOneWidget);
      expect(find.textContaining('Secure Progress Photos'), findsOneWidget);
      expect(find.text('Tap to Unlock Photos'), findsOneWidget);

      // Tap biometric unlock button
      await tester.tap(find.text('Tap to Unlock Photos'));
      await tester.pumpAndSettle();

      expect(find.text('Week 1'), findsOneWidget);
      expect(find.text('Week 4'), findsOneWidget);
      expect(find.text('Week 8'), findsOneWidget);
    });
  });
}
