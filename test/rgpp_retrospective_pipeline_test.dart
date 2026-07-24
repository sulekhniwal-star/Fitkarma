/// §P10-L Retrospective Glycemic Processing Pipeline (RGPP) — Unit Tests

import 'package:fitkarma/features/predictive/cgm_sync_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = CgmSyncEngine();

  group('RGPP — Late-Arriving CGM Batch Detection (§P10-L)', () {
    test('returns non-late report for fresh real-time readings', () {
      final now = DateTime(2026, 7, 24, 14, 0);
      final batch = [
        GlucoseReading(
          readingId: '1',
          timestamp: now.subtract(const Duration(minutes: 5)),
          glucoseValueMgDl: 98.0,
          trendDirection: GlucoseTrend.flat,
          status: SensorStatus.active,
        ),
        GlucoseReading(
          readingId: '2',
          timestamp: now.subtract(const Duration(minutes: 2)),
          glucoseValueMgDl: 102.0,
          trendDirection: GlucoseTrend.rising,
          status: SensorStatus.active,
        ),
      ];

      final report = engine.detectLateArrivingBatch(batch, syncTime: now);

      expect(report.isLateArrivingBatch, isFalse);
      expect(report.lateReadingCount, equals(0));
      expect(report.totalReadingCount, equals(2));
      expect(report.hasSufficientDensity, isTrue);
    });

    test('detects late-arriving batch with 4-hour sync latency', () {
      final syncTime = DateTime(2026, 7, 24, 18, 0); // 6:00 PM sync
      final batch = [
        GlucoseReading(
          readingId: '1',
          timestamp: DateTime(2026, 7, 24, 14, 0), // 2:00 PM (4-hour delay)
          glucoseValueMgDl: 92.0,
          trendDirection: GlucoseTrend.flat,
          status: SensorStatus.active,
        ),
        GlucoseReading(
          readingId: '2',
          timestamp: DateTime(2026, 7, 24, 14, 45), // 2:45 PM (3h 15m delay)
          glucoseValueMgDl: 148.0,
          trendDirection: GlucoseTrend.rapidlyRising,
          status: SensorStatus.active,
        ),
      ];

      final report = engine.detectLateArrivingBatch(batch, syncTime: syncTime);

      expect(report.isLateArrivingBatch, isTrue);
      expect(report.lateReadingCount, equals(2));
      expect(report.maxLatencyMinutes, equals(240)); // 4 hours
      expect(report.earliestTimestamp, equals(DateTime(2026, 7, 24, 14, 0)));
      expect(report.latestTimestamp, equals(DateTime(2026, 7, 24, 14, 45)));
    });

    test('handles empty batch gracefully', () {
      final now = DateTime(2026, 7, 24, 12, 0);
      final report = engine.detectLateArrivingBatch([], syncTime: now);

      expect(report.isLateArrivingBatch, isFalse);
      expect(report.lateReadingCount, equals(0));
      expect(report.totalReadingCount, equals(0));
      expect(report.hasSufficientDensity, isFalse);
    });
  });

  group('RGPP — Retroactive Food-Window Linking Algorithm (§P10-L)', () {
    test('retroactively links 4-hour delayed CGM batch to logged lunch', () {
      final syncTime = DateTime(2026, 7, 24, 18, 0); // 6:00 PM sync
      final mealTime = DateTime(2026, 7, 24, 13, 30); // 1:30 PM Thali

      final unlinkedMeals = [
        CorrelatedMealEntry(
          foodName: 'North Indian Thali & Rice',
          consumeTime: mealTime,
          carbsGrams: 85.0,
        ),
      ];

      // Late-arriving batch covering 1:15 PM to 3:30 PM
      final batch = [
        GlucoseReading(
          readingId: 'b1',
          timestamp: DateTime(2026, 7, 24, 13, 15), // Pre-meal baseline
          glucoseValueMgDl: 94.0,
          trendDirection: GlucoseTrend.flat,
          status: SensorStatus.active,
        ),
        GlucoseReading(
          readingId: 'b2',
          timestamp: DateTime(2026, 7, 24, 13, 30), // Meal time baseline
          glucoseValueMgDl: 96.0,
          trendDirection: GlucoseTrend.flat,
          status: SensorStatus.active,
        ),
        GlucoseReading(
          readingId: 'p1',
          timestamp: DateTime(2026, 7, 24, 14, 15), // 45m post-meal peak
          glucoseValueMgDl: 154.0,
          trendDirection: GlucoseTrend.rapidlyRising,
          status: SensorStatus.active,
        ),
        GlucoseReading(
          readingId: 'p2',
          timestamp: DateTime(2026, 7, 24, 15, 0), // 90m post-meal
          glucoseValueMgDl: 130.0,
          trendDirection: GlucoseTrend.falling,
          status: SensorStatus.active,
        ),
      ];

      final results = engine.executeRetroactiveFoodLinking(
        batch: batch,
        unlinkedMeals: unlinkedMeals,
        syncTime: syncTime,
      );

      expect(results, hasLength(1));
      final res = results.first;
      expect(res.meal.foodName, contains('Thali'));
      expect(res.baselineGlucose, equals(95.0)); // (94 + 96) / 2
      expect(res.peakGlucose, equals(154.0));
      expect(res.spikeDelta, equals(59.0)); // 154 - 95 = 59
      expect(res.isRetroactivelyLinked, isTrue);
      expect(res.matchingConfidence, equals(1.0));
      expect(res.retrospectiveInsight, contains('salad (fiber) or paneer'));
    });

    test('handles out-of-order readings in late batch', () {
      final syncTime = DateTime(2026, 7, 24, 20, 0);
      final mealTime = DateTime(2026, 7, 24, 14, 0);

      final unlinkedMeals = [
        CorrelatedMealEntry(
          foodName: 'Fruit Juice & Sandwich',
          consumeTime: mealTime,
          carbsGrams: 60.0,
        ),
      ];

      // Out-of-order batch
      final batch = [
        GlucoseReading(
          readingId: '2',
          timestamp: DateTime(2026, 7, 24, 14, 45), // Peak
          glucoseValueMgDl: 160.0,
          trendDirection: GlucoseTrend.rising,
          status: SensorStatus.active,
        ),
        GlucoseReading(
          readingId: '1',
          timestamp: DateTime(2026, 7, 24, 13, 45), // Baseline
          glucoseValueMgDl: 100.0,
          trendDirection: GlucoseTrend.flat,
          status: SensorStatus.active,
        ),
      ];

      final results = engine.executeRetroactiveFoodLinking(
        batch: batch,
        unlinkedMeals: unlinkedMeals,
        syncTime: syncTime,
      );

      expect(results, hasLength(1));
      expect(results.first.spikeDelta, equals(60.0));
      expect(results.first.retrospectiveInsight, contains('Fruit Juice'));
    });

    test('ignores meals outside lookback window (e.g. > 24 hours ago)', () {
      final syncTime = DateTime(2026, 7, 24, 20, 0);
      final oldMealTime = DateTime(2026, 7, 22, 12, 0); // 2 days ago

      final unlinkedMeals = [
        CorrelatedMealEntry(
          foodName: 'Old Oats',
          consumeTime: oldMealTime,
          carbsGrams: 40.0,
        ),
      ];

      final batch = [
        GlucoseReading(
          readingId: '1',
          timestamp: DateTime(2026, 7, 22, 12, 30),
          glucoseValueMgDl: 120.0,
          trendDirection: GlucoseTrend.rising,
          status: SensorStatus.active,
        ),
      ];

      final results = engine.executeRetroactiveFoodLinking(
        batch: batch,
        unlinkedMeals: unlinkedMeals,
        syncTime: syncTime,
      );

      expect(results, isEmpty);
    });

    test('reduces confidence score when baseline readings are missing', () {
      final syncTime = DateTime(2026, 7, 24, 19, 0);
      final mealTime = DateTime(2026, 7, 24, 15, 0);

      final unlinkedMeals = [
        CorrelatedMealEntry(
          foodName: 'Protein Shake',
          consumeTime: mealTime,
          carbsGrams: 25.0,
        ),
      ];

      // Batch only has post-meal reading (no pre-meal baseline reading)
      final batch = [
        GlucoseReading(
          readingId: '1',
          timestamp: DateTime(2026, 7, 24, 15, 45),
          glucoseValueMgDl: 135.0,
          trendDirection: GlucoseTrend.rising,
          status: SensorStatus.active,
        ),
      ];

      final results = engine.executeRetroactiveFoodLinking(
        batch: batch,
        unlinkedMeals: unlinkedMeals,
        syncTime: syncTime,
      );

      expect(results, hasLength(1));
      expect(results.first.matchingConfidence, equals(0.7));
    });
  });
}
