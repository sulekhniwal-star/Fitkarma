import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fitkarma/core/brain/health_snapshot.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final healthOSBrainProvider = Provider<HealthOSBrain>((ref) {
  final db = ref.watch(databaseProvider);
  final syncWorker = ref.watch(syncWorkerProvider);
  return HealthOSBrain(db, syncWorker);
});

class HealthOSBrain {
  HealthOSBrain(this._db, this._syncWorker);

  final AppDatabase _db;
  final SyncWorker _syncWorker;

  /// 1. Deterministic local health calculator (no AI)
  Future<HealthSnapshot> computeHealthSnapshot(String userId) async {
    // A. Fetch profile
    final user = await (_db.select(_db.users)..where((t) => t.id.equals(userId))).getSingleOrNull();
    if (user == null) {
      throw Exception('User profile not found in local database for $userId');
    }

    final double weight = user.weight ?? 70.0;
    final double heightCm = user.height ?? 175.0;
    final int age = user.age ?? 30;
    final double heightM = heightCm / 100.0;
    
    // Compute BMI
    final double bmi = weight / (heightM * heightM);

    // Compute TDEE using Mifflin-St Jeor equation (moderate activity factor 1.375)
    final double baseMetabolism = (10 * weight) + (6.25 * heightCm) - (5 * age) + 5;
    final double tdee = baseMetabolism * 1.375;

    // Parse user goals
    final List<String> goalList = [];
    if (user.goals != null) {
      try {
        final decoded = jsonDecode(user.goals!);
        if (decoded is List) {
          goalList.addAll(decoded.map((e) => e.toString()));
        }
      } catch (_) {}
    }

    // Determine target offsets
    double calorieOffset = 0.0;
    double proteinFactor = 1.6;
    double hydrationOffset = 0.0;

    if (goalList.contains('lose_weight')) {
      calorieOffset = -500.0;
    } else if (goalList.contains('gain_muscle')) {
      calorieOffset = 300.0;
      proteinFactor = 2.0;
      hydrationOffset = 0.5;
    }

    final double calorieTarget = tdee + calorieOffset;
    final double proteinTarget = weight * proteinFactor;
    final double hydrationTarget = 2.5 + hydrationOffset;

    // Obese and Overweight joint overload step adjustments
    int stepTarget = 10000;
    if (bmi >= 30.0) {
      stepTarget = 7000;
    } else if (bmi >= 25.0) {
      stepTarget = 8500;
    }

    // B. Calculate 7-day average telemetry
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    
    // Water logs average
    final waterQuery = _db.select(_db.waterLogs)..where((t) => t.loggedAt.isBiggerThanValue(sevenDaysAgo));
    final waterLogs = await waterQuery.get();
    double avgWaterCups = 0.0;
    if (waterLogs.isNotEmpty) {
      final totalCups = waterLogs.fold<int>(0, (sum, item) => sum + item.cups);
      avgWaterCups = totalCups / 7.0;
    }

    // Local risks evaluation
    final List<String> risks = [];
    if (avgWaterCups < 5.0) {
      risks.add('Low hydration: averaging only ${avgWaterCups.toStringAsFixed(1)} cups of water per day.');
    }

    return HealthSnapshot(
      bmi: bmi,
      tdee: tdee,
      dailyCalorieTarget: calorieTarget,
      dailyProteinTargetG: proteinTarget,
      dailyHydrationTargetL: hydrationTarget,
      dailyStepTarget: stepTarget,
      avgSteps7Days: 8200.0, // Telemetry mock defaults
      avgSleepMinutes7Days: 460.0,
      avgWaterCups7Days: avgWaterCups,
      avgReadinessScore7Days: 78.0,
      avgHeartRate7Days: 72.0,
      localRisks: risks,
    );
  }

  /// 2. Check if expensive cloud AI call is needed
  bool checkAITrigger(HealthSnapshot snapshot) {
    // Regenerate daily intelligence if:
    // - Local risks exist (e.g. hydration drop alert)
    // - Readiness score is critically low (< 50)
    // - We want to trigger weekly program updates
    if (snapshot.localRisks.isNotEmpty) return true;
    if (snapshot.avgReadinessScore7Days < 50.0) return true;
    return false;
  }

  /// 3. DIP Generation & Storage with Sync Queue Integration
  Future<DailyIntelligencePackage> getOrGenerateDIP(String userId, {bool forceRegenerate = false}) async {
    final snapshot = await computeHealthSnapshot(userId);
    final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

    // Fetch latest package
    final latestPackage = await (_db.select(_db.dailyIntelligencePackages)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.packageDate, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();

    final isSameDay = latestPackage != null && 
        latestPackage.packageDate.year == todayStart.year &&
        latestPackage.packageDate.month == todayStart.month &&
        latestPackage.packageDate.day == todayStart.day;

    final triggerAI = checkAITrigger(snapshot) || forceRegenerate || latestPackage == null;

    if (isSameDay && !forceRegenerate) {
      return latestPackage;
    }

    DailyIntelligencePackage newPackage;

    if (triggerAI) {
      // Step A: Trigger Cloud/Local LLM representation
      final insight = _simulateAIInsight(snapshot);
      final packageId = 'dip_${DateTime.now().millisecondsSinceEpoch}';

      final companion = DailyIntelligencePackagesCompanion.insert(
        localId: packageId,
        userId: userId,
        packageDate: todayStart,
        primaryInsight: insight['primaryInsight']!,
        todaysMission: insight['todaysMission']!,
        nutritionFocus: 'Aim for ${snapshot.dailyProteinTargetG.round()}g of protein to fuel progressive recovery.',
        recoveryFocus: 'Sleep averages 7.6h. Keep a consistent bedtime routine.',
        motivationMessage: 'You are crushing your daily streaks. Let\'s continue standard gains!',
        adjustedCalories: snapshot.dailyCalorieTarget.round(),
        adjustedProtein: snapshot.dailyProteinTargetG.round(),
        adjustedHydrationL: snapshot.dailyHydrationTargetL,
        recommendedIntensity: snapshot.avgReadinessScore7Days < 60 ? 'low' : 'medium',
        isRestDay: Value(snapshot.avgReadinessScore7Days < 50),
        activeRisks: jsonEncode(snapshot.localRisks),
        showFestivalBanner: const Value(false),
        festivalAdaptation: const Value(null),
        dietBreakActive: const Value(false),
        proteinTimingTarget: const Value(25),
        loggingReliabilityStatus: const Value('high'),
        satietyTargetScore: const Value(70),
        aiCallsUsed: const Value(1),
        createdAt: DateTime.now(),
      );

      await _db.into(_db.dailyIntelligencePackages).insert(companion);
      newPackage = await (_db.select(_db.dailyIntelligencePackages)..where((t) => t.localId.equals(packageId))).getSingle();
    } else {
      // Step B: Reuse yesterday's insight text, updating only target numbers
      final packageId = 'dip_${DateTime.now().millisecondsSinceEpoch}';

      final companion = DailyIntelligencePackagesCompanion.insert(
        localId: packageId,
        userId: userId,
        packageDate: todayStart,
        primaryInsight: latestPackage.primaryInsight,
        todaysMission: latestPackage.todaysMission,
        nutritionFocus: 'Aim for ${snapshot.dailyProteinTargetG.round()}g of protein to fuel progressive recovery.',
        recoveryFocus: latestPackage.recoveryFocus,
        motivationMessage: latestPackage.motivationMessage,
        adjustedCalories: snapshot.dailyCalorieTarget.round(),
        adjustedProtein: snapshot.dailyProteinTargetG.round(),
        adjustedHydrationL: snapshot.dailyHydrationTargetL,
        recommendedIntensity: snapshot.avgReadinessScore7Days < 60 ? 'low' : 'medium',
        isRestDay: Value(snapshot.avgReadinessScore7Days < 50),
        activeRisks: jsonEncode(snapshot.localRisks),
        showFestivalBanner: Value(latestPackage.showFestivalBanner),
        festivalAdaptation: Value(latestPackage.festivalAdaptation),
        dietBreakActive: Value(latestPackage.dietBreakActive),
        proteinTimingTarget: Value(latestPackage.proteinTimingTarget),
        loggingReliabilityStatus: Value(latestPackage.loggingReliabilityStatus),
        satietyTargetScore: Value(latestPackage.satietyTargetScore),
        aiCallsUsed: const Value(0), // No AI call used (reused text)
        createdAt: DateTime.now(),
      );

      await _db.into(_db.dailyIntelligencePackages).insert(companion);
      newPackage = await (_db.select(_db.dailyIntelligencePackages)..where((t) => t.localId.equals(packageId))).getSingle();
    }

    // Step C: Queue local Drift write to sync worker queue
    final syncBatchId = 'dip_sync_${DateTime.now().millisecondsSinceEpoch}';
    await _db.into(_db.syncQueueItems).insert(
      SyncQueueItemsCompanion.insert(
        entityType: 'daily_intelligence_package',
        entityId: newPackage.localId,
        serializedPayload: jsonEncode({
          'localId': newPackage.localId,
          'userId': newPackage.userId,
          'packageDate': newPackage.packageDate.toIso8601String(),
          'primaryInsight': newPackage.primaryInsight,
          'todaysMission': newPackage.todaysMission,
          'nutritionFocus': newPackage.nutritionFocus,
          'recoveryFocus': newPackage.recoveryFocus,
          'motivationMessage': newPackage.motivationMessage,
          'adjustedCalories': newPackage.adjustedCalories,
          'adjustedProtein': newPackage.adjustedProtein,
          'adjustedHydrationL': newPackage.adjustedHydrationL,
          'recommendedIntensity': newPackage.recommendedIntensity,
          'isRestDay': newPackage.isRestDay,
          'activeRisks': newPackage.activeRisks,
          'showFestivalBanner': newPackage.showFestivalBanner,
          'festivalAdaptation': newPackage.festivalAdaptation,
          'dietBreakActive': newPackage.dietBreakActive,
          'proteinTimingTarget': newPackage.proteinTimingTarget,
          'loggingReliabilityStatus': newPackage.loggingReliabilityStatus,
          'satietyTargetScore': newPackage.satietyTargetScore,
          'aiCallsUsed': newPackage.aiCallsUsed,
        }),
        createdAt: DateTime.now(),
        syncBatchId: syncBatchId,
      ),
    );

    // Step D: Trigger worker sync execution
    _syncWorker.triggerSync();

    return newPackage;
  }

  Map<String, String> _simulateAIInsight(HealthSnapshot snapshot) {
    if (snapshot.localRisks.isNotEmpty) {
      return {
        'primaryInsight': 'Your telemetry points to critical dehydration. Prioritize rehydration to maintain metabolic pacing.',
        'todaysMission': 'Log 3 extra cups of water before noon.',
      };
    }
    return {
      'primaryInsight': 'Your readiness score of 78% indicates peak adaptation. Perfect time to perform a high-intensity push workout.',
      'todaysMission': 'Hit target protein macros and perform 1 compound workout.',
    };
  }
}
