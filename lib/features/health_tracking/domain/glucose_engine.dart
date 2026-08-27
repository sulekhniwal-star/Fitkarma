enum GlucoseContextType {
  fasting(name: 'Fasting (खाली पेट)', normalMax: 99),
  preMeal(name: 'Pre-Meal (भोजन से पहले)', normalMax: 105),
  postMeal2h(name: '2h Post-Meal (भोजन के 2 घंटे बाद)', normalMax: 139),
  bedtime(name: 'Bedtime (सोने से पहले)', normalMax: 120),
  random(name: 'Random / Other (अन्य समय)', normalMax: 140);

  final String name;
  final int normalMax;

  const GlucoseContextType({required this.name, required this.normalMax});
}

enum GlucoseStatus { normal, elevated, high, hypoglycemic }

class GlucoseReading {
  final String id;
  final int glucoseMgDl;
  final GlucoseContextType contextType;
  final String? correlatedMealName;
  final int? preMealGlucose; // for excursion calculation
  final DateTime recordedAt;

  const GlucoseReading({
    required this.id,
    required this.glucoseMgDl,
    required this.contextType,
    this.correlatedMealName,
    this.preMealGlucose,
    required this.recordedAt,
  });

  int? get mealExcursion => (preMealGlucose != null) ? (glucoseMgDl - preMealGlucose!) : null;

  factory GlucoseReading.fromMap(Map<String, dynamic> map, String id) {
    final typeName = map['contextType'] as String? ?? 'fasting';
    final contextType = GlucoseContextType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => GlucoseContextType.fasting,
    );

    return GlucoseReading(
      id: id,
      glucoseMgDl: (map['glucoseMgDl'] as num?)?.toInt() ?? 95,
      contextType: contextType,
      correlatedMealName: map['correlatedMealName'] as String?,
      preMealGlucose: (map['preMealGlucose'] as num?)?.toInt(),
      recordedAt: map['recordedAt'] != null
          ? DateTime.tryParse(map['recordedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'glucoseMgDl': glucoseMgDl,
      'contextType': contextType.name,
      'correlatedMealName': correlatedMealName,
      'preMealGlucose': preMealGlucose,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }
}

class GlucoseSummaryResult {
  final double estimatedHbA1c;
  final double averageGlucoseMgDl;
  final double timeInRangePercent; // 70 to 140 mg/dL
  final GlucoseStatus currentStatus;
  final String glycemicInsight;

  const GlucoseSummaryResult({
    required this.estimatedHbA1c,
    required this.averageGlucoseMgDl,
    required this.timeInRangePercent,
    required this.currentStatus,
    required this.glycemicInsight,
  });
}

class GlucoseEngine {
  /// Pure Dart deterministic calculation of estimated HbA1c using Nathan et al. formula
  /// eHbA1c (%) = (Average Glucose + 46.7) / 28.7
  static double calculateEstimatedHbA1c(double averageGlucoseMgDl) {
    if (averageGlucoseMgDl <= 0) return 5.2;
    final hba1c = (averageGlucoseMgDl + 46.7) / 28.7;
    return double.parse(hba1c.toStringAsFixed(1));
  }

  /// Evaluates glycemic health from a list of historical readings
  static GlucoseSummaryResult evaluateReadings(List<GlucoseReading> readings) {
    if (readings.isEmpty) {
      return const GlucoseSummaryResult(
        estimatedHbA1c: 5.3,
        averageGlucoseMgDl: 105.0,
        timeInRangePercent: 95.0,
        currentStatus: GlucoseStatus.normal,
        glycemicInsight: 'No glucose readings logged yet. Baseline glycemic metrics active.',
      );
    }

    final totalGlucose = readings.fold<int>(0, (sum, item) => sum + item.glucoseMgDl);
    final avg = totalGlucose / readings.length;
    final eA1c = calculateEstimatedHbA1c(avg);

    // Time In Range (TIR: 70 to 140 mg/dL)
    final inRangeCount = readings.where((r) => r.glucoseMgDl >= 70 && r.glucoseMgDl <= 140).length;
    final tir = (inRangeCount / readings.length) * 100.0;

    final latest = readings.first;
    final GlucoseStatus status;
    if (latest.glucoseMgDl < 70) {
      status = GlucoseStatus.hypoglycemic;
    } else if (latest.glucoseMgDl <= latest.contextType.normalMax) {
      status = GlucoseStatus.normal;
    } else if (latest.glucoseMgDl <= latest.contextType.normalMax + 30) {
      status = GlucoseStatus.elevated;
    } else {
      status = GlucoseStatus.high;
    }

    final String insight;
    if (status == GlucoseStatus.high) {
      insight = 'Elevated postprandial glucose detected. Take a 15-minute brisk walk (शतपावली) to stimulate GLUT-4 muscle glucose uptake without insulin demand.';
    } else if (tir >= 85.0) {
      insight = 'Outstanding Glycemic Stability! Your Time-In-Range (${tir.round()}%) reflects excellent insulin sensitivity and balanced meal composition.';
    } else {
      insight = 'Moderate glycemic variability. Consider pairing complex carbohydrates (millets/brown rice) with fiber and protein (daal/paneer).';
    }

    return GlucoseSummaryResult(
      estimatedHbA1c: eA1c,
      averageGlucoseMgDl: double.parse(avg.toStringAsFixed(1)),
      timeInRangePercent: double.parse(tir.toStringAsFixed(1)),
      currentStatus: status,
      glycemicInsight: insight,
    );
  }
}
