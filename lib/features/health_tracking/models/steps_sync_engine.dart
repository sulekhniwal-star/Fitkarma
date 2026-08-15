// §P4-B Auto-Detection & Sync Engine (Pure Dart)
//
// Platform Bridging: Wraps the `health` package to read from
//   HealthConnect (Android) and HealthKit (iOS).
// Background Sync: Fired every 15 min by Workmanager.
//   Fetches step delta, compares with Drift cache, writes locally.

// ── Sync Status ───────────────────────────────────────────────────────────────

enum SyncStatus { idle, syncing, synced, error }

extension SyncStatusLabel on SyncStatus {
  String get label {
    switch (this) {
      case SyncStatus.idle:
        return 'Pending';
      case SyncStatus.syncing:
        return 'Syncing…';
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.error:
        return 'Error';
    }
  }
}

// ── Platform Source ───────────────────────────────────────────────────────────

enum StepDataSource {
  healthConnect, // Android 14+ HealthConnect
  healthKit, // iOS HealthKit
  manual, // User-entered fallback
  unknown,
}

// ── Hourly Step Bucket ────────────────────────────────────────────────────────

class HourlyStepBucket {
  final int hour; // 0–23
  final int steps; // accumulated in this hour

  const HourlyStepBucket({required this.hour, required this.steps});
}

// ── Steps Sync Record ─────────────────────────────────────────────────────────

class StepsSyncRecord {
  final DateTime date;
  final int totalSteps;
  final int stepGoal;
  final double distanceKm;
  final int activeMinutes;
  final int caloriesBurned;
  final List<HourlyStepBucket> hourlyDistribution;
  final StepDataSource source;
  final DateTime lastSyncedAt;
  final SyncStatus syncStatus;

  const StepsSyncRecord({
    required this.date,
    required this.totalSteps,
    this.stepGoal = 10000,
    required this.distanceKm,
    required this.activeMinutes,
    required this.caloriesBurned,
    this.hourlyDistribution = const [],
    this.source = StepDataSource.healthConnect,
    required this.lastSyncedAt,
    this.syncStatus = SyncStatus.synced,
  });

  double get progressFraction =>
      stepGoal > 0 ? (totalSteps / stepGoal).clamp(0.0, 1.0) : 0.0;

  int get remainingSteps => (stepGoal - totalSteps).clamp(0, stepGoal);

  StepsSyncRecord copyWith({
    int? totalSteps,
    double? distanceKm,
    int? activeMinutes,
    int? caloriesBurned,
    List<HourlyStepBucket>? hourlyDistribution,
    SyncStatus? syncStatus,
    DateTime? lastSyncedAt,
  }) {
    return StepsSyncRecord(
      date: date,
      totalSteps: totalSteps ?? this.totalSteps,
      stepGoal: stepGoal,
      distanceKm: distanceKm ?? this.distanceKm,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      hourlyDistribution: hourlyDistribution ?? this.hourlyDistribution,
      source: source,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}

// ── Steps Sync Engine ─────────────────────────────────────────────────────────

/// §P4-B Auto-Detection & Sync Engine.
///
/// In production:
///   - [syncStepsWithDeviceHealth] is called by Workmanager every 15 minutes.
///   - [readFromPlatform] wraps `Health().getTotalStepsInInterval(midnight, now)`.
///   - Steps are written to Drift via [updateDailySteps].
///
/// This class is Pure Dart — the `health` package call is injected via
/// [readFromPlatform] callback so the engine is fully testable without a device.
class StepsSyncEngine {
  const StepsSyncEngine();

  /// §P4-B syncStepsWithDeviceHealth (per spec)
  ///
  /// [readFromPlatform] wraps `Health().getTotalStepsInInterval(midnight, now)`.
  /// Returns the new step count written, or null if nothing to sync.
  Future<int?> syncStepsWithDeviceHealth({
    required Future<int?> Function(DateTime start, DateTime end)
        readFromPlatform,
    required Future<int?> Function(DateTime date) readFromDrift,
    required Future<void> Function(DateTime date, int steps) writeToDrift,
  }) async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    // 1. Fetch from platform (HealthConnect / HealthKit)
    final platformSteps = await readFromPlatform(midnight, now);
    if (platformSteps == null) return null;

    // 2. Compare with cached Drift value
    final cachedSteps = await readFromDrift(midnight);

    // 3. Only write if there's a delta (avoid unnecessary Drift writes)
    if (cachedSteps == null || platformSteps != cachedSteps) {
      await writeToDrift(midnight, platformSteps);
      return platformSteps;
    }

    return null; // No change — nothing written
  }

  /// Derive derived metrics from raw step count + duration
  StepMetrics deriveMetrics({
    required int steps,
    required int goalSteps,
  }) {
    // Walking: ~0.762m stride × steps = distance
    final distanceKm = (steps * 0.000762).clamp(0, double.infinity);

    // ~100 steps/min average walking cadence
    final activeMinutes = (steps / 100).round().clamp(0, 1440);

    // MET-based approximation: steps × 0.04 kcal (70kg average)
    final calories = (steps * 0.04).round().clamp(0, 9999);

    final progress = goalSteps > 0 ? (steps / goalSteps).clamp(0.0, 1.0) : 0.0;

    return StepMetrics(
      steps: steps,
      goalSteps: goalSteps,
      distanceKm: double.parse(distanceKm.toStringAsFixed(1)),
      activeMinutes: activeMinutes,
      caloriesBurned: calories,
      progressFraction: progress,
    );
  }

  /// Build hourly distribution from hourly step data Map
  List<HourlyStepBucket> buildHourlyDistribution(Map<int, int> hourlyData) {
    return List.generate(24, (h) {
      return HourlyStepBucket(hour: h, steps: hourlyData[h] ?? 0);
    });
  }

  /// Generate a coach nudge based on current step progress
  String generateCoachNudge({
    required int currentSteps,
    required int goalSteps,
    required int activeMinutes,
  }) {
    final remaining = goalSteps - currentSteps;
    final progress = goalSteps > 0 ? currentSteps / goalSteps : 0.0;

    if (progress >= 1.0) {
      return 'Goal achieved! 🎉 You\'ve hit $goalSteps steps. Consider an evening walk to bank extra Karma.';
    }
    if (progress >= 0.85) {
      final minutesNeeded = (remaining / 100).ceil();
      return 'Almost there! A $minutesNeeded-minute walk now will cross your daily goal before dinner.';
    }
    if (progress >= 0.5) {
      return 'Good momentum — you\'re halfway. ${_formatSteps(remaining)} steps left. '
          'Try a 15-minute walk after your next meal.';
    }
    if (activeMinutes < 20) {
      return 'You\'ve been largely sedentary today. Even a 10-minute walk now '
          'will meaningfully improve your recovery score.';
    }
    return 'Keep going! ${_formatSteps(remaining)} steps remaining to hit your $goalSteps target.';
  }

  String _formatSteps(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

/// Derived step metrics (computed by engine, not stored in Drift)
class StepMetrics {
  final int steps;
  final int goalSteps;
  final double distanceKm;
  final int activeMinutes;
  final int caloriesBurned;
  final double progressFraction;

  const StepMetrics({
    required this.steps,
    required this.goalSteps,
    required this.distanceKm,
    required this.activeMinutes,
    required this.caloriesBurned,
    required this.progressFraction,
  });
}
