import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/readiness_engine.dart';

class ReadinessRepository {
  final SupabaseClient? _supabase;

  ReadinessRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Fetches daily readiness evaluation from LocalStorage cache or computes locally
  Future<ReadinessEvaluationResult> getDailyReadiness({
    required String uid,
    required String dateStr,
    double? currentHrvRmssd,
    double? baselineHrv14Day,
    double? currentRestingHr,
    double? baselineRestingHr14Day,
    double? deepSleepMinutes,
    double? remSleepMinutes,
    double? totalSleepHours = 7.5,
    int? yesterdaySteps = 8200,
    int? somaticSorenessScore = 20,
    bool isIll = false,
  }) async {
    final cacheKey = 'readiness_${uid}_$dateStr';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is Map) {
        return ReadinessEvaluationResult.fromMap(
          Map<String, dynamic>.from(cached),
        );
      }

      final response = await _client
          .from('daily_intelligence')
          .select()
          .eq('user_id', uid)
          .eq('date', dateStr)
          .maybeSingle();

      if (response != null && response['dip_payload'] != null) {
        final payload = response['dip_payload'] as Map<String, dynamic>;
        if (payload['readiness'] != null) {
          return ReadinessEvaluationResult.fromMap(
            Map<String, dynamic>.from(payload['readiness']),
          );
        }
      }
    } catch (_) {
      // Offline fallback
    }

    // Pure Dart deterministic calculation fallback
    return ReadinessEngine.calculateReadiness(
      currentHrvRmssd: currentHrvRmssd,
      baselineHrv14Day: baselineHrv14Day,
      currentRestingHr: currentRestingHr,
      baselineRestingHr14Day: baselineRestingHr14Day,
      deepSleepMinutes: deepSleepMinutes,
      remSleepMinutes: remSleepMinutes,
      totalSleepHours: totalSleepHours,
      yesterdaySteps: yesterdaySteps,
      somaticSorenessScore: somaticSorenessScore,
      isIll: isIll,
    );
  }

  /// Persists readiness score to LocalStorage and Supabase
  Future<void> saveReadinessResult({
    required String uid,
    required String dateStr,
    required ReadinessEvaluationResult result,
  }) async {
    final cacheKey = 'readiness_${uid}_$dateStr';
    await LocalStorageService.saveDraft(cacheKey, result.toMap());

    try {
      await _client.from('daily_intelligence').upsert({
        'user_id': uid,
        'date': dateStr,
        'readiness_score': result.score,
        'dip_payload': {
          'readiness': result.toMap(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
      });
    } catch (_) {
      // Handled via local storage
    }
  }
}
