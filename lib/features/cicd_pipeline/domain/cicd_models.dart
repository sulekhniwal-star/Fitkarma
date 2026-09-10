import 'package:flutter/foundation.dart';

/// Distinct stages in the FitKarma CI/CD Pipeline
enum PipelineStage {
  formatAndLint(
    name: 'Dart Format & Static Linting',
    regionalName: 'कोड प्रारूप व स्थैतिक विश्लेषण',
    estimatedSeconds: 25,
  ),
  unitAndWidgetTests(
    name: '105+ Pure Dart & Widget Tests',
    regionalName: '१०५+ यूनिट व विजेट परीक्षण',
    estimatedSeconds: 45,
  ),
  secretsAndSecurityScan(
    name: 'Zero-Secrets & Security Audit',
    regionalName: 'सुरक्षा व सीक्रेट्स लीकेज स्कैन',
    estimatedSeconds: 15,
  ),
  cloudFunctionsValidation(
    name: 'Cloud Functions & Webhook Check',
    regionalName: 'क्लाउड फंक्शन्स व वेबहुक सत्यापन',
    estimatedSeconds: 30,
  ),
  androidAabBuild(
    name: 'Android Release App Bundle (AAB)',
    regionalName: 'एंड्रॉइड रिलीज ऐप बंडल निर्माण',
    estimatedSeconds: 180,
  ),
  iosIpaBuild(
    name: 'iOS Release Archive (IPA)',
    regionalName: 'आईओएस रिलीज आर्काइव निर्माण',
    estimatedSeconds: 240,
  ),
  firebaseRulesDeploy(
    name: 'Firestore & Storage Rules Deploy',
    regionalName: 'फायरस्टोर व स्टोरेज नियम परिनियोजन',
    estimatedSeconds: 20,
  );

  final String name;
  final String regionalName;
  final int estimatedSeconds;

  const PipelineStage({
    required this.name,
    required this.regionalName,
    required this.estimatedSeconds,
  });
}

/// Execution status of a pipeline or individual stage
enum PipelineStatus {
  queued(name: 'Queued', regionalName: 'कतार में'),
  running(name: 'In Progress', regionalName: 'प्रक्रियाधीन'),
  passed(name: 'Success (Green)', regionalName: 'सफल'),
  failed(name: 'Failed (Red)', regionalName: 'विफल'),
  cancelled(name: 'Cancelled', regionalName: 'रद्द');

  final String name;
  final String regionalName;

  const PipelineStatus({
    required this.name,
    required this.regionalName,
  });
}

/// Execution record of a single pipeline stage
@immutable
class StageRunRecord {
  final PipelineStage stage;
  final PipelineStatus status;
  final int durationSeconds;
  final String logsSummary;
  final String regionalLogsSummary;
  final DateTime executedAt;

  const StageRunRecord({
    required this.stage,
    required this.status,
    required this.durationSeconds,
    required this.logsSummary,
    required this.regionalLogsSummary,
    required this.executedAt,
  });

  bool get isPassed => status == PipelineStatus.passed;
}

/// Complete CI/CD Build Run Report
@immutable
class CicdPipelineReport {
  final String pipelineRunId;
  final String branch;
  final String commitHash;
  final String commitMessage;
  final String author;
  final PipelineStatus overallStatus;
  final List<StageRunRecord> stages;
  final int totalDurationSeconds;
  final String androidArtifactUrl;
  final String iosArtifactUrl;
  final DateTime startedAt;

  const CicdPipelineReport({
    required this.pipelineRunId,
    required this.branch,
    required this.commitHash,
    required this.commitMessage,
    required this.author,
    required this.overallStatus,
    required this.stages,
    required this.totalDurationSeconds,
    required this.androidArtifactUrl,
    required this.iosArtifactUrl,
    required this.startedAt,
  });

  bool get isAllGreen =>
      overallStatus == PipelineStatus.passed && stages.every((s) => s.isPassed);
}
