import 'package:fitkarma/features/predictive/cgm_dashboard_screen.dart';
import 'package:fitkarma/features/predictive/cgm_notifier.dart';
import 'package:fitkarma/features/predictive/cgm_sync_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = CgmSyncEngine();
  final now = DateTime.now();

  group('§P10-H & §P10-L CgmSyncEngine Unit Tests', () {
    test('Detects glucose spike > 40 mg/dL within 90 mins and correlates pre-meal log', () {
      final readings = [
        GlucoseReading(
          readingId: 'g1',
          timestamp: now.subtract(const Duration(minutes: 75)),
          glucoseValueMgDl: 120.0,
          trendDirection: GlucoseTrend.flat,
          status: SensorStatus.active,
        ),
        GlucoseReading(
          readingId: 'g2',
          timestamp: now.subtract(const Duration(minutes: 15)),
          glucoseValueMgDl: 172.0, // +52 mg/dL spike within 60 mins
          trendDirection: GlucoseTrend.rapidlyRising,
          status: SensorStatus.active,
        ),
      ];

      final meals = [
        CorrelatedMealEntry(
          foodName: 'White Rice (Thali)',
          consumeTime: now.subtract(const Duration(minutes: 45)),
          carbsGrams: 65.0,
        ),
      ];

      final spikes = engine.detectSpikesAndCorrelate(readings: readings, mealLogs: meals);

      expect(spikes.length, 1);
      expect(spikes.first.glucoseDelta, 52.0);
      expect(spikes.first.correlatedMeal.foodName, 'White Rice (Thali)');
      expect(spikes.first.aiInsight, contains('Next time, add 150g salad (fiber) or paneer'));
    });
  });

  group('§P10-H CgmDashboardScreen Widget Tests', () {
    testWidgets('Renders live glucose reading, trend badge, detected spikes, and retrospective insights', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cgmProvider.overrideWith(CgmNotifier.new),
          ],
          child: const MaterialApp(
            home: CgmDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar
      expect(find.text('🩺 CGM Glucose Stream — Live'), findsOneWidget);

      // 2. Live Reading Gauge
      expect(find.text('Sensor Active'), findsOneWidget);
      expect(find.text('124'), findsOneWidget);
      expect(find.text('mg/dL'), findsOneWidget);
      expect(find.text('↗ Rising'), findsOneWidget);

      // 3. Detected Spikes & Correlated Meal
      expect(find.text('⚠️ Detected Spikes (Last 24 Hours):'), findsOneWidget);
      expect(find.text('Correlated food: White Rice (Thali)'), findsOneWidget);

      // 4. Retrospective Glycemic Insight (§P10-L)
      expect(find.textContaining('White Rice (Thali) alone triggers rapid digestion'), findsOneWidget);
    });
  });
}
