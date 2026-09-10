import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/cicd_pipeline/domain/cicd_engine.dart';
import 'package:fitkarma/features/cicd_pipeline/domain/cicd_models.dart';
import 'package:fitkarma/features/cicd_pipeline/presentation/providers/cicd_provider.dart';

void main() {
  group('CicdEngine Deterministic Tests', () {
    const engine = CicdEngine();

    test('Generates verified CI/CD report with all 7 passing stages', () {
      final report = engine.generatePipelineReport();

      expect(report.stages.length, equals(7));
      expect(report.overallStatus, equals(PipelineStatus.passed));
      expect(report.isAllGreen, isTrue);
      expect(report.totalDurationSeconds, greaterThan(0));
      expect(report.androidArtifactUrl.isNotEmpty, isTrue);
      expect(report.iosArtifactUrl.isNotEmpty, isTrue);
    });

    test('Identifies failed pipeline if any individual stage fails', () {
      final stagesWithFailure = [
        StageRunRecord(
          stage: PipelineStage.unitAndWidgetTests,
          status: PipelineStatus.failed,
          durationSeconds: 15,
          logsSummary: 'Test assertion failed',
          regionalLogsSummary: 'परीक्षण विफल',
          executedAt: DateTime.now(),
        ),
      ];

      final failedReport =
          engine.generatePipelineReport(customStages: stagesWithFailure);
      expect(failedReport.overallStatus, equals(PipelineStatus.failed));
      expect(failedReport.isAllGreen, isFalse);
    });
  });

  group('Cicd StateNotifier Provider Tests', () {
    test('StateNotifier triggers automated pipeline run and selects stages',
        () async {
      final notifier = CicdNotifier();

      expect(notifier.state.selectedStage, isNull);
      expect(
          notifier.state.report.overallStatus, equals(PipelineStatus.passed));

      notifier.selectStage(PipelineStage.androidAabBuild);
      expect(
          notifier.state.selectedStage, equals(PipelineStage.androidAabBuild));

      notifier.selectStage(null);
      expect(notifier.state.selectedStage, isNull);

      await notifier.triggerPipelineRun();
      expect(notifier.state.report.commitHash, equals('8e4f10c'));
      expect(notifier.state.successMessage, contains('completed successfully'));
    });
  });
}
