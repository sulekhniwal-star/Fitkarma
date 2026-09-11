import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/environmental_health_engine.dart';

class EnvironmentalHealthRepository {
  final SupabaseClient? _supabase;

  EnvironmentalHealthRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Fetches the latest environmental snapshot with offline caching
  Future<EnvironmentalHealthSnapshot> getEnvironmentalSnapshot({
    required String uid,
    int aqi = 145,
    double uvIndex = 6.5,
    double temperatureC = 33.0,
    double humidityPercent = 60.0,
  }) async {
    final cacheKey = 'env_$uid';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is Map) {
        return EnvironmentalHealthSnapshot.fromMap(Map<String, dynamic>.from(cached));
      }

      final response = await _client
          .from('environmental_telemetry')
          .select()
          .eq('user_id', uid)
          .order('timestamp', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        return EnvironmentalHealthSnapshot.fromMap(response);
      }
    } catch (_) {
      // Offline fallback
    }

    // Pure Dart deterministic evaluation fallback
    return EnvironmentalHealthEngine.evaluate(
      aqi: aqi,
      uvIndex: uvIndex,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
    );
  }

  /// Persists environmental health data to Supabase & LocalStorage
  Future<void> saveEnvironmentalSnapshot({
    required String uid,
    required EnvironmentalHealthSnapshot snapshot,
  }) async {
    final cacheKey = 'env_$uid';
    await LocalStorageService.saveDraft(cacheKey, snapshot.toMap());

    try {
      await _client.from('environmental_telemetry').insert({
        'user_id': uid,
        'aqi': snapshot.aqi,
        'uv_index': snapshot.uvIndex,
        'wet_bulb_temp_c': snapshot.heatIndexC,
        'outdoor_recommendation': snapshot.recommendation,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {
      // Handled via local draft
    }
  }
}
