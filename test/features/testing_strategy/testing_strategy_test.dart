import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/testing_strategy/domain/testing_engine.dart';
import 'package:fitkarma/features/testing_strategy/domain/testing_models.dart';
import 'package:fitkarma/features/testing_strategy/presentation/providers/testing_provider.dart';

void main() {
  group('TestingEngine Deterministic Tests', () {
    const engine = TestingEngine();

    test('Compiles comprehensive Testing Pyramid Report across all modules',
        () {
      final report = engine.compileTestingPyramidReport();

      expect(report.totalTestsCount, greaterThanOrEqualTo(100));
      expect(report.totalPassedTests, equals(report.totalTestsCount));
      expect(report.overallCoveragePercent, greaterThanOrEqualTo(90.0));
      expect(report.isAllGreen, isTrue);
      expect(report.featureSuites.length, greaterThanOrEqualTo(7));
    });

    test(
        'All default test suites have valid layers and passing execution status',
        () {
      final report = engine.compileTestingPyramidReport();

      for (final suite in report.featureSuites) {
        expect(suite.status, equals(TestExecutionStatus.passed));
        expect(suite.isAllPassed, isTrue);
        expect(suite.coveragePercent, greaterThanOrEqualTo(80.0));
      }
    });
  });

  group('Testing StateNotifier Provider Tests', () {
    test('StateNotifier filters suites by layer and executes full suite run',
        () async {
      final notifier = TestingNotifier();

      expect(notifier.state.selectedLayer, isNull);
      expect(notifier.state.filteredSuites.length,
          equals(notifier.state.report.featureSuites.length));

      notifier.selectLayer(TestLayer.unit);
      expect(notifier.state.selectedLayer, equals(TestLayer.unit));
      expect(
          notifier.state.filteredSuites.every((s) => s.layer == TestLayer.unit),
          isTrue);

      notifier.selectLayer(null);
      expect(notifier.state.selectedLayer, isNull);

      await notifier.runAllTests();
      expect(notifier.state.successMessage, contains('tests passed with'));
    });
  });
}
