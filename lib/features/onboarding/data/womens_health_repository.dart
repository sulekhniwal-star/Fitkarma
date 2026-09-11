import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/womens_health_engine.dart';

class WomensHealthRepository {
  final SupabaseClient? _supabase;

  WomensHealthRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Fetches women's health profile with offline caching and pure Dart fallback
  Future<WomensHealthProfile> getProfile({
    required String uid,
    int cycleLengthDays = 28,
    int periodLengthDays = 5,
    int currentCycleDay = 10,
    LifeStageMode mode = LifeStageMode.regularCycle,
    bool isPcos = false,
  }) async {
    final cacheKey = 'womens_health_$uid';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is Map) {
        return WomensHealthProfile.fromMap(Map<String, dynamic>.from(cached));
      }

      final response = await _client
          .from('cycle_tracking')
          .select()
          .eq('user_id', uid)
          .order('period_start_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        return WomensHealthProfile.fromMap(response);
      }
    } catch (_) {
      // Offline fallback
    }

    return WomensHealthEngine.evaluateProfile(
      cycleLengthDays: cycleLengthDays,
      periodLengthDays: periodLengthDays,
      currentCycleDay: currentCycleDay,
      mode: mode,
      isPcos: isPcos,
    );
  }

  /// Persists women's health profile to Supabase and LocalStorage
  Future<void> saveProfile({
    required String uid,
    required WomensHealthProfile profile,
  }) async {
    final cacheKey = 'womens_health_$uid';
    await LocalStorageService.saveDraft(cacheKey, profile.toMap());

    try {
      await _client.from('cycle_tracking').upsert({
        'user_id': uid,
        'phase': profile.currentPhase.name,
        'cycle_length_days': profile.cycleLengthDays,
        'period_start_date': DateTime.now().toUtc().toIso8601String().split('T')[0],
        'pcos_flag': profile.isPcosDiagnosed,
        'logged_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {
      // Handled via local storage
    }
  }
}
