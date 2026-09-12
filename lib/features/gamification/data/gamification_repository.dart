import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/gamification_models.dart';
import '../domain/services/adherence_engine.dart';
import '../domain/services/cohort_benchmarking_engine.dart';
import '../domain/services/karma_engine.dart';

class GamificationRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final KarmaEngine karmaEngine;
  final AdherenceEngine adherenceEngine;
  final CohortBenchmarkingEngine cohortEngine;
  final _uuid = const Uuid();

  GamificationRepository({
    required this.db,
    required this.syncWorker,
    this.karmaEngine = const KarmaEngine(),
    this.adherenceEngine = const AdherenceEngine(),
    this.cohortEngine = const CohortBenchmarkingEngine(),
  });

  /// Award Karma points for an action, factoring in active streak bonus
  Future<KarmaTransaction> awardKarmaPoints({
    required String userId,
    required KarmaActionType actionType,
    required String description,
    required String descriptionHindi,
  }) async {
    // 1. Fetch current streak for daily_log
    final streak = await getStreak(userId: userId, habitType: 'daily_log');
    final currentStreakDays = streak?.currentStreak ?? 0;

    final points = karmaEngine.calculatePointsAwarded(
      action: actionType,
      currentStreakDays: currentStreakDays,
    );

    final transactionId = _uuid.v4();
    final now = DateTime.now();

    // 2. Insert to local Drift ledger
    await db.into(db.localKarmaPoints).insert(
          LocalKarmaPointsCompanion.insert(
            id: transactionId,
            userId: userId,
            points: points,
            actionType: actionType.name,
            description: description,
            earnedAt: now,
          ),
        );

    // 3. Queue Outbox mutation for Supabase
    await syncWorker.enqueueMutation(
      tableName: 'karma_points',
      action: 'INSERT',
      payload: {
        'id': transactionId,
        'user_id': userId,
        'points': points,
        'action_type': actionType.name,
        'description': description,
        'earned_at': now.toIso8601String(),
      },
    );

    // 4. Update streak
    await recordHabitActivity(userId: userId, habitType: 'daily_log');

    return KarmaTransaction(
      id: transactionId,
      userId: userId,
      points: points,
      actionType: actionType,
      description: description,
      descriptionHindi: descriptionHindi,
      earnedAt: now,
    );
  }

  /// Update habit streak
  Future<void> recordHabitActivity({
    required String userId,
    required String habitType,
  }) async {
    final now = DateTime.now();
    final existing = await getStreak(userId: userId, habitType: habitType);

    if (existing == null) {
      final id = _uuid.v4();
      await db.into(db.localHabitStreaks).insert(
            LocalHabitStreaksCompanion.insert(
              id: id,
              userId: userId,
              habitType: habitType,
              currentStreak: 1,
              longestStreak: 1,
              lastActiveDate: now,
            ),
          );
      return;
    }

    final diffDays = now.difference(existing.lastActiveDate).inDays;
    int newStreak = existing.currentStreak;

    if (diffDays == 1) {
      newStreak += 1;
    } else if (diffDays > 1) {
      newStreak = 1; // Streak broken
    }

    final longest = newStreak > existing.longestStreak ? newStreak : existing.longestStreak;

    await (db.update(db.localHabitStreaks)..where((t) => t.id.equals(existing.id))).write(
      LocalHabitStreaksCompanion(
        currentStreak: Value(newStreak),
        longestStreak: Value(longest),
        lastActiveDate: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  /// Query specific habit streak
  Future<LocalHabitStreak?> getStreak({
    required String userId,
    required String habitType,
  }) async {
    return (db.select(db.localHabitStreaks)
          ..where((t) => t.userId.equals(userId) & t.habitType.equals(habitType)))
        .getSingleOrNull();
  }

  /// Calculate total lifetime Karma points
  Future<int> getTotalKarmaPoints(String userId) async {
    final transactions = await (db.select(db.localKarmaPoints)..where((t) => t.userId.equals(userId))).get();
    int total = 0;
    for (final t in transactions) {
      total += t.points;
    }
    return total;
  }

  /// Get recent transactions
  Future<List<LocalKarmaPoint>> getRecentTransactions(String userId) async {
    return (db.select(db.localKarmaPoints)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.earnedAt, mode: OrderingMode.desc)])
          ..limit(20))
        .get();
  }
}
