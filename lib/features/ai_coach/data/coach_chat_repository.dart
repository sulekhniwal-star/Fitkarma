import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/coach_message.dart';

class CoachChatRepository {
  final SupabaseClient? _supabase;

  CoachChatRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Fetches conversation messages for the current date with offline cache support
  Future<List<CoachMessage>> getConversationMessages({
    required String uid,
    required String dateStr,
  }) async {
    final cacheKey = 'chat_${uid}_$dateStr';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is List) {
        return cached
            .map((item) => CoachMessage.fromMap(Map<String, dynamic>.from(item)))
            .toList();
      }

      final response = await _client
          .from('daily_intelligence')
          .select('dip_payload')
          .eq('user_id', uid)
          .eq('date', dateStr)
          .maybeSingle();

      if (response != null && response['dip_payload'] != null) {
        final payload = response['dip_payload'] as Map<String, dynamic>;
        if (payload['messages'] != null && payload['messages'] is List) {
          final list = payload['messages'] as List;
          return list
              .map((item) => CoachMessage.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        }
      }
    } catch (_) {
      // Offline fallback
    }

    // Default welcome message from Karma Coach
    return [
      CoachMessage(
        id: 'msg_welcome',
        text:
            'Namaste! I am Karma Coach. How can I support your nutrition, recovery, or training today?',
        sender: MessageSender.coach,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  /// Persists full conversation thread to LocalStorage & Supabase
  Future<void> saveConversation({
    required String uid,
    required String dateStr,
    required List<CoachMessage> messages,
  }) async {
    final cacheKey = 'chat_${uid}_$dateStr';
    final rawList = messages.map((m) => m.toMap()).toList();
    await LocalStorageService.saveDraft(cacheKey, rawList);

    try {
      await _client.from('daily_intelligence').upsert({
        'user_id': uid,
        'date': dateStr,
        'dip_payload': {
          'messages': rawList,
          'last_updated_at': DateTime.now().toUtc().toIso8601String(),
        },
      });
    } catch (_) {
      // Saved in local cache, syncs when reconnecting
    }
  }
}
