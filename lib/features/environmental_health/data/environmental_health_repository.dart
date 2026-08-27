import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/environmental_health_engine.dart';

class EnvironmentalHealthRepository {
  final FirebaseFirestore _firestore;

  EnvironmentalHealthRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches the latest environmental snapshot with offline caching
  Future<EnvironmentalHealthSnapshot> getEnvironmentalSnapshot({
    required String uid,
    int aqi = 145,
    double uvIndex = 6.5,
    double temperatureC = 33.0,
    double humidityPercent = 60.0,
  }) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('environmentalHealth')
          .doc('today');

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data() != null) {
        return EnvironmentalHealthSnapshot.fromMap(snapshot.data()!);
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

  /// Persists environmental health data to Firestore
  Future<void> saveEnvironmentalSnapshot({
    required String uid,
    required EnvironmentalHealthSnapshot snapshot,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('environmentalHealth')
        .doc('today');

    await docRef.set(snapshot.toMap(), SetOptions(merge: true));
  }
}
