import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/body_composition_estimator.dart';
import 'package:fitkarma/features/transformation/screens/body_analytics_screen.dart';

void main() {
  group('Phase 11 — Visual Body Analytics Tests (§P11-A, §P11-B, §P11-C)', () {
    const estimator = BodyCompositionEstimator();

    test(
        'BodyCompositionEstimator U.S. Navy Formula calculates accurate body fat & lean mass for male',
        () {
      final result = estimator.estimate(
        heightCm: 175.0,
        weightKg: 78.0,
        waistCm: 86.5,
        neckCm: 38.0,
        gender: 'male',
        age: 28,
      );

      expect(result.estimationMethod, equals('U.S. Navy Formula'));
      expect(result.confidence, equals('Medium (±3-4%)'));
      expect(result.bodyFatPct, greaterThanOrEqualTo(15.0));
      expect(result.bodyFatPct, lessThanOrEqualTo(25.0));
      expect(result.leanMassKg + result.fatMassKg, closeTo(78.0, 0.2));
    });

    test(
        'BodyCompositionEstimator uses BMI fallback when neck/waist measurements are absent',
        () {
      final result = estimator.estimate(
        heightCm: 175.0,
        weightKg: 78.0,
        gender: 'male',
        age: 28,
      );

      expect(result.estimationMethod, equals('BMI-based estimate'));
      expect(result.confidence, equals('Fallback (±5-6%)'));
      expect(result.bodyFatPct, greaterThan(0.0));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'BodyAnalyticsScreen renders Body Fat BentoCard, 3-month trend deltas, and biometric lock',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BodyAnalyticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Body Analytics'), findsOneWidget);
      expect(find.text('Estimated Body Fat Range'), findsOneWidget);
      expect(find.text('Lean Mass'), findsAtLeastNWidgets(1));
      expect(find.text('Fat Mass'), findsOneWidget);
      expect(find.text('3-Month Trend (Deltas)'), findsOneWidget);
      expect(find.text('Anthropometric Checkpoints'), findsOneWidget);
      expect(
          find.textContaining('§P11-B Progress Photo System'), findsOneWidget);
      expect(find.text('Authenticate to Unlock Photos'), findsOneWidget);

      final unlockBtn = find.text('Authenticate to Unlock Photos');
      await tester.ensureVisible(unlockBtn);
      await tester.tap(unlockBtn);
      await tester.pumpAndSettle();

      expect(find.text('Encrypted Progress Photos Unlocked'), findsOneWidget);
    });
  });
}
