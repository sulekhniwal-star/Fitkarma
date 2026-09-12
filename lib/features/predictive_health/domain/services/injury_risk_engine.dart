import '../models/predictive_health_models.dart';

class InjuryRiskEngine {
  const InjuryRiskEngine();

  /// Evaluates Acute:Chronic Workload Ratio (ACWR) and athletic injury hazard
  InjuryRiskAssessment evaluateWorkloadRatio({
    required double past7DaysLoadKg, // Acute load
    required double past28DaysLoadKg, // Total 28-day load
  }) {
    final double chronicWeeklyAvg = (past28DaysLoadKg / 4.0);
    final double chronicLoad = chronicWeeklyAvg > 0 ? chronicWeeklyAvg : (past7DaysLoadKg > 0 ? past7DaysLoadKg : 1.0);
    final double acwr = double.parse((past7DaysLoadKg / chronicLoad).toStringAsFixed(2));

    AcwrStatus status;
    String rec;
    String recHi;

    if (acwr > 1.50) {
      status = AcwrStatus.dangerZone;
      rec = 'High injury risk! Training volume spiked drastically. Deload or take an active recovery day.';
      recHi = 'चोट का अत्यधिक जोखिम! ट्रेनिंग वॉल्यूम बहुत तेजी से बढ़ा है। आज हल्का वर्कआउट या रिकवरी रखें।';
    } else if (acwr >= 1.30) {
      status = AcwrStatus.warning;
      rec = 'Moderate workload spike. Focus on sleep quality, hydration, and mobility drills.';
      recHi = 'वॉल्यूम में मध्यम वृद्धि। अच्छी नींद, हाइड्रेशन और मोबिलिटी स्ट्रेचिंग पर ध्यान दें।';
    } else if (acwr >= 0.80) {
      status = AcwrStatus.sweetSpot;
      rec = 'Optimal sweet spot (0.8–1.3)! Maximum progressive overload adaptation with minimal injury risk.';
      recHi = 'उत्कृष्ट संतुलन (०.८-१.३)! सुरक्षित प्रगति और न्यूनतम चोट की संभावना।';
    } else {
      status = AcwrStatus.underloading;
      rec = 'Underloading detected. Safe to progressively ramp up volume and intensity.';
      recHi = 'कम लोड दर्ज हुआ। आप धीरे-धीरे वॉल्यूम और तीव्रता बढ़ा सकते हैं।';
    }

    return InjuryRiskAssessment(
      acwr: acwr,
      status: status,
      acuteLoadKg: past7DaysLoadKg,
      chronicLoadKg: chronicLoad,
      recommendation: rec,
      recommendationHindi: recHi,
    );
  }
}
