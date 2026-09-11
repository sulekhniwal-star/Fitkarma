import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/template_fallback_engine.dart';

enum AiModelTier { tiny, medium, large }

class AiRoutingRepository {
  final SupabaseClient? _supabase;

  AiRoutingRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Invokes the server-side Groq router through Supabase Edge Functions
  /// Seamlessly falls back to local deterministic templates if offline.
  Future<String> askCoach({
    required String prompt,
    AiModelTier tier = AiModelTier.medium,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'askAiCoach',
        body: {
          'tier': tier.name.toUpperCase(),
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are FitKarma AI Health Coach. Provide actionable, concise advice for Indian fitness enthusiasts.',
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        },
      );

      final data = response.data;
      if (data != null && data is Map && data['response'] != null && (data['response'] as String).isNotEmpty) {
        return data['response'] as String;
      }
    } catch (_) {
      // Network failure, offline, or uninitialized backend -> fallback
    }

    // Local deterministic fallback
    return TemplateFallbackEngine.getFallbackResponse(prompt);
  }
}
