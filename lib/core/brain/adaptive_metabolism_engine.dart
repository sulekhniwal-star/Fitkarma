import 'package:drift/drift.dart';
import 'package:fitkarma/core/database/app_database.dart';

enum CalibrationConfidence { low, medium, high }

class WeightReading {
  WeightReading({required this.date, required this.weightKg});

  final DateTime date;
  final double weightKg;
}

class FoodLog {
  FoodLog({
    required this.consumeTime,
    required this.calories,
    this.isComplete = true,
  });

  final DateTime consumeTime;
  final double calories;
  final bool isComplete;
}

class AdaptiveCalibrationResult {
  AdaptiveCalibrationResult({
    required this.previousCalorieTarget,
    required this.newCalorieTarget,
    required this.impliedTDEE,
    required this.actualWeeklyDeltaKg,
    required this.targetWeeklyDeltaKg,
    required this.adherenceScore,
    required this.metabolicAdaptationDetected,
    required this.calibrationDate,
    required this.confidenceLevel,
    this.isInsufficientData = false,
  });

  factory AdaptiveCalibrationResult.insufficientData() {
    return AdaptiveCalibrationResult(
      previousCalorieTarget: 0,
      newCalorieTarget: 0,
      impliedTDEE: 0,
      actualWeeklyDeltaKg: 0.0,
      targetWeeklyDeltaKg: 0.0,
      adherenceScore: 0.0,
      metabolicAdaptationDetected: false,
      calibrationDate: DateTime.now(),
      confidenceLevel: CalibrationConfidence.low,
      isInsufficientData: true,
    );
  }

  final int previousCalorieTarget;
  final int newCalorieTarget;
  final int impliedTDEE;
  final double actualWeeklyDeltaKg;
  final double targetWeeklyDeltaKg;
  final double adherenceScore;
  final bool metabolicAdaptationDetected;
  final DateTime calibrationDate;
  final CalibrationConfidence confidenceLevel;
  final bool isInsufficientData;
}

class AdaptiveMetabolismEngine {
  AdaptiveMetabolismEngine({this.baselineTDEE = 2000.0});

  final double baselineTDEE;

  /// Called weekly by the Health OS Brain to recalculate metabolic changes.
  AdaptiveCalibrationResult recalibrate({
    required List<WeightReading> recentWeighIns, // last 4 weeks
    required List<FoodLog> recentFoodLogs, // last 4 weeks
    required double targetWeeklyDeltaKg, // user's goal rate
    required int currentCalorieTarget,
  }) {
    if (recentWeighIns.length < 2) {
      return AdaptiveCalibrationResult.insufficientData();
    }

    // Step 1: Compute actual weekly weight change (linear regression over 4 weeks with rolling median)
    final actualWeeklyDeltaKg = linearRegression(recentWeighIns);

    // Step 2: Compute average daily calories consumed
    final avgCaloriesConsumed = avgDailyCalories(recentFoodLogs);

    // Step 3: Compute implied actual TDEE
    // actual_delta_kg/week * 7700 kcal/kg = weekly caloric delta
    // TDEE_implied = calories_consumed - (actual_delta * 7700 / 7)
    final actualDailyDeltaKcal = actualWeeklyDeltaKg * 7700 / 7;
    final impliedTDEE = avgCaloriesConsumed - actualDailyDeltaKcal;

    // Step 4: Compute new calorie target
    final targetDailyDeltaKcal = targetWeeklyDeltaKg * 7700 / 7;
    final newCalorieTarget = (impliedTDEE + targetDailyDeltaKcal).round();

    // Step 5: Adherence score (logging days over 28-day window)
    final loggingDays = recentFoodLogs
        .where((l) => l.isComplete)
        .map(
          (l) =>
              '${l.consumeTime.year}-${l.consumeTime.month}-${l.consumeTime.day}',
        )
        .toSet()
        .length;
    final adherence = loggingDays / 28.0;

    // Step 6: Detect metabolic adaptation
    // If TDEE dropped >15% below baseline (adaptive thermogenesis)
    final metabolicAdaptation = impliedTDEE < (baselineTDEE * 0.85);

    return AdaptiveCalibrationResult(
      previousCalorieTarget: currentCalorieTarget,
      newCalorieTarget: newCalorieTarget.clamp(1200, 4000),
      impliedTDEE: impliedTDEE.round(),
      actualWeeklyDeltaKg: actualWeeklyDeltaKg,
      targetWeeklyDeltaKg: targetWeeklyDeltaKg,
      adherenceScore: adherence,
      metabolicAdaptationDetected: metabolicAdaptation,
      calibrationDate: DateTime.now(),
      confidenceLevel: _confidence(adherence, recentWeighIns.length),
    );
  }

  double linearRegression(List<WeightReading> readings) {
    if (readings.length < 2) return 0.0;

    // Sort readings chronologically
    final sorted = List<WeightReading>.from(readings)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Step 1: Apply 7-day rolling median smoothing to filter water-weight noise
    final smoothed = <double>[];
    for (int i = 0; i < sorted.length; i++) {
      final current = sorted[i];
      final window = sorted
          .where((r) {
            final difference = current.date.difference(r.date).inDays.abs();
            return difference <= 6;
          })
          .map((r) => r.weightKg)
          .toList();

      window.sort();
      final median = window[window.length ~/ 2];
      smoothed.add(median);
    }

    // Step 2: Compute least-squares linear regression slope (kg per week)
    final firstDate = sorted.first.date;
    final times = sorted
        .map((r) => r.date.difference(firstDate).inDays / 7.0)
        .toList();

    double sumX = 0;
    double sumY = 0;
    double sumXY = 0;
    double sumXX = 0;
    final n = sorted.length;

    for (int i = 0; i < n; i++) {
      final x = times[i];
      final y = smoothed[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumXX += x * x;
    }

    final denominator = (n * sumXX) - (sumX * sumX);
    if (denominator == 0) return 0.0;

    final slopeKgPerWeek = ((n * sumXY) - (sumX * sumY)) / denominator;
    return slopeKgPerWeek;
  }

  double avgDailyCalories(List<FoodLog> logs) {
    if (logs.isEmpty) return 2000.0;

    final dailyCalories = <String, double>{};
    for (final log in logs) {
      final key =
          '${log.consumeTime.year}-${log.consumeTime.month}-${log.consumeTime.day}';
      dailyCalories[key] = (dailyCalories[key] ?? 0.0) + log.calories;
    }

    final totalCalories = dailyCalories.values.fold<double>(
      0.0,
      (sum, val) => sum + val,
    );
    return totalCalories / dailyCalories.length;
  }

  CalibrationConfidence _confidence(double adherence, int weighIns) {
    if (adherence > 0.85 && weighIns >= 4) return CalibrationConfidence.high;
    if (adherence > 0.60 && weighIns >= 2) return CalibrationConfidence.medium;
    return CalibrationConfidence.low;
  }
}

class AdaptiveMetabolismService {
  AdaptiveMetabolismService(this._db, this._engine);

  final AppDatabase _db;
  final AdaptiveMetabolismEngine _engine;

  /// Performs the TDEE recalibration and saves the new dailyCalorieTarget in SQLite.
  Future<AdaptiveCalibrationResult> runRecalibrationAndWire({
    required String userId,
    required List<WeightReading> recentWeighIns,
    required List<FoodLog> recentFoodLogs,
    required double targetWeeklyDeltaKg,
  }) async {
    final user = await (_db.select(
      _db.users,
    )..where((t) => t.id.equals(userId))).getSingleOrNull();
    if (user == null) {
      throw Exception('User profile not found');
    }

    final currentTarget = user.dailyCalorieTarget ?? 2000;

    final result = _engine.recalibrate(
      recentWeighIns: recentWeighIns,
      recentFoodLogs: recentFoodLogs,
      targetWeeklyDeltaKg: targetWeeklyDeltaKg,
      currentCalorieTarget: currentTarget,
    );

    if (!result.isInsufficientData) {
      await (_db.update(_db.users)..where((t) => t.id.equals(userId))).write(
        UsersCompanion(dailyCalorieTarget: Value(result.newCalorieTarget)),
      );
    }

    return result;
  }
}
