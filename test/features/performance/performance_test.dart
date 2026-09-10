import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/performance/domain/performance_engine.dart';
import 'package:fitkarma/features/performance/domain/performance_models.dart';
import 'package:fitkarma/features/performance/presentation/providers/performance_provider.dart';

void main() {
  group('PerformanceEngine Deterministic Tests', () {
    const engine = PerformanceEngine();

    test(
        'Micro-benchmarks execute in sub-15ms across all core health algorithms',
        () {
      final benchmarks = engine.runEngineBenchmarks(iterations: 50);

      expect(benchmarks.length, equals(4));
      for (final b in benchmarks) {
        expect(b.executionMilliseconds, lessThan(15.0));
        expect(b.isWithinBudget, isTrue);
      }
    });

    test(
        'Performance audit evaluation generates Grade A on standard 120 FPS settings',
        () {
      const settings = PerformanceSettings(targetFps: 120);
      final report = engine.evaluatePerformanceAudit(settings);

      expect(report.overallPerformanceScore, greaterThanOrEqualTo(90));
      expect(report.performanceGrade, equals(PerformanceGrade.gradeA));
      expect(report.averageFps, greaterThan(100.0));
      expect(report.currentMemoryUsageMb, lessThan(100.0));
      expect(report.optimizationTips.isNotEmpty, isTrue);
    });

    test('Battery saver mode adapts framerate and reduces memory footprint',
        () {
      const saverSettings =
          PerformanceSettings(batterySaverMode: true, targetFps: 60);
      final report = engine.evaluatePerformanceAudit(saverSettings);

      expect(report.averageFps, lessThan(65.0));
      expect(report.currentMemoryUsageMb, lessThan(45.0));
    });
  });

  group('Performance StateNotifier Provider Tests', () {
    test('StateNotifier adjusts FPS, toggles battery saver, and purges cache',
        () async {
      final notifier = PerformanceNotifier();

      expect(notifier.state.report.settings.targetFps, equals(120));

      notifier.setTargetFps(60);
      expect(notifier.state.report.settings.targetFps, equals(60));

      notifier.toggleBatterySaver(true);
      expect(notifier.state.report.settings.batterySaverMode, isTrue);
      expect(notifier.state.report.settings.targetFps, equals(60));

      notifier.toggleRepaintBoundaries(false);
      expect(notifier.state.report.settings.enableRepaintBoundaries, isFalse);

      await notifier.runBenchmarks();
      expect(notifier.state.successMessage, contains('completed in sub-10ms'));

      await notifier.clearCache();
      expect(notifier.state.cacheCleared, isTrue);
      expect(notifier.state.successMessage, contains('purged successfully'));
    });
  });
}
