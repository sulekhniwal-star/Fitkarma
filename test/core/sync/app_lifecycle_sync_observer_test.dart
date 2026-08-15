import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/sync/app_lifecycle_sync_observer.dart';

class MockSyncCoordinator implements SyncCoordinator {
  final List<String> callOrder = [];

  @override
  Future<void> pushLocalChangesToCloud() async {
    callOrder.add('pushLocalChangesToCloud');
  }

  @override
  Future<void> pullRemoteChangesToLocal() async {
    callOrder.add('pullRemoteChangesToLocal');
  }

  @override
  Future<void> recalculateLocalReadinessState() async {
    callOrder.add('recalculateLocalReadinessState');
  }
}

void main() {
  group('§P14-B App Lifecycle Sync Observer Tests (Pure Dart)', () {
    test(
        'Executes 3-step synchronization sequence in exact order upon resume after cooldown',
        () async {
      final mockCoordinator = MockSyncCoordinator();
      // Initial sync was 10 minutes ago (> 5 min cooldown)
      final tenMinutesAgo =
          DateTime.now().subtract(const Duration(minutes: 10));
      final observer = AppLifecycleSyncObserver(
        mockCoordinator,
        initialSyncTime: tenMinutesAgo,
        cooldownMinutes: 5,
      );

      expect(observer.syncExecutionCount, equals(0));

      // Simulate App Resumed
      observer.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(observer.syncExecutionCount, equals(1));
      expect(
          mockCoordinator.callOrder,
          equals([
            'pushLocalChangesToCloud',
            'pullRemoteChangesToLocal',
            'recalculateLocalReadinessState',
          ]));
    });

    test(
        'Suppresses sync if app was resumed within the 5-minute cooldown period',
        () async {
      final mockCoordinator = MockSyncCoordinator();
      // Initial sync was 2 minutes ago (< 5 min cooldown)
      final twoMinutesAgo = DateTime.now().subtract(const Duration(minutes: 2));
      final observer = AppLifecycleSyncObserver(
        mockCoordinator,
        initialSyncTime: twoMinutesAgo,
        cooldownMinutes: 5,
      );

      // Simulate App Resumed
      observer.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(observer.syncExecutionCount, equals(0));
      expect(mockCoordinator.callOrder, isEmpty);
    });

    test(
        'Handles silent push notification with content-available payload in background',
        () async {
      final mockCoordinator = MockSyncCoordinator();
      final observer = AppLifecycleSyncObserver(mockCoordinator);

      // Non-content-available push -> ignored
      final ignored = await observer
          .handleSilentPushNotification({'title': 'Regular Alert'});
      expect(ignored, isFalse);
      expect(observer.syncExecutionCount, equals(0));

      // Silent push wake-up
      final handled =
          await observer.handleSilentPushNotification({'content-available': 1});
      expect(handled, isTrue);
      expect(observer.syncExecutionCount, equals(1));
      expect(mockCoordinator.callOrder.length, equals(3));
    });
  });
}
