/// §P6-F Adaptive Computer Vision Loop — Movement Log Persistence
///
/// In-memory repository for storing per-session movement form quality logs,
/// frame rate diagnostics, and thermal workload states.
library;

import 'package:fitkarma/features/workout/form_deviation_detector.dart';
import 'package:fitkarma/features/workout/thermal_frame_processor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Log Entry Model
// ─────────────────────────────────────────────────────────────────────────────

/// Persisted record of a movement set form quality frame/rep.
class MovementLogEntry {
  const MovementLogEntry({
    required this.id,
    required this.sessionId,
    required this.exerciseName,
    required this.timestamp,
    required this.formScore,
    required this.thermalState,
    required this.trackedJointCount,
    required this.kneeValgusDetected,
    required this.heelLiftDetected,
    required this.feedbackCue,
  });

  final String id;
  final String sessionId;
  final String exerciseName;
  final DateTime timestamp;
  final int formScore;
  final ThermalWorkloadState thermalState;
  final int trackedJointCount;
  final bool kneeValgusDetected;
  final bool heelLiftDetected;
  final String feedbackCue;
}

// ─────────────────────────────────────────────────────────────────────────────
// Repository
// ─────────────────────────────────────────────────────────────────────────────

class MovementLogRepository {
  final List<MovementLogEntry> _logs = [];

  /// Records a form evaluation result.
  void addEntry({
    required String sessionId,
    required String exerciseName,
    required FormQualityScore score,
  }) {
    _logs.add(
      MovementLogEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        sessionId: sessionId,
        exerciseName: exerciseName,
        timestamp: DateTime.now(),
        formScore: score.overallScore,
        thermalState: score.thermalState,
        trackedJointCount: score.trackedJointCount,
        kneeValgusDetected: score.kneeValgusFlag,
        heelLiftDetected: score.heelLiftFlag,
        feedbackCue: score.feedback,
      ),
    );
  }

  /// Returns all movement logs for a given session.
  List<MovementLogEntry> getSessionLogs(String sessionId) {
    return _logs.where((l) => l.sessionId == sessionId).toList();
  }

  /// Computes average form quality score for a workout session.
  double getAverageFormScore(String sessionId) {
    final sessionLogs = getSessionLogs(sessionId);
    if (sessionLogs.isEmpty) return 100.0;

    final totalScore = sessionLogs.fold<int>(0, (sum, item) => sum + item.formScore);
    return totalScore / sessionLogs.length;
  }

  /// Clears in-memory storage (useful for testing).
  void clear() => _logs.clear();

  List<MovementLogEntry> get allLogs => List.unmodifiable(_logs);
}

final movementLogRepositoryProvider = Provider<MovementLogRepository>((_) {
  return MovementLogRepository();
});
