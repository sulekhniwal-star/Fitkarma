import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fitkarma/core/database/app_database.dart';

class TransformationMemoryService {
  TransformationMemoryService(this._db);

  final AppDatabase _db;

  /// Retrieves or seeds a blank TransformationMemory for a user
  Future<TransformationMemory> getOrCreateMemory(String userId) async {
    final existing =
        await (_db.select(_db.transformationMemories)
              ..where((t) => t.userId.equals(userId))
              ..limit(1))
            .getSingleOrNull();

    if (existing != null) return existing;

    final localId = 'memory_${DateTime.now().millisecondsSinceEpoch}';
    final companion = TransformationMemoriesCompanion.insert(
      localId: localId,
      userId: userId,
      weightHistoryJson: '[]',
      majorStruggles: '[]',
      injuriesJson: '[]',
      successPatterns: '[]',
      motivationTriggers: '[]',
      primaryPersonality: 'Competitor',
      conversationSummary: 'No summaries recorded yet.',
      lastUpdated: DateTime.now(),
      syncStatus: 'pending',
    );

    await _db.into(_db.transformationMemories).insert(companion);
    return await (_db.select(
      _db.transformationMemories,
    )..where((t) => t.localId.equals(localId))).getSingle();
  }

  /// Appends a new success pattern or program evolution event to TransformationMemory
  Future<void> recordEvolutionEvent(
    String userId,
    String fromProgram,
    String toProgram,
  ) async {
    final memory = await getOrCreateMemory(userId);

    final List<String> patterns = [];
    try {
      final decoded = jsonDecode(memory.successPatterns);
      if (decoded is List) {
        patterns.addAll(decoded.map((e) => e.toString()));
      }
    } catch (_) {}

    patterns.add(
      'Program evolved: Advanced from $fromProgram to $toProgram on ${DateTime.now().toIso8601String()}',
    );

    await (_db.update(
      _db.transformationMemories,
    )..where((t) => t.localId.equals(memory.localId))).write(
      TransformationMemoriesCompanion(
        successPatterns: Value(jsonEncode(patterns)),
        lastUpdated: Value(DateTime.now()),
        syncStatus: const Value('pending'),
      ),
    );
  }
}
