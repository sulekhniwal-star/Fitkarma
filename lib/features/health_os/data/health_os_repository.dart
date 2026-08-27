import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/daily_intelligence_package.dart';
import '../domain/health_os_calculator.dart';

class HealthOsRepository {
  final FirebaseFirestore _firestore;

  HealthOsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Retrieves the Daily Intelligence Package for the given date.
  /// Seamlessly leverages Firestore offline cache or calculates offline fallback.
  Future<DailyIntelligencePackage> getDailyPackage({
    required String uid,
    required String dateStr,
  }) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection(AppConstants.healthOsSubcollection)
          .doc(dateStr);

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data() != null) {
        return DailyIntelligencePackage.fromMap(snapshot.data()!, dateStr);
      }
    } catch (_) {
      // If Firestore is unavailable or uninitialized in unit testing / offline mode,
      // fallback to deterministic pure Dart computation
    }

    // Local deterministic fallback
    return HealthOsCalculator.computePackage(date: dateStr);
  }

  /// Writes a locally calculated or updated package to Firestore (queued automatically when offline)
  Future<void> saveDailyPackage({
    required String uid,
    required DailyIntelligencePackage package,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.healthOsSubcollection)
        .doc(package.date);

    await docRef.set(package.toMap(), SetOptions(merge: true));
  }
}
