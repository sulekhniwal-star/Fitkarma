import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/life_events/domain/models/life_event_models.dart';
import 'package:fitkarma/features/life_events/domain/services/festival_intelligence_engine.dart';
import 'package:fitkarma/features/life_events/domain/services/wedding_transformation_engine.dart';
import 'package:fitkarma/features/life_events/domain/services/ai_roast_engine.dart';
import 'package:fitkarma/features/life_events/domain/services/travel_intelligence_engine.dart';
import 'package:fitkarma/features/life_events/data/life_events_repository.dart';

void main() {
  group('Life Events - FestivalIntelligenceEngine Tests', () {
    const engine = FestivalIntelligenceEngine();

    test('Returns full list of Indian festival protocols', () {
      final protocols = engine.getAllProtocols();
      expect(protocols.length, greaterThanOrEqualTo(3));
      final navratri = protocols.firstWhere((p) => p.id == 'fest_navratri');
      expect(navratri.fastingRules.isNotEmpty, isTrue);
      expect(navratri.nutritionGuidelines.any((g) => g.contains('Kuttu') || g.contains('Singhara')), isTrue);
    });

    test('Diwali protocol contains feast buffer and mithai control', () {
      final protocols = engine.getAllProtocols();
      final diwali = protocols.firstWhere((p) => p.id == 'fest_diwali');
      expect(diwali.nameHindi.isNotEmpty, isTrue);
      expect(diwali.feastBufferAdvice.isNotEmpty, isTrue);
    });
  });

  group('Life Events - WeddingTransformationEngine Tests', () {
    const engine = WeddingTransformationEngine();

    test('Generates Phase 2 plan for 6 weeks out', () {
      final weddingDate = DateTime.now().add(const Duration(days: 42));
      final plan = engine.createWeddingPlan(
        id: 'plan-1',
        userId: 'test-user',
        weddingDate: weddingDate,
        currentWeightKg: 78.0,
        targetWeightKg: 72.0,
        currentWaistCm: 90.0,
        targetWaistCm: 82.0,
      );

      expect(plan.daysRemaining, inInclusiveRange(41, 43));
      expect(plan.currentPhaseName, contains('Phase 2'));
      expect(plan.weeklyMilestones.length, greaterThanOrEqualTo(2));
    });

    test('Generates Phase 4 Peak Week plan for 5 days out', () {
      final weddingDate = DateTime.now().add(const Duration(days: 5));
      final plan = engine.createWeddingPlan(
        id: 'plan-2',
        userId: 'test-user',
        weddingDate: weddingDate,
        currentWeightKg: 74.0,
        targetWeightKg: 72.0,
        currentWaistCm: 84.0,
        targetWaistCm: 82.0,
      );

      expect(plan.currentPhaseName, contains('Peak Week'));
    });
  });

  group('Life Events - AIRoastEngine Tests', () {
    const engine = AIRoastEngine();

    test('Generates savage roast for missed steps with Sharma Ji reference', () {
      final roast = engine.generateRoast(
        triggerType: 'missed_steps',
        intensity: RoastIntensity.savage,
        userName: 'Vikram',
      );

      expect(roast.headline, contains('Sharma Ji'));
      expect(roast.body, contains('Vikram'));
      expect(roast.punchline.isNotEmpty, isTrue);
      expect(roast.bodyHindi.isNotEmpty, isTrue);
    });

    test('Generates roast for Swiggy midnight binge', () {
      final roast = engine.generateRoast(
        triggerType: 'swiggy_binge',
        intensity: RoastIntensity.spicy,
        userName: 'Pooja',
      );

      expect(roast.headline, contains('Biryani'));
      expect(roast.body, contains('Pooja'));
    });
  });

  group('Life Events - TravelIntelligenceEngine Tests', () {
    const engine = TravelIntelligenceEngine();

    test('Returns hotel room HIIT and Surya Namaskar when hotel gym is false', () {
      final plan = engine.createTravelPlan(
        destination: 'Mumbai',
        tripDurationDays: 3,
        hasHotelGym: false,
      );

      expect(plan.hotelWorkouts.any((w) => w.contains('Surya Namaskar')), isTrue);
      expect(plan.digestionChecklist.any((d) => d.contains('Ajwain') || d.contains('Jeera')), isTrue);
      expect(plan.hydrationStrategy.isNotEmpty, isTrue);
    });

    test('Returns DB complex workout when hotel gym is true', () {
      final plan = engine.createTravelPlan(
        destination: 'London',
        tripDurationDays: 5,
        hasHotelGym: true,
      );

      expect(plan.hotelWorkouts.any((w) => w.contains('Dumbbell')), isTrue);
    });
  });

  group('Life Events - LifeEventsRepository Integration Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker outbox;
    late LifeEventsRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      outbox = OutboxSyncWorker(db: db, supabaseClient: null);
      repo = LifeEventsRepository(
        db: db,
        syncWorker: outbox,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('Saves active life event and retrieves from Drift', () async {
      await repo.saveActiveLifeEvent(
        id: 'event-1',
        userId: 'user-1',
        eventType: LifeEventType.weddingPrep,
        title: 'Shaadi Season Transformation',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 60)),
        config: {'target_garment': 'Sherwani'},
      );

      final events = await repo.getActiveEvents('user-1');
      expect(events.length, equals(1));
      expect(events.first.title, equals('Shaadi Season Transformation'));
      expect(events.first.eventType, equals('weddingPrep'));
    });

    test('Saves wedding plan and retrieves latest from Drift', () async {
      final plan = WeddingTransformationPlan(
        id: 'plan-1',
        userId: 'user-1',
        weddingDate: DateTime.now().add(const Duration(days: 60)),
        daysRemaining: 60,
        baselineWeightKg: 78.0,
        targetWeightKg: 70.0,
        baselineWaistCm: 88.0,
        targetWaistCm: 80.0,
        currentPhaseName: 'Phase 1: Metabolic Foundation',
        currentPhaseNameHindi: 'चरण १',
        weeklyMilestones: ['Establish calorie deficit'],
      );

      await repo.saveWeddingPlan(plan);
      final retrieved = await repo.getLatestWeddingPlan('user-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.targetWeightKg, equals(70.0));
      expect(retrieved.currentPhase, contains('Phase 1'));
    });
  });
}
