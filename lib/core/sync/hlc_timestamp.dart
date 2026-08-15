import 'dart:math';

/// Hybrid Logical Clock (HLC) Timestamp for Conflict-Free Offline Sync
class HlcTimestamp implements Comparable<HlcTimestamp> {
  final int physicalTimeMillis;
  final int logicalCounter;
  final String nodeId;

  const HlcTimestamp({
    required this.physicalTimeMillis,
    required this.logicalCounter,
    required this.nodeId,
  });

  /// Generate next HLC timestamp ensuring strict monotonicity
  factory HlcTimestamp.now(String nodeId, {HlcTimestamp? lastHlc}) {
    final nowPhysical = DateTime.now().millisecondsSinceEpoch;
    if (lastHlc == null) {
      return HlcTimestamp(
          physicalTimeMillis: nowPhysical, logicalCounter: 0, nodeId: nodeId);
    }

    final maxPhysical = max(nowPhysical, lastHlc.physicalTimeMillis);
    int newCounter = 0;
    if (maxPhysical == lastHlc.physicalTimeMillis) {
      newCounter = lastHlc.logicalCounter + 1;
    }

    return HlcTimestamp(
      physicalTimeMillis: maxPhysical,
      logicalCounter: newCounter,
      nodeId: nodeId,
    );
  }

  @override
  int compareTo(HlcTimestamp other) {
    if (physicalTimeMillis != other.physicalTimeMillis) {
      return physicalTimeMillis.compareTo(other.physicalTimeMillis);
    }
    if (logicalCounter != other.logicalCounter) {
      return logicalCounter.compareTo(other.logicalCounter);
    }
    return nodeId.compareTo(other.nodeId);
  }

  @override
  String toString() => '$physicalTimeMillis:$logicalCounter:$nodeId';
}
