import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/adaptive_metabolism_engine.dart';

class MetabolismRepository {
  final FirebaseFirestore _firestore;

  MetabolismRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

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
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('metabolism')
          .doc('current');

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data() != null) {
        return AdaptiveMetabolismProfile.fromMap(snapshot.data()!);
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

  /// Persists adaptive metabolism calculations to Firestore
  Future<void> saveMetabolismProfile({
    required String uid,
    required AdaptiveMetabolismProfile profile,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('metabolism')
        .doc('current');

    await docRef.set(profile.toMap(), SetOptions(merge: true));
  }
}
