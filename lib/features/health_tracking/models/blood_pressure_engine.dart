// §P4-D Blood Pressure Engine (Pure Dart)
//
// Models AHA (American Heart Association) categories, BP records,
// rising trend detection, and security/biometric state logic.

// ── Blood Pressure Category ───────────────────────────────────────────────────

enum BpCategory { normal, elevated, stage1, stage2, crisis }

extension BpCategoryStyle on BpCategory {
  String get label {
    switch (this) {
      case BpCategory.normal:
        return 'Normal';
      case BpCategory.elevated:
        return 'Elevated';
      case BpCategory.stage1:
        return 'Stage 1 Hypertension';
      case BpCategory.stage2:
        return 'Stage 2 Hypertension';
      case BpCategory.crisis:
        return 'Hypertensive Crisis';
    }
  }

  String get guidance {
    switch (this) {
      case BpCategory.normal:
        return 'Optimal reading. Maintain regular exercise and a satvik/balanced diet.';
      case BpCategory.elevated:
        return 'Slightly elevated. Reduce sodium intake and re-check after resting.';
      case BpCategory.stage1:
        return 'Stage 1 Hypertension. Limit caffeine, manage stress, and consult your doctor if consistent.';
      case BpCategory.stage2:
        return 'Stage 2 Hypertension. Avoid intense strenuous lifts and schedule a clinical evaluation.';
      case BpCategory.crisis:
        return 'CRITICAL: Seek immediate emergency medical care if accompanied by symptoms!';
    }
  }
}

// ── Recording Method ──────────────────────────────────────────────────────────

enum BpRecordingMethod { manual, wearable }

extension BpRecordingMethodLabel on BpRecordingMethod {
  String get label => this == BpRecordingMethod.manual ? 'Manual' : 'Wearable';
}

// ── Blood Pressure Record Model ───────────────────────────────────────────────

class BloodPressureRecord {
  final int? id;
  final int systolic;
  final int diastolic;
  final DateTime measuredAt;
  final BpRecordingMethod recordingMethod;

  const BloodPressureRecord({
    this.id,
    required this.systolic,
    required this.diastolic,
    required this.measuredAt,
    this.recordingMethod = BpRecordingMethod.manual,
  });

  BpCategory get category =>
      BloodPressureEngine.categorizeBp(systolic, diastolic);

  String get readingLabel => '$systolic / $diastolic mmHg';
}

// ── Blood Pressure Engine ─────────────────────────────────────────────────────

class BloodPressureEngine {
  const BloodPressureEngine();

  /// AHA Standard Blood Pressure Classification:
  /// - Normal: < 120 AND < 80
  /// - Elevated: 120-129 AND < 80
  /// - Stage 1: 130-139 OR 80-89
  /// - Stage 2: 140+ OR 90+
  /// - Crisis: > 180 OR > 120
  static BpCategory categorizeBp(int systolic, int diastolic) {
    if (systolic > 180 || diastolic > 120) {
      return BpCategory.crisis;
    }
    if (systolic >= 140 || diastolic >= 90) {
      return BpCategory.stage2;
    }
    if (systolic >= 130 || diastolic >= 89) {
      return BpCategory.stage1;
    }
    if (systolic >= 120 && diastolic < 80) {
      return BpCategory.elevated;
    }
    return BpCategory.normal;
  }

  /// Detects consecutive rising BP trend (e.g. 3 rising readings in a row)
  bool detectRisingTrend(List<BloodPressureRecord> history,
      {int consecutiveCount = 3}) {
    if (history.length < consecutiveCount) return false;

    // Sort ascending by measuredAt to trace timeline
    final sorted = List<BloodPressureRecord>.from(history)
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));

    final tail = sorted.sublist(sorted.length - consecutiveCount);
    for (int i = 1; i < tail.length; i++) {
      if (tail[i].systolic <= tail[i - 1].systolic) {
        return false;
      }
    }
    return true;
  }

  /// Generate risk warning nudge for BP screen header
  String? generateBpWarning(List<BloodPressureRecord> history) {
    if (history.isEmpty) return null;

    final latest = history.last;

    if (latest.category == BpCategory.crisis) {
      return 'CRITICAL: Very high BP reading recorded (${latest.readingLabel}). Rest and consult a healthcare provider immediately.';
    }

    if (detectRisingTrend(history, consecutiveCount: 3)) {
      return 'Warning: 3 consecutive rising BP readings recorded. Limit caffeine and record again tonight.';
    }

    if (latest.category == BpCategory.stage2 ||
        latest.category == BpCategory.stage1) {
      return 'Elevated blood pressure trend (${latest.readingLabel}). Consider light cardio over max-effort lifts today.';
    }

    return null;
  }
}
