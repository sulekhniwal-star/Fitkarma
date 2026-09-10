import 'package:flutter/foundation.dart';

/// Performance grading tier for monthly health synthesis
enum MonthlyHealthGrade {
  aPlus(
      grade: 'A+',
      label: 'Exceptional (Utkrisht)',
      regionalLabel: 'उत्कृष्ट स्वास्थ्य सुधार',
      minScore: 90,
      colorCode: 0xFF00E676),
  a(
      grade: 'A',
      label: 'Optimal (Uttam)',
      regionalLabel: 'उत्तम स्वास्थ्य स्तर',
      minScore: 80,
      colorCode: 0xFF448AFF),
  b(
      grade: 'B',
      label: 'Moderate (Madhyam)',
      regionalLabel: 'मध्यम प्रगति (सुधार संभव)',
      minScore: 70,
      colorCode: 0xFFFFB300),
  c(
      grade: 'C',
      label: 'Needs Focus (Dhyan Aavashyak)',
      regionalLabel: 'ध्यान आवश्यक (सक्रियता बढ़ाएं)',
      minScore: 0,
      colorCode: 0xFFFF5252);

  final String grade;
  final String label;
  final String regionalLabel;
  final int minScore;
  final int colorCode;

  const MonthlyHealthGrade({
    required this.grade,
    required this.label,
    required this.regionalLabel,
    required this.minScore,
    required this.colorCode,
  });
}

/// Monthly summary of a core health pillar
@immutable
class MonthlyPillarSummary {
  final String title;
  final String regionalTitle;
  final String iconName;
  final double score; // 0 to 100
  final String statusLabel;
  final String regionalStatusLabel;
  final String primaryMetric;
  final String primaryMetricLabel;
  final String monthDelta; // e.g. "+4% vs last month"
  final bool isPositiveDelta;
  final List<String> bulletInsights;
  final List<String> regionalBulletInsights;

  const MonthlyPillarSummary({
    required this.title,
    required this.regionalTitle,
    required this.iconName,
    required this.score,
    required this.statusLabel,
    required this.regionalStatusLabel,
    required this.primaryMetric,
    required this.primaryMetricLabel,
    required this.monthDelta,
    required this.isPositiveDelta,
    required this.bulletInsights,
    required this.regionalBulletInsights,
  });
}

/// Major clinical or habit milestone in the 30-day cycle
@immutable
class MonthlyHealthWin {
  final String id;
  final String title;
  final String regionalTitle;
  final String metricImpact;
  final String iconName;
  final int karmaEarned;

  const MonthlyHealthWin({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.metricImpact,
    required this.iconName,
    required this.karmaEarned,
  });
}

/// Key clinical priority target for the upcoming 30 days
@immutable
class NextMonthFocusArea {
  final String id;
  final String title;
  final String regionalTitle;
  final String rationale;
  final String regionalRationale;
  final String targetGoal;
  final String projectedBenefit;

  const NextMonthFocusArea({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.rationale,
    required this.regionalRationale,
    required this.targetGoal,
    required this.projectedBenefit,
  });
}

/// Comprehensive Monthly Health Report
@immutable
class MonthlyHealthReport {
  final String reportId;
  final String monthTitle; // e.g. "August 2026"
  final String regionalMonthTitle;
  final DateTime generatedAt;
  final double compositeScore; // 0 to 100
  final MonthlyHealthGrade grade;
  final double biologicalAge;
  final double biologicalAgeDelta; // e.g. -0.8 years
  final double agingPace; // e.g. 0.84x
  final List<MonthlyPillarSummary> pillarSummaries;
  final List<MonthlyHealthWin> topWins;
  final List<NextMonthFocusArea> nextMonthPriorities;
  final String clinicalExecutiveSummary;
  final String regionalClinicalExecutiveSummary;
  final String doctorSummaryParagraph;

  const MonthlyHealthReport({
    required this.reportId,
    required this.monthTitle,
    required this.regionalMonthTitle,
    required this.generatedAt,
    required this.compositeScore,
    required this.grade,
    required this.biologicalAge,
    required this.biologicalAgeDelta,
    required this.agingPace,
    required this.pillarSummaries,
    required this.topWins,
    required this.nextMonthPriorities,
    required this.clinicalExecutiveSummary,
    required this.regionalClinicalExecutiveSummary,
    required this.doctorSummaryParagraph,
  });
}
