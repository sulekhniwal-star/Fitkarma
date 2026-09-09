import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/cicd_engine.dart';
import '../../domain/cicd_models.dart';

/// State of the CI/CD Pipeline Dashboard
class CicdState {
  final CicdPipelineReport report;
  final bool isRunning;
  final PipelineStage? selectedStage;
  final String? successMessage;

  const CicdState({
    required this.report,
    this.isRunning = false,
    this.selectedStage,
    this.successMessage,
  });

  CicdState copyWith({
    CicdPipelineReport? report,
    bool? isRunning,
    PipelineStage? selectedStage,
    bool clearSelectedStage = false,
    String? successMessage,
  }) {
    return CicdState(
      report: report ?? this.report,
      isRunning: isRunning ?? this.isRunning,
      selectedStage: clearSelectedStage ? null : (selectedStage ?? this.selectedStage),
      successMessage: successMessage,
    );
  }
}

final cicdProvider =
    StateNotifierProvider<CicdNotifier, CicdState>((ref) {
  return CicdNotifier();
});

class CicdNotifier extends StateNotifier<CicdState> {
  CicdNotifier() : super(_buildInitialState());

  static const CicdEngine _engine = CicdEngine();

  static CicdState _buildInitialState() {
    final report = _engine.generatePipelineReport();
    return CicdState(report: report);
  }

  void selectStage(PipelineStage? stage) {
    state = state.copyWith(selectedStage: stage, clearSelectedStage: stage == null);
  }

  Future<void> triggerPipelineRun() async {
    state = state.copyWith(isRunning: true, successMessage: null);

    // Simulate CI/CD run
    await Future.delayed(const Duration(milliseconds: 350));

    final updatedReport = _engine.generatePipelineReport(
      commitHash: '8e4f10c',
      commitMessage: 'ci(deploy): automated production build run verified',
    );

    state = state.copyWith(
      report: updatedReport,
      isRunning: false,
      successMessage: 'CI/CD Pipeline Run #${updatedReport.pipelineRunId.split('_').last} completed successfully (All Green)!',
    );
  }
}
