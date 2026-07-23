import 'package:drift/drift.dart';
import 'package:fitkarma/core/ai/ai_router.dart';
import 'package:fitkarma/core/database/app_database.dart';

class InsightTemplateEngine {
  InsightTemplateEngine(this._db);

  final AppDatabase _db;

  /// Selects and interpolates parameterized templates based on local telemetry
  Future<String?> tryHandle(AIRequest request) async {
    if (request.complexity != AIComplexity.dailyInsight) return null;

    final user = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(request.userId))).getSingleOrNull();
    if (user == null) return null;

    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));

    // Water logs average
    final waterLogs = await (_db.select(
      _db.waterLogs,
    )..where((t) => t.loggedAt.isBiggerThanValue(sevenDaysAgo))).get();

    double avgWaterCups = 0.0;
    if (waterLogs.isNotEmpty) {
      final totalCups = waterLogs.fold<int>(0, (sum, item) => sum + item.cups);
      avgWaterCups = totalCups / 7.0;
    }

    // Hydration warnings rotation
    if (avgWaterCups < 6.0) {
      final templates = [
        "Your hydration levels are tracking below average (${avgWaterCups.toStringAsFixed(1)} cups/day vs target of 8 cups). Drink a glass of warm water now to boost alertness.",
        "Hydration gap: you averaged ${avgWaterCups.toStringAsFixed(1)} cups this week. Keep a water bottle at your work desk to remind yourself to sip regularly.",
        "Boosting water intake (averaging ${avgWaterCups.toStringAsFixed(1)} cups vs target of 8) will help with mental clarity and physical energy pacing.",
      ];
      return templates[today.day % templates.length];
    }

    // Default template rotation to prevent fatigue
    final templates = [
      "Your consistency is your superpower. Stay aligned with your calorie budgets and daily step targets today.",
      "Stay active! Small choices like taking the stairs instead of the elevator aggregate into massive health score gains.",
      "Consistency is tracking well. Prioritize sleep and recovery tonight to prep for a progressive overload session tomorrow.",
    ];
    return templates[today.day % templates.length];
  }
}
