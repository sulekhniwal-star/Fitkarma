import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/advanced_intelligence/domain/models/advanced_intelligence_models.dart';
import 'package:fitkarma/features/advanced_intelligence/domain/services/adaptive_metabolism_engine.dart';
import 'package:fitkarma/features/advanced_intelligence/domain/services/longevity_score_engine.dart';
import 'package:fitkarma/features/advanced_intelligence/domain/services/environmental_intelligence_engine.dart';
import 'package:fitkarma/features/advanced_intelligence/data/advanced_intelligence_repository.dart';

void main() {
  group('Advanced Intelligence - AdaptiveMetabolismEngine Tests', () {
    const engine = AdaptiveMetabolismEngine();

    test('Computes BMR and identifies progressing state for consistent weight loss', () {
      final report = engine.calculateMetabolicAdaptation(
        id: 'rep-1',
        userId: 'user-1',
        weightKg: 80.0,
        heightCm: 178.0,
        age: 26,
        isMale: true,
        currentIntakeKcal: 1800,
        weightDeltaPast3WeeksKg: -1.5,
        weeksInDeficit: 3,
      );

      expect(report.baselineBmr, greaterThan(1700));
      expect(report.plateauStatus, equals(PlateauStatus.progressing));
      expect(report.recommendedRefeed, equals(RefeedType.none));
    });

    test('Identifies metabolic plateau and prescribes full caloric refeed', () {
      final report = engine.calculateMetabolicAdaptation(
        id: 'rep-2',
        userId: 'user-1',
        weightKg: 75.0,
        heightCm: 175.0,
        age: 30,
        isMale: true,
        currentIntakeKcal: 1500,
        weightDeltaPast3WeeksKg: 0.05,
        weeksInDeficit: 8,
      );

      expect(report.plateauStatus, equals(PlateauStatus.plateaued));
      expect(report.recommendedRefeed, equals(RefeedType.fullCaloricReset));
      expect(report.metabolicAdaptationFactor, lessThan(1.0));
      expect(report.strategyDescription, contains('refeed'));
    });
  });

  group('Advanced Intelligence - LongevityScoreEngine Tests', () {
    const engine = LongevityScoreEngine();

    test('Computes high Longevity Score and positive lifespan projection for healthy profile', () {
      final assessment = engine.computeLongevityScore(
        id: 'longevity-1',
        userId: 'user-1',
        restingHeartRate: 58.0,
        hrvRmssd: 65.0,
        fastingGlucoseMgDl: 88.0,
        systolicBp: 115.0,
        maxDesiBaithakReps: 55,
        weeklyActiveHours: 5.5,
        dailyPranayamaMinutes: 20,
      );

      expect(assessment.overallLongevityScore, greaterThanOrEqualTo(85));
      expect(assessment.projectedLifespanGainYears, greaterThan(5.0));
      expect(assessment.pillars.cardiometabolic, equals(100.0));
      expect(assessment.pillars.functionalStrength, equals(100.0));
    });

    test('Flags cardiometabolic stress and gives appropriate lever', () {
      final assessment = engine.computeLongevityScore(
        id: 'longevity-2',
        userId: 'user-2',
        restingHeartRate: 78.0,
        hrvRmssd: 25.0,
        fastingGlucoseMgDl: 132.0,
        systolicBp: 145.0,
        maxDesiBaithakReps: 12,
        weeklyActiveHours: 1.0,
        dailyPranayamaMinutes: 0,
      );

      expect(assessment.overallLongevityScore, lessThan(60));
      expect(assessment.primaryLongevityLever.isNotEmpty, isTrue);
    });
  });

  group('Advanced Intelligence - EnvironmentalIntelligenceEngine Tests', () {
    const engine = EnvironmentalIntelligenceEngine();

    test('Flags hazardous AQI (>200) and shifts workout indoors with Surya Namaskar', () {
      final plan = engine.generateEnvironmentalPlan(
        city: 'Delhi',
        aqi: 280,
        temperatureC: 32.0,
        humidityPercent: 70.0,
      );

      expect(plan.canExerciseOutdoors, isFalse);
      expect(plan.indoorSubstitutionWorkout, contains('Surya Namaskar'));
      expect(plan.aqiCategory, contains('Hazardous'));
    });

    test('Approves outdoor workout for good AQI', () {
      final plan = engine.generateEnvironmentalPlan(
        city: 'Bengaluru',
        aqi: 42,
        temperatureC: 24.0,
        humidityPercent: 55.0,
      );

      expect(plan.canExerciseOutdoors, isTrue);
      expect(plan.aqiCategory, contains('Good'));
    });
  });

  group('Advanced Intelligence - AdvancedIntelligenceRepository Integration Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker outbox;
    late AdvancedIntelligenceRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      outbox = OutboxSyncWorker(db: db, supabaseClient: null);
      repo = AdvancedIntelligenceRepository(
        db: db,
        syncWorker: outbox,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('Saves metabolic report and retrieves latest from Drift', () async {
      final report = AdaptiveMetabolismReport(
        id: 'met-1',
        userId: 'user-1',
        baselineBmr: 1720.0,
        estimatedTdee: 2200.0,
        currentCalorieTarget: 1700.0,
        metabolicAdaptationFactor: 0.93,
        plateauStatus: PlateauStatus.progressing,
        weeksStalled: 0,
        recommendedRefeed: RefeedType.none,
        strategyDescription: 'Maintain steady deficit',
        strategyDescriptionHindi: 'वर्तमान डाइट जारी रखें',
        calculatedAt: DateTime.now(),
      );

      await repo.saveMetabolicReport(report);
      final retrieved = await repo.getLatestMetabolicReport('user-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.estimatedTdee, equals(2200.0));
      expect(retrieved.plateauStatus, equals('progressing'));
    });

    test('Saves longevity assessment and retrieves latest from Drift', () async {
      final assessment = LongevityAssessment(
        id: 'long-1',
        userId: 'user-1',
        overallLongevityScore: 88,
        pillars: const LongevityPillars(
          cardiometabolic: 90.0,
          cellularRecovery: 85.0,
          functionalStrength: 90.0,
          lifestyleHabits: 85.0,
        ),
        projectedLifespanGainYears: 6.2,
        primaryLongevityLever: 'Anulom Vilom Pranayama',
        primaryLongevityLeverHindi: 'प्राणायाम',
        assessedAt: DateTime.now(),
      );

      await repo.saveLongevityAssessment(assessment);
      final retrieved = await repo.getLatestLongevityAssessment('user-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.overallScore, equals(88));
      expect(retrieved.projectedLifespanGainYears, equals(6.2));
    });
  });
}
