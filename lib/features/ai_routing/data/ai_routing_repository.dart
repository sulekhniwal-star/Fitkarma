import 'package:cloud_functions/cloud_functions.dart';
import '../domain/template_fallback_engine.dart';

enum AiModelTier { tiny, medium, large }

class AiRoutingRepository {
  final FirebaseFunctions _functions;

  AiRoutingRepository({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  /// Invokes the server-side Groq router through Firebase Callable Functions
  /// Seamlessly falls back to local deterministic templates if offline.
  Future<String> askCoach({
    required String prompt,
    AiModelTier tier = AiModelTier.medium,
  }) async {
    try {
      final callable = _functions.httpsCallable('askAiCoach');
      final response = await callable.call<Map<String, dynamic>>({
        'tier': tier.name.toUpperCase(),
        'messages': [
          {
            'role': 'system',
            'content': 'You are FitKarma AI Health Coach. Provide actionable, concise advice for Indian fitness enthusiasts.',
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
      });

      final result = response.data;
      if (result['response'] != null && (result['response'] as String).isNotEmpty) {
        return result['response'] as String;
      }
    } catch (_) {
      // Network failure, emulator offline, or uninitialized Firebase -> fallback
    }

    // Local deterministic fallback
    return TemplateFallbackEngine.getFallbackResponse(prompt);
  }
}
