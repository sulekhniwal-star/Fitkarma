/// §P6-E UserScores — wires upperBodyReadiness / lowerBodyReadiness
/// and mobilityIndex into a unified user athletic profile.
library;

/// Aggregated user physical readiness and movement health scores.
class UserScores {
  const UserScores({
    this.upperBodyReadiness = 100.0,
    this.lowerBodyReadiness = 100.0,
    this.overallReadiness = 100.0,
    this.mobilityIndex = 100,
    this.daySwapSuggestion,
  });

  /// 0–100 shoulder/chest/back segment readiness.
  final double upperBodyReadiness;

  /// 0–100 quad/hamstring/hip/ankle segment readiness.
  final double lowerBodyReadiness;

  /// Weighted mean readiness across upper and lower segments.
  final double overallReadiness;

  /// Movement Screening mobility score 0–100 (from MobilityDiagnosisEngine).
  final int mobilityIndex;

  /// Non-null when an upper/lower training day swap is advisable.
  final String? daySwapSuggestion;

  UserScores copyWith({
    double? upperBodyReadiness,
    double? lowerBodyReadiness,
    double? overallReadiness,
    int? mobilityIndex,
    String? daySwapSuggestion,
  }) {
    return UserScores(
      upperBodyReadiness: upperBodyReadiness ?? this.upperBodyReadiness,
      lowerBodyReadiness: lowerBodyReadiness ?? this.lowerBodyReadiness,
      overallReadiness: overallReadiness ?? this.overallReadiness,
      mobilityIndex: mobilityIndex ?? this.mobilityIndex,
      daySwapSuggestion: daySwapSuggestion ?? this.daySwapSuggestion,
    );
  }
}
