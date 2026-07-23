/// Hybrid Logical Clock: physical time + a logical counter that increments
/// on every local or remote event this node observes. Monotonic even when
/// device clocks disagree, because the counter — not the wall clock —
/// breaks ties.
class HLCTimestamp implements Comparable<HLCTimestamp> {
  const HLCTimestamp({
    required this.physicalTime,
    required this.logicalCounter,
    required this.nodeId,
  });

  final DateTime physicalTime;
  final int logicalCounter;
  final String nodeId; // final tiebreaker if both are equal

  @override
  int compareTo(HLCTimestamp other) {
    final physicalCompare = physicalTime.compareTo(other.physicalTime);
    if (physicalCompare != 0) return physicalCompare;
    final logicalCompare = logicalCounter.compareTo(other.logicalCounter);
    if (logicalCompare != 0) return logicalCompare;
    return nodeId.compareTo(other.nodeId);
  }
}

enum SyncResolutionType { merged, keepLocal, keepRemote }

class SyncResolution {
  const SyncResolution._(this.type, [this.mergedRecord]);

  factory SyncResolution.merged(SyncableEntity merged) =>
      SyncResolution._(SyncResolutionType.merged, merged);
  factory SyncResolution.keepLocal() =>
      const SyncResolution._(SyncResolutionType.keepLocal);
  factory SyncResolution.keepRemote() =>
      const SyncResolution._(SyncResolutionType.keepRemote);

  final SyncResolutionType type;
  final SyncableEntity? mergedRecord;
}

class SyncMergeResolver {
  const SyncMergeResolver();

  /// Resolves conflicts between a local and remote record for the same entity
  SyncResolution resolveConflict<T extends SyncableEntity>({
    required T localRecord,
    required T remoteRecord,
  }) {
    // 1. If it's a cumulative metric (e.g., step log), merge by summing
    //    deltas — deduplicated by syncBatchId, see CumulativeLog.mergeWith.
    if (localRecord is CumulativeLog && remoteRecord is CumulativeLog) {
      return SyncResolution.merged(
        (localRecord as CumulativeLog).mergeWith(remoteRecord as CumulativeLog),
      );
    }

    // 2. Otherwise, fall back to Last-Write-Wins using the HLC, not the
    //    raw device clock — resistant to clock skew between devices.
    if (localRecord.hlc.compareTo(remoteRecord.hlc) > 0) {
      return SyncResolution.keepLocal(); // Push local update to remote
    } else {
      return SyncResolution.keepRemote(); // Overwrite local Drift DB with remote
    }
  }
}

abstract class SyncableEntity {
  HLCTimestamp get hlc;
}

abstract class CumulativeLog extends SyncableEntity {
  /// Client-generated ID for this delta batch. The server maintains a
  /// set of already-applied batch IDs per entity and no-ops a repeat —
  /// this is what makes a retried sync safe to resend.
  String get syncBatchId;

  CumulativeLog mergeWith(CumulativeLog other);
}
