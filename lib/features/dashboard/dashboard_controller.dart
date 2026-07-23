import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';

class DashboardState {
  const DashboardState({
    required this.steps,
    required this.targetSteps,
    required this.sleepHours,
    required this.sleepScore,
    required this.systolic,
    required this.diastolic,
    required this.glucose,
    required this.waterL,
    required this.waterTargetL,
    required this.caloriesConsumed,
    required this.caloriesTarget,
    required this.readinessScore,
    required this.healthScore,
    required this.streakDays,
    required this.karmaPoints,
    required this.primaryInsight,
    required this.isLoading,
  });

  final int steps;
  final int targetSteps;
  final double sleepHours;
  final int sleepScore;
  final int systolic;
  final int diastolic;
  final double glucose;
  final double waterL;
  final double waterTargetL;
  final int caloriesConsumed;
  final int caloriesTarget;
  final int readinessScore;
  final int healthScore;
  final int streakDays;
  final int karmaPoints;
  final String primaryInsight;
  final bool isLoading;

  DashboardState copyWith({
    int? steps,
    int? targetSteps,
    double? sleepHours,
    int? sleepScore,
    int? systolic,
    int? diastolic,
    double? glucose,
    double? waterL,
    double? waterTargetL,
    int? caloriesConsumed,
    int? caloriesTarget,
    int? readinessScore,
    int? healthScore,
    int? streakDays,
    int? karmaPoints,
    String? primaryInsight,
    bool? isLoading,
  }) {
    return DashboardState(
      steps: steps ?? this.steps,
      targetSteps: targetSteps ?? this.targetSteps,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepScore: sleepScore ?? this.sleepScore,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      glucose: glucose ?? this.glucose,
      waterL: waterL ?? this.waterL,
      waterTargetL: waterTargetL ?? this.waterTargetL,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      readinessScore: readinessScore ?? this.readinessScore,
      healthScore: healthScore ?? this.healthScore,
      streakDays: streakDays ?? this.streakDays,
      karmaPoints: karmaPoints ?? this.karmaPoints,
      primaryInsight: primaryInsight ?? this.primaryInsight,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    Future.microtask(() => loadData());
    return const DashboardState(
      steps: 8420,
      targetSteps: 10000,
      sleepHours: 6.33,
      sleepScore: 82,
      systolic: 120,
      diastolic: 80,
      glucose: 95.0,
      waterL: 1.8,
      waterTargetL: 3.0,
      caloriesConsumed: 1240,
      caloriesTarget: 1800,
      readinessScore: 73,
      healthScore: 80,
      streakDays: 12,
      karmaPoints: 4280,
      primaryInsight:
          'Add paneer or 2 boiled eggs to breakfast to help your muscles recover.',
      isLoading: true,
    );
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final db = ref.read(databaseProvider);
      const userId = 'onboarding_user'; // Standard user reference

      // 1. Fetch latest daily intelligence package
      final dip =
          await (db.select(db.dailyIntelligencePackages)
                ..where((t) => t.userId.equals(userId))
                ..orderBy([
                  (t) => drift.OrderingTerm(
                    expression: t.packageDate,
                    mode: drift.OrderingMode.desc,
                  ),
                ])
                ..limit(1))
              .getSingleOrNull();

      // 2. Fetch latest recovery log
      final recoveryLogs = await db.getRecoveryLogs(userId);
      final latestRecovery = recoveryLogs.isNotEmpty
          ? recoveryLogs.first
          : null;

      // 3. Update state incorporating DB values or fallback to default specs
      state = state.copyWith(
        readinessScore: latestRecovery?.readinessScore ?? 73,
        healthScore: 80,
        sleepScore: latestRecovery?.sleepPerformanceScore ?? 82,
        sleepHours: latestRecovery != null
            ? (latestRecovery.sleepPerformanceScore / 60.0)
            : 6.33,
        caloriesTarget: dip?.adjustedCalories ?? 1800,
        waterTargetL: dip?.adjustedHydrationL ?? 3.0,
        primaryInsight:
            dip?.primaryInsight ??
            'Add paneer or 2 boiled eggs to breakfast to help your muscles recover.',
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);
