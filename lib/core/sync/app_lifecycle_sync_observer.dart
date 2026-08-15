// §P14-B App Foreground Catch-Up Sync & iOS Sync Safeguards (Pure Dart)
// Cross-reference: §P14-B in Fitkarma_documentation.md

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract Synchronization Coordinator Interface
abstract class SyncCoordinator {
  Future<void> pushLocalChangesToCloud();
  Future<void> pullRemoteChangesToLocal();
  Future<void> recalculateLocalReadinessState();
}

/// In-App Default Sync Coordinator
class DefaultSyncCoordinator implements SyncCoordinator {
  bool pushExecuted = false;
  bool pullExecuted = false;
  bool readinessRecalculated = false;

  @override
  Future<void> pushLocalChangesToCloud() async {
    pushExecuted = true;
  }

  @override
  Future<void> pullRemoteChangesToLocal() async {
    pullExecuted = true;
  }

  @override
  Future<void> recalculateLocalReadinessState() async {
    readinessRecalculated = true;
  }
}

/// §P14-B App Lifecycle Sync Observer
class AppLifecycleSyncObserver extends WidgetsBindingObserver {
  final SyncCoordinator _syncCoordinator;
  DateTime _lastSyncTime;
  final int cooldownMinutes;
  int syncExecutionCount = 0;

  AppLifecycleSyncObserver(
    this._syncCoordinator, {
    DateTime? initialSyncTime,
    this.cooldownMinutes = 5,
  }) : _lastSyncTime = initialSyncTime ?? DateTime.now();

  DateTime get lastSyncTime => _lastSyncTime;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final elapsedSinceLastSync = DateTime.now().difference(_lastSyncTime);

      // Prevent double-sync if app was toggled rapidly (5-minute cooldown)
      if (elapsedSinceLastSync.inMinutes >= cooldownMinutes) {
        triggerForegroundCatchUpSync();
      }
    }
  }

  /// Executes the 3-step foreground catch-up synchronization
  Future<void> triggerForegroundCatchUpSync() async {
    _lastSyncTime = DateTime.now();
    syncExecutionCount++;

    // 1. Sync local Drift changes to Cloud
    await _syncCoordinator.pushLocalChangesToCloud();

    // 2. Fetch new updates (e.g. fresh wearable logs, remote doctor comments)
    await _syncCoordinator.pullRemoteChangesToLocal();

    // 3. Re-evaluate readiness and update DIP cache in Drift
    await _syncCoordinator.recalculateLocalReadinessState();
  }

  /// Handles silent push notification ({ "content-available": 1 }) in background
  Future<bool> handleSilentPushNotification(Map<String, dynamic> payload) async {
    if (payload['content-available'] == 1 ||
        payload['content_available'] == 1 ||
        payload['content_available'] == true) {
      await triggerForegroundCatchUpSync();
      return true;
    }
    return false;
  }
}

final syncCoordinatorProvider =
    Provider<SyncCoordinator>((ref) => DefaultSyncCoordinator());

final lifecycleSyncObserverProvider =
    Provider<AppLifecycleSyncObserver>((ref) {
  final coordinator = ref.watch(syncCoordinatorProvider);
  return AppLifecycleSyncObserver(coordinator);
});
