/// Model Tiers for Tiered AI Routing
enum AiModelTier {
  /// Fast, low latency model for basic classification & quick extraction
  tiny,

  /// Balanced model for coaching responses & meal quality analysis
  medium,

  /// High reasoning model for clinical report parsing & complex trajectory forecasting
  large,
}

/// Task Complexity Classification
enum TaskComplexity {
  simpleExtraction,
  coachingNudge,
  clinicalAnalysis,
}

/// Tiered AI Router Component
class AiRouter {
  const AiRouter();

  /// Routes task complexity to the appropriate AI Model Tier
  AiModelTier routeTask(TaskComplexity complexity) {
    switch (complexity) {
      case TaskComplexity.simpleExtraction:
        return AiModelTier.tiny;
      case TaskComplexity.coachingNudge:
        return AiModelTier.medium;
      case TaskComplexity.clinicalAnalysis:
        return AiModelTier.large;
    }
  }

  /// Get model identifier for designated tier
  String getModelIdentifier(AiModelTier tier) {
    switch (tier) {
      case AiModelTier.tiny:
        return 'llama-3.1-8b-instant';
      case AiModelTier.medium:
        return 'llama-3.3-70b-versatile';
      case AiModelTier.large:
        return 'mixtral-8x7b-32768';
    }
  }
}
