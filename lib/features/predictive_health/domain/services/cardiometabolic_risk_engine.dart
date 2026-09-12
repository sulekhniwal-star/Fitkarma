import '../models/predictive_health_models.dart';

class CardiometabolicRiskEngine {
  const CardiometabolicRiskEngine();

  /// Evaluates 10-year cardiometabolic risk and Metabolic Syndrome (ATP III South Asian cutoffs)
  HealthRiskProfile evaluateRisk({
    required String gender, // 'male' or 'female'
    required int age,
    required double waistCircumferenceCm,
    required double systolicBp,
    required double diastolicBp,
    double? fastingGlucoseMgDl,
    double? triglyceridesMgDl,
    double? hdlCholesterolMgDl,
    double? totalCholesterolMgDl,
    bool isSmoker = false,
  }) {
    int metSynCount = 0;
    final List<String> riskFactors = [];
    final List<String> riskFactorsHindi = [];

    final isMale = gender.toLowerCase() == 'male';

    // 1. South Asian Central Adiposity (Men >= 90cm, Women >= 80cm)
    final waistThreshold = isMale ? 90.0 : 80.0;
    if (waistCircumferenceCm >= waistThreshold) {
      metSynCount++;
      riskFactors.add('Elevated Waist Circumference ($waistCircumferenceCm cm >= $waistThreshold cm)');
      riskFactorsHindi.add('कमर का घेरा मानक से अधिक ($waistCircumferenceCm सेमी)');
    }

    // 2. Blood Pressure (>= 130/85 mmHg)
    if (systolicBp >= 130 || diastolicBp >= 85) {
      metSynCount++;
      riskFactors.add('Prehypertensive/Hypertensive Blood Pressure (${systolicBp.toInt()}/${diastolicBp.toInt()} mmHg)');
      riskFactorsHindi.add('रक्तचाप मानक से अधिक (${systolicBp.toInt()}/${diastolicBp.toInt()} mmHg)');
    }

    // 3. Fasting Glucose (>= 100 mg/dL)
    if (fastingGlucoseMgDl != null && fastingGlucoseMgDl >= 100) {
      metSynCount++;
      riskFactors.add('Impaired Fasting Glucose (${fastingGlucoseMgDl.toInt()} mg/dL >= 100 mg/dL)');
      riskFactorsHindi.add('फास्टिंग ग्लूकोज स्तर बढ़ा हुआ (${fastingGlucoseMgDl.toInt()} mg/dL)');
    }

    // 4. Triglycerides (>= 150 mg/dL)
    if (triglyceridesMgDl != null && triglyceridesMgDl >= 150) {
      metSynCount++;
      riskFactors.add('Elevated Serum Triglycerides (${triglyceridesMgDl.toInt()} mg/dL >= 150 mg/dL)');
      riskFactorsHindi.add('ट्राइग्लिसराइड्स स्तर अधिक (${triglyceridesMgDl.toInt()} mg/dL)');
    }

    // 5. Low HDL Cholesterol (Men < 40 mg/dL, Women < 50 mg/dL)
    final hdlThreshold = isMale ? 40.0 : 50.0;
    if (hdlCholesterolMgDl != null && hdlCholesterolMgDl < hdlThreshold) {
      metSynCount++;
      riskFactors.add('Low Protective HDL Cholesterol (${hdlCholesterolMgDl.toInt()} mg/dL < $hdlThreshold mg/dL)');
      riskFactorsHindi.add('सुरक्षात्मक एचडीएल कोलेस्ट्रॉल कम (${hdlCholesterolMgDl.toInt()} mg/dL)');
    }

    final hasMetabolicSyndrome = metSynCount >= 3;

    // 10-Year Estimated Cardiovascular Risk %
    double cvRisk = (age * 0.15) + (systolicBp >= 140 ? 3.5 : (systolicBp >= 130 ? 1.5 : 0.0));
    if (isSmoker) cvRisk += 4.5;
    if (hasMetabolicSyndrome) cvRisk += 3.0;
    if (totalCholesterolMgDl != null && totalCholesterolMgDl >= 200) cvRisk += 2.0;

    final double tenYearRiskPercent = double.parse(cvRisk.clamp(1.0, 35.0).toStringAsFixed(1));

    CardioRiskLevel level;
    if (tenYearRiskPercent < 5.0) {
      level = CardioRiskLevel.low;
    } else if (tenYearRiskPercent < 10.0) {
      level = CardioRiskLevel.moderate;
    } else if (tenYearRiskPercent < 20.0) {
      level = CardioRiskLevel.elevated;
    } else {
      level = CardioRiskLevel.high;
    }

    // Prediabetes risk trajectory score (0-100)
    double prediabetesScore = 15.0;
    if (fastingGlucoseMgDl != null) {
      if (fastingGlucoseMgDl >= 126) {
        prediabetesScore = 95.0;
      } else if (fastingGlucoseMgDl >= 100) {
        prediabetesScore = 65.0 + ((fastingGlucoseMgDl - 100) * 1.15);
      }
    }
    if (waistCircumferenceCm >= waistThreshold) prediabetesScore += 15.0;
    prediabetesScore = prediabetesScore.clamp(0.0, 100.0);

    return HealthRiskProfile(
      cardioRisk: level,
      tenYearCardioRiskPercent: tenYearRiskPercent,
      metabolicSyndromeFlag: hasMetabolicSyndrome,
      metSynCriteriaMetCount: metSynCount,
      prediabetesRiskScore: double.parse(prediabetesScore.toStringAsFixed(1)),
      primaryRiskFactors: riskFactors,
      primaryRiskFactorsHindi: riskFactorsHindi,
    );
  }
}
