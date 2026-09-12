import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

enum SyncState { idle, syncing, offline, error }

/// OutboxSyncWorker — Flushes Drift `pending_mutations` outbox to Supabase
/// Implements offline-first writes, exponential backoff, and incremental sync.
class OutboxSyncWorker {
  final AppDatabase db;
  final SupabaseClient? supabaseClient;
  final _uuid = const Uuid();

  SyncState _state = SyncState.idle;
  SyncState get state => _state;

  Timer? _retryTimer;
  int _consecutiveFailures = 0;

  OutboxSyncWorker({
    required this.db,
    this.supabaseClient,
  });

  /// Enqueue a mutation for offline-first resilience
  Future<String> enqueueMutation({
    required String tableName,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final mutationId = _uuid.v4();
    await db.into(db.pendingMutations).insert(
          PendingMutationsCompanion.insert(
            id: mutationId,
            targetTable: tableName,
            action: action,
            payload: jsonEncode(payload),
            createdAt: Value(DateTime.now()),
            retryCount: const Value(0),
          ),
        );

    // Trigger an immediate sync attempt
    triggerSync();
    return mutationId;
  }

  /// Process all pending mutations in FIFO order
  Future<void> triggerSync() async {
    if (_state == SyncState.syncing) return;
    if (supabaseClient == null) {
      _state = SyncState.offline;
      return;
    }

    _state = SyncState.syncing;

    try {
      final pendingList = await (db.select(db.pendingMutations)
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .get();

      if (pendingList.isEmpty) {
        _state = SyncState.idle;
        _consecutiveFailures = 0;
        return;
      }

      for (final mutation in pendingList) {
        final payload = jsonDecode(mutation.payload) as Map<String, dynamic>;

        try {
          switch (mutation.action.toUpperCase()) {
            case 'INSERT':
            case 'UPSERT':
              await supabaseClient!.from(mutation.targetTable).upsert(payload);
              break;
            case 'UPDATE':
              final id = payload['id'] ?? payload['user_id'];
              if (id != null) {
                await supabaseClient!
                    .from(mutation.targetTable)
                    .update(payload)
                    .eq(payload.containsKey('id') ? 'id' : 'user_id', id);
              }
              break;
            case 'DELETE':
              final id = payload['id'] ?? payload['user_id'];
              if (id != null) {
                await supabaseClient!
                    .from(mutation.targetTable)
                    .delete()
                    .eq(payload.containsKey('id') ? 'id' : 'user_id', id);
              }
              break;
          }

          // Successfully synced, remove from outbox
          await (db.delete(db.pendingMutations)..where((t) => t.id.equals(mutation.id))).go();
        } catch (e) {
          // Record failure and increment retry
          await (db.update(db.pendingMutations)..where((t) => t.id.equals(mutation.id))).write(
            PendingMutationsCompanion(
              retryCount: Value(mutation.retryCount + 1),
              lastError: Value(e.toString()),
            ),
          );
          rethrow;
        }
      }

      _consecutiveFailures = 0;
      _state = SyncState.idle;
    } catch (e) {
      _consecutiveFailures++;
      _state = SyncState.error;
      _scheduleExponentialBackoff();
    }
  }

  void _scheduleExponentialBackoff() {
    _retryTimer?.cancel();
    final delaySeconds = (2 << (_consecutiveFailures.clamp(0, 5))) * 1;
    _retryTimer = Timer(Duration(seconds: delaySeconds), () {
      triggerSync();
    });
  }

  void dispose() {
    _retryTimer?.cancel();
  }
}
