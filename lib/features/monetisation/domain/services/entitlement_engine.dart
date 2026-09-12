import '../models/monetisation_models.dart';

class EntitlementEngine {
  const EntitlementEngine();

  /// Determines whether the active entitlement tier permits access to a requested feature
  bool canAccessFeature({
    required UserEntitlement? entitlement,
    required String featureKey,
  }) {
    if (entitlement == null || !entitlement.isActive || entitlement.isExpired) {
      // Free tier defaults
      return _freeTierFeatures.contains(featureKey);
    }

    switch (entitlement.tier) {
      case AppSubscriptionTier.free:
        return _freeTierFeatures.contains(featureKey);
      case AppSubscriptionTier.pro:
        return _proTierFeatures.contains(featureKey) || _freeTierFeatures.contains(featureKey);
      case AppSubscriptionTier.elite:
      case AppSubscriptionTier.corporate:
        return true; // Elite & Corporate have all features
    }
  }

  static const Set<String> _freeTierFeatures = {
    'daily_mission',
    'readiness_basic',
    'dosha_quiz',
    'standard_nutrition_logging',
    'desi_workouts',
    'basic_karma',
    'squads_view',
  };

  static const Set<String> _proTierFeatures = {
    'ai_coach_unlimited',
    'festival_travel_modes',
    'cgm_telemetry_graphs',
    'biological_age_calculator',
    'doctor_dossier_pdf',
    'visual_body_analytics',
    'advanced_habits',
    'family_health_monitoring',
    'ad_free_experience',
  };

  /// Returns localized upgrade pitch based on restricted feature
  String getUpgradeMessage(String featureKey) {
    switch (featureKey) {
      case 'cgm_telemetry_graphs':
        return 'Unlock real-time CGM spike analytics and metabolic telemetry with FitKarma Pro.';
      case 'doctor_dossier_pdf':
        return 'Generate clinical-grade doctor summary dossiers in 1-click with FitKarma Pro.';
      case 'biological_age_calculator':
        return 'Calculate and track your cellular biological age with FitKarma Pro.';
      case 'human_coach_consultation':
        return 'Book 1-on-1 certified functional medicine and fitness coaches with FitKarma Elite.';
      default:
        return 'Upgrade to FitKarma Pro to unlock unlimited AI coaching and advanced health analytics.';
    }
  }
}
