import 'package:drift/drift.dart';
import 'package:fitkarma/core/database/app_database.dart';

class AICache {
  AICache(this._db);

  final AppDatabase _db;

  /// Retrieves a non-expired cached response from the database
  Future<String?> get(String userId, String promptHash) async {
    final now = DateTime.now();
    final entry =
        await (_db.select(_db.aICacheEntries)..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.promptHash.equals(promptHash) &
                  t.expiresAt.isBiggerThanValue(now),
            ))
            .getSingleOrNull();
    return entry?.response;
  }

  /// Stores or updates an AI response cache entry
  Future<void> set(
    String userId,
    String promptHash,
    String response, {
    Duration ttl = const Duration(hours: 24),
  }) async {
    final expiresAt = DateTime.now().add(ttl);
    final companion = AICacheEntriesCompanion.insert(
      userId: userId,
      promptHash: promptHash,
      response: response,
      expiresAt: expiresAt,
    );
    await _db.into(_db.aICacheEntries).insertOnConflictUpdate(companion);
  }

  /// Purges all cached items for a user (DPDP Act right-to-erasure)
  Future<void> purgeForUser(String userId) async {
    await (_db.delete(
      _db.aICacheEntries,
    )..where((t) => t.userId.equals(userId))).go();
  }
}
