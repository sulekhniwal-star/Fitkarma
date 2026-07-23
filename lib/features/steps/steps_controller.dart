import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';

class StepsState {
  const StepsState({
    required this.stepsToday,
    required this.targetSteps,
    required this.distanceKm,
    required this.activeMinutes,
    required this.caloriesBurned,
    required this.hourlySteps,
    required this.syncStatus,
    required this.isLoading,
  });

  final int stepsToday;
  final int targetSteps;
  final double distanceKm;
  final int activeMinutes;
  final int caloriesBurned;
  final Map<int, int> hourlySteps;
  final String syncStatus; // 'Synced', 'Syncing', 'Error'
  final bool isLoading;

  StepsState copyWith({
    int? stepsToday,
    int? targetSteps,
    double? distanceKm,
    int? activeMinutes,
    int? caloriesBurned,
    Map<int, int>? hourlySteps,
    String? syncStatus,
    bool? isLoading,
  }) {
    return StepsState(
      stepsToday: stepsToday ?? this.stepsToday,
      targetSteps: targetSteps ?? this.targetSteps,
      distanceKm: distanceKm ?? this.distanceKm,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      hourlySteps: hourlySteps ?? this.hourlySteps,
      syncStatus: syncStatus ?? this.syncStatus,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class StepsNotifier extends Notifier<StepsState> {
  @override
  StepsState build() {
    Future.microtask(() => loadFromDb());
    return const StepsState(
      stepsToday: 8420,
      targetSteps: 10000,
      distanceKm: 6.2,
      activeMinutes: 52,
      caloriesBurned: 340,
      hourlySteps: {8: 1200, 10: 2500, 12: 1500, 14: 800, 16: 1800, 18: 620},
      syncStatus: 'Synced',
      isLoading: true,
    );
  }

  Future<void> loadFromDb() async {
    state = state.copyWith(isLoading: true);
    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      // Query step logs for today
      final logs = await (db.select(
        db.stepLogs,
      )..where((t) => t.loggedAt.isBiggerOrEqualValue(midnight))).get();

      // Cumulative Log pattern: sum all deltas for the day
      int dbSteps = 0;
      for (final log in logs) {
        dbSteps += log.steps;
      }

      // If we have database logs, use them; otherwise use mock defaults
      final steps = logs.isNotEmpty ? dbSteps : 8420;

      // Re-calculate metrics based on steps count
      final distance = double.parse((steps * 0.00075).toStringAsFixed(1));
      final minutes = steps ~/ 160;
      final calories = (steps * 0.04).round();

      // Re-bucket hourly steps from database if logs are available
      final Map<int, int> hourly = {};
      if (logs.isNotEmpty) {
        for (final log in logs) {
          final hr = log.loggedAt.hour;
          hourly[hr] = (hourly[hr] ?? 0) + log.steps;
        }
      } else {
        hourly.addAll({
          8: 1200,
          10: 2500,
          12: 1500,
          14: 800,
          16: 1800,
          18: 620,
        });
      }

      state = state.copyWith(
        stepsToday: steps,
        distanceKm: distance,
        activeMinutes: minutes,
        caloriesBurned: calories,
        hourlySteps: hourly,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> syncWithDeviceHealth(int deltaSteps) async {
    state = state.copyWith(syncStatus: 'Syncing');
    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();

      // Insert delta using CumulativeLog pattern
      await db
          .into(db.stepLogs)
          .insert(
            StepLogsCompanion.insert(
              steps: deltaSteps,
              syncBatchId: 'batch_${now.millisecondsSinceEpoch}',
              loggedAt: now,
              hlcPhysicalTime: now,
              hlcLogicalCounter: 0,
              hlcNodeId: 'device_sensor',
            ),
          );

      await loadFromDb();
      state = state.copyWith(syncStatus: 'Synced');
    } catch (_) {
      state = state.copyWith(syncStatus: 'Error');
    }
  }
}

final stepsProvider = NotifierProvider<StepsNotifier, StepsState>(
  StepsNotifier.new,
);
