import 'daily_intelligence_package.dart';

/// §P3-B AI Context Builder & Compressed Context Payload (Pure Dart)

class HealthSnapshotSummary {
  final double avg7DayProteinG;
  final double avg7DaySleepHours;
  final double avg7DayStrain;
  final String primaryConcern;

  const HealthSnapshotSummary({
    this.avg7DayProteinG = 58.0,
    this.avg7DaySleepHours = 7.2,
    this.avg7DayStrain = 10.5,
    this.primaryConcern = 'Low protein adherence',
  });

  Map<String, dynamic> toJson() => {
        'avg_protein_g': avg7DayProteinG,
        'avg_sleep_h': avg7DaySleepHours,
        'avg_strain': avg7DayStrain,
        'concern': primaryConcern,
      };
}

class AIContext {
  final String userId;
  final String name;
  final List<String> goals;
  final String program;
  final String dietType;
  final String tone;
  final List<String> injuries;
  final HealthSnapshotSummary snapshot;
  final int readinessScore;
  final String readinessTier;
  final String primaryFocus;
  final String primaryConcern;
  final int sleepDebtMin;
  final double dailyStrain;
  final String? weather;
  final String? festival;

  const AIContext({
    required this.userId,
    required this.name,
    required this.goals,
    required this.program,
    required this.dietType,
    this.tone = 'Empathetic',
    this.injuries = const [],
    required this.snapshot,
    required this.readinessScore,
    required this.readinessTier,
    required this.primaryFocus,
    required this.primaryConcern,
    this.sleepDebtMin = -45,
    this.dailyStrain = 8.5,
    this.weather,
    this.festival,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'goals': goals,
        'program': program,
        'diet_type': dietType,
        'tone': tone,
        'injuries': injuries,
        'snapshot': snapshot.toJson(),
        'readiness_score': readinessScore,
        'readiness_tier': readinessTier,
        'primary_focus': primaryFocus,
        'primary_concern': primaryConcern,
        'sleep_debt_min': sleepDebtMin,
        'daily_strain': dailyStrain,
        'weather': weather,
        'festival': festival,
      };

  String toCompressedPromptString() {
    return 'Profile: $name ($dietType, Goals: ${goals.join(', ')}, Program: $program)\n'
        'State: Readiness $readinessScore ($readinessTier), Focus: $primaryFocus, Sleep Debt: ${sleepDebtMin}m, Strain: $dailyStrain\n'
        'Trends: 7d Protein ${snapshot.avg7DayProteinG}g, 7d Sleep ${snapshot.avg7DaySleepHours}h, Concern: $primaryConcern\n'
        'Context: Weather: ${weather ?? 'Normal'}, Festival: ${festival ?? 'None'}';
  }
}

class AIContextBuilder {
  const AIContextBuilder();

  /// Build token-compressed AIContext combining profile, 7-day snapshot trends, DIP, and environmental triggers
  AIContext buildCompressed({
    required String userId,
    required String name,
    required List<String> goals,
    required String program,
    required String dietType,
    required DailyIntelligencePackage dip,
    HealthSnapshotSummary? snapshot,
    List<String> injuries = const [],
    String tone = 'Empathetic',
    int sleepDebtMin = -45,
    double dailyStrain = 8.5,
    String? weather = 'AQI 180 (Poor), 34°C',
    String? festival = 'Diwali (in 3 days)',
  }) {
    final healthSnapshot = snapshot ?? const HealthSnapshotSummary();

    return AIContext(
      userId: userId,
      name: name,
      goals: goals,
      program: program,
      dietType: dietType,
      tone: tone,
      injuries: injuries,
      snapshot: healthSnapshot,
      readinessScore: dip.readinessScore,
      readinessTier: dip.readinessTier.name,
      primaryFocus: dip.primaryFocus,
      primaryConcern: healthSnapshot.primaryConcern,
      sleepDebtMin: sleepDebtMin,
      dailyStrain: dailyStrain,
      weather: weather,
      festival: festival,
    );
  }
}
