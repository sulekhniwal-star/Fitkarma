import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/daily_intelligence_package.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/health_os_calculator.dart';

class HealthOsRepository {
  final SupabaseClient? _supabase;

  HealthOsRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Retrieves the Daily Intelligence Package for the given date.
  /// Seamlessly leverages LocalStorage cache or calculates offline fallback.
  Future<DailyIntelligencePackage> getDailyPackage({
    required String uid,
    required String dateStr,
  }) async {
    final cacheKey = 'health_os_${uid}_$dateStr';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is Map) {
        return DailyIntelligencePackage.fromMap(Map<String, dynamic>.from(cached), dateStr);
      }

      final response = await _client
          .from('daily_intelligence')
          .select()
          .eq('user_id', uid)
          .eq('date', dateStr)
          .maybeSingle();

      if (response != null) {
        final dipPayload = response['dip_payload'] as Map<String, dynamic>? ?? {};
        return DailyIntelligencePackage.fromMap({
          ...dipPayload,
          'readinessScore': (response['readiness_score'] as num?)?.toInt() ?? 70,
          'healthScore': 75,
          'aiBriefing': response['morning_briefing'] ?? '',
        }, dateStr);
      }
    } catch (_) {
      // Offline fallback
    }

    // Local deterministic fallback
    return HealthOsCalculator.computePackage(date: dateStr);
  }

  /// Writes a locally calculated or updated package to LocalStorage and Supabase
  Future<void> saveDailyPackage({
    required String uid,
    required DailyIntelligencePackage package,
  }) async {
    final cacheKey = 'health_os_${uid}_${package.date}';
    await LocalStorageService.saveDraft(cacheKey, package.toMap());

    try {
      await _client.from('daily_intelligence').upsert({
        'user_id': uid,
        'date': package.date,
        'readiness_score': package.readinessScore,
        'recovery_score': package.readinessScore,
        'morning_briefing': package.aiBriefing,
        'dip_payload': package.toMap(),
        'generated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {
      // Handled via local storage
    }
  }
}
