import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/sync/offline_sync_queue.dart';

void main() {
  group('OfflineSyncQueue Unit Tests', () {
    test('PendingMutation correctly serializes and deserializes', () {
      final now = DateTime.now();
      final mutation = PendingMutation(
        id: 'test-uuid-1234',
        table: 'meals',
        action: MutationAction.insert,
        payload: {'meal_name': 'Paneer Bhurji', 'calories': 320},
        createdAt: now,
      );

      final map = mutation.toMap();
      final reconstructed = PendingMutation.fromMap(map);

      expect(reconstructed.id, equals('test-uuid-1234'));
      expect(reconstructed.table, equals('meals'));
      expect(reconstructed.action, equals(MutationAction.insert));
      expect(reconstructed.payload['meal_name'], equals('Paneer Bhurji'));
      expect(reconstructed.payload['calories'], equals(320));
      expect(reconstructed.status, equals(MutationStatus.pending));
      expect(reconstructed.retryCount, equals(0));
    });

    test('PendingMutation copyWith updates fields correctly', () {
      final now = DateTime.now();
      final mutation = PendingMutation(
        id: 'test-uuid-5678',
        table: 'biomarkers',
        action: MutationAction.upsert,
        payload: {'glucose': 95},
        createdAt: now,
      );

      final updated = mutation.copyWith(
        status: MutationStatus.failed,
        retryCount: 1,
        errorMessage: 'Network timeout',
      );

      expect(updated.id, equals('test-uuid-5678'));
      expect(updated.status, equals(MutationStatus.failed));
      expect(updated.retryCount, equals(1));
      expect(updated.errorMessage, equals('Network timeout'));
    });

    test('OfflineSyncQueueState tracks pending count and sync metrics', () {
      final now = DateTime.now();
      final state = OfflineSyncQueueState(
        queue: [
          PendingMutation(
            id: '1',
            table: 'meals',
            action: MutationAction.insert,
            payload: {},
            createdAt: now,
            status: MutationStatus.pending,
          ),
          PendingMutation(
            id: '2',
            table: 'steps',
            action: MutationAction.insert,
            payload: {},
            createdAt: now,
            status: MutationStatus.pending,
          ),
          PendingMutation(
            id: '3',
            table: 'sleep',
            action: MutationAction.insert,
            payload: {},
            createdAt: now,
            status: MutationStatus.completed,
          ),
        ],
        isSyncing: false,
        totalSynced: 5,
      );

      expect(state.pendingCount, equals(2));
      expect(state.totalSynced, equals(5));
      expect(state.isSyncing, isFalse);
    });
  });
}
