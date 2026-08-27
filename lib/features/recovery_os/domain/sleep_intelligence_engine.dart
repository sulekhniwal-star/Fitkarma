class SleepSessionData {
  final DateTime sleepStart;
  final DateTime sleepEnd;
  final int deepSleepMinutes;
  final int remSleepMinutes;
  final int lightSleepMinutes;
  final int awakeMinutes;
  final int latencyMinutes; // time to fall asleep
  final int userSleepNeedHours; // baseline need, default 8

  const SleepSessionData({
    required this.sleepStart,
    required this.sleepEnd,
    required this.deepSleepMinutes,
    required this.remSleepMinutes,
    required this.lightSleepMinutes,
    required this.awakeMinutes,
    this.latencyMinutes = 15,
    this.userSleepNeedHours = 8,
  });

  int get totalDurationMinutes => sleepEnd.difference(sleepStart).inMinutes;
  int get actualAsleepMinutes => deepSleepMinutes + remSleepMinutes + lightSleepMinutes;
  double get totalSleepHours => actualAsleepMinutes / 60.0;
  double get sleepEfficiency => totalDurationMinutes > 0
      ? (actualAsleepMinutes / totalDurationMinutes).clamp(0.0, 1.0)
      : 0.85;

  factory SleepSessionData.fromMap(Map<String, dynamic> map) {
    return SleepSessionData(
      sleepStart: map['sleepStart'] != null
          ? DateTime.tryParse(map['sleepStart']) ?? DateTime.now().subtract(const Duration(hours: 8))
          : DateTime.now().subtract(const Duration(hours: 8)),
      sleepEnd: map['sleepEnd'] != null
          ? DateTime.tryParse(map['sleepEnd']) ?? DateTime.now()
          : DateTime.now(),
      deepSleepMinutes: (map['deepSleepMinutes'] as num?)?.toInt() ?? 75,
      remSleepMinutes: (map['remSleepMinutes'] as num?)?.toInt() ?? 95,
      lightSleepMinutes: (map['lightSleepMinutes'] as num?)?.toInt() ?? 240,
      awakeMinutes: (map['awakeMinutes'] as num?)?.toInt() ?? 30,
      latencyMinutes: (map['latencyMinutes'] as num?)?.toInt() ?? 15,
      userSleepNeedHours: (map['userSleepNeedHours'] as num?)?.toInt() ?? 8,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sleepStart': sleepStart.toIso8601String(),
      'sleepEnd': sleepEnd.toIso8601String(),
      'deepSleepMinutes': deepSleepMinutes,
      'remSleepMinutes': remSleepMinutes,
      'lightSleepMinutes': lightSleepMinutes,
      'awakeMinutes': awakeMinutes,
      'latencyMinutes': latencyMinutes,
      'userSleepNeedHours': userSleepNeedHours,
    };
  }

  static SleepSessionData defaultSession() {
    final now = DateTime.now();
    return SleepSessionData(
      sleepStart: DateTime(now.year, now.month, now.day, 23, 0).subtract(const Duration(days: 1)),
      sleepEnd: DateTime(now.year, now.month, now.day, 7, 0),
      deepSleepMinutes: 80,
      remSleepMinutes: 100,
      lightSleepMinutes: 260,
      awakeMinutes: 40,
      latencyMinutes: 15,
      userSleepNeedHours: 8,
    );
  }
}

class SleepAnalysisResult {
  final int sleepScore; // 0 to 100
  final double deepSleepPercent;
  final double remSleepPercent;
  final double sleepDebtHours; // 7-day cumulative debt
  final String optimalBedtimeWindow;
  final String sleepQualityCategory;
  final List<String> windDownProtocols;

  const SleepAnalysisResult({
    required this.sleepScore,
    required this.deepSleepPercent,
    required this.remSleepPercent,
    required this.sleepDebtHours,
    required this.optimalBedtimeWindow,
    required this.sleepQualityCategory,
    required this.windDownProtocols,
  });
}

class SleepIntelligenceEngine {
  /// Pure Dart deterministic calculation of sleep architecture, quality score, and circadian debt
  static SleepAnalysisResult evaluateSleep({
    required SleepSessionData session,
    double rolling7DaySleepDebt = 1.5,
  }) {
    final totalMins = session.actualAsleepMinutes.clamp(1, 1440);
    final deepPercent = session.deepSleepMinutes / totalMins;
    final remPercent = session.remSleepMinutes / totalMins;

    // 1. Duration Score (40 pts)
    final durationRatio = (session.totalSleepHours / session.userSleepNeedHours).clamp(0.0, 1.0);
    final durationScore = durationRatio * 40.0;

    // 2. Deep Sleep Score (25 pts) - optimal is >= 15% (0.15)
    final deepRatio = (deepPercent / 0.18).clamp(0.0, 1.0);
    final deepScore = deepRatio * 25.0;

    // 3. REM Sleep Score (20 pts) - optimal is >= 20% (0.20)
    final remRatio = (remPercent / 0.22).clamp(0.0, 1.0);
    final remScore = remRatio * 20.0;

    // 4. Efficiency Score (15 pts)
    final effScore = (session.sleepEfficiency * 15.0).clamp(0.0, 15.0);

    final finalScore = (durationScore + deepScore + remScore + effScore).round().clamp(0, 100);

    final String category;
    if (finalScore >= 85) {
      category = 'Optimal Restorative Sleep (उत्कृष्ट नींद)';
    } else if (finalScore >= 70) {
      category = 'Good Quality Sleep (संतुलित नींद)';
    } else if (finalScore >= 50) {
      category = 'Sub-optimal Sleep (अधूरी नींद)';
    } else {
      category = 'Severe Sleep Deficit (नींद की भारी कमी)';
    }

    // Dynamic Bedtime Calculation based on debt
    final String bedtimeWindow;
    if (rolling7DaySleepDebt > 3.0) {
      bedtimeWindow = '10:00 PM – 10:30 PM (Early catch-up window)';
    } else if (rolling7DaySleepDebt > 1.0) {
      bedtimeWindow = '10:30 PM – 11:00 PM (Target circadian window)';
    } else {
      bedtimeWindow = '11:00 PM – 11:30 PM (Maintenance bedtime)';
    }

    final protocols = [
      'Turmeric Golden Milk (हल्दी दूध) or Chamomile tea 45 mins prior to sleep.',
      'Stop caffeine/chai intake at least 8 hours before target bedtime.',
      'Dim blue-light screens and keep bedroom cool (~20-22°C) for melatonin release.',
      '5-minute 4-7-8 Pranayama or box breathing to activate parasympathetic tone.',
    ];

    return SleepAnalysisResult(
      sleepScore: finalScore,
      deepSleepPercent: deepPercent,
      remSleepPercent: remPercent,
      sleepDebtHours: rolling7DaySleepDebt,
      optimalBedtimeWindow: bedtimeWindow,
      sleepQualityCategory: category,
      windDownProtocols: protocols,
    );
  }
}
