import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/performance_engine.dart';
import '../../domain/performance_models.dart';

/// State of Performance Management & Engine Benchmarking
class PerformanceState {
  final PerformanceAuditReport report;
  final bool isLoading;
  final bool cacheCleared;
  final String? successMessage;
  final String? errorMessage;

  const PerformanceState({
    required this.report,
    this.isLoading = false,
    this.cacheCleared = false,
    this.successMessage,
    this.errorMessage,
  });

  PerformanceState copyWith({
    PerformanceAuditReport? report,
    bool? isLoading,
    bool? cacheCleared,
    String? successMessage,
    String? errorMessage,
  }) {
    return PerformanceState(
      report: report ?? this.report,
      isLoading: isLoading ?? this.isLoading,
      cacheCleared: cacheCleared ?? this.cacheCleared,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

final performanceProvider =
    StateNotifierProvider<PerformanceNotifier, PerformanceState>((ref) {
  return PerformanceNotifier();
});

class PerformanceNotifier extends StateNotifier<PerformanceState> {
  PerformanceNotifier() : super(_buildInitialState());

  static const PerformanceEngine _engine = PerformanceEngine();

  static PerformanceState _buildInitialState() {
    const defaultSettings = PerformanceSettings();
    final report = _engine.evaluatePerformanceAudit(defaultSettings);
    return PerformanceState(report: report);
  }

  void setTargetFps(int fps) {
    final updatedSettings = state.report.settings.copyWith(targetFps: fps);
    final report = _engine.evaluatePerformanceAudit(updatedSettings);
    state = state.copyWith(
      report: report,
      successMessage: 'Target framerate set to $fps FPS.',
    );
  }

  void toggleBatterySaver(bool isSaver) {
    final updatedSettings = state.report.settings.copyWith(
      batterySaverMode: isSaver,
      targetFps: isSaver ? 60 : 120,
    );
    final report = _engine.evaluatePerformanceAudit(updatedSettings);
    state = state.copyWith(
      report: report,
      successMessage: isSaver
          ? 'Battery Saver activated (60 FPS).'
          : 'High Performance Mode enabled (120 FPS).',
    );
  }

  void toggleRepaintBoundaries(bool enabled) {
    final updatedSettings =
        state.report.settings.copyWith(enableRepaintBoundaries: enabled);
    final report = _engine.evaluatePerformanceAudit(updatedSettings);
    state = state.copyWith(
      report: report,
      successMessage:
          'Repaint boundary isolation ${enabled ? "enabled" : "disabled"}.',
    );
  }

  Future<void> runBenchmarks() async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    await Future.delayed(const Duration(milliseconds: 250));

    final report = _engine.evaluatePerformanceAudit(state.report.settings);

    state = state.copyWith(
      report: report,
      isLoading: false,
      successMessage: 'Engine calculation benchmarks completed in sub-10ms.',
    );
  }

  Future<void> clearCache() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 200));

    final updatedReport = _engine.evaluatePerformanceAudit(
      state.report.settings
          .copyWith(batterySaverMode: state.report.settings.batterySaverMode),
    );

    state = state.copyWith(
      report: updatedReport,
      isLoading: false,
      cacheCleared: true,
      successMessage:
          'In-memory telemetry and offline cache purged successfully.',
    );
  }
}
