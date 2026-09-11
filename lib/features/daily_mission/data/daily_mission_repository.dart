import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/daily_mission.dart';

class DailyMissionRepository {
  final SupabaseClient? _supabase;

  DailyMissionRepository({SupabaseClient? supabase})
      : _supabase = supabase;

  SupabaseClient get _client => _supabase ?? Supabase.instance.client;

  /// Fetches the user's daily missions for the specified date
  Future<List<DailyMissionItem>> getDailyMissions({
    required String uid,
    required String dateStr,
    int targetSteps = 8000,
    int targetCalories = 2000,
    int targetProtein = 130,
    String workoutName = 'Upper Body Strength',
  }) async {
    final cacheKey = 'missions_${uid}_$dateStr';
    try {
      final cached = LocalStorageService.getDraft(cacheKey);
      if (cached != null && cached is List) {
        return cached
            .map((item) => DailyMissionItem.fromMap(Map<String, dynamic>.from(item)))
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
        if (payload['missions'] != null && payload['missions'] is List) {
          final list = payload['missions'] as List;
          return list
              .map((item) => DailyMissionItem.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        }
      }
    } catch (_) {
      // Offline fallback
    }

    // Default calibrated daily missions
    return [
      DailyMissionItem(
        id: 'mission_steps',
        title: 'Step Mastery',
        regionalTitle: 'दैनिक कदम लक्ष्य',
        targetSubtitle: 'Walk $targetSteps steps today',
        karmaReward: 15,
        category: MissionCategory.steps,
      ),
      DailyMissionItem(
        id: 'mission_workout',
        title: 'Workout Session',
        regionalTitle: 'कसरत सत्र पूरा करें',
        targetSubtitle: 'Complete $workoutName',
        karmaReward: 25,
        category: MissionCategory.workout,
      ),
      DailyMissionItem(
        id: 'mission_nutrition',
        title: 'Macro Adherence',
        regionalTitle: 'पोषण एवं प्रोटीन लक्ष्य',
        targetSubtitle: 'Hit ${targetProtein}g protein & $targetCalories kcal',
        karmaReward: 20,
        category: MissionCategory.nutrition,
      ),
      const DailyMissionItem(
        id: 'mission_hydration',
        title: 'Optimal Hydration',
        regionalTitle: 'पर्याप्त जलपान',
        targetSubtitle: 'Drink 3.0L water',
        karmaReward: 10,
        category: MissionCategory.hydration,
      ),
      const DailyMissionItem(
        id: 'mission_recovery',
        title: 'Sleep & Wind Down',
        regionalTitle: 'गहरी नींद एवं विश्राम',
        targetSubtitle: 'Log 7.5+ hours restful sleep',
        karmaReward: 10,
        category: MissionCategory.recovery,
      ),
    ];
  }

  /// Toggles mission completion status in LocalStorage & Supabase
  Future<void> saveMissions({
    required String uid,
    required String dateStr,
    required List<DailyMissionItem> missions,
  }) async {
    final cacheKey = 'missions_${uid}_$dateStr';
    final rawList = missions.map((m) => m.toMap()).toList();
    await LocalStorageService.saveDraft(cacheKey, rawList);

    try {
      await _client.from('daily_intelligence').upsert({
        'user_id': uid,
        'date': dateStr,
        'dip_payload': {
          'missions': rawList,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
      });
    } catch (_) {
      // Handled via local storage
    }
  }
}
