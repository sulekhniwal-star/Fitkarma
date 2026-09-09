import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/clinical_lab_engine.dart';
import '../../domain/clinical_lab_models.dart';

final clinicalLabProvider =
    StateNotifierProvider<ClinicalLabNotifier, ClinicalReportIntelligence>((ref) {
  return ClinicalLabNotifier();
});

class ClinicalLabNotifier extends StateNotifier<ClinicalReportIntelligence> {
  ClinicalLabNotifier() : super(_buildInitialReport());

  static final ClinicalLabEngine _engine = const ClinicalLabEngine();

  static ClinicalReportIntelligence _buildInitialReport() {
    return _engine.parseAndAnalyzeReport(
      reportId: 'rep_lab_2026_08',
      labProviderName: 'Dr. Lal PathLabs',
      testDate: DateTime(2026, 8, 15),
      fastingGlucoseMgDl: 89.0,
      hba1cPercent: 5.2,
      totalCholesterolMgDl: 178.0,
      triglyceridesMgDl: 118.0,
      hdlCholesterolMgDl: 52.0,
      ldlCholesterolMgDl: 102.0,
      hsCrpMgL: 0.75,
      altSgptUnitsL: 22.0,
      astSgotUnitsL: 21.0,
      serumCreatinineMgDl: 0.92,
      serumUricAcidMgDl: 5.2,
      vitaminD3NgMl: 46.0,
      vitaminB12PgMl: 480.0,
      hemoglobinGDl: 15.1,
      tshUiuMl: 1.95,
    );
  }

  void parseCustomLabData({
    required String reportId,
    required String labProviderName,
    required DateTime testDate,
    required double fastingGlucoseMgDl,
    required double hba1cPercent,
    required double totalCholesterolMgDl,
    required double triglyceridesMgDl,
    required double hdlCholesterolMgDl,
    required double ldlCholesterolMgDl,
    required double hsCrpMgL,
    required double altSgptUnitsL,
    required double astSgotUnitsL,
    required double serumCreatinineMgDl,
    required double serumUricAcidMgDl,
    required double vitaminD3NgMl,
    required double vitaminB12PgMl,
    required double hemoglobinGDl,
    required double tshUiuMl,
  }) {
    state = _engine.parseAndAnalyzeReport(
      reportId: reportId,
      labProviderName: labProviderName,
      testDate: testDate,
      fastingGlucoseMgDl: fastingGlucoseMgDl,
      hba1cPercent: hba1cPercent,
      totalCholesterolMgDl: totalCholesterolMgDl,
      triglyceridesMgDl: triglyceridesMgDl,
      hdlCholesterolMgDl: hdlCholesterolMgDl,
      ldlCholesterolMgDl: ldlCholesterolMgDl,
      hsCrpMgL: hsCrpMgL,
      altSgptUnitsL: altSgptUnitsL,
      astSgotUnitsL: astSgotUnitsL,
      serumCreatinineMgDl: serumCreatinineMgDl,
      serumUricAcidMgDl: serumUricAcidMgDl,
      vitaminD3NgMl: vitaminD3NgMl,
      vitaminB12PgMl: vitaminB12PgMl,
      hemoglobinGDl: hemoglobinGDl,
      tshUiuMl: tshUiuMl,
    );
  }
}
