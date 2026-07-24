/// §P10-F Clinical Report Intelligence — Models
///
/// Defines supported lab report types, value classifications, extracted biomarker models,
/// and clinical result payloads matching §P10-F specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Payloads (§P10-F Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum ClinicalReportType {
  cbc('CBC (Complete Blood Count)', '🩸'),
  lipidProfile('Lipid Profile', '🫀'),
  lft('LFT (Liver Function)', '🧪'),
  kft('KFT (Kidney Function)', '🩺'),
  hbA1c('HbA1c Glucose', '📊'),
  vitaminD('Vitamin D (25-OH)', '☀️'),
  thyroid('Thyroid (TSH/T3/T4)', '🦋'),
  ironStudies('Iron Studies & Ferritin', '⚡');

  const ClinicalReportType(this.displayName, this.iconSymbol);

  final String displayName;
  final String iconSymbol;
}

enum LabValueClassification {
  normal('Normal', '🟩'),
  borderline('Borderline', '🟨'),
  abnormalLow('Low', '🟦'),
  abnormalHigh('High', '🟥');

  const LabValueClassification(this.displayName, this.indicatorEmoji);

  final String displayName;
  final String indicatorEmoji;
}

class ExtractedLabValue {
  const ExtractedLabValue({
    required this.markerName,
    required this.numericValue,
    required this.unit,
    required this.referenceRangeText,
    required this.classification,
    this.clinicalInterpretation,
  });

  final String markerName;
  final double numericValue;
  final String unit;
  final String referenceRangeText;
  final LabValueClassification classification;
  final String? clinicalInterpretation;
}

class ClinicalReportResult {
  const ClinicalReportResult({
    required this.reportType,
    required this.values,
    required this.keyFindings,
    required this.planAdjustments,
    required this.uploadDate,
  });

  final ClinicalReportType reportType;
  final List<ExtractedLabValue> values;
  final List<String> keyFindings;
  final List<String> planAdjustments;
  final DateTime uploadDate;
}
