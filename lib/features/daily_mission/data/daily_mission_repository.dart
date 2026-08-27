import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/daily_mission.dart';

class DailyMissionRepository {
  final FirebaseFirestore _firestore;

  DailyMissionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches the user's daily missions for the specified date
  Future<List<DailyMissionItem>> getDailyMissions({
    required String uid,
    required String dateStr,
    int targetSteps = 8000,
    int targetCalories = 2000,
    int targetProtein = 130,
    String workoutName = 'Upper Body Strength',
  }) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('dailyMissions')
          .doc(dateStr);

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data()?['missions'] != null) {
        final list = snapshot.data()!['missions'] as List;
        return list
            .map((item) => DailyMissionItem.fromMap(Map<String, dynamic>.from(item)))
            .toList();
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

  /// Toggles mission completion status in Firestore
  Future<void> saveMissions({
    required String uid,
    required String dateStr,
    required List<DailyMissionItem> missions,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('dailyMissions')
        .doc(dateStr);

    await docRef.set({
      'missions': missions.map((m) => m.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
