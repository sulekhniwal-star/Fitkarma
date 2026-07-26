import 'package:drift/drift.dart';
import 'package:fitkarma/core/brain/health_os_brain.dart';
import 'package:fitkarma/core/brain/health_snapshot.dart';
import 'package:fitkarma/core/database/app_database.dart' hide HealthSnapshot;

class AIContext {
  AIContext({
    required this.name,
    required this.goals,
    required this.program,
    required this.dietType,
    required this.tone,
    required this.injuries,
    required this.snapshot,
    required this.readinessScore,
    required this.primaryConcern,
    this.weather,
    this.festival,
  });

  final String name;
  final String goals; // e.g. JSON list or string
  final String program; // e.g. active program
  final String dietType; // e.g. Veg, Non-veg
  final String tone; // e.g. gentle, motivational, roast, no_nonsense
  final String injuries; // e.g. knee pain
  final HealthSnapshot snapshot;
  final int readinessScore;
  final String primaryConcern;
  final String? weather;
  final String? festival;

  /// Compresses the context to a prompt payload string under a token budget.
  /// Standard word/token approximation: ~4 characters per token.
  String toPromptPayload({int tokenBudget = 500}) {
    String buildPayload({bool compress = false}) {
      final buffer = StringBuffer();
      buffer.writeln("Name: $name");
      buffer.writeln("Goals: $goals");
      if (!compress) {
        buffer.writeln("Program: $program");
        buffer.writeln("Diet: $dietType");
        buffer.writeln("Injuries: $injuries");
      }
      buffer.writeln("Tone: $tone");
      buffer.writeln("Readiness: $readinessScore");
      buffer.writeln("Concern: $primaryConcern");

      if (weather != null && !compress) {
        buffer.writeln("Weather: $weather");
      }
      if (festival != null && !compress) {
        buffer.writeln("Festival: $festival");
      }

      // Health Snapshot
      buffer.writeln("BMI: ${snapshot.bmi.toStringAsFixed(1)}");
      buffer.writeln("TDEE: ${snapshot.tdee.round()}");
      buffer.writeln("Cal Target: ${snapshot.dailyCalorieTarget.round()}");
      buffer.writeln(
        "Protein Target: ${snapshot.dailyProteinTargetG.round()}g",
      );
      buffer.writeln(
        "Hydration Target: ${snapshot.dailyHydrationTargetL.toStringAsFixed(1)}L",
      );
      buffer.writeln("Step Target: ${snapshot.dailyStepTarget}");

      // 7-day trends
      buffer.writeln("Avg Steps: ${snapshot.avgSteps7Days.round()}");
      buffer.writeln("Avg Sleep: ${snapshot.avgSleepMinutes7Days.round()}m");
      buffer.writeln(
        "Avg Water: ${snapshot.avgWaterCups7Days.toStringAsFixed(1)} cups",
      );
      buffer.writeln(
        "Avg Readiness: ${snapshot.avgReadinessScore7Days.round()}",
      );
      buffer.writeln("Avg HR: ${snapshot.avgHeartRate7Days.round()}");

      // Local risks
      if (snapshot.localRisks.isNotEmpty) {
        final risks = compress
            ? snapshot.localRisks.take(1)
            : snapshot.localRisks;
        buffer.writeln("Risks: ${risks.join('; ')}");
      }

      return buffer.toString().trim();
    }

    String payload = buildPayload(compress: false);
    int estimatedTokens = (payload.length / 4).round();

    if (estimatedTokens > tokenBudget) {
      // Exceeds budget, perform compression
      payload = buildPayload(compress: true);
      estimatedTokens = (payload.length / 4).round();

      // If still exceeding, perform aggressive truncation
      if (estimatedTokens > tokenBudget) {
        const suffix = "... [truncated]";
        final allowedChars = (tokenBudget * 4) - suffix.length;
        if (allowedChars > 0 && allowedChars < payload.length) {
          payload = payload.substring(0, allowedChars) + suffix;
        } else {
          payload = suffix;
        }
      }
    }

    return payload;
  }
}

class AIContextBuilder {
  AIContextBuilder(this._db, this._healthOSBrain);

  final AppDatabase _db;
  final HealthOSBrain _healthOSBrain;

  Future<AIContext> buildCompressed(
    String userId, {
    String? weather,
    String? festival,
  }) async {
    final user = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(userId))).getSingleOrNull();
    if (user == null) {
      throw Exception("User not found: $userId");
    }

    final snapshot = await _healthOSBrain.computeHealthSnapshot(userId);

    // Fetch latest DIP
    final dip =
        await (_db.select(_db.dailyIntelligencePackages)
              ..where((t) => t.userId.equals(userId))
              ..orderBy([(t) => OrderingTerm.desc(t.packageDate)])
              ..limit(1))
            .getSingleOrNull();

    final readinessScore = dip?.adjustedCalories != null
        ? (snapshot.avgReadinessScore7Days.round())
        : 75;

    final primaryConcern = snapshot.localRisks.isNotEmpty
        ? snapshot.localRisks.first
        : "None";

    // Fallback/Parse values
    final name = user.name ?? "User";
    final goals = user.goals ?? "[]";
    final program = user.currentProgram ?? "Standard program";
    final dietType = "Veg/Indian";
    final tone = "motivational";
    final injuries = "None";

    return AIContext(
      name: name,
      goals: goals,
      program: program,
      dietType: dietType,
      tone: tone,
      injuries: injuries,
      snapshot: snapshot,
      readinessScore: readinessScore,
      primaryConcern: primaryConcern,
      weather: weather,
      festival: festival,
    );
  }
}
