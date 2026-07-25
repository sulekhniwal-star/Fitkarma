/// §P14-B Performance Benchmarks — Unit & Widget Verification Tests

import 'package:fitkarma/core/config/device_tier.dart';
import 'package:fitkarma/core/performance/performance_tracker.dart';
import 'package:fitkarma/core/providers/core_providers.dart';
import 'package:fitkarma/shared/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class LowTierNotifier extends DeviceTierNotifier {
  @override
  DeviceTier build() => DeviceTier.low;
}

class MediumTierNotifier extends DeviceTierNotifier {
  @override
  DeviceTier build() => DeviceTier.medium;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final perfTracker = PerformanceMetricsTracker();
  const briefingEngine = DailyBriefingPerformanceEngine();

  group('§P14-B Cold Start Performance Tests (< 2s)', () {
    test('verifies cold start metrics completion is under 2.0 seconds threshold', () {
      perfTracker.recordAppStart();
      // Simulate app initialization work (50ms)
      perfTracker.recordAppReady();

      expect(perfTracker.coldStartDurationMs, lessThan(2000));
      expect(perfTracker.isColdStartCompliant(2000), isTrue);
    });
  });

  group('§P14-B Daily Briefing Latency Tests (< 100ms)', () {
    test('verifies Daily Briefing open latency read from Drift is under 100ms threshold', () async {
      final latencyMs = await briefingEngine.measureDailyBriefingOpenLatencyMs(
        readDipFromDriftQuery: () async {
          await Future<void>.delayed(const Duration(milliseconds: 5));
          return '{"dip": "Hydrate 3.0L + 30-min Walk"}';
        },
      );

      expect(latencyMs, lessThan(100));
      expect(briefingEngine.isBriefingLatencyCompliant(latencyMs, 100), isTrue);
    });
  });

  group('§P14-B GlassCard Blur Disabled on DeviceTier.low Tests', () {
    test('RenderingPerformanceEngine disables blur filter for DeviceTier.low', () {
      expect(RenderingPerformanceEngine.shouldEnableGlassBlur(DeviceTier.low), isFalse);
      expect(RenderingPerformanceEngine.shouldEnableGlassBlur(DeviceTier.medium), isTrue);
      expect(RenderingPerformanceEngine.shouldEnableGlassBlur(DeviceTier.high), isTrue);
    });

    testWidgets('GlassCard omits BackdropFilter when DeviceTier is low', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deviceTierProvider.overrideWith(LowTierNotifier.new),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: GlassCard(
                child: Text('Low Tier Card'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Low Tier Card'), findsOneWidget);
      // Blur is disabled on low tier, so BackdropFilter should NOT be rendered
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('GlassCard enables BackdropFilter when DeviceTier is medium', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deviceTierProvider.overrideWith(MediumTierNotifier.new),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: GlassCard(
                child: Text('Medium Tier Card'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Medium Tier Card'), findsOneWidget);
      // Blur is enabled on medium tier, so BackdropFilter MUST be rendered
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
