import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/readiness_engine.dart';

class ReadinessRepository {
  final FirebaseFirestore _firestore;

  ReadinessRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches daily readiness evaluation from Firestore cache or computes locally
  Future<ReadinessEvaluationResult> getDailyReadiness({
    required String uid,
    required String dateStr,
    double? currentHrvRmssd,
    double? baselineHrv14Day,
    double? currentRestingHr,
    double? baselineRestingHr14Day,
    double? deepSleepMinutes,
    double? remSleepMinutes,
    double? totalSleepHours = 7.5,
    int? yesterdaySteps = 8200,
    int? somaticSorenessScore = 20,
    bool isIll = false,
  }) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection(AppConstants.dailyLogsSubcollection)
          .doc(dateStr);

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data()?['readiness'] != null) {
        return ReadinessEvaluationResult.fromMap(
          Map<String, dynamic>.from(snapshot.data()!['readiness']),
        );
      }
    } catch (_) {
      // Offline fallback
    }

    // Pure Dart deterministic calculation fallback
    return ReadinessEngine.calculateReadiness(
      currentHrvRmssd: currentHrvRmssd,
      baselineHrv14Day: baselineHrv14Day,
      currentRestingHr: currentRestingHr,
      baselineRestingHr14Day: baselineRestingHr14Day,
      deepSleepMinutes: deepSleepMinutes,
      remSleepMinutes: remSleepMinutes,
      totalSleepHours: totalSleepHours,
      yesterdaySteps: yesterdaySteps,
      somaticSorenessScore: somaticSorenessScore,
      isIll: isIll,
    );
  }

  /// Persists readiness score to Firestore
  Future<void> saveReadinessResult({
    required String uid,
    required String dateStr,
    required ReadinessEvaluationResult result,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.dailyLogsSubcollection)
        .doc(dateStr);

    await docRef.set({
      'readiness': result.toMap(),
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
