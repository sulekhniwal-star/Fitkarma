import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/daily_mission/models/soreness_models.dart';
import 'package:fitkarma/features/daily_mission/providers/recovery_log_provider.dart';
import 'package:fitkarma/features/daily_mission/screens/recovery_log_screen.dart';

void main() {
  group('RecoveryLogScreen & Notifier Tests (§P2-C)', () {
    test('SorenessState composite score calculation', () {
      final state0 = SorenessState.initial();
      expect(state0.compositeSorenessValue, equals(1)); // Fresh

      final stateMild = SorenessState(
        sorenessMap: {
          ...state0.sorenessMap,
          MuscleGroup.chest: SorenessSeverity.mild,
        },
      );
      expect(stateMild.compositeSorenessValue, equals(2)); // 1 pt -> 2

      final stateSevere = SorenessState(
        sorenessMap: {
          ...state0.sorenessMap,
          MuscleGroup.chest: SorenessSeverity.severe,
          MuscleGroup.quads: SorenessSeverity.severe,
          MuscleGroup.shoulders: SorenessSeverity.moderate,
        },
      );
      // 3 + 3 + 2 = 8 pts -> 4
      expect(stateSevere.compositeSorenessValue, equals(4));
    });

    test('RecoveryLogNotifier state updates and readiness recalculation', () {
      final notifier = RecoveryLogNotifier();
      expect(notifier.state.readinessScore, greaterThan(0));

      notifier.toggleMuscleSoreness(MuscleGroup.chest);
      expect(notifier.state.soreness.sorenessMap[MuscleGroup.chest],
          equals(SorenessSeverity.mild));

      notifier.commitLog();
      expect(notifier.state.isCommitted, isTrue);
    });

    testWidgets('RecoveryLogScreen renders body soreness map & HRV trend',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RecoveryLogScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check Recovery Score & Header
      expect(find.textContaining('Recovery Score:'), findsOneWidget);
      expect(find.text('Optimal Capacity'), findsOneWidget);

      // Check Body Soreness Map section
      expect(find.text('Interactive Soreness Map'), findsOneWidget);
      expect(find.text('Front'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);

      // Check HRV Trend section
      expect(find.textContaining('HRV Trend'), findsOneWidget);

      // Check Commit button
      expect(find.text('COMMIT RECOVERY LOG'), findsOneWidget);

      // Tap Commit button (ensure visible in scrollable)
      await tester.ensureVisible(find.text('COMMIT RECOVERY LOG'));
      await tester.tap(find.text('COMMIT RECOVERY LOG'));
      await tester.pumpAndSettle();

      expect(find.text('✓ LOG COMMITTED'), findsOneWidget);
    });
  });
}
