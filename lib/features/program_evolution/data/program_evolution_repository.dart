import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/program_evolution_engine.dart';

class ProgramEvolutionRepository {
  final FirebaseFirestore _firestore;

  ProgramEvolutionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches the latest evolution check from Firestore (offline-cached) or evaluates locally
  Future<ProgramEvolutionResult> getLatestEvolution({
    required String uid,
    int completedWorkouts = 12,
    int plannedWorkouts = 14,
    double averageReadiness = 78.0,
    int consecutiveLowReadinessDays = 0,
    bool weightPlateau14Days = false,
  }) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('programEvolution')
          .doc('latest');

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists && snapshot.data() != null) {
        return ProgramEvolutionResult.fromMap(snapshot.data()!);
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

  /// Persists evolution status to Firestore (queued offline automatically)
  Future<void> saveEvolutionResult({
    required String uid,
    required ProgramEvolutionResult result,
  }) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('programEvolution')
        .doc('latest');

    await docRef.set(result.toMap(), SetOptions(merge: true));
  }
}
