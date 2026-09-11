import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/body_soreness_map.dart';

class RecoveryRepository {
  final SupabaseClient? _supabase;

  RecoveryRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Fetches the daily body soreness map with offline caching
  Future<BodySorenessMap> getDailySorenessMap({
    required String uid,
    required String dateStr,
  }) async {
    final cacheKey = 'soreness_${uid}_$dateStr';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is Map) {
        return BodySorenessMap.fromMap(
          Map<String, dynamic>.from(cached),
        );
      }

      final response = await _client
          .from('soreness_logs')
          .select()
          .eq('user_id', uid)
          .eq('date', dateStr)
          .maybeSingle();

      if (response != null && response['body_map'] != null) {
        return BodySorenessMap.fromMap(
          Map<String, dynamic>.from(response['body_map']),
        );
      }
    } catch (_) {
      // Offline fallback
    }

    return BodySorenessMap.initial();
  }

  /// Persists body soreness map to LocalStorage and Supabase
  Future<void> saveSorenessMap({
    required String uid,
    required String dateStr,
    required BodySorenessMap map,
  }) async {
    final cacheKey = 'soreness_${uid}_$dateStr';
    await LocalStorageService.saveDraft(cacheKey, map.toMap());

    try {
      await _client.from('soreness_logs').upsert({
        'user_id': uid,
        'date': dateStr,
        'overall_soreness': map.cumulativeScore ~/ 10,
        'body_map': map.toMap(),
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {
      // Handled via local storage
    }
  }
}
