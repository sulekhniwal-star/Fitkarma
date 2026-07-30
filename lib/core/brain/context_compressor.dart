import '../brain/daily_intelligence_package.dart';

/// Compresses user context into a token-efficient JSON payload for LLM prompts
class ContextCompressor {
  const ContextCompressor();

  /// Build compressed context dictionary
  Map<String, dynamic> compressContext({
    required DailyIntelligencePackage dip,
    required double bmr,
    required double tdee,
    required String goal,
    required String dietaryPreference,
  }) {
    return {
      'r_score': dip.readinessScore,
      'r_tier': dip.readinessTier.name,
      'focus': dip.primaryFocus,
      'bmr': bmr.round(),
      'tdee': tdee.round(),
      'goal': goal,
      'diet': dietaryPreference,
    };
  }
}
