enum AiModelTier { tiny, medium, large }

/// Rule Evaluator and Router for LLM tasks via Cloudflare Worker
class AiRouter {
  const AiRouter();

  /// Determine target AI model tier based on task complexity and user readiness context
  AiModelTier routeTask({required String taskType, bool requiresDeepReasoning = false}) {
    if (requiresDeepReasoning) {
      return AiModelTier.large; // e.g. Llama 3 70B via Groq
    }

    switch (taskType) {
      case 'workout_form_tip':
      case 'quick_nutrition_fact':
        return AiModelTier.tiny;
      case 'daily_coaching_summary':
      case 'recipe_substitution':
        return AiModelTier.medium;
      case 'health_anomaly_investigation':
      case 'program_evolution':
        return AiModelTier.large;
      default:
        return AiModelTier.medium;
    }
  }
}
