enum RiskTier {
  optimal(name: 'Optimal / Low Risk', regionalName: 'आदर्श / निम्न जोखिम'),
  moderate(name: 'Moderate Precaution', regionalName: 'मध्यम सावधानी'),
  elevated(name: 'Elevated Risk', regionalName: 'बढ़ा हुआ जोखिम'),
  high(name: 'High Cardiometabolic Alert', regionalName: 'उच्च जोखिम चेतावनी');

  final String name;
  final String regionalName;

  const RiskTier({required this.name, required this.regionalName});
}

enum AutonomicState {
  parasympatheticDominant(name: 'Parasympathetic Rest & Recovery'),
  balanced(name: 'Optimal Autonomic Homeostasis'),
  sympatheticOverdrive(name: 'Sympathetic Stress Overdrive');

  final String name;

  const AutonomicState({required this.name});
}

class PreventiveHealthReport {
  final int cardiometabolicRiskScore; // 0 to 100
  final RiskTier cardiometabolicTier;
  final AutonomicState autonomicState;
  final int bpContribution;
  final int glucoseContribution;
  final int bmiContribution;
  final int sleepDebtContribution;
  final List<String> preventiveActionProtocols;
  final String clinicalSummary;

  const PreventiveHealthReport({
    required this.cardiometabolicRiskScore,
    required this.cardiometabolicTier,
    required this.autonomicState,
    required this.bpContribution,
    required this.glucoseContribution,
    required this.bmiContribution,
    required this.sleepDebtContribution,
    required this.preventiveActionProtocols,
    required this.clinicalSummary,
  });
}

class PreventiveIntelligenceEngine {
  /// Pure Dart deterministic calculation of Cardiometabolic Risk (CMR) and Autonomic Balance
  static PreventiveHealthReport evaluatePreventiveHealth({
    int systolicBp = 120,
    int diastolicBp = 80,
    double fastingGlucoseMgDl = 95.0,
    double bmi = 23.2,
    double rolling7DaySleepDebtHours = 1.0,
    double currentHrvMs = 58.0,
    double baselineHrvMs = 60.0,
    double currentRhrBpm = 56.0,
    double baselineRhrBpm = 54.0,
  }) {
    // 1. Blood Pressure Risk Points (Max 30 pts)
    int bpPts = 0;
    if (systolicBp >= 140 || diastolicBp >= 90) {
      bpPts = 30;
    } else if (systolicBp >= 130 || diastolicBp >= 80) {
      bpPts = 20;
    } else if (systolicBp >= 120) {
      bpPts = 10;
    }

    // 2. Glucose Risk Points (Max 30 pts)
    int glucosePts = 0;
    if (fastingGlucoseMgDl >= 126) {
      glucosePts = 30;
    } else if (fastingGlucoseMgDl >= 100) {
      glucosePts = 18;
    } else if (fastingGlucoseMgDl >= 95) {
      glucosePts = 5;
    }

    // 3. Asian-Indian BMI Risk Points (Max 25 pts, Cutoff: 23.0 kg/m2)
    int bmiPts = 0;
    if (bmi >= 27.5) {
      bmiPts = 25;
    } else if (bmi >= 25.0) {
      bmiPts = 18;
    } else if (bmi >= 23.0) {
      bmiPts = 10;
    }

    // 4. Sleep Debt & Lifestyle Points (Max 15 pts)
    int sleepPts = 0;
    if (rolling7DaySleepDebtHours > 3.0) {
      sleepPts = 15;
    } else if (rolling7DaySleepDebtHours > 1.5) {
      sleepPts = 8;
    }

    final totalRiskScore = (bpPts + glucosePts + bmiPts + sleepPts).clamp(0, 100);

    // Determine Risk Tier
    final RiskTier tier;
    if (totalRiskScore >= 60) {
      tier = RiskTier.high;
    } else if (totalRiskScore >= 35) {
      tier = RiskTier.elevated;
    } else if (totalRiskScore >= 18) {
      tier = RiskTier.moderate;
    } else {
      tier = RiskTier.optimal;
    }

    // Determine Autonomic State
    final hrvDelta = currentHrvMs - baselineHrvMs;
    final rhrDelta = currentRhrBpm - baselineRhrBpm;
    final AutonomicState autonomicState;
    if (hrvDelta < -10.0 || rhrDelta > 6.0) {
      autonomicState = AutonomicState.sympatheticOverdrive;
    } else if (hrvDelta > 8.0 && rhrDelta <= 0) {
      autonomicState = AutonomicState.parasympatheticDominant;
    } else {
      autonomicState = AutonomicState.balanced;
    }

    // Generate Preventive Action Protocols
    final List<String> protocols = [];
    if (tier == RiskTier.high || tier == RiskTier.elevated) {
      protocols.add('Zone 2 Cardio: 35 minutes of steady walking/cycling 4x/week to enhance capillary density.');
      protocols.add('Sodium Management: Keep sodium under 2,000mg and emphasize high-potassium greens.');
      protocols.add('Post-Meal Walking (शतपावली): 10-15 minutes after lunch and dinner for GLUT-4 activation.');
      protocols.add('Sleep Extension: Add 45 minutes to your sleep opportunity to clear autonomic strain.');
    } else if (tier == RiskTier.moderate) {
      protocols.add('Maintain consistent meal timing with fiber-rich Indian legumes (daal, chana).');
      protocols.add('Engage in 10 minutes of evening Pranayama (Anulom Vilom) to reduce cortisol.');
      protocols.add('Hit 8,000 to 10,000 daily steps to preserve insulin sensitivity.');
    } else {
      protocols.add('Maintain your balanced resistance and cardiovascular training split.');
      protocols.add('Continue whole-food Mediterranean-Indian dietary staples.');
    }

    final String summary;
    if (tier == RiskTier.optimal) {
      summary = 'All preventive cardiometabolic biomarkers are within optimal functional ranges.';
    } else if (tier == RiskTier.moderate) {
      summary = 'Minor metabolic or lifestyle drift detected. Early lifestyle tuning will reverse early risk markers.';
    } else {
      summary = 'Elevated cardiometabolic indicators. Proactive lifestyle modifications are strongly recommended.';
    }

    return PreventiveHealthReport(
      cardiometabolicRiskScore: totalRiskScore,
      cardiometabolicTier: tier,
      autonomicState: autonomicState,
      bpContribution: bpPts,
      glucoseContribution: glucosePts,
      bmiContribution: bmiPts,
      sleepDebtContribution: sleepPts,
      preventiveActionProtocols: protocols,
      clinicalSummary: summary,
    );
  }
}
