import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/cgm_analysis_engine.dart';
import 'package:fitkarma/features/predictive_health/screens/cgm_dashboard_screen.dart';

void main() {
  group('§P10-H Continuous Biomarker Tracking (CGM Sync) Tests', () {
    const engine = CgmAnalysisEngine();

    test(
        'detectSpikes detects spike >40 mg/dL within 90 mins and correlates pre-spike foods',
        () {
      final now = DateTime.now();
      final readings = [
        GlucoseReading(
            readingId: 'g1',
            timestamp: now.subtract(const Duration(hours: 2)),
            glucoseValueMgDl: 120.0,
            trendDirection: GlucoseTrend.rising),
        GlucoseReading(
            readingId: 'g2',
            timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
            glucoseValueMgDl: 172.0,
            trendDirection: GlucoseTrend.rapidlyRising),
      ];

      final foodLogs = [
        CgmFoodLogSnapshot(
            foodName: 'White Rice (Thali)',
            consumeTime: now.subtract(const Duration(hours: 2, minutes: 15)),
            calories: 520),
      ];

      final spikes = engine.detectSpikes(readings, foodLogs);

      expect(spikes.length, equals(1));
      expect(spikes.first.glucoseDelta, equals(52.0));
      expect(spikes.first.peakGlucose, equals(172.0));
      expect(spikes.first.correlatedFoods.first.foodName,
          equals('White Rice (Thali)'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'CgmDashboardScreen renders Live Glucose Stream card and detected spikes breakdown',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CgmDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🩺 CGM Glucose Stream'), findsOneWidget);
      expect(find.text('Live Glucose Stream'), findsOneWidget);
      expect(find.text('SENSOR ACTIVE'), findsOneWidget);
      expect(find.textContaining('124'), findsOneWidget);
      expect(find.text('⚠️ Detected Spikes (Last 24 Hours)'), findsOneWidget);
      expect(
          find.textContaining('White Rice (Thali)'), findsAtLeastNWidgets(1));
    });
  });
}
