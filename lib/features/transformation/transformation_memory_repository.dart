/// §P8-A Transformation Memory Repository
///
/// In-memory repository for persisting TransformationMemory models and WeightCheckpoints.
library;

import 'package:fitkarma/features/transformation/transformation_journey_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransformationMemoryRepository {
  TransformationMemory _memory = TransformationMemory.initial();

  TransformationMemory get memory => _memory;

  /// Updates persistent transformation memory.
  void updateMemory(TransformationMemory updated) {
    _memory = updated;
  }

  /// Adds a new weight checkpoint to transformation memory.
  void addWeightCheckpoint(DateTime date, double weightKg) {
    final updatedHistory = List<WeightCheckpoint>.from(_memory.weightHistory)
      ..add(WeightCheckpoint(date: date, weightKg: weightKg))
      ..sort((a, b) => a.date.compareTo(b.date));

    _memory = TransformationMemory(
      weightHistory: updatedHistory,
      majorStruggles: _memory.majorStruggles,
      injuries: _memory.injuries,
      successPatterns: _memory.successPatterns,
      motivationTriggers: _memory.motivationTriggers,
      quitAttempts: _memory.quitAttempts,
      primaryPersonality: _memory.primaryPersonality,
    );
  }

  /// Clears in-memory data (useful for testing).
  void clear() {
    _memory = TransformationMemory.initial();
  }
}

final transformationMemoryRepositoryProvider = Provider<TransformationMemoryRepository>((_) {
  return TransformationMemoryRepository();
});
