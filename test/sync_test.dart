import 'package:fitkarma/core/sync/sync_merge_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

// Concrete mockup implementation of CumulativeLog
class MockCumulativeLog extends CumulativeLog {
  MockCumulativeLog({
    required this.hlc,
    required this.syncBatchId,
    required this.count,
  });

  @override
  final HLCTimestamp hlc;
  @override
  final String syncBatchId;
  final int count;

  @override
  CumulativeLog mergeWith(CumulativeLog other) {
    if (other is MockCumulativeLog) {
      return MockCumulativeLog(
        hlc: hlc.compareTo(other.hlc) > 0 ? hlc : other.hlc,
        syncBatchId: '$syncBatchId+${other.syncBatchId}',
        count: count + other.count,
      );
    }
    return this;
  }
}

// Concrete mockup implementation of transactional entity
class MockEntity extends SyncableEntity {
  MockEntity({required this.hlc, required this.data});

  @override
  final HLCTimestamp hlc;
  final String data;
}

void main() {
  group('Hybrid Logical Clock (HLC) Tests', () {
    test('HLC comparison physical time precedence', () {
      final t1 = DateTime(2026, 7, 12, 12, 0, 0);
      final t2 = DateTime(2026, 7, 12, 12, 0, 1);
      final hlc1 = HLCTimestamp(
        physicalTime: t1,
        logicalCounter: 10,
        nodeId: 'nodeA',
      );
      final hlc2 = HLCTimestamp(
        physicalTime: t2,
        logicalCounter: 0,
        nodeId: 'nodeA',
      );

      expect(hlc1.compareTo(hlc2), isNegative);
      expect(hlc2.compareTo(hlc1), isPositive);
    });

    test('HLC comparison logical counter tiebreaker', () {
      final t1 = DateTime(2026, 7, 12, 12, 0, 0);
      final hlc1 = HLCTimestamp(
        physicalTime: t1,
        logicalCounter: 5,
        nodeId: 'nodeA',
      );
      final hlc2 = HLCTimestamp(
        physicalTime: t1,
        logicalCounter: 8,
        nodeId: 'nodeA',
      );

      expect(hlc1.compareTo(hlc2), isNegative);
    });

    test('HLC comparison nodeId final tiebreaker', () {
      final t1 = DateTime(2026, 7, 12, 12, 0, 0);
      final hlc1 = HLCTimestamp(
        physicalTime: t1,
        logicalCounter: 5,
        nodeId: 'nodeA',
      );
      final hlc2 = HLCTimestamp(
        physicalTime: t1,
        logicalCounter: 5,
        nodeId: 'nodeB',
      );

      expect(hlc1.compareTo(hlc2), isNegative);
    });
  });

  group('Sync Conflict Resolver Tests', () {
    const resolver = SyncMergeResolver();

    test('Last-Write-Wins (LWW) with HLC', () {
      final t1 = DateTime(2026, 7, 12, 12, 0, 0);
      final t2 = DateTime(2026, 7, 12, 12, 0, 5);

      final local = MockEntity(
        hlc: HLCTimestamp(
          physicalTime: t2,
          logicalCounter: 0,
          nodeId: 'clientA',
        ),
        data: 'Local newer state',
      );
      final remote = MockEntity(
        hlc: HLCTimestamp(
          physicalTime: t1,
          logicalCounter: 10,
          nodeId: 'clientB',
        ),
        data: 'Remote older state',
      );

      final resolution = resolver.resolveConflict(
        localRecord: local,
        remoteRecord: remote,
      );
      expect(resolution.type, SyncResolutionType.keepLocal);
    });

    test('CumulativeLog merging cumulative values', () {
      final t = DateTime(2026, 7, 12, 12, 0, 0);
      final local = MockCumulativeLog(
        hlc: HLCTimestamp(
          physicalTime: t,
          logicalCounter: 0,
          nodeId: 'clientA',
        ),
        syncBatchId: 'b1',
        count: 5,
      );
      final remote = MockCumulativeLog(
        hlc: HLCTimestamp(
          physicalTime: t,
          logicalCounter: 1,
          nodeId: 'clientB',
        ),
        syncBatchId: 'b2',
        count: 10,
      );

      final resolution = resolver.resolveConflict(
        localRecord: local,
        remoteRecord: remote,
      );
      expect(resolution.type, SyncResolutionType.merged);

      final merged = resolution.mergedRecord as MockCumulativeLog;
      expect(merged.count, 15);
      expect(merged.syncBatchId, 'b1+b2');
    });
  });
}
