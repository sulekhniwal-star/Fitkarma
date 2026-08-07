import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/steps_sync_engine.dart';

/// §P4-B Steps State — DIP-first, Drift-backed
class StepsState {
  final StepsSyncRecord record;
  final String coachNudge;
  final bool isPermissionGranted;
  final bool isSyncing;

  const StepsState({
    required this.record,
    this.coachNudge = '',
    this.isPermissionGranted = true,
    this.isSyncing = false,
  });

  StepsState copyWith({
    StepsSyncRecord? record,
    String? coachNudge,
    bool? isPermissionGranted,
    bool? isSyncing,
  }) {
    return StepsState(
      record: record ?? this.record,
      coachNudge: coachNudge ?? this.coachNudge,
      isPermissionGranted:
          isPermissionGranted ?? this.isPermissionGranted,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

/// §P4-B StepsNotifier
///
/// Sync flow (Workmanager triggers every 15 min):
///   1. Set syncStatus = syncing
///   2. Call engine.syncStepsWithDeviceHealth (platform → Drift delta write)
///   3. Recompute derived metrics (distance, calories, active min)
///   4. Regenerate coach nudge
///   5. Set syncStatus = synced / error
class StepsNotifier extends StateNotifier<StepsState> {
  final StepsSyncEngine _engine;

  StepsNotifier(this._engine) : super(_buildInitialState(_engine)) {
    _loadFromDrift();
  }

  static StepsState _buildInitialState(StepsSyncEngine engine) {
    final metrics = engine.deriveMetrics(steps: 8420, goalSteps: 10000);
    final nudge = engine.generateCoachNudge(
      currentSteps: 8420,
      goalSteps: 10000,
      activeMinutes: 52,
    );
    final record = StepsSyncRecord(
      date: DateTime.now(),
      totalSteps: 8420,
      stepGoal: 10000,
      distanceKm: metrics.distanceKm,
      activeMinutes: metrics.activeMinutes,
      caloriesBurned: metrics.caloriesBurned,
      hourlyDistribution: _buildSampleHourly(engine),
      source: StepDataSource.healthConnect,
      lastSyncedAt: DateTime.now(),
      syncStatus: SyncStatus.synced,
    );
    return StepsState(record: record, coachNudge: nudge);
  }

  /// Load from Drift on screen open (instant, no AI call)
  Future<void> _loadFromDrift() async {
    // Production: query Drift daily_metrics for today's steps + hourly buckets
    // Already initialized with sample data in _buildInitialState
  }

  /// §P4-B syncStepsWithDeviceHealth — called by Workmanager every 15 min
  Future<void> triggerSync() async {
    state = state.copyWith(
      isSyncing: true,
      record: state.record.copyWith(syncStatus: SyncStatus.syncing),
    );

    try {
      // Inject platform/Drift callbacks — mocked here for Pure Dart testability
      final newSteps = await _engine.syncStepsWithDeviceHealth(
        readFromPlatform: (start, end) async {
          // Production: return await Health().getTotalStepsInInterval(start, end);
          await Future.delayed(const Duration(milliseconds: 300));
          return 8850; // Simulated delta (430 new steps since last sync)
        },
        readFromDrift: (_) async => state.record.totalSteps,
        writeToDrift: (_, __) async {
          // Production: await db.updateDailySteps(date, steps);
        },
      );

      if (newSteps != null) {
        final metrics = _engine.deriveMetrics(
          steps: newSteps,
          goalSteps: state.record.stepGoal,
        );
        final nudge = _engine.generateCoachNudge(
          currentSteps: newSteps,
          goalSteps: state.record.stepGoal,
          activeMinutes: metrics.activeMinutes,
        );

        state = state.copyWith(
          isSyncing: false,
          record: state.record.copyWith(
            totalSteps: newSteps,
            distanceKm: metrics.distanceKm,
            activeMinutes: metrics.activeMinutes,
            caloriesBurned: metrics.caloriesBurned,
            syncStatus: SyncStatus.synced,
            lastSyncedAt: DateTime.now(),
          ),
          coachNudge: nudge,
        );
      } else {
        // No delta — mark as synced with no change
        state = state.copyWith(
          isSyncing: false,
          record: state.record.copyWith(
            syncStatus: SyncStatus.synced,
            lastSyncedAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        record: state.record.copyWith(syncStatus: SyncStatus.error),
      );
    }
  }

  /// Manual step entry (fallback when HealthConnect/HealthKit unavailable)
  void logManualSteps(int steps) {
    final metrics =
        _engine.deriveMetrics(steps: steps, goalSteps: state.record.stepGoal);
    final nudge = _engine.generateCoachNudge(
      currentSteps: steps,
      goalSteps: state.record.stepGoal,
      activeMinutes: metrics.activeMinutes,
    );
    state = state.copyWith(
      record: state.record.copyWith(
        totalSteps: steps,
        distanceKm: metrics.distanceKm,
        activeMinutes: metrics.activeMinutes,
        caloriesBurned: metrics.caloriesBurned,
        syncStatus: SyncStatus.synced,
        lastSyncedAt: DateTime.now(),
      ),
      coachNudge: nudge,
    );
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  static List<HourlyStepBucket> _buildSampleHourly(StepsSyncEngine engine) {
    return engine.buildHourlyDistribution({
      6: 320,
      7: 540,
      8: 890,
      9: 1240,
      10: 620,
      11: 480,
      12: 750,
      13: 380,
      14: 920,
      15: 560,
      16: 300,
      17: 420,
    });
  }
}

final stepsProvider =
    StateNotifierProvider<StepsNotifier, StepsState>(
        (_) => StepsNotifier(const StepsSyncEngine()));
