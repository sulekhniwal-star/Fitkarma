/// §DB Cumulative Log Sync & Server-Side Batch Idempotency Engine
///
/// Implements `syncBatchId` idempotency for cumulative log sync batches (water, steps, logs)
/// and server-side deduplication matching §DB / Cross-Cutting specs.
library;

import 'sync_merge_resolver.dart';

class WaterLogEntry implements CumulativeLog {
  const WaterLogEntry({
    required this.id,
    required this.userId,
    required this.cups,
    required this.syncBatchId,
    required this.hlc,
  });

  final String id;
  final String userId;
  final int cups;
  @override
  final String syncBatchId;
  @override
  final HLCTimestamp hlc;

  @override
  CumulativeLog mergeWith(CumulativeLog other) {
    if (other is WaterLogEntry && other.syncBatchId == syncBatchId) {
      // Deduplicated repeat payload
      return this;
    }
    final otherWater = other as WaterLogEntry;
    return WaterLogEntry(
      id: id,
      userId: userId,
      cups: cups + otherWater.cups,
      syncBatchId: '${syncBatchId}_merged_${otherWater.syncBatchId}',
      hlc: hlc.compareTo(otherWater.hlc) > 0 ? hlc : otherWater.hlc,
    );
  }
}

class CumulativeLogSyncEngine {
  CumulativeLogSyncEngine();

  final Set<String> _processedBatchIds = {};

  /// Server-side deduplication process: ingests sync batch and ignores duplicates.
  bool processSyncBatch(CumulativeLog log) {
    if (_processedBatchIds.contains(log.syncBatchId)) {
      // Repeat batch delivery ignored — safe retry idempotency
      return false;
    }
    _processedBatchIds.add(log.syncBatchId);
    return true;
  }

  bool isBatchProcessed(String batchId) => _processedBatchIds.contains(batchId);
}
