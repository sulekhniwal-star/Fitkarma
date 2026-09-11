import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/program_evolution_engine.dart';

class ProgramEvolutionRepository {
  final SupabaseClient? _supabase;

  ProgramEvolutionRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Fetches the latest evolution check from LocalStorage or evaluates locally
  Future<ProgramEvolutionResult> getLatestEvolution({
    required String uid,
    int completedWorkouts = 12,
    int plannedWorkouts = 14,
    double averageReadiness = 78.0,
    int consecutiveLowReadinessDays = 0,
    bool weightPlateau14Days = false,
  }) async {
    final cacheKey = 'prog_evol_$uid';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is Map) {
        return ProgramEvolutionResult.fromMap(Map<String, dynamic>.from(cached));
      }

      final response = await _client
          .from('daily_intelligence')
          .select('dip_payload')
          .eq('user_id', uid)
          .order('date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null && response['dip_payload'] != null) {
        final payload = response['dip_payload'] as Map<String, dynamic>;
        if (payload['program_evolution'] != null) {
          return ProgramEvolutionResult.fromMap(
              Map<String, dynamic>.from(payload['program_evolution']));
        }
      }
    } catch (_) {
      // Offline fallback
    }

    // Local deterministic fallback computation
    final result = ProgramEvolutionEngine.evaluateProgression(
      completedWorkouts: completedWorkouts,
      plannedWorkouts: plannedWorkouts,
      averageReadiness: averageReadiness,
      consecutiveLowReadinessDays: consecutiveLowReadinessDays,
      weightPlateau14Days: weightPlateau14Days,
    );

    return result;
  }

  /// Persists evolution status to LocalStorage and Supabase
  Future<void> saveEvolutionResult({
    required String uid,
    required ProgramEvolutionResult result,
  }) async {
    final cacheKey = 'prog_evol_$uid';
    await LocalStorageService.saveDraft(cacheKey, result.toMap());

    try {
      await _client.from('daily_intelligence').upsert({
        'user_id': uid,
        'date': DateTime.now().toUtc().toIso8601String().split('T')[0],
        'dip_payload': {
          'program_evolution': result.toMap(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
      });
    } catch (_) {
      // Handled via local storage
    }
  }
}
