/// Readiness & Health Score Tier
enum ReadinessTier { basic, enhanced, premium }

/// Canonical Daily Intelligence Package (DIP) assembled by Health OS Brain
class DailyIntelligencePackage {
  final String userId;
  final DateTime date;
  final int readinessScore;
  final ReadinessTier readinessTier;
  final String primaryFocus;
  final List<String> dailyMissions;
  final Map<String, dynamic> contextualMetadata;

  const DailyIntelligencePackage({
    required this.userId,
    required this.date,
    required this.readinessScore,
    required this.readinessTier,
    required this.primaryFocus,
    required this.dailyMissions,
    this.contextualMetadata = const {},
  });

  factory DailyIntelligencePackage.fromJson(Map<String, dynamic> json) {
    return DailyIntelligencePackage(
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      readinessScore: json['readiness_score'] as int,
      readinessTier: ReadinessTier.values.byName(json['readiness_tier'] as String? ?? 'basic'),
      primaryFocus: json['primary_focus'] as String,
      dailyMissions: List<String>.from(json['daily_missions'] ?? []),
      contextualMetadata: json['contextual_metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'date': date.toIso8601String(),
        'readiness_score': readinessScore,
        'readiness_tier': readinessTier.name,
        'primary_focus': primaryFocus,
        'daily_missions': dailyMissions,
        'contextual_metadata': contextualMetadata,
      };
}
