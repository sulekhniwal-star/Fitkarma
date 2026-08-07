/// §P4-C Sleep Stage Metrics and Debt Modeling (Pure Dart)

// ── Sleep Stage ───────────────────────────────────────────────────────────────

enum SleepStage { awake, rem, light, deep }

extension SleepStageStyle on SleepStage {
  String get label {
    switch (this) {
      case SleepStage.awake:
        return 'Awake';
      case SleepStage.rem:
        return 'REM';
      case SleepStage.light:
        return 'Light';
      case SleepStage.deep:
        return 'Deep';
    }
  }
}

// ── Sleep Debt Level ──────────────────────────────────────────────────────────

enum SleepDebtLevel { none, low, moderate, high, severe }

extension SleepDebtLevelLabel on SleepDebtLevel {
  String get label {
    switch (this) {
      case SleepDebtLevel.none:
        return 'None';
      case SleepDebtLevel.low:
        return 'Low';
      case SleepDebtLevel.moderate:
        return 'Moderate';
      case SleepDebtLevel.high:
        return 'High';
      case SleepDebtLevel.severe:
        return 'Severe';
    }
  }
}

// ── Sleep Quality ─────────────────────────────────────────────────────────────

enum SleepQuality { poor, fair, normal, good, excellent }

extension SleepQualityLabel on SleepQuality {
  String get label {
    switch (this) {
      case SleepQuality.poor:
        return 'Poor';
      case SleepQuality.fair:
        return 'Fair';
      case SleepQuality.normal:
        return 'Normal';
      case SleepQuality.good:
        return 'Good';
      case SleepQuality.excellent:
        return 'Excellent';
    }
  }

  int get starRating {
    switch (this) {
      case SleepQuality.poor:
        return 1;
      case SleepQuality.fair:
        return 2;
      case SleepQuality.normal:
        return 3;
      case SleepQuality.good:
        return 4;
      case SleepQuality.excellent:
        return 5;
    }
  }
}

// ── Sleep Stage Breakdown ─────────────────────────────────────────────────────

class SleepStageBreakdown {
  final double awakePct;  // 0.0–1.0
  final double remPct;    // 0.0–1.0
  final double lightPct;  // 0.0–1.0
  final double deepPct;   // 0.0–1.0

  const SleepStageBreakdown({
    required this.awakePct,
    required this.remPct,
    required this.lightPct,
    required this.deepPct,
  });

  /// Validates that the four stages sum to ≈1.0 (within float tolerance)
  bool get isValid {
    final sum = awakePct + remPct + lightPct + deepPct;
    return (sum - 1.0).abs() < 0.02;
  }

  /// Stage with the highest percentage
  SleepStage get dominantStage {
    final values = {
      SleepStage.awake: awakePct,
      SleepStage.rem: remPct,
      SleepStage.light: lightPct,
      SleepStage.deep: deepPct,
    };
    return values.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  Map<SleepStage, double> get asMap => {
        SleepStage.awake: awakePct,
        SleepStage.rem: remPct,
        SleepStage.light: lightPct,
        SleepStage.deep: deepPct,
      };
}

// ── HRV Data Point ────────────────────────────────────────────────────────────

class HrvDataPoint {
  final DateTime date;
  final double rmssdMs; // rMSSD in milliseconds

  const HrvDataPoint({required this.date, required this.rmssdMs});
}

// ── Night Sleep Record ────────────────────────────────────────────────────────

class NightSleepRecord {
  final DateTime date;
  final double totalHours;         // e.g. 7.25 = 7h 15m
  final SleepQuality quality;
  final SleepStageBreakdown stages;
  final double efficiencyPct;      // 0–100
  final DateTime? bedtime;
  final DateTime? wakeTime;

  const NightSleepRecord({
    required this.date,
    required this.totalHours,
    required this.quality,
    required this.stages,
    this.efficiencyPct = 88.0,
    this.bedtime,
    this.wakeTime,
  });

  int get totalMinutes => (totalHours * 60).round();

  /// Human-readable duration string, e.g. "7h 15m"
  String get durationLabel {
    final h = totalHours.floor();
    final m = ((totalHours - h) * 60).round();
    return '${h}h ${m}m';
  }
}

// ── Sleep Debt Engine ─────────────────────────────────────────────────────────

/// §P4-C Sleep Debt Engine (Pure Dart)
///
/// Formula (per spec):
///   Sleep Debt = Σᵢ₌₁⁷ (480 − sleepMinutesᵢ)
///
/// Default baseline: 480 minutes (8 hours)
class SleepDebtEngine {
  final int baselineMinutes;

  const SleepDebtEngine({this.baselineMinutes = 480});

  /// Calculate rolling 7-day sleep debt in minutes.
  ///
  /// [sleepMinutesPerDay]: list of actual sleep minutes for each day.
  ///   May have fewer than 7 entries (early in program or missing data).
  ///   Each missing day contributes a full deficit (baseline).
  ///
  /// Returns: positive = debt, negative = surplus.
  int calculateRolling7DayDebt(List<int> sleepMinutesPerDay) {
    // Pad to 7 days with baseline if fewer entries
    final padded = List<int>.from(sleepMinutesPerDay);
    while (padded.length < 7) {
      padded.insert(0, baselineMinutes); // Assume target on missing days
    }
    // Use last 7 entries
    final window = padded.length > 7 ? padded.sublist(padded.length - 7) : padded;
    int debt = 0;
    for (final minutes in window) {
      debt += baselineMinutes - minutes;
    }
    return debt; // positive = owe sleep, negative = banked extra
  }

  /// Classify debt magnitude into a [SleepDebtLevel]
  SleepDebtLevel classifyDebt(int debtMinutes) {
    if (debtMinutes <= 0) return SleepDebtLevel.none;
    if (debtMinutes <= 60) return SleepDebtLevel.low;
    if (debtMinutes <= 180) return SleepDebtLevel.moderate;
    if (debtMinutes <= 360) return SleepDebtLevel.high;
    return SleepDebtLevel.severe;
  }

  /// Format debt as human-readable string (e.g. "−30m", "+1h 10m")
  String formatDebt(int debtMinutes) {
    if (debtMinutes == 0) return '0m';
    final sign = debtMinutes > 0 ? '−' : '+'; // debt=positive means owe
    final abs = debtMinutes.abs();
    final h = abs ~/ 60;
    final m = abs % 60;
    if (h == 0) return '$sign${m}m';
    if (m == 0) return '$sign${h}h';
    return '$sign${h}h ${m}m';
  }

  /// Compute sleep quality from stage breakdown and duration ratio
  SleepQuality classifyQuality({
    required double actualHours,
    required double needHours,
    required double deepPct,
    required double remPct,
  }) {
    final durationRatio = needHours > 0 ? actualHours / needHours : 0.0;
    final restfulness = deepPct + remPct; // combined restorative %

    if (durationRatio >= 0.95 && restfulness >= 0.38) return SleepQuality.excellent;
    if (durationRatio >= 0.87 && restfulness >= 0.33) return SleepQuality.good;
    if (durationRatio >= 0.75 && restfulness >= 0.25) return SleepQuality.normal;
    if (durationRatio >= 0.60) return SleepQuality.fair;
    return SleepQuality.poor;
  }
}
