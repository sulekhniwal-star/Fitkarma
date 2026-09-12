import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/metabolism/services/metabolism_engine.dart';
import 'package:fitkarma/features/onboarding/data/onboarding_repository.dart';
import 'package:fitkarma/features/onboarding/domain/models/onboarding_state.dart';
import 'package:fitkarma/features/onboarding/domain/services/bmi_calculator.dart';
import 'package:fitkarma/features/onboarding/domain/services/dosha_scoring_engine.dart';
import 'package:fitkarma/features/onboarding/domain/services/womens_health_engine.dart';

void main() {
  group('BMICalculator (Asian-Indian Specific Cutoffs)', () {
    const calculator = BMICalculator();

    test('Classifies 23.5 BMI as Overweight for Asian-Indians (Normal is <=22.9)', () {
      // 1.70m, 68kg => BMI = 68 / (1.7 * 1.7) = 23.529 => Overweight (Asian-Indian standard)
      final result = calculator.calculate(heightCm: 170.0, weightKg: 68.0);
      expect(result.category, equals(BMICategory.overweight));
      expect(result.bmi, equals(23.5));
      expect(result.idealWeightMaxKg, lessThan(68.0));
    });

    test('Classifies 21.0 BMI as Optimal Normal', () {
      // 1.75m, 64kg => BMI = 64 / (1.75 * 1.75) = 20.89 => Optimal
      final result = calculator.calculate(heightCm: 175.0, weightKg: 64.0);
      expect(result.category, equals(BMICategory.normal));
      expect(result.label, contains('Optimal'));
    });
  });

  group('DoshaScoringEngine (Ayurvedic Assessment)', () {
    const engine = DoshaScoringEngine();

    test('Calculates Pitta dominance when Pitta score is highest', () {
      final profile = engine.calculateDosha(
        vataPoints: 10,
        pittaPoints: 30,
        kaphaPoints: 10,
      );

      expect(profile.dominantDosha, equals(DoshaType.pitta));
      expect(profile.pittaPercent, equals(60.0));
      expect(profile.title, contains('Pitta Dominant'));
      expect(profile.dietaryGuidance.first, contains('cooling foods'));
    });

    test('Calculates Tridoshic when scores are evenly balanced', () {
      final profile = engine.calculateDosha(
        vataPoints: 20,
        pittaPoints: 20,
        kaphaPoints: 20,
      );

      expect(profile.dominantDosha, equals(DoshaType.tridoshic));
      expect(profile.title, contains('Tridoshic'));
    });
  });

  group('WomensHealthEngine (Cycle & PCOS)', () {
    const engine = WomensHealthEngine();

    test('Identifies Follicular phase on Day 8 with strength overload guidance', () {
      final profile = engine.evaluateCycle(
        cycleLengthDays: 28,
        currentCycleDay: 8,
        hasPCOS: false,
      );

      expect(profile.currentPhase, equals(CyclePhase.follicular));
      expect(profile.trainingRecommendation, contains('progressive overload'));
    });

    test('Appends PCOS insulin sensitivity modifier when PCOS is enabled', () {
      final profile = engine.evaluateCycle(
        cycleLengthDays: 32,
        currentCycleDay: 18,
        hasPCOS: true,
      );

      expect(profile.hasPCOS, isTrue);
      expect(profile.nutritionRecommendation, contains('PCOS Calibrator'));
    });
  });

  group('OnboardingRepository (Offline Persistence & Outbox)', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late OnboardingRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db);
      repo = OnboardingRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      syncWorker.dispose();
      await db.close();
    });

    test('saveCompleteOnboarding writes profile, dosha, and cycle tracking to local Drift and queues outbox mutations', () async {
      const doshaEngine = DoshaScoringEngine();
      final doshaProfile = doshaEngine.calculateDosha(
        vataPoints: 10,
        pittaPoints: 30,
        kaphaPoints: 10,
      );

      const womensEngine = WomensHealthEngine();
      final cycleProfile = womensEngine.evaluateCycle(
        cycleLengthDays: 28,
        currentCycleDay: 9,
        hasPCOS: false,
      );

      final state = OnboardingState(
        age: 27,
        gender: Gender.female,
        heightCm: 165.0,
        weightKg: 60.0,
        goal: Goal.fatLoss,
        doshaProfile: doshaProfile,
        enableWomensHealth: true,
        cycleProfile: cycleProfile,
      );

      await repo.saveCompleteOnboarding(
        userId: 'test-user-p1',
        state: state,
      );

      // Verify Local Profile
      final profile = await (db.select(db.localProfiles)..where((t) => t.userId.equals('test-user-p1'))).getSingle();
      expect(profile.age, equals(27));
      expect(profile.gender, equals('female'));

      // Verify Local Dosha
      final dosha = await (db.select(db.localDoshaScores)..where((t) => t.userId.equals('test-user-p1'))).getSingle();
      expect(dosha.dominantDosha, equals('pitta'));

      // Verify Local Cycle Tracking
      final cycle = await (db.select(db.localCycleTracking)..where((t) => t.userId.equals('test-user-p1'))).getSingle();
      expect(cycle.currentPhase, equals('follicular'));

      // Verify Outbox Queue has 3 mutations: profiles, dosha_scores, cycle_tracking
      final mutations = await db.select(db.pendingMutations).get();
      expect(mutations.length, equals(3));
      expect(mutations.map((m) => m.targetTable), containsAll(['profiles', 'dosha_scores', 'cycle_tracking']));
    });
  });
}
