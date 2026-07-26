import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:fitkarma/core/brain/adaptive_metabolism_engine.dart';
import 'package:fitkarma/core/database/app_database.dart' hide FoodLog;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AdaptiveMetabolismEngine engine;
  late AdaptiveMetabolismService service;

  setUp(() async {
    db = AppDatabase.executor(NativeDatabase.memory());
    engine = AdaptiveMetabolismEngine(baselineTDEE: 2200.0);
    service = AdaptiveMetabolismService(db, engine);

    // Seed default user
    await db
        .into(db.users)
        .insert(
          UsersCompanion.insert(
            id: 'user_met',
            name: const Value('Metabolism User'),
            email: const Value('met@fitkarma.com'),
            age: const Value(30),
            weight: const Value(80.0),
            height: const Value(180.0),
            dailyCalorieTarget: const Value(2000),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'AdaptiveMetabolismEngine calculates correct linear regression weight trends',
    () {
      final now = DateTime.now();
      // Simulate a user losing exactly 0.5 kg per week over 4 weeks
      final weighIns = [
        WeightReading(
          date: now.subtract(const Duration(days: 21)),
          weightKg: 80.0,
        ),
        WeightReading(
          date: now.subtract(const Duration(days: 14)),
          weightKg: 79.5,
        ),
        WeightReading(
          date: now.subtract(const Duration(days: 7)),
          weightKg: 79.0,
        ),
        WeightReading(date: now, weightKg: 78.5),
      ];

      final slope = engine.linearRegression(weighIns);
      // Slope should be -0.5 kg/week
      expect(slope, closeTo(-0.5, 0.05));
    },
  );

  test('AdaptiveMetabolismEngine recalibrates TDEE and detects adaptation', () {
    final now = DateTime.now();
    final weighIns = [
      WeightReading(
        date: now.subtract(const Duration(days: 21)),
        weightKg: 80.0,
      ),
      WeightReading(
        date: now.subtract(const Duration(days: 14)),
        weightKg: 79.9,
      ), // Under-performing (losing slowly)
      WeightReading(
        date: now.subtract(const Duration(days: 7)),
        weightKg: 79.8,
      ),
      WeightReading(date: now, weightKg: 79.7),
    ];

    // Log food intake averaging 1800 kcal/day
    final foodLogs = List.generate(28, (index) {
      return FoodLog(
        consumeTime: now.subtract(Duration(days: index)),
        calories: 1800.0,
        isComplete: true,
      );
    });

    // Recalibrate for target loss rate of -0.5 kg/week
    final result = engine.recalibrate(
      recentWeighIns: weighIns,
      recentFoodLogs: foodLogs,
      targetWeeklyDeltaKg: -0.5,
      currentCalorieTarget: 2000,
    );

    // Expected weight change is -0.5, actual is -0.1 kg/week
    // Implied daily delta kcal = -0.1 * 7700 / 7 = -110 kcal/day
    // Implied TDEE = 1800 - (-110) = 1910 kcal/day (metabolic slowing!)
    expect(result.impliedTDEE, 1910);

    // Target daily delta = -0.5 * 7700 / 7 = -550 kcal/day
    // New calorie target = 1910 - 550 = 1360 kcal/day
    expect(result.newCalorieTarget, 1360);
    expect(result.adherenceScore, 1.0);

    // Baseline is 2200. 1910 is < (2200 * 0.85 = 1870)? No, 1910 is not.
    // If we drop avg calories to 1600:
    // Implied TDEE = 1600 - (-110) = 1710. 1710 < 1870. So metabolic adaptation should trigger!
    final foodLogsAdapt = List.generate(28, (index) {
      return FoodLog(
        consumeTime: now.subtract(Duration(days: index)),
        calories: 1600.0,
        isComplete: true,
      );
    });

    final resultAdapt = engine.recalibrate(
      recentWeighIns: weighIns,
      recentFoodLogs: foodLogsAdapt,
      targetWeeklyDeltaKg: -0.5,
      currentCalorieTarget: 2000,
    );

    expect(resultAdapt.metabolicAdaptationDetected, isTrue);
  });

  test(
    'AdaptiveMetabolismService updates user dailyCalorieTarget in database',
    () async {
      final now = DateTime.now();
      final weighIns = [
        WeightReading(
          date: now.subtract(const Duration(days: 21)),
          weightKg: 80.0,
        ),
        WeightReading(
          date: now.subtract(const Duration(days: 14)),
          weightKg: 79.5,
        ),
        WeightReading(
          date: now.subtract(const Duration(days: 7)),
          weightKg: 79.0,
        ),
        WeightReading(date: now, weightKg: 78.5),
      ];

      final foodLogs = List.generate(28, (index) {
        return FoodLog(
          consumeTime: now.subtract(Duration(days: index)),
          calories: 2200.0,
          isComplete: true,
        );
      });

      // Run recalibration service
      final result = await service.runRecalibrationAndWire(
        userId: 'user_met',
        recentWeighIns: weighIns,
        recentFoodLogs: foodLogs,
        targetWeeklyDeltaKg: -0.5,
      );

      // Verify database was updated
      final user = await (db.select(
        db.users,
      )..where((t) => t.id.equals('user_met'))).getSingle();
      expect(user.dailyCalorieTarget, result.newCalorieTarget);
      expect(user.dailyCalorieTarget, isNotNull);
    },
  );
}
