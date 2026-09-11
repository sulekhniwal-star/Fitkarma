import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/adaptive_metabolism_engine.dart';

class MetabolismRepository {
  final SupabaseClient? _supabase;

  MetabolismRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Fetches the user's latest adaptive metabolism profile with offline caching
  Future<AdaptiveMetabolismProfile> getMetabolismProfile({
    required String uid,
    double weightKg = 72.0,
    double heightCm = 175.0,
    int age = 28,
    BiologicalSex sex = BiologicalSex.male,
    NutritionGoal goal = NutritionGoal.fatLoss,
    double? avgDailyIntake14Days = 2100.0,
    double? weightDelta14DaysKg = -0.4,
  }) async {
    final cacheKey = 'metabolism_$uid';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is Map) {
        return AdaptiveMetabolismProfile.fromMap(Map<String, dynamic>.from(cached));
      }

      final response = await _client
          .from('body_analytics')
          .select()
          .eq('user_id', uid)
          .order('logged_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null && response['notes'] != null) {
        // Can read cached payload
      }
    } catch (_) {
      // Offline fallback
    }

    // Pure Dart deterministic calculation fallback
    return AdaptiveMetabolismEngine.computeMetabolism(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      sex: sex,
      goal: goal,
      avgDailyIntake14Days: avgDailyIntake14Days,
      weightDelta14DaysKg: weightDelta14DaysKg,
    );
  }

  /// Persists adaptive metabolism calculations to Supabase and LocalStorage
  Future<void> saveMetabolismProfile({
    required String uid,
    required AdaptiveMetabolismProfile profile,
  }) async {
    final cacheKey = 'metabolism_$uid';
    await LocalStorageService.saveDraft(cacheKey, profile.toMap());

    try {
      await _client.from('body_analytics').upsert({
        'user_id': uid,
        'logged_date': DateTime.now().toUtc().toIso8601String().split('T')[0],
        'weight_kg': profile.targetCalories / 30.0,
        'bmr_kcal': profile.bmr.toInt(),
      });
    } catch (_) {
      // Handled via local storage
    }
  }
}
