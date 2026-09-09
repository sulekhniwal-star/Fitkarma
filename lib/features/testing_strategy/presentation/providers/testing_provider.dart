import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/testing_engine.dart';
import '../../domain/testing_models.dart';

/// State of Testing Strategy & Coverage Diagnostics
class TestingState {
  final TestingPyramidReport report;
  final TestLayer? selectedLayer;
  final bool isRunningAll;
  final String? successMessage;

  const TestingState({
    required this.report,
    this.selectedLayer,
    this.isRunningAll = false,
    this.successMessage,
  });

  TestingState copyWith({
    TestingPyramidReport? report,
    TestLayer? selectedLayer,
    bool clearLayer = false,
    bool? isRunningAll,
    String? successMessage,
  }) {
    return TestingState(
      report: report ?? this.report,
      selectedLayer: clearLayer ? null : (selectedLayer ?? this.selectedLayer),
      isRunningAll: isRunningAll ?? this.isRunningAll,
      successMessage: successMessage,
    );
  }

  List<FeatureTestSuite> get filteredSuites {
    if (selectedLayer == null) return report.featureSuites;
    return report.featureSuites.where((s) => s.layer == selectedLayer).toList();
  }
}

final testingProvider =
    StateNotifierProvider<TestingNotifier, TestingState>((ref) {
  return TestingNotifier();
});

class TestingNotifier extends StateNotifier<TestingState> {
  TestingNotifier() : super(_buildInitialState());

  static const TestingEngine _engine = TestingEngine();

  static TestingState _buildInitialState() {
    final report = _engine.compileTestingPyramidReport();
    return TestingState(report: report);
  }

  void selectLayer(TestLayer? layer) {
    state = state.copyWith(selectedLayer: layer, clearLayer: layer == null);
  }

  Future<void> runAllTests() async {
    state = state.copyWith(isRunningAll: true, successMessage: null);

    // Simulate complete project test runner execution
    await Future.delayed(const Duration(milliseconds: 300));

    final report = _engine.compileTestingPyramidReport();

    state = state.copyWith(
      report: report,
      isRunningAll: false,
      successMessage: 'All ${report.totalTestsCount} tests passed with ${report.overallCoveragePercent}% code coverage!',
    );
  }
}
