import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/health_tracking/models/device_reliability_engine.dart';
import 'package:fitkarma/features/health_tracking/models/wearable_sync_merger.dart';
import 'package:fitkarma/shared/widgets/wearable_data_source_card.dart';

void main() {
  group('§P4-G Smart Wearable Comparison Layer Tests', () {
    const reliabilityEngine = DeviceReliabilityEngine();
    const syncMerger = WearableSyncMerger();

    // ── DeviceReliabilityEngine Unit Tests ───────────────────────────────────

    test('Device Confidence Matrix maps Apple Watch, WHOOP, Garmin, Samsung, Fitbit, Mi Band correctly', () {
      expect(DeviceReliabilityEngine.deviceProfiles[WearableSource.whoop]?.hrvConfidence, equals(0.95));
      expect(DeviceReliabilityEngine.deviceProfiles[WearableSource.appleWatch]?.hrConfidence, equals(0.95));
      expect(DeviceReliabilityEngine.deviceProfiles[WearableSource.garmin]?.hrvConfidence, equals(0.88));
      expect(DeviceReliabilityEngine.deviceProfiles[WearableSource.samsungGalaxy]?.hrvConfidence, equals(0.70));
      expect(DeviceReliabilityEngine.deviceProfiles[WearableSource.fitbitSense]?.hrConfidence, equals(0.75));
      expect(DeviceReliabilityEngine.deviceProfiles[WearableSource.miBandNoise]?.hrvConfidence, equals(0.40));
    });

    test('applyConfidence computes readiness weight thresholds correctly', () {
      expect(reliabilityEngine.calculateReadinessWeight(0.95), equals(1.0));
      expect(reliabilityEngine.calculateReadinessWeight(0.70), equals(0.70));
      expect(reliabilityEngine.calculateReadinessWeight(0.40), equals(0.40));
    });

    test('applyConfidence builds result with device display label', () {
      final res = reliabilityEngine.applyConfidence(
        source: WearableSource.whoop,
        rawHRV: 58.0,
        rawHR: 62.0,
      );

      expect(res.readinessWeight, equals(1.0));
      expect(res.displayLabel, contains('WHOOP 4.0'));
      expect(res.displayLabel, contains('Very High'));
    });

    // ── WearableSyncMerger Unit Tests ─────────────────────────────────────────

    test('Resolution Rule 1: Higher confidence cardiac data overrides lower confidence in same bucket', () {
      final now = DateTime(2026, 8, 7, 8, 30);
      final local = [
        WearableDataPoint(timestamp: now, source: WearableSource.miBandNoise, type: MetricType.hrvMs, value: 45.0),
      ];

      final incoming = [
        WearableDataPoint(timestamp: now, source: WearableSource.garmin, type: MetricType.hrvMs, value: 58.0),
      ];

      final result = syncMerger.mergeDataStreams(localHistory: local, incomingStream: incoming);

      expect(result.mergedPoints.length, equals(1));
      expect(result.mergedPoints.first.source, equals(WearableSource.garmin));
      expect(result.mergedPoints.first.value, equals(58.0));
    });

    test('Resolution Rule 2: Smartwatch hourly step bucket overrides phone steps without double counting', () {
      final now = DateTime(2026, 8, 7, 10, 0);
      final local = [
        WearableDataPoint(timestamp: now, source: WearableSource.manualInput, type: MetricType.cumulativeSteps, value: 500.0),
      ];

      final incoming = [
        WearableDataPoint(timestamp: now, source: WearableSource.appleWatch, type: MetricType.cumulativeSteps, value: 1200.0),
      ];

      final result = syncMerger.mergeDataStreams(localHistory: local, incomingStream: incoming);

      expect(result.mergedPoints.length, equals(1));
      expect(result.mergedPoints.first.value, equals(1200.0));
    });

    test('Resolution Rule 3: Triggers readiness recalculation when late sync sleep delta > 30m or HRV delta > 10%', () {
      final now = DateTime(2026, 8, 7, 6, 0);
      final local = [
        WearableDataPoint(timestamp: now, source: WearableSource.manualInput, type: MetricType.sleepDuration, value: 360.0), // 6h
      ];

      final incoming = [
        WearableDataPoint(timestamp: now, source: WearableSource.whoop, type: MetricType.sleepDuration, value: 450.0), // 7.5h (90m delta)
      ];

      final result = syncMerger.mergeDataStreams(localHistory: local, incomingStream: incoming);

      expect(result.requiresReadinessRecalculation, isTrue);
      expect(result.summaryMessage, contains('Readiness score recalibrated'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('WearableDataSourceCard renders active wearable and confidence info', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WearableDataSourceCard(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('WHOOP 4.0'), findsWidgets);
      expect(find.text('Today\'s HRV'), findsOneWidget);
      expect(find.text('Your Baseline'), findsOneWidget);
      expect(find.textContaining('100% confidence'), findsOneWidget);
    });
  });
}
