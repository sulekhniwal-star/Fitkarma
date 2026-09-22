import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../main.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../health_tracking/data/health_tracking_repository.dart';
import '../../../metabolism/services/metabolism_engine.dart';
import '../../../nutrition/data/nutrition_repository.dart';
import '../../../readiness_engine/data/readiness_repository.dart';
import '../../../readiness_engine/domain/services/readiness_calculation_engine.dart';
import '../../../workout/data/workout_repository.dart';

/// Active User ID Provider (authenticated Supabase user or fallback local user)
final activeUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id ?? 'local-user-demo-1';
});

/// Repositories
final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncWorker = ref.watch(outboxSyncWorkerProvider);
  return NutritionRepository(db: db, syncWorker: syncWorker);
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncWorker = ref.watch(outboxSyncWorkerProvider);
  return WorkoutRepository(db: db, syncWorker: syncWorker);
});

final healthTrackingRepositoryProvider = Provider<HealthTrackingRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncWorker = ref.watch(outboxSyncWorkerProvider);
  return HealthTrackingRepository(db: db, syncWorker: syncWorker);
});

final readinessCalculationEngineProvider = Provider<ReadinessCalculationEngine>((ref) {
  return const ReadinessCalculationEngine();
});

final readinessRepositoryProvider = Provider<ReadinessRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncWorker = ref.watch(outboxSyncWorkerProvider);
  final engine = ref.watch(readinessCalculationEngineProvider);
  return ReadinessRepository(db: db, syncWorker: syncWorker, engine: engine);
});

/// Reactive Stream of User's Local Profile
final userProfileStreamProvider = StreamProvider<LocalProfile?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);
  return (db.select(db.localProfiles)..where((t) => t.userId.equals(userId))).watchSingleOrNull();
});

/// Reactive Stream of Today's Logged Meals
final todayMealsStreamProvider = StreamProvider<List<LocalMeal>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);

  return (db.select(db.localMeals)
        ..where((t) => t.userId.equals(userId) & t.loggedAt.isBiggerOrEqualValue(startOfDay))
        ..orderBy([(t) => OrderingTerm(expression: t.loggedAt, mode: OrderingMode.desc)]))
      .watch();
});

/// Reactive Stream of Today's Logged Workouts
final todayWorkoutsStreamProvider = StreamProvider<List<LocalWorkoutSession>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);

  return (db.select(db.localWorkoutSessions)
        ..where((t) => t.userId.equals(userId) & t.startedAt.isBiggerOrEqualValue(startOfDay))
        ..orderBy([(t) => OrderingTerm(expression: t.startedAt, mode: OrderingMode.desc)]))
      .watch();
});

/// Reactive Stream of Today's Wearable Step Samples
final todayWearableSamplesStreamProvider = StreamProvider<List<LocalWearableSample>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);

  return (db.select(db.localWearableSamples)
        ..where((t) => t.userId.equals(userId) & t.timestamp.isBiggerOrEqualValue(startOfDay))
        ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
      .watch();
});

/// Reactive Stream of Latest Readiness Score
final latestReadinessStreamProvider = StreamProvider<LocalReadinessScore?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(activeUserIdProvider);

  return (db.select(db.localReadinessScores)
        ..where((t) => t.userId.equals(userId))
        ..orderBy([(t) => OrderingTerm(expression: t.calculatedAt, mode: OrderingMode.desc)])
        ..limit(1))
      .watchSingleOrNull();
});

/// Aggregated Live Dashboard State Model
class DashboardState {
  final double targetCalories;
  final double consumedCalories;
  final double burnedCalories;
  final double targetProteinGrams;
  final double consumedProteinGrams;
  final double targetCarbsGrams;
  final double consumedCarbsGrams;
  final double targetFatsGrams;
  final double consumedFatsGrams;
  final int todaySteps;
  final int stepGoal;
  final int workoutDurationMinutes;
  final int workoutTargetMinutes;
  final double totalVolumeTonnageKg;
  final int? readinessScore;
  final String readinessLabel;
  final String readinessHindiLabel;
  final String readinessSubtitle;
  final int mealsLoggedCount;
  final int workoutsLoggedCount;
  final List<LocalMeal> recentMeals;
  final List<LocalWorkoutSession> recentWorkouts;

  const DashboardState({
    required this.targetCalories,
    required this.consumedCalories,
    required this.burnedCalories,
    required this.targetProteinGrams,
    required this.consumedProteinGrams,
    required this.targetCarbsGrams,
    required this.consumedCarbsGrams,
    required this.targetFatsGrams,
    required this.consumedFatsGrams,
    required this.todaySteps,
    required this.stepGoal,
    required this.workoutDurationMinutes,
    required this.workoutTargetMinutes,
    required this.totalVolumeTonnageKg,
    this.readinessScore,
    required this.readinessLabel,
    required this.readinessHindiLabel,
    required this.readinessSubtitle,
    required this.mealsLoggedCount,
    required this.workoutsLoggedCount,
    required this.recentMeals,
    required this.recentWorkouts,
  });

  double get caloriesRingProgress =>
      targetCalories > 0 ? (consumedCalories / targetCalories).clamp(0.0, 1.0) : 0.0;

  double get workoutRingProgress =>
      workoutTargetMinutes > 0 ? (workoutDurationMinutes / workoutTargetMinutes).clamp(0.0, 1.0) : 0.0;

  double get stepsRingProgress =>
      stepGoal > 0 ? (todaySteps / stepGoal).clamp(0.0, 1.0) : 0.0;

  double get remainingCalories => (targetCalories - consumedCalories);
}

/// Aggregated Live Dashboard Provider
final dashboardStateProvider = Provider<DashboardState>((ref) {
  final profileAsync = ref.watch(userProfileStreamProvider);
  final mealsAsync = ref.watch(todayMealsStreamProvider);
  final workoutsAsync = ref.watch(todayWorkoutsStreamProvider);
  final wearablesAsync = ref.watch(todayWearableSamplesStreamProvider);
  final readinessAsync = ref.watch(latestReadinessStreamProvider);
  final metabolismEngine = ref.watch(metabolismEngineProvider);

  // 1. Calculate profile & targets
  final profile = profileAsync.value;
  final weight = profile?.weightKg ?? 72.0;
  final height = profile?.heightCm ?? 175.0;
  final age = profile?.age ?? 28;
  final gender = profile?.gender == 'female' ? Gender.female : Gender.male;

  final metaTarget = metabolismEngine.calculateProfile(
    weightKg: weight,
    heightCm: height,
    age: age,
    gender: gender,
    activityLevel: ActivityLevel.moderate,
    goal: Goal.fatLoss,
  );

  // 2. Aggregate Today's Meals
  final meals = mealsAsync.value ?? [];
  double consumedCals = 0;
  double consumedProtein = 0;
  double consumedCarbs = 0;
  double consumedFats = 0;

  for (final m in meals) {
    consumedCals += m.caloriesKcal;
    consumedProtein += m.proteinGrams;
    consumedCarbs += m.carbsGrams;
    consumedFats += m.fatGrams;
  }

  // 3. Aggregate Today's Workouts
  final workouts = workoutsAsync.value ?? [];
  int workoutSeconds = 0;
  double totalVolumeKg = 0;

  for (final w in workouts) {
    workoutSeconds += w.durationSeconds;
    totalVolumeKg += w.totalVolumeKg;
  }
  final workoutMinutes = (workoutSeconds / 60).round();
  final burnedCalories = workoutMinutes * 7.5; // ~7.5 kcal/min moderate-high training

  // 4. Aggregate Today's Steps
  final samples = wearablesAsync.value ?? [];
  int steps = 0;
  for (final s in samples) {
    if (s.metric == 'steps') {
      steps += s.value.toInt();
    }
  }

  // 5. Readiness Info
  final latestReadiness = readinessAsync.value;
  int? score = latestReadiness?.score;
  String readinessLabel;
  String readinessHindiLabel;
  String readinessSubtitle;

  if (score != null) {
    if (score >= 85) {
      readinessLabel = 'Prime';
      readinessHindiLabel = 'सर्वोत्तम';
      readinessSubtitle = 'Optimal autonomic balance. Prime for high-intensity output.';
    } else if (score >= 70) {
      readinessLabel = 'Productive';
      readinessHindiLabel = 'उत्पादक';
      readinessSubtitle = 'Good physiological capacity. Moderate to high volume recommended.';
    } else if (score >= 50) {
      readinessLabel = 'Moderate';
      readinessHindiLabel = 'मध्यम';
      readinessSubtitle = 'System is recovering. Prioritize technique & steady aerobic work.';
    } else {
      readinessLabel = 'Recovery';
      readinessHindiLabel = 'विश्राम';
      readinessSubtitle = 'High systemic strain detected. Active recovery & Pranayama advised.';
    }
  } else {
    readinessLabel = 'Check-in Needed';
    readinessHindiLabel = 'चेक-इन आवश्यक';
    readinessSubtitle = 'Complete your morning recovery ritual to compute today\'s score.';
  }

  return DashboardState(
    targetCalories: metaTarget.targetCalories,
    consumedCalories: consumedCals,
    burnedCalories: burnedCalories,
    targetProteinGrams: metaTarget.targetProteinGrams,
    consumedProteinGrams: consumedProtein,
    targetCarbsGrams: metaTarget.targetCarbsGrams,
    consumedCarbsGrams: consumedCarbs,
    targetFatsGrams: metaTarget.targetFatsGrams,
    consumedFatsGrams: consumedFats,
    todaySteps: steps,
    stepGoal: 10000,
    workoutDurationMinutes: workoutMinutes,
    workoutTargetMinutes: 45,
    totalVolumeTonnageKg: totalVolumeKg,
    readinessScore: score,
    readinessLabel: readinessLabel,
    readinessHindiLabel: readinessHindiLabel,
    readinessSubtitle: readinessSubtitle,
    mealsLoggedCount: meals.length,
    workoutsLoggedCount: workouts.length,
    recentMeals: meals,
    recentWorkouts: workouts,
  );
});
