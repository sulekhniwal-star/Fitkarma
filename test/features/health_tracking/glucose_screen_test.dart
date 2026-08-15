import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/health_tracking/models/glucose_engine.dart';
import 'package:fitkarma/features/health_tracking/providers/glucose_provider.dart';
import 'package:fitkarma/features/health_tracking/screens/glucose_screen.dart';

void main() {
  group('§P4-E Glucose Screen & HbA1c Estimation Tests', () {
    const engine = GlucoseEngine();

    // ── GlucoseEngine Unit Tests ─────────────────────────────────────────────

    test('categorizeGlucose: Fasting category thresholds', () {
      expect(GlucoseEngine.categorizeGlucose(95, GlucoseContextTag.fasting),
          equals(GlucoseCategory.normal));
      expect(GlucoseEngine.categorizeGlucose(105, GlucoseContextTag.fasting),
          equals(GlucoseCategory.elevated));
      expect(GlucoseEngine.categorizeGlucose(130, GlucoseContextTag.fasting),
          equals(GlucoseCategory.high));
    });

    test('categorizeGlucose: Post-meal category thresholds', () {
      expect(GlucoseEngine.categorizeGlucose(120, GlucoseContextTag.postMeal1h),
          equals(GlucoseCategory.normal));
      expect(GlucoseEngine.categorizeGlucose(155, GlucoseContextTag.postMeal1h),
          equals(GlucoseCategory.elevated));
      expect(GlucoseEngine.categorizeGlucose(210, GlucoseContextTag.postMeal2h),
          equals(GlucoseCategory.critical));
    });

    test(
        'calculateEstimatedHba1c: mathematical formula calculation ((Avg + 46.7) / 28.7)',
        () {
      final records = [
        GlucoseRecord(
            mgDl: 100,
            tag: GlucoseContextTag.fasting,
            measuredAt: DateTime.now()),
        GlucoseRecord(
            mgDl: 140,
            tag: GlucoseContextTag.postMeal1h,
            measuredAt: DateTime.now()),
      ];
      // Avg = 120 mg/dL → HbA1c = (120 + 46.7)/28.7 = 5.808 -> 5.8%
      final result =
          engine.calculateEstimatedHba1c(records: records, totalLoggedDays: 95);

      expect(result.averageGlucoseMgDl, equals(120.0));
      expect(result.estimatedHba1cPct, equals(5.8));
      expect(result.isSufficientData, isTrue);
      expect(result.statusLabel, contains('Pre-diabetic'));
    });

    test('calculateEstimatedHba1c: requires >= 90 days of logs per spec', () {
      final records = [
        GlucoseRecord(
            mgDl: 95,
            tag: GlucoseContextTag.fasting,
            measuredAt: DateTime.now()),
      ];
      final result =
          engine.calculateEstimatedHba1c(records: records, totalLoggedDays: 45);

      expect(result.isSufficientData, isFalse);
      expect(result.statusLabel, contains('requires >= 90 days'));
    });

    test('detectMealSpikeNudge: detects spike >= 140 mg/dL after meal', () {
      final records = [
        GlucoseRecord(
          mgDl: 155,
          tag: GlucoseContextTag.postMeal1h,
          measuredAt: DateTime.now(),
          correlatedMealName: 'Masala Dosa',
        ),
      ];

      final nudge = engine.detectMealSpikeNudge(records);
      expect(nudge, isNotNull);
      expect(nudge, contains('Masala Dosa'));
      expect(nudge, contains('Glycemic spike'));
    });

    // ── Notifier Unit Tests ──────────────────────────────────────────────────

    test(
        'GlucoseNotifier initializes with sample records and unlocked state after microtask',
        () {
      final notifier = GlucoseNotifier(const GlucoseEngine());
      expect(notifier.state.records, isNotEmpty);
      expect(notifier.state.latestFasting, isNotNull);
      expect(notifier.state.latestPostMeal, isNotNull);
    });

    test(
        'GlucoseNotifier.logGlucoseReading updates records and recalculates HbA1c',
        () {
      final notifier = GlucoseNotifier(const GlucoseEngine());
      notifier.logGlucoseReading(
        mgDl: 160,
        tag: GlucoseContextTag.postMeal1h,
        correlatedMealName: 'Biryani',
      );

      expect(notifier.state.records.last.mgDl, equals(160));
      expect(
          notifier.state.latestPostMeal?.correlatedMealName, equals('Biryani'));
      expect(notifier.state.spikeNudge, contains('Biryani'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('GlucoseScreen renders Blood Glucose title and main widgets',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: GlucoseScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Blood Glucose'), findsOneWidget);
      expect(find.text('Glucose Response Curve'), findsOneWidget);
      expect(find.text('Estimated HbA1c'), findsOneWidget);
      expect(find.text('Log Glucose Reading'), findsOneWidget);
    });
  });
}
