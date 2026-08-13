class DoctorShareConfig {
  final String shareId;
  final String passCodePin; // 4-digit security PIN
  final int validDays; // Link duration (e.g. 7 days)
  final DateTime generatedAt;
  final bool includeBiomarkers;
  final bool includeBpAndGlucose;
  final bool includeRiskFlags;

  const DoctorShareConfig({
    required this.shareId,
    required this.passCodePin,
    this.validDays = 7,
    required this.generatedAt,
    this.includeBiomarkers = true,
    this.includeBpAndGlucose = true,
    this.includeRiskFlags = true,
  });

  DateTime get expiresAt => generatedAt.add(Duration(days: validDays));

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  String get shareUrl => 'https://share.fitkarma.app/portal/$shareId';
}

class DoctorReportSummary {
  final String patientName;
  final int averageSystolicBp;
  final int averageDiastolicBp;
  final double averageFastingGlucoseMgDl;
  final double adherencePct90Days;
  final double consistencyPct90Days;
  final List<String> activeRiskFlags;
  final List<String> biomarkerSummary;

  const DoctorReportSummary({
    required this.patientName,
    required this.averageSystolicBp,
    required this.averageDiastolicBp,
    required this.averageFastingGlucoseMgDl,
    required this.adherencePct90Days,
    required this.consistencyPct90Days,
    required this.activeRiskFlags,
    required this.biomarkerSummary,
  });
}

/// Pure-Dart Doctor Sharing & Security Token Service per §P10-J spec
class DoctorSharingService {
  const DoctorSharingService();

  DoctorShareConfig generateShareToken({
    required String passCodePin,
    int validDays = 7,
  }) {
    final shareId = DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase();
    return DoctorShareConfig(
      shareId: shareId,
      passCodePin: passCodePin,
      validDays: validDays,
      generatedAt: DateTime.now(),
    );
  }

  DoctorReportSummary generateSampleReportSummary(String patientName) {
    return DoctorReportSummary(
      patientName: patientName,
      averageSystolicBp: 122,
      averageDiastolicBp: 80,
      averageFastingGlucoseMgDl: 104.5,
      adherencePct90Days: 88.5,
      consistencyPct90Days: 92.0,
      activeRiskFlags: [
        'Glycemic Instability (Postprandial spikes > 40 mg/dL)',
        'Mild Vitamin D Deficit (Low outdoor activity)',
      ],
      biomarkerSummary: [
        'HbA1c: 5.6% (Normal Range: <5.7%)',
        'Serum Vitamin D: 26.5 ng/mL (Sub-optimal)',
        'Lipid Profile: Total Cholesterol 185 mg/dL, HDL 52 mg/dL',
      ],
    );
  }
}
