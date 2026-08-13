import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/retrospective_glucose_matcher.dart';
import 'package:fitkarma/features/predictive_health/screens/retrospective_glycemic_pipeline_screen.dart';

void main() {
  group('§P10-L Retrospective Glycemic Processing Pipeline Tests', () {
    const matcher = RetrospectiveGlucoseMatcher();

    test('processMealWindow returns complete result when baseline and post-meal readings satisfy density requirements', () {
      final now = DateTime.now();
      final mealTime = now.subtract(const Duration(hours: 2));

      final readings = [
        // Baseline window (-30m to 0m)
        CgmReadingData(id: 'r1', timestamp: mealTime.subtract(const Duration(minutes: 25)), glucoseMgDl: 90.0),
        CgmReadingData(id: 'r2', timestamp: mealTime.subtract(const Duration(minutes: 10)), glucoseMgDl: 94.0),
        // Post-meal window (0m to +120m)
        CgmReadingData(id: 'r3', timestamp: mealTime.add(const Duration(minutes: 20)), glucoseMgDl: 120.0),
        CgmReadingData(id: 'r4', timestamp: mealTime.add(const Duration(minutes: 45)), glucoseMgDl: 142.0),
        CgmReadingData(id: 'r5', timestamp: mealTime.add(const Duration(minutes: 70)), glucoseMgDl: 130.0),
        CgmReadingData(id: 'r6', timestamp: mealTime.add(const Duration(minutes: 95)), glucoseMgDl: 105.0),
      ];

      final result = matcher.processMealWindow(mealConsumeTime: mealTime, syncedReadings: readings);

      expect(result.isAnalysisComplete, isTrue);
      expect(result.baselineGlucose, equals(92.0));
      expect(result.peakGlucose, equals(142.0));
      expect(result.glycemicSpike, equals(50.0));
    });

    test('processMealWindow returns incomplete result when reading density is insufficient', () {
      final now = DateTime.now();
      final mealTime = now.subtract(const Duration(hours: 2));

      final readings = [
        CgmReadingData(id: 'r1', timestamp: mealTime.subtract(const Duration(minutes: 10)), glucoseMgDl: 94.0),
      ];

      final result = matcher.processMealWindow(mealConsumeTime: mealTime, syncedReadings: readings);

      expect(result.isAnalysisComplete, isFalse);
      expect(result.glycemicSpike, isNull);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('RetrospectiveGlycemicPipelineScreen renders pipeline overview and retrospective insight cards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RetrospectiveGlycemicPipelineScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🔄 Retrospective Glycemic Pipeline'), findsOneWidget);
      expect(find.text('Retrospective Sync & Backfill'), findsOneWidget);
      expect(find.text('Recent Meals & Glycemic Audit Status'), findsOneWidget);
      expect(find.textContaining('Glycemic Response Audit'), findsOneWidget);
      expect(find.textContaining('Lunch (Dal Makhani + 2 Rotis)'), findsOneWidget);
      expect(find.textContaining('Snack (Samosa + Chai)'), findsOneWidget);
    });
  });
}
