import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/gamification/data/gamification_repository.dart';
import 'package:fitkarma/features/gamification/domain/models/gamification_models.dart';
import 'package:fitkarma/features/gamification/domain/services/adherence_engine.dart';
import 'package:fitkarma/features/gamification/domain/services/cohort_benchmarking_engine.dart';
import 'package:fitkarma/features/gamification/domain/services/karma_engine.dart';

void main() {
  group('KarmaEngine Tests', () {
    const engine = KarmaEngine();

    test('Base points match activity definitions', () {
      expect(engine.getBasePoints(KarmaActionType.workoutCompleted), 50);
      expect(engine.getBasePoints(KarmaActionType.mealLogged), 20);
      expect(engine.getBasePoints(KarmaActionType.stepsTargetHit), 30);
      expect(engine.getBasePoints(KarmaActionType.sleepTargetMet), 25);
      expect(engine.getBasePoints(KarmaActionType.fastingGoalCompleted), 40);
    });

    test('Streak multiplier rewards continuous daily consistency', () {
      expect(engine.getStreakMultiplier(0), 1.0);
      expect(engine.getStreakMultiplier(3), 1.10);
      expect(engine.getStreakMultiplier(7), 1.25);
      expect(engine.getStreakMultiplier(14), 1.50);

      final awarded = engine.calculatePointsAwarded(
        action: KarmaActionType.workoutCompleted,
        currentStreakDays: 7,
      );
      expect(awarded, 63);
    });

    test('Karma Tier calculation resolves proper Yogi designations', () {
      expect(engine.getTierInfo(200).tier, KarmaTier.novice);
      expect(engine.getTierInfo(800).tier, KarmaTier.sadhak);
      expect(engine.getTierInfo(2400).tier, KarmaTier.abhyasi);
      expect(engine.getTierInfo(4500).tier, KarmaTier.yogi);
      expect(engine.getTierInfo(8500).tier, KarmaTier.guru);
    });
  });

  group('AdherenceEngine Tests', () {
    const engine = AdherenceEngine();

    test('Full compliance across 4 pillars returns 100 overall adherence score', () {
      final adherence = engine.calculateWeeklyAdherence(
        mealsLoggedThisWeek: 21,
        workoutsCompletedThisWeek: 4,
        stepTargetDaysMetThisWeek: 5,
        sleepTargetDaysMetThisWeek: 6,
      );

      expect(adherence.overallScore, 100);
      expect(adherence.summary, contains('Elite Adherence'));
    });

    test('Partial compliance returns accurate weighted score and summary', () {
      final adherence = engine.calculateWeeklyAdherence(
        mealsLoggedThisWeek: 14,
        workoutsCompletedThisWeek: 3,
        stepTargetDaysMetThisWeek: 4,
        sleepTargetDaysMetThisWeek: 4,
      );

      expect(adherence.overallScore, greaterThan(60));
      expect(adherence.overallScore, lessThan(85));
      expect(adherence.summary, contains('Solid Adherence'));
    });
  });

  group('CohortBenchmarkingEngine Tests', () {
    const engine = CohortBenchmarkingEngine();

    test('Derives correct demographic cohort name and percentile metrics', () {
      final benchmark = engine.evaluateCohortPercentiles(
        age: 28,
        gender: 'male',
        weeklyTonnageKg: 14000,
        averageDailySteps: 8500,
        adherenceScore: 85,
      );

      expect(benchmark.cohortName, 'Indian Males 25–34');
      expect(benchmark.volumePercentile, greaterThan(80.0));
      expect(benchmark.stepsPercentile, greaterThan(70.0));
      expect(benchmark.insight.isNotEmpty, isTrue);
    });
  });

  group('GamificationRepository Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late GamificationRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db, supabaseClient: null);
      repository = GamificationRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      await db.close();
    });

    test('awardKarmaPoints saves ledger entry, updates streak, and queues Outbox mutation', () async {
      final tx = await repository.awardKarmaPoints(
        userId: 'user_gamer_1',
        actionType: KarmaActionType.workoutCompleted,
        description: 'Heavy Push Day Completed',
        descriptionHindi: 'पुश डे पूरा हुआ',
      );

      expect(tx.points, 50);

      final total = await repository.getTotalKarmaPoints('user_gamer_1');
      expect(total, 50);

      final streak = await repository.getStreak(userId: 'user_gamer_1', habitType: 'daily_log');
      expect(streak, isNotNull);
      expect(streak!.currentStreak, 1);

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'karma_points'), isTrue);
    });
  });
}
