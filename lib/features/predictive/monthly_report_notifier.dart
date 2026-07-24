/// §P10-C Monthly Health Report — Riverpod Notifier
///
/// Riverpod state management for loading and exporting monthly health reports.
library;

import 'package:fitkarma/features/predictive/biological_age_estimator.dart';
import 'package:fitkarma/features/predictive/health_risk_prevention_engine.dart';
import 'package:fitkarma/features/predictive/monthly_report_generator.dart';
import 'package:fitkarma/features/predictive/monthly_report_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyReportNotifier extends Notifier<MonthlyReportPayload> {
  final MonthlyReportGeneratorJob _generatorJob = MonthlyReportGeneratorJob();

  @override
  MonthlyReportPayload build() {
    final now = DateTime.now();

    final snapshot = UserMonthlyHealthSnapshot(
      chronologicalAge: 32,
      restingHrBpm: 58.0,
      hrvMs: 68.0,
      sleepHoursAvg: 7.6,
      bmi: 22.0,
      dailyStepsAvg: 9400,
      fastingGlucoseMgDl: 92.0,
      calculationDate: now,
    );

    const telemetry = UserHealthTelemetry(
      systolicBpMmHg: 118,
      diastolicBpMmHg: 78,
      isBpRising: false,
      stepsDecliningDays: 0,
      fastingGlucoseMgDl: 92,
      isGlucoseRising: false,
      bmi: 22.0,
      restingHrBpm: 58,
      isRestingHrElevated: false,
      stressScore: 28,
      sleepHoursAvg: 7.6,
      waistCircumferenceCm: 80,
      isMale: true,
      hrvMs: 68,
      isHrvDeclining: false,
      isPerformanceDropping: false,
      dailyStepsAvg: 9400,
      highFatigueDays: 0,
    );

    return _generatorJob.generateReport(
      monthPeriod: 'May 2026',
      snapshot: snapshot,
      telemetry: telemetry,
    );
  }

  /// Generates clean text export representation.
  String exportReportAsText() {
    return _generatorJob.exportToTextFormat(state);
  }
}

final monthlyReportProvider =
    NotifierProvider<MonthlyReportNotifier, MonthlyReportPayload>(MonthlyReportNotifier.new);
