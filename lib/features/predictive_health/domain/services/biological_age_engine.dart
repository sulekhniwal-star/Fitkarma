import '../models/predictive_health_models.dart';

class BiologicalAgeEngine {
  const BiologicalAgeEngine();

  /// Calculates deterministic biological age estimate and itemized biomarker contributors
  BiologicalAgeEstimate calculateBiologicalAge({
    required String id,
    required String userId,
    required int chronologicalAge,
    required double restingHeartRateBpm,
    required double hrvRmsddMs,
    required double bmi,
    required double systolicBp,
    required int averageDailySteps,
    required double averageSleepHours,
    required DateTime calculatedAt,
  }) {
    double ageOffset = 0.0;
    final List<BiomarkerContributor> contributors = [];

    // 1. Resting Heart Rate (Cardiovascular Efficiency)
    double rhrImpact = 0.0;
    String rhrStatus;
    if (restingHeartRateBpm < 60) {
      rhrImpact = -2.5;
      rhrStatus = 'Athletic Resting Heart Rate (<60 bpm)';
    } else if (restingHeartRateBpm <= 70) {
      rhrImpact = -1.0;
      rhrStatus = 'Optimal Heart Rate (60-70 bpm)';
    } else if (restingHeartRateBpm <= 80) {
      rhrImpact = 1.0;
      rhrStatus = 'Slightly Elevated Heart Rate (70-80 bpm)';
    } else {
      rhrImpact = 2.8;
      rhrStatus = 'Elevated Resting Heart Rate (>80 bpm)';
    }
    ageOffset += rhrImpact;
    contributors.add(BiomarkerContributor(
      markerName: 'Resting Heart Rate',
      markerNameHindi: 'विश्राम हृदय गति',
      impactYears: rhrImpact,
      status: rhrStatus,
      isProtective: rhrImpact < 0,
    ));

    // 2. Heart Rate Variability (Autonomic Balance)
    double hrvImpact = 0.0;
    String hrvStatus;
    if (hrvRmsddMs >= 65) {
      hrvImpact = -2.0;
      hrvStatus = 'Robust Vagal Tone (>65 ms)';
    } else if (hrvRmsddMs >= 45) {
      hrvImpact = -0.8;
      hrvStatus = 'Healthy HRV (45-65 ms)';
    } else if (hrvRmsddMs >= 30) {
      hrvImpact = 1.2;
      hrvStatus = 'Suppressed HRV (30-45 ms)';
    } else {
      hrvImpact = 2.5;
      hrvStatus = 'Significant Autonomic Stress (<30 ms)';
    }
    ageOffset += hrvImpact;
    contributors.add(BiomarkerContributor(
      markerName: 'Heart Rate Variability',
      markerNameHindi: 'हृदय गति परिवर्तनशीलता (HRV)',
      impactYears: hrvImpact,
      status: hrvStatus,
      isProtective: hrvImpact < 0,
    ));

    // 3. Asian-Indian BMI Cutoffs (18.5 - 22.9 optimal)
    double bmiImpact = 0.0;
    String bmiStatus;
    if (bmi >= 18.5 && bmi <= 22.9) {
      bmiImpact = -1.5;
      bmiStatus = 'Optimal Asian-Indian Body Mass (18.5-22.9)';
    } else if (bmi < 25.0) {
      bmiImpact = 1.0;
      bmiStatus = 'Overweight for Asian Phenotype (23.0-24.9)';
    } else {
      bmiImpact = 2.8;
      bmiStatus = 'Elevated Adiposity (>=25.0)';
    }
    ageOffset += bmiImpact;
    contributors.add(BiomarkerContributor(
      markerName: 'Asian-Indian BMI Profile',
      markerNameHindi: 'भारतीय बीएमआई मानक',
      impactYears: bmiImpact,
      status: bmiStatus,
      isProtective: bmiImpact < 0,
    ));

    // 4. Blood Pressure Staging
    double bpImpact = 0.0;
    String bpStatus;
    if (systolicBp < 120) {
      bpImpact = -1.2;
      bpStatus = 'Optimal Arterial Pressure (<120 mmHg)';
    } else if (systolicBp < 130) {
      bpImpact = 0.6;
      bpStatus = 'Pre-Hypertensive (120-129 mmHg)';
    } else if (systolicBp < 140) {
      bpImpact = 1.8;
      bpStatus = 'Stage 1 Hypertension (130-139 mmHg)';
    } else {
      bpImpact = 3.2;
      bpStatus = 'Stage 2 Hypertension (>=140 mmHg)';
    }
    ageOffset += bpImpact;
    contributors.add(BiomarkerContributor(
      markerName: 'Systolic Arterial Pressure',
      markerNameHindi: 'सिस्टोलिक रक्तचाप',
      impactYears: bpImpact,
      status: bpStatus,
      isProtective: bpImpact < 0,
    ));

    // 5. Daily Step Volume & Aerobic Fitness
    double stepsImpact = 0.0;
    String stepsStatus;
    if (averageDailySteps >= 10000) {
      stepsImpact = -2.0;
      stepsStatus = 'High Daily Activity (10,000+ steps)';
    } else if (averageDailySteps >= 7500) {
      stepsImpact = -1.0;
      stepsStatus = 'Consistent Daily Movement (7,500-10,000 steps)';
    } else if (averageDailySteps >= 5000) {
      stepsImpact = 0.8;
      stepsStatus = 'Moderate Sedentary Risk (5,000-7,500 steps)';
    } else {
      stepsImpact = 2.2;
      stepsStatus = 'Sedentary Lifestyle (<5,000 steps)';
    }
    ageOffset += stepsImpact;
    contributors.add(BiomarkerContributor(
      markerName: 'Daily Step Volume',
      markerNameHindi: 'दैनिक कदम संख्या',
      impactYears: stepsImpact,
      status: stepsStatus,
      isProtective: stepsImpact < 0,
    ));

    // 6. Sleep Duration & Recovery
    double sleepImpact = 0.0;
    String sleepStatus;
    if (averageSleepHours >= 7.5 && averageSleepHours <= 9.0) {
      sleepImpact = -1.2;
      sleepStatus = 'Optimal Circadian Sleep (7.5-9 hrs)';
    } else if (averageSleepHours >= 6.5) {
      sleepImpact = 0.2;
      sleepStatus = 'Acceptable Sleep (6.5-7.5 hrs)';
    } else {
      sleepImpact = 2.2;
      sleepStatus = 'Chronic Sleep Debt (<6.5 hrs)';
    }
    ageOffset += sleepImpact;
    contributors.add(BiomarkerContributor(
      markerName: 'Sleep Duration & Architecture',
      markerNameHindi: 'नींद की अवधि व गुणवत्ता',
      impactYears: sleepImpact,
      status: sleepStatus,
      isProtective: sleepImpact < 0,
    ));

    final double biologicalAge = double.parse((chronologicalAge + ageOffset).toStringAsFixed(1));
    final double ageDelta = double.parse((biologicalAge - chronologicalAge).toStringAsFixed(1));

    // Identify top recommendation based on worst biomarker impact
    final worstContributor = List<BiomarkerContributor>.from(contributors)
      ..sort((a, b) => b.impactYears.compareTo(a.impactYears));

    String topAction;
    String topActionHindi;

    if (worstContributor.first.impactYears <= 0) {
      topAction = 'Maintain current elite cardiovascular conditioning and restful sleep patterns.';
      topActionHindi = 'अपनी उत्कृष्ट हृदय गति और नियमित नींद के पैटर्न को बनाए रखें।';
    } else if (worstContributor.first.markerName == 'Resting Heart Rate') {
      topAction = 'Add 2 weekly Zone 2 aerobic cardio sessions (30-45 mins) to reduce resting HR.';
      topActionHindi = 'विश्राम हृदय गति कम करने के लिए सप्ताह में २ बार जोन २ एरोबिक कार्डियो करें।';
    } else if (worstContributor.first.markerName == 'Heart Rate Variability') {
      topAction = 'Incorporate daily 10-minute Anulom Vilom pranayama and ensure consistent sleep timing.';
      topActionHindi = 'प्रतिदिन १० मिनट अनुलोम-विलोम प्राणायाम करें और नींद का समय नियमित रखें।';
    } else if (worstContributor.first.markerName == 'Systolic Arterial Pressure') {
      topAction = 'Reduce dietary sodium, incorporate potassium-rich Indian greens, and hydrate well.';
      topActionHindi = 'भोजन में नमक कम करें, पोटैशियम युक्त हरी सब्जियां शामिल करें और भरपूर पानी पिएं।';
    } else if (worstContributor.first.markerName == 'Daily Step Volume') {
      topAction = 'Aim for 8,000+ daily steps with 15-minute post-meal Shatapawali walks.';
      topActionHindi = 'प्रतिदिन भोजन के बाद १५ मिनट शतपावली टहलकर ८,०००+ कदमों का लक्ष्य रखें।';
    } else {
      topAction = 'Prioritize 7.5+ hours of dark, cool circadian sleep without late-night screens.';
      topActionHindi = 'स्क्रीन से दूर रहकर प्रतिदिन कम से कम ७.५ घंटे की गहरी नींद लें।';
    }

    return BiologicalAgeEstimate(
      id: id,
      userId: userId,
      chronologicalAge: chronologicalAge,
      biologicalAge: biologicalAge,
      ageDelta: ageDelta,
      confidenceScore: 0.92,
      contributors: contributors,
      topImprovementAction: topAction,
      topImprovementActionHindi: topActionHindi,
      calculatedAt: calculatedAt,
    );
  }
}
