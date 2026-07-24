/// §P10-C Monthly Health Report — Models
///
/// Defines report payloads, vitals summary averages, and focus strategies
/// matching §P10-C specification.
library;

import 'package:fitkarma/features/predictive/biological_age_estimator.dart';
import 'package:fitkarma/features/predictive/health_risk_prevention_engine.dart';

class MonthlyReportPayload {
  const MonthlyReportPayload({
    required this.reportMonthPeriod,
    required this.biologicalAgeResult,
    required this.systolicBpAvg,
    required this.diastolicBpAvg,
    required this.fastingGlucoseAvg,
    required this.hrvAvgMs,
    required this.hrvTrendPercent,
    required this.detectedRisks,
    required this.focusStrategyItems,
    required this.generatedAt,
  });

  final String reportMonthPeriod;
  final BiologicalAgeResult biologicalAgeResult;
  final double systolicBpAvg;
  final double diastolicBpAvg;
  final double fastingGlucoseAvg;
  final double hrvAvgMs;
  final double hrvTrendPercent;
  final List<HealthRiskFlag> detectedRisks;
  final List<String> focusStrategyItems;
  final DateTime generatedAt;
}
