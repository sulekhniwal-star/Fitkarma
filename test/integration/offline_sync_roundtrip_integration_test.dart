import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/sync/hlc_timestamp.dart';
import 'package:fitkarma/core/sync/sync_merge_resolver.dart';
import 'package:fitkarma/core/sync/app_lifecycle_sync_observer.dart';

class TestSyncRecord implements SyncableEntity {
  final String id;
  final String content;
  @override
  final HlcTimestamp hlc;

  TestSyncRecord({required this.id, required this.content, required this.hlc});
}

class TestStepDeltaLog extends CumulativeLog {
  final String id;
  final int stepCount;
  @override
  final String syncBatchId;
  @override
  final HlcTimestamp hlc;

  TestStepDeltaLog({
    required this.id,
    required this.stepCount,
    required this.syncBatchId,
    required this.hlc,
  });

  @override
  CumulativeLog mergeWith(CumulativeLog other) {
    if (other is! TestStepDeltaLog) return this;
    return TestStepDeltaLog(
      id: id,
      stepCount: stepCount + other.stepCount,
      syncBatchId: '$syncBatchId+${other.syncBatchId}',
      hlc: hlc.compareTo(other.hlc) > 0 ? hlc : other.hlc,
    );
  }
}

void main() {
  group('§P14-C Integration: Offline -> Online Sync Round-Trip & Conflict Resolution', () {
    const resolver = SyncMergeResolver();

    test('LWW Conflict Resolution: Newer local HLC retains local record', () {
      const hlcOlder = HlcTimestamp(physicalTimeMillis: 1000, logicalCounter: 0, nodeId: 'nodeA');
      const hlcNewer = HlcTimestamp(physicalTimeMillis: 2000, logicalCounter: 0, nodeId: 'nodeB');

      final local = TestSyncRecord(id: 'rec_1', content: 'Local Update', hlc: hlcNewer);
      final remote = TestSyncRecord(id: 'rec_1', content: 'Remote Update', hlc: hlcOlder);

      final resolution = resolver.resolveConflict(localRecord: local, remoteRecord: remote);
      expect(resolution.action, equals(SyncAction.keepLocal));
    });

    test('Cumulative Log CRRA: Merges step deltas from disparate devices deduplicated', () {
      const hlc1 = HlcTimestamp(physicalTimeMillis: 1000, logicalCounter: 0, nodeId: 'nodeA');
      const hlc2 = HlcTimestamp(physicalTimeMillis: 1050, logicalCounter: 0, nodeId: 'nodeB');

      final localSteps = TestStepDeltaLog(id: 'steps_today', stepCount: 3500, syncBatchId: 'batch_local_1', hlc: hlc1);
      final remoteSteps = TestStepDeltaLog(id: 'steps_today', stepCount: 1200, syncBatchId: 'batch_remote_2', hlc: hlc2);

      final resolution = resolver.resolveConflict(localRecord: localSteps, remoteRecord: remoteSteps);
      expect(resolution.action, equals(SyncAction.merged));

      final merged = resolution.resolvedRecord as TestStepDeltaLog;
      expect(merged.stepCount, equals(4700));
    });

    test('Full Foreground Catch-Up Sync Round-Trip', () async {
      final coordinator = DefaultSyncCoordinator();
      final observer = AppLifecycleSyncObserver(coordinator);

      expect(coordinator.pushExecuted, isFalse);
      expect(coordinator.pullExecuted, isFalse);
      expect(coordinator.readinessRecalculated, isFalse);

      await observer.triggerForegroundCatchUpSync();

      expect(coordinator.pushExecuted, isTrue);
      expect(coordinator.pullExecuted, isTrue);
      expect(coordinator.readinessRecalculated, isTrue);
    });
  });
}
