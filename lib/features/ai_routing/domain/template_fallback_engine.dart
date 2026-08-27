class TemplateFallbackEngine {
  static const Map<String, String> _templates = {
    'nutrition': 'FitKarma Offline Nutrition: Focus on whole Indian foods — daal, paneer/tofu, seasonal vegetables, and balanced complex carbs like brown rice or millets.',
    'workout': 'FitKarma Offline Workout: Follow progressive overload on compound movements. Rest 90-120 seconds between heavy sets.',
    'recovery': 'FitKarma Offline Recovery: Prioritize 7-8 hours of sleep and active hydration. Do 10 minutes of gentle yoga or foam rolling.',
    'general': 'FitKarma Coach (Offline Mode): Track your meals, complete your daily steps, and stay consistent with your routine.'
  };

  /// Generates a local fallback response when internet or Cloud Functions are unreachable
  static String getFallbackResponse(String userPrompt) {
    final lower = userPrompt.toLowerCase();
    if (lower.contains('food') || lower.contains('diet') || lower.contains('eat') || lower.contains('protein') || lower.contains('calorie')) {
      return _templates['nutrition']!;
    }
    if (lower.contains('workout') || lower.contains('gym') || lower.contains('exercise') || lower.contains('lift') || lower.contains('cardio')) {
      return _templates['workout']!;
    }
    if (lower.contains('sleep') || lower.contains('rest') || lower.contains('sore') || lower.contains('recovery') || lower.contains('tired')) {
      return _templates['recovery']!;
    }
    return _templates['general']!;
  }
}
