import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/womens_health_engine.dart';

class WomensHealthRepository {
  final FirebaseFirestore _firestore;

  WomensHealthRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches women's health profile with offline caching and pure Dart fallback
  Future<WomensHealthProfile> getProfile({
    required String uid,
    int cycleLengthDays = 28,
    int periodLengthDays = 5,
    int currentCycleDay = 10,
    LifeStageMode mode = LifeStageMode.regularCycle,
    bool isPcos = false,
  }) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('womensHealth')
          .doc('profile');

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data() != null) {
        return WomensHealthProfile.fromMap(snapshot.data()!);
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

  /// Persists women's health profile to Firestore
  Future<void> saveProfile({
    required String uid,
    required WomensHealthProfile profile,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('womensHealth')
        .doc('profile');

    await docRef.set(profile.toMap(), SetOptions(merge: true));
  }
}
