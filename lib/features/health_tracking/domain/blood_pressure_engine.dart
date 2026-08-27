enum BloodPressureCategory {
  normal(name: 'Normal (सामान्य)', isAlert: false),
  elevated(name: 'Elevated / Pre-hypertensive (हल्का बढ़ा हुआ)', isAlert: false),
  stage1Hypertension(name: 'Stage 1 Hypertension (उच्च रक्तचाप स्टेज 1)', isAlert: true),
  stage2Hypertension(name: 'Stage 2 Hypertension (उच्च रक्तचाप स्टेज 2)', isAlert: true),
  hypertensiveCrisis(name: 'Hypertensive Crisis (आपातकालीन उच्च रक्तचाप)', isAlert: true);

  final String name;
  final bool isAlert;

  const BloodPressureCategory({required this.name, required this.isAlert});
}

class BloodPressureReading {
  final String id;
  final int systolic;
  final int diastolic;
  final int pulseBpm;
  final String arm; // 'Left' or 'Right'
  final String posture; // 'Sitting' or 'Lying'
  final DateTime recordedAt;

  const BloodPressureReading({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulseBpm,
    this.arm = 'Left',
    this.posture = 'Sitting',
    required this.recordedAt,
  });

  double get meanArterialPressure => diastolic + ((systolic - diastolic) / 3.0);
  int get pulsePressure => systolic - diastolic;

  factory BloodPressureReading.fromMap(Map<String, dynamic> map, String id) {
    return BloodPressureReading(
      id: id,
      systolic: (map['systolic'] as num?)?.toInt() ?? 120,
      diastolic: (map['diastolic'] as num?)?.toInt() ?? 80,
      pulseBpm: (map['pulseBpm'] as num?)?.toInt() ?? 70,
      arm: map['arm'] as String? ?? 'Left',
      posture: map['posture'] as String? ?? 'Sitting',
      recordedAt: map['recordedAt'] != null
          ? DateTime.tryParse(map['recordedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'systolic': systolic,
      'diastolic': diastolic,
      'pulseBpm': pulseBpm,
      'arm': arm,
      'posture': posture,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }
}

class BloodPressureEvaluation {
  final BloodPressureCategory category;
  final double meanArterialPressure;
  final int pulsePressure;
  final String lifestyleRecommendation;

  const BloodPressureEvaluation({
    required this.category,
    required this.meanArterialPressure,
    required this.pulsePressure,
    required this.lifestyleRecommendation,
  });
}

class BloodPressureEngine {
  /// Pure Dart deterministic evaluation of Blood Pressure according to AHA and Indian consensus guidelines
  static BloodPressureEvaluation evaluate({
    required int systolic,
    required int diastolic,
  }) {
    final map = diastolic + ((systolic - diastolic) / 3.0);
    final pulsePressure = systolic - diastolic;

    final BloodPressureCategory category;
    final String recommendation;

    if (systolic > 180 || diastolic > 120) {
      category = BloodPressureCategory.hypertensiveCrisis;
      recommendation = 'CRITICAL: Immediate medical attention required. Rest quietly and contact emergency healthcare.';
    } else if (systolic >= 140 || diastolic >= 90) {
      category = BloodPressureCategory.stage2Hypertension;
      recommendation = 'Stage 2 Hypertension detected. Consult physician, reduce sodium (<2,000mg/day), and incorporate daily Zone 2 brisk walking.';
    } else if ((systolic >= 130 && systolic <= 139) || (diastolic >= 80 && diastolic <= 89)) {
      category = BloodPressureCategory.stage1Hypertension;
      recommendation = 'Stage 1 Hypertension. Focus on potassium-rich foods (coconut water, bananas, spinach), daily Pranayama, and weight management.';
    } else if (systolic >= 120 && systolic <= 129 && diastolic < 80) {
      category = BloodPressureCategory.elevated;
      recommendation = 'Elevated blood pressure. Maintain adequate hydration, limit caffeine after 2 PM, and engage in regular cardiovascular exercise.';
    } else {
      category = BloodPressureCategory.normal;
      recommendation = 'Optimal blood pressure. Cardiovascular arterial elasticity and autonomic tone are balanced.';
    }

    return BloodPressureEvaluation(
      category: category,
      meanArterialPressure: double.parse(map.toStringAsFixed(1)),
      pulsePressure: pulsePressure,
      lifestyleRecommendation: recommendation,
    );
  }
}
