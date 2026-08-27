import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/body_soreness_map.dart';

class RecoveryRepository {
  final FirebaseFirestore _firestore;

  RecoveryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches the daily body soreness map with offline caching
  Future<BodySorenessMap> getDailySorenessMap({
    required String uid,
    required String dateStr,
  }) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection(AppConstants.dailyLogsSubcollection)
          .doc(dateStr);

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data()?['sorenessMap'] != null) {
        return BodySorenessMap.fromMap(
          Map<String, dynamic>.from(snapshot.data()!['sorenessMap']),
        );
      }
    } catch (_) {
      // Offline fallback
    }

    return BodySorenessMap.initial();
  }

  /// Persists body soreness map to Firestore
  Future<void> saveSorenessMap({
    required String uid,
    required String dateStr,
    required BodySorenessMap map,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.dailyLogsSubcollection)
        .doc(dateStr);

    await docRef.set({
      'sorenessMap': map.toMap(),
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
