/// §P4-E Glucose Engine & HbA1c Estimator (Pure Dart)

// ── Glucose Measurement Context Tag ───────────────────────────────────────────

enum GlucoseContextTag {
  fasting,
  preMeal,
  postMeal1h,
  postMeal2h,
  bedtime,
  random,
}

extension GlucoseContextTagStyle on GlucoseContextTag {
  String get label {
    switch (this) {
      case GlucoseContextTag.fasting:
        return 'Fasting';
      case GlucoseContextTag.preMeal:
        return 'Pre-Meal';
      case GlucoseContextTag.postMeal1h:
        return 'Post-Meal (1-hour)';
      case GlucoseContextTag.postMeal2h:
        return 'Post-Meal (2-hour)';
      case GlucoseContextTag.bedtime:
        return 'Bedtime';
      case GlucoseContextTag.random:
        return 'Random';
    }
  }
}

// ── Glucose Status Category ───────────────────────────────────────────────────

enum GlucoseCategory { normal, elevated, high, critical }

extension GlucoseCategoryStyle on GlucoseCategory {
  String get label {
    switch (this) {
      case GlucoseCategory.normal:
        return 'Normal';
      case GlucoseCategory.elevated:
        return 'Elevated';
      case GlucoseCategory.high:
        return 'High';
      case GlucoseCategory.critical:
        return 'Critical Spike';
    }
  }
}

// ── Glucose Record ────────────────────────────────────────────────────────────

class GlucoseRecord {
  final int? id;
  final double mgDl;
  final GlucoseContextTag tag;
  final DateTime measuredAt;
  final String? correlatedMealName;
  final String? notes;

  const GlucoseRecord({
    this.id,
    required this.mgDl,
    required this.tag,
    required this.measuredAt,
    this.correlatedMealName,
    this.notes,
  });

  GlucoseCategory get category => GlucoseEngine.categorizeGlucose(mgDl, tag);

  String get readingLabel => '${mgDl.round()} mg/dL';
}

// ── HbA1c Estimation Result ───────────────────────────────────────────────────

class Hba1cEstimation {
  final double estimatedHba1cPct;
  final double averageGlucoseMgDl;
  final int totalLoggedDays;
  final bool isSufficientData; // requires >= 90 days of logs per spec
  final String statusLabel;

  const Hba1cEstimation({
    required this.estimatedHba1cPct,
    required this.averageGlucoseMgDl,
    required this.totalLoggedDays,
    required this.isSufficientData,
    required this.statusLabel,
  });
}

// ── Glucose Engine ────────────────────────────────────────────────────────────

class GlucoseEngine {
  const GlucoseEngine();

  /// Categorize Glucose reading by value and measurement context tag
  static GlucoseCategory categorizeGlucose(double mgDl, GlucoseContextTag tag) {
    if (tag == GlucoseContextTag.fasting) {
      if (mgDl >= 126) return GlucoseCategory.high;
      if (mgDl >= 100) return GlucoseCategory.elevated;
      return GlucoseCategory.normal;
    } else if (tag == GlucoseContextTag.postMeal1h || tag == GlucoseContextTag.postMeal2h) {
      if (mgDl >= 200) return GlucoseCategory.critical;
      if (mgDl >= 140) return GlucoseCategory.elevated;
      return GlucoseCategory.normal;
    } else {
      if (mgDl >= 200) return GlucoseCategory.critical;
      if (mgDl >= 140) return GlucoseCategory.high;
      if (mgDl >= 115) return GlucoseCategory.elevated;
      return GlucoseCategory.normal;
    }
  }

  /// §P4-E HbA1c Calculation (per spec mathematical formula):
  ///   Estimated HbA1c (%) = (Average Glucose mg/dL + 46.7) / 28.7
  ///   Requires >= 90 days of recorded glucose logs.
  Hba1cEstimation calculateEstimatedHba1c({
    required List<GlucoseRecord> records,
    required int totalLoggedDays,
  }) {
    if (records.isEmpty) {
      return Hba1cEstimation(
        estimatedHba1cPct: 0.0,
        averageGlucoseMgDl: 0.0,
        totalLoggedDays: totalLoggedDays,
        isSufficientData: false,
        statusLabel: 'Insufficient data (<90 days)',
      );
    }

    final sum = records.fold<double>(0.0, (acc, r) => acc + r.mgDl);
    final avg = sum / records.length;

    final hba1c = (avg + 46.7) / 28.7;
    final isSufficient = totalLoggedDays >= 90;

    String status = 'Normal (<5.7%)';
    if (hba1c >= 6.5) {
      status = 'Diabetic Threshold (>=6.5%)';
    } else if (hba1c >= 5.7) {
      status = 'Pre-diabetic Threshold (>=5.7%)';
    }

    return Hba1cEstimation(
      estimatedHba1cPct: double.parse(hba1c.toStringAsFixed(1)),
      averageGlucoseMgDl: double.parse(avg.toStringAsFixed(1)),
      totalLoggedDays: totalLoggedDays,
      isSufficientData: isSufficient,
      statusLabel: isSufficient ? status : 'Estimation requires >= 90 days of logs ($totalLoggedDays logged)',
    );
  }

  /// Detect glycemic spikes correlated with meal inputs
  String? detectMealSpikeNudge(List<GlucoseRecord> records) {
    if (records.isEmpty) return null;

    final postMealSpikes = records.where((r) =>
        (r.tag == GlucoseContextTag.postMeal1h || r.tag == GlucoseContextTag.postMeal2h) &&
        r.mgDl >= 140.0);

    if (postMealSpikes.isNotEmpty) {
      final spike = postMealSpikes.last;
      final mealName = spike.correlatedMealName ?? 'your recent meal';
      return 'Glycemic spike detected (${spike.readingLabel}) after $mealName. A 10-minute post-meal walk helps flatten glucose curves.';
    }

    return null;
  }
}
