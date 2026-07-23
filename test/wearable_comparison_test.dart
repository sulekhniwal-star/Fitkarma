import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitkarma/features/wearable/device_reliability_engine.dart';
import 'package:fitkarma/features/wearable/wearable_comparison_screen.dart';

void main() {
  group('DeviceReliabilityEngine Unit Tests', () {
    final engine = DeviceReliabilityEngine();

    test('WHOOP 4.0 has 0.95 HRV confidence and 1.0 weight', () {
      final res = engine.applyConfidence(
        source: WearableSource.whoop,
        rawHRV: 60.0,
        rawHR: 70.0,
      );
      expect(res.hrvConfidence, 0.95);
      expect(res.hrConfidence, 0.90);
      expect(res.readinessWeight, 1.0);
    });

    test('Garmin has 0.88 HRV confidence and 1.0 weight', () {
      final res = engine.applyConfidence(
        source: WearableSource.garmin,
        rawHRV: 60.0,
        rawHR: 70.0,
      );
      expect(res.hrvConfidence, 0.88);
      expect(res.readinessWeight, 1.0);
    });

    test('Samsung Watch 6 has 0.70 HRV confidence and 0.70 weight', () {
      final res = engine.applyConfidence(
        source: WearableSource.samsungWatch,
        rawHRV: 60.0,
        rawHR: 70.0,
      );
      expect(res.hrvConfidence, 0.70);
      expect(res.readinessWeight, 0.70);
    });

    test('Mi Band / Noise has 0.40 HRV confidence and 0.40 weight', () {
      final res = engine.applyConfidence(
        source: WearableSource.miBand,
        rawHRV: 60.0,
        rawHR: 70.0,
      );
      expect(res.hrvConfidence, 0.40);
      expect(res.readinessWeight, 0.40);
    });
  });

  group('WearableSyncMerger Unit Tests', () {
    final merger = WearableSyncMerger();
    final confidenceMap = {
      WearableSource.appleWatch: 0.85,
      WearableSource.whoop: 0.95,
      WearableSource.manual: 0.30,
    };

    test(
      'Cardiac Data merges and resolves overlapping minute buckets using higher confidence',
      () {
        final timestamp = DateTime(2026, 7, 19, 10, 15, 30);
        final local = [
          WearableDataPoint(
            timestamp: timestamp,
            source: WearableSource.appleWatch,
            type: MetricType.pointInTimeHeartRate,
            value: 75.0,
          ),
        ];

        final incoming = [
          WearableDataPoint(
            timestamp: timestamp.add(
              const Duration(seconds: 15),
            ), // Same minute bucket
            source: WearableSource.whoop, // Higher confidence
            type: MetricType.pointInTimeHeartRate,
            value: 72.0,
          ),
        ];

        final merged = merger.mergeDataStreams(
          localHistory: local,
          incomingStream: incoming,
          sourceConfidenceMap: confidenceMap,
        );

        expect(merged.length, 1);
        expect(merged.first.source, WearableSource.whoop);
        expect(merged.first.value, 72.0);
      },
    );

    test(
      'Cumulative Steps overrides lower-confidence phone counts for same hour bucket',
      () {
        final t1 = DateTime(2026, 7, 19, 8, 30);

        final local = [
          WearableDataPoint(
            timestamp: t1,
            source:
                WearableSource.manual, // Phone step estimation (low confidence)
            type: MetricType.cumulativeSteps,
            value: 1200.0,
          ),
        ];

        final incoming = [
          WearableDataPoint(
            timestamp: t1.add(const Duration(minutes: 15)), // Same hour
            source: WearableSource.appleWatch, // High confidence watch
            type: MetricType.cumulativeSteps,
            value: 1500.0,
          ),
        ];

        final merged = merger.mergeDataStreams(
          localHistory: local,
          incomingStream: incoming,
          sourceConfidenceMap: confidenceMap,
        );

        expect(merged.length, 1);
        expect(merged.first.source, WearableSource.appleWatch);
        expect(merged.first.value, 1500.0);
      },
    );
  });

  group('WearableComparisonScreen Widget Tests', () {
    Widget buildSubject() {
      return const MaterialApp(home: WearableComparisonScreen());
    }

    testWidgets(
      'Renders WearableComparisonScreen and updates selected source details',
      (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        // Verify title and dropdown exists
        expect(find.text('Wearable Comparison'), findsOneWidget);
        expect(
          find.byKey(const Key('wearable_source_dropdown')),
          findsOneWidget,
        );

        // Verify default primary device display card (WHOOP 4.0)
        expect(
          find.byKey(const Key('wearable_primary_source_card')),
          findsOneWidget,
        );
        expect(find.textContaining('HRV Source: WHOOP 4.0'), findsOneWidget);
        expect(
          find.textContaining('weighted at 100% confidence'),
          findsOneWidget,
        );

        // Tap dropdown to select Samsung Galaxy Watch 6
        await tester.tap(find.byKey(const Key('wearable_source_dropdown')));
        await tester.pumpAndSettle();

        // Find the dropdown option and tap it
        final dropdownItem = find.text('Samsung Galaxy Watch 6').last;
        await tester.tap(dropdownItem);
        await tester.pumpAndSettle();

        // Verify primary card updated
        expect(
          find.textContaining('HRV Source: Samsung Galaxy Watch 6'),
          findsOneWidget,
        );
        expect(
          find.textContaining('weighted at 70% confidence'),
          findsOneWidget,
        );
      },
    );
  });
}
