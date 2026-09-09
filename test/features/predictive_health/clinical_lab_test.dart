import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/clinical_lab_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/clinical_lab_models.dart';

void main() {
  group('ClinicalLabEngine Tests', () {
    const engine = ClinicalLabEngine();

    test('Parses and analyzes optimal laboratory panel without physician escalation', () {
      final report = engine.parseAndAnalyzeReport(
        reportId: 'lab_test_01',
        labProviderName: 'Dr. Lal PathLabs',
        testDate: DateTime(2026, 8, 10),
        fastingGlucoseMgDl: 88.0,
        hba1cPercent: 5.1,
        totalCholesterolMgDl: 175.0,
        triglyceridesMgDl: 105.0,
        hdlCholesterolMgDl: 55.0,
        ldlCholesterolMgDl: 98.0,
        hsCrpMgL: 0.6,
        altSgptUnitsL: 20.0,
        astSgotUnitsL: 19.0,
        serumCreatinineMgDl: 0.90,
        serumUricAcidMgDl: 5.0,
        vitaminD3NgMl: 52.0,
        vitaminB12PgMl: 550.0,
        hemoglobinGDl: 15.2,
        tshUiuMl: 1.8,
      );

      expect(report.overallMetabolicGradeScore, greaterThanOrEqualTo(85.0));
      expect(report.requiresPhysicianConsult, isFalse);
      expect(report.parsedBiomarkers.length, greaterThanOrEqualTo(10));
      expect(report.panelSummaries.length, equals(5));
      expect(report.optimizationProtocols.isNotEmpty, isTrue);
    });

    test('Triggers critical physician escalation when severe biomarkers are parsed', () {
      final report = engine.parseAndAnalyzeReport(
        reportId: 'lab_test_critical',
        labProviderName: 'Thyrocare',
        testDate: DateTime(2026, 8, 12),
        fastingGlucoseMgDl: 165.0,
        hba1cPercent: 8.8,
        totalCholesterolMgDl: 280.0,
        triglyceridesMgDl: 340.0,
        hdlCholesterolMgDl: 32.0,
        ldlCholesterolMgDl: 195.0,
        hsCrpMgL: 6.8,
        altSgptUnitsL: 95.0,
        astSgotUnitsL: 82.0,
        serumCreatinineMgDl: 1.85,
        serumUricAcidMgDl: 9.8,
        vitaminD3NgMl: 12.0,
        vitaminB12PgMl: 140.0,
        hemoglobinGDl: 9.8,
        tshUiuMl: 9.5,
      );

      expect(report.requiresPhysicianConsult, isTrue);
      expect(report.physicianEscalationRationale, contains('Critical threshold'));
      expect(report.parsedBiomarkers.any((b) => b.status == LabBiomarkerStatus.critical), isTrue);
    });
  });
}
