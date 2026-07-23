import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/azure_provider.dart';
import 'connectivity_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

class SyncWorker {
  SyncWorker(this._db, this._client, this._ref);

  final AppDatabase _db;
  final AzureSyncClient _client;
  final Ref _ref;
  bool _isSyncing = false;

  bool get isSyncing => _isSyncing;

  /// Triggers the background synchronization queue
  Future<void> triggerSync() async {
    final isOnline = _ref.read(connectivityProvider);
    if (!isOnline) {
      return;
    }

    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final queueItems = await (_db.select(
        _db.syncQueueItems,
      )..orderBy([(t) => OrderingTerm(expression: t.createdAt)])).get();

      for (final item in queueItems) {
        final isStillOnline = _ref.read(connectivityProvider);
        if (!isStillOnline) break;

        final success = await _client.postSyncPayload(
          item.entityType,
          item.serializedPayload,
        );

        if (success) {
          // Sync succeeded. Remove from local FIFO queue
          await (_db.delete(
            _db.syncQueueItems,
          )..where((t) => t.id.equals(item.id))).go();
        } else {
          // Sync failed. Check retry limits
          final nextRetry = item.retryCount + 1;

          if (nextRetry >= 3) {
            // Retries exceeded (3x limit). Redirect to Dead Letter Queue (DLQ)
            await _db
                .into(_db.deadLetterQueueItems)
                .insert(
                  DeadLetterQueueItemsCompanion.insert(
                    entityType: item.entityType,
                    entityId: item.entityId,
                    serializedPayload: item.serializedPayload,
                    syncBatchId: item.syncBatchId,
                    failureReason:
                        'Remote HTTP sync failed 3 consecutive times',
                    failedAt: DateTime.now(),
                  ),
                );
            // Drop from active queue
            await (_db.delete(
              _db.syncQueueItems,
            )..where((t) => t.id.equals(item.id))).go();
          } else {
            // Update retry count and preserve in queue
            await (_db.update(_db.syncQueueItems)
                  ..where((t) => t.id.equals(item.id)))
                .write(SyncQueueItemsCompanion(retryCount: Value(nextRetry)));
            break; // Terminate sync loop on transient network failure
          }
        }
      }
    } catch (_) {
      // Failures are recovered on next triggerSync execution
    } finally {
      _isSyncing = false;
    }
  }
}

final syncWorkerProvider = Provider<SyncWorker>((ref) {
  final worker = SyncWorker(
    ref.watch(databaseProvider),
    ref.watch(azureSyncClientProvider),
    ref,
  );

  // Auto-trigger sync when connectivity state changes back to online
  ref.listen<bool>(connectivityProvider, (previous, next) {
    if (next) {
      worker.triggerSync();
    }
  });

  return worker;
});
