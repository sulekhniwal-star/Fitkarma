import 'hlc_timestamp.dart';

/// Contract for entities participating in sync conflict resolution
abstract class SyncableEntity {
  HlcTimestamp get hlc;
}

/// Contract for cumulative log entities merged via deduplicated CRRA
abstract class CumulativeLog extends SyncableEntity {
  /// Client-generated ID for this delta batch.
  /// Server/local merger maintains a set of applied batch IDs to guarantee idempotency.
  String get syncBatchId;

  CumulativeLog mergeWith(CumulativeLog other);
}

/// Represents the result of a sync merge resolution
class SyncResolution<T extends SyncableEntity> {
  final T? resolvedRecord;
  final SyncAction action;

  const SyncResolution._(this.resolvedRecord, this.action);

  factory SyncResolution.merged(T record) =>
      SyncResolution._(record, SyncAction.merged);
  factory SyncResolution.keepLocal() =>
      const SyncResolution._(null, SyncAction.keepLocal);
  factory SyncResolution.keepRemote() =>
      const SyncResolution._(null, SyncAction.keepRemote);
}

enum SyncAction { merged, keepLocal, keepRemote }

/// Drift Sync Merge Resolver with Hybrid Concurrency Policy
class SyncMergeResolver {
  const SyncMergeResolver();

  /// Resolves conflicts between a local and remote record for the same entity
  SyncResolution resolveConflict<T extends SyncableEntity>({
    required T localRecord,
    required T remoteRecord,
  }) {
    // 1. If cumulative metric (e.g., step log), merge deltas deduplicated by syncBatchId
    if (localRecord is CumulativeLog && remoteRecord is CumulativeLog) {
      final merged = (localRecord as CumulativeLog)
          .mergeWith(remoteRecord as CumulativeLog);
      return SyncResolution.merged(merged as T);
    }

    // 2. Otherwise fall back to Last-Write-Wins using the HLC (clock-skew resistant)
    if (localRecord.hlc.compareTo(remoteRecord.hlc) > 0) {
      return SyncResolution.keepLocal(); // Push local update to remote
    } else {
      return SyncResolution.keepRemote(); // Overwrite local record with remote
    }
  }
}
