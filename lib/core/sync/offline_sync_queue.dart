import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/local_storage_service.dart';
import '../services/supabase_service.dart';
import 'sync_utils.dart';

enum MutationAction { insert, update, delete, upsert }

enum MutationStatus { pending, inProgress, failed, completed }

class PendingMutation {
  final String id;
  final String table;
  final MutationAction action;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final MutationStatus status;
  final String? errorMessage;

  const PendingMutation({
    required this.id,
    required this.table,
    required this.action,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.status = MutationStatus.pending,
    this.errorMessage,
  });

  PendingMutation copyWith({
    String? id,
    String? table,
    MutationAction? action,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
    MutationStatus? status,
    String? errorMessage,
  }) {
    return PendingMutation(
      id: id ?? this.id,
      table: table ?? this.table,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table': table,
      'action': action.name,
      'payload': payload,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'status': status.name,
      'errorMessage': errorMessage,
    };
  }

  factory PendingMutation.fromMap(Map<String, dynamic> map) {
    return PendingMutation(
      id: map['id'] as String,
      table: map['table'] as String,
      action: MutationAction.values.firstWhere(
        (a) => a.name == map['action'],
        orElse: () => MutationAction.upsert,
      ),
      payload: Map<String, dynamic>.from(map['payload'] as Map),
      createdAt: DateTime.parse(map['createdAt'] as String),
      retryCount: (map['retryCount'] as num?)?.toInt() ?? 0,
      status: MutationStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => MutationStatus.pending,
      ),
      errorMessage: map['errorMessage'] as String?,
    );
  }
}

class OfflineSyncQueueState {
  final List<PendingMutation> queue;
  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final int totalSynced;

  const OfflineSyncQueueState({
    this.queue = const [],
    this.isSyncing = false,
    this.lastSyncedAt,
    this.totalSynced = 0,
  });

  OfflineSyncQueueState copyWith({
    List<PendingMutation>? queue,
    bool? isSyncing,
    DateTime? lastSyncedAt,
    int? totalSynced,
  }) {
    return OfflineSyncQueueState(
      queue: queue ?? this.queue,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      totalSynced: totalSynced ?? this.totalSynced,
    );
  }

  int get pendingCount =>
      queue.where((m) => m.status == MutationStatus.pending).length;
}

class OfflineSyncQueueNotifier extends StateNotifier<OfflineSyncQueueState> {
  final LocalStorageService _storage;
  final SupabaseClient? _supabase;
  static const String _storageKey = 'offline_pending_mutations_v1';

  OfflineSyncQueueNotifier({
    LocalStorageService? storage,
    SupabaseClient? supabase,
  })  : _storage = storage ?? LocalStorageService(),
        _supabase = supabase,
        super(const OfflineSyncQueueState()) {
    _loadQueueFromStorage();
  }

  void _loadQueueFromStorage() {
    try {
      final raw = _storage.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final list = (jsonDecode(raw) as List)
            .map((item) =>
                PendingMutation.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();
        state = state.copyWith(queue: list);
      }
    } catch (e) {
      debugPrint('Error loading sync queue: $e');
    }
  }

  Future<void> _persistQueue() async {
    try {
      final raw = jsonEncode(state.queue.map((m) => m.toMap()).toList());
      await _storage.setString(_storageKey, raw);
    } catch (e) {
      debugPrint('Error persisting sync queue: $e');
    }
  }

  /// Enqueue a mutation for offline-first resilience
  Future<String> enqueue({
    required String table,
    required MutationAction action,
    required Map<String, dynamic> payload,
  }) async {
    final id = SyncUtils.generateIdempotencyKey();
    final mutation = PendingMutation(
      id: id,
      table: table,
      action: action,
      payload: SyncUtils.withTimestamp(payload),
      createdAt: DateTime.now(),
      status: MutationStatus.pending,
    );

    state = state.copyWith(queue: [...state.queue, mutation]);
    await _persistQueue();
    return id;
  }

  /// Flushes all pending mutations to Supabase remote database
  Future<int> flushQueue([SupabaseClient? clientOverride]) async {
    final client = clientOverride ?? _supabase ?? (Supabase.instance.client);
    if (state.isSyncing) return 0;

    final pending = state.queue
        .where((m) =>
            m.status == MutationStatus.pending ||
            m.status == MutationStatus.failed)
        .toList();

    if (pending.isEmpty) return 0;

    state = state.copyWith(isSyncing: true);
    int successCount = 0;
    final updatedQueue = List<PendingMutation>.from(state.queue);

    for (int i = 0; i < updatedQueue.length; i++) {
      final mutation = updatedQueue[i];
      if (mutation.status != MutationStatus.pending &&
          mutation.status != MutationStatus.failed) {
        continue;
      }

      try {
        switch (mutation.action) {
          case MutationAction.insert:
            await client.from(mutation.table).insert(mutation.payload);
            break;
          case MutationAction.upsert:
            await client.from(mutation.table).upsert(mutation.payload);
            break;
          case MutationAction.update:
            final id = mutation.payload['id'] ?? mutation.payload['user_id'];
            if (id != null) {
              await client
                  .from(mutation.table)
                  .update(mutation.payload)
                  .eq('id', id);
            }
            break;
          case MutationAction.delete:
            final id = mutation.payload['id'];
            if (id != null) {
              await client.from(mutation.table).delete().eq('id', id);
            }
            break;
        }

        updatedQueue[i] = mutation.copyWith(
          status: MutationStatus.completed,
          errorMessage: null,
        );
        successCount++;
      } catch (e) {
        updatedQueue[i] = mutation.copyWith(
          status: MutationStatus.failed,
          retryCount: mutation.retryCount + 1,
          errorMessage: e.toString(),
        );
      }
    }

    // Retain failed mutations, prune completed ones
    final prunedQueue = updatedQueue
        .where((m) => m.status != MutationStatus.completed)
        .toList();

    state = state.copyWith(
      queue: prunedQueue,
      isSyncing: false,
      lastSyncedAt: DateTime.now(),
      totalSynced: state.totalSynced + successCount,
    );

    await _persistQueue();
    return successCount;
  }

  /// Clears all mutations from the queue
  Future<void> clearQueue() async {
    state = state.copyWith(queue: []);
    await _persistQueue();
  }
}

final offlineSyncQueueProvider =
    StateNotifierProvider<OfflineSyncQueueNotifier, OfflineSyncQueueState>(
        (ref) {
  final client = ref.watch(supabaseClientProvider);
  return OfflineSyncQueueNotifier(supabase: client);
});
