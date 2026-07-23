import 'package:drift/drift.dart';
import 'package:fitkarma/core/ai/ai_router.dart';
import 'package:fitkarma/core/database/app_database.dart';

class RuleEngine {
  RuleEngine(this._db);

  final AppDatabase _db;

  /// Inspects local DB states and returns a deterministic alert if thresholds are violated
  Future<String?> tryHandle(AIRequest request) async {
    if (request.complexity != AIComplexity.dailyInsight) return null;

    final user = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(request.userId))).getSingleOrNull();
    if (user == null) return null;

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Evaluate hydration deficit rule using the actual Drift cups column
    final waterLogs = await (_db.select(
      _db.waterLogs,
    )..where((t) => t.loggedAt.isBiggerThanValue(todayStart))).get();

    final totalCups = waterLogs.fold<int>(0, (sum, item) => sum + item.cups);

    if (DateTime.now().hour >= 15 && totalCups < 4) {
      return "HYDRATION WARNING: It is past 3:00 PM and you have logged only $totalCups cups of water today. Drink 2 cups now to prevent afternoon energy slumps.";
    }

    return null;
  }
}
