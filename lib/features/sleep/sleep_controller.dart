import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';

class SleepState {
  const SleepState({
    required this.sleepMinutes,
    required this.awakeMinutes,
    required this.remMinutes,
    required this.lightMinutes,
    required this.deepMinutes,
    required this.sleepQuality,
    required this.sleepDebtMinutes,
    required this.hrvTrend,
    required this.isLoading,
  });

  final int sleepMinutes;
  final int awakeMinutes;
  final int remMinutes;
  final int lightMinutes;
  final int deepMinutes;
  final int sleepQuality;
  final int sleepDebtMinutes;
  final List<double> hrvTrend;
  final bool isLoading;

  SleepState copyWith({
    int? sleepMinutes,
    int? awakeMinutes,
    int? remMinutes,
    int? lightMinutes,
    int? deepMinutes,
    int? sleepQuality,
    int? sleepDebtMinutes,
    List<double>? hrvTrend,
    bool? isLoading,
  }) {
    return SleepState(
      sleepMinutes: sleepMinutes ?? this.sleepMinutes,
      awakeMinutes: awakeMinutes ?? this.awakeMinutes,
      remMinutes: remMinutes ?? this.remMinutes,
      lightMinutes: lightMinutes ?? this.lightMinutes,
      deepMinutes: deepMinutes ?? this.deepMinutes,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sleepDebtMinutes: sleepDebtMinutes ?? this.sleepDebtMinutes,
      hrvTrend: hrvTrend ?? this.hrvTrend,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SleepNotifier extends Notifier<SleepState> {
  @override
  SleepState build() {
    Future.microtask(() => loadFromDb());
    return const SleepState(
      sleepMinutes: 435, // 7h 15m
      awakeMinutes: 23,
      remMinutes: 90,
      lightMinutes: 247,
      deepMinutes: 75,
      sleepQuality: 80,
      sleepDebtMinutes: -30, // Default sleep debt (surplus)
      hrvTrend: [58.0, 62.0, 60.0, 64.0, 61.0, 65.0, 68.0],
      isLoading: true,
    );
  }

  Future<void> loadFromDb() async {
    state = state.copyWith(isLoading: true);
    try {
      final db = ref.read(databaseProvider);
      const userId = 'onboarding_user'; // Standard user reference
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Query sleep logs for the last 7 days
      final logs = await (db.select(db.sleepLogs)
            ..where((t) => t.userId.equals(userId) & t.sleepDate.isBiggerOrEqualValue(sevenDaysAgo))
            ..orderBy([(t) => drift.OrderingTerm(expression: t.sleepDate, mode: drift.OrderingMode.desc)]))
          .get();

      if (logs.isEmpty) {
        // Fallback to default state if no DB logs exist yet
        state = state.copyWith(
          sleepMinutes: 435,
          awakeMinutes: 23,
          remMinutes: 90,
          lightMinutes: 247,
          deepMinutes: 75,
          sleepQuality: 80,
          sleepDebtMinutes: -30,
          hrvTrend: [58.0, 62.0, 60.0, 64.0, 61.0, 65.0, 68.0],
          isLoading: false,
        );
        return;
      }

      // Calculate last night (most recent log)
      final lastNight = logs.first;

      // Compute rolling sleep debt: sum of (480 - actualSleepMinutes) for logged days in last 7 days
      int debt = 0;
      final Set<String> loggedDates = {};
      for (final log in logs) {
        final dateKey = '${log.sleepDate.year}-${log.sleepDate.month}-${log.sleepDate.day}';
        if (!loggedDates.contains(dateKey)) {
          loggedDates.add(dateKey);
          debt += (480 - log.sleepMinutes);
        }
      }

      // Populate HRV trend from logs (reverse to make chronological)
      final List<double> hrvs = logs.map((l) => l.hrvMs).toList().reversed.toList();

      state = state.copyWith(
        sleepMinutes: lastNight.sleepMinutes,
        awakeMinutes: lastNight.awakeMinutes,
        remMinutes: lastNight.remMinutes,
        lightMinutes: lastNight.lightMinutes,
        deepMinutes: lastNight.deepMinutes,
        sleepQuality: lastNight.sleepQuality,
        sleepDebtMinutes: debt,
        hrvTrend: hrvs,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addSleepLog({
    required int durationMinutes,
    required int awakeMinutes,
    required int remMinutes,
    required int lightMinutes,
    required int deepMinutes,
    required int quality,
    required double hrv,
    required DateTime date,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final db = ref.read(databaseProvider);
      const userId = 'onboarding_user'; // Standard user reference

      // Insert sleep log delta
      await db.into(db.sleepLogs).insert(
        SleepLogsCompanion.insert(
          userId: userId,
          sleepMinutes: durationMinutes,
          awakeMinutes: awakeMinutes,
          remMinutes: remMinutes,
          lightMinutes: lightMinutes,
          deepMinutes: deepMinutes,
          sleepQuality: quality,
          hrvMs: hrv,
          sleepDate: date,
          syncBatchId: 'sleep_${date.millisecondsSinceEpoch}',
          hlcPhysicalTime: date,
          hlcLogicalCounter: 0,
          hlcNodeId: 'device_wearable',
        ),
      );

      await loadFromDb();
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final sleepProvider = NotifierProvider<SleepNotifier, SleepState>(
  SleepNotifier.new,
);
