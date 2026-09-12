import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/coach_message.dart';

/// CoachService — Secure client interface invoking Supabase Edge Function
/// Zero client-side AI keys or direct third-party API exposure.
class CoachService {
  final SupabaseClient? supabaseClient;

  CoachService({this.supabaseClient});

  /// Send message to Supabase Edge Function `coach-message`
  Future<CoachMessage> sendMessage({
    required String sessionId,
    required String userMessage,
    required Map<String, dynamic> contextSnapshot,
  }) async {
    if (supabaseClient != null) {
      try {
        final response = await supabaseClient!.functions.invoke(
          'coach-message',
          body: {
            'session_id': sessionId,
            'message': userMessage,
            'context': contextSnapshot,
          },
        );

        if (response.status == 200 && response.data != null) {
          final data = response.data as Map<String, dynamic>;
          return CoachMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            sessionId: sessionId,
            sender: MessageSender.coach,
            content: data['reply'] as String? ?? '',
            modelUsed: data['model_used'] as String? ?? 'llama-3.3-70b',
            timestamp: DateTime.now(),
          );
        }
      } catch (_) {
        // Fall through to deterministic offline fallback
      }
    }

    // Deterministic Offline Fallback Response
    final lower = userMessage.toLowerCase();
    String fallbackReply = "I am currently running in offline mode. For optimal recovery, stay hydrated and ensure adequate protein intake with your meals.";
    
    if (lower.contains('protein') || lower.contains('diet') || lower.contains('food')) {
      fallbackReply = "For high-protein Indian options, prioritize: Sattu drink (20g protein/100g), Low-fat Paneer (18g/100g), Sprouted Moong, and Soya chunks (52g/100g).";
    } else if (lower.contains('sore') || lower.contains('recovery') || lower.contains('pain')) {
      fallbackReply = "For muscle soreness, ensure 2.5L electrolyte water intake, 10 minutes of gentle mobility, and 8 hours of sleep tonight.";
    } else if (lower.contains('workout') || lower.contains('exercise')) {
      fallbackReply = "Remember to follow progressive overload principles: aim to add 1 rep or 1-2kg on your compound lifts when recovery permits.";
    }

    return CoachMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionId: sessionId,
      sender: MessageSender.coach,
      content: fallbackReply,
      modelUsed: 'offline-deterministic',
      timestamp: DateTime.now(),
    );
  }
}
