import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/monetisation/domain/models/monetisation_models.dart';
import 'package:fitkarma/features/monetisation/domain/services/entitlement_engine.dart';
import 'package:fitkarma/features/monetisation/domain/services/coach_marketplace_engine.dart';
import 'package:fitkarma/features/monetisation/domain/services/affiliate_engine.dart';
import 'package:fitkarma/features/monetisation/data/monetisation_repository.dart';

void main() {
  group('Monetisation - EntitlementEngine Tests', () {
    const engine = EntitlementEngine();

    test('Free tier allows daily missions but restricts CGM and Doctor Dossier', () {
      final entitlement = UserEntitlement(
        id: 'ent-1',
        userId: 'user-free',
        tier: AppSubscriptionTier.free,
        source: 'revenuecat',
        isActive: true,
        createdAt: DateTime.now(),
      );

      expect(engine.canAccessFeature(entitlement: entitlement, featureKey: 'daily_mission'), isTrue);
      expect(engine.canAccessFeature(entitlement: entitlement, featureKey: 'cgm_telemetry_graphs'), isFalse);
      expect(engine.canAccessFeature(entitlement: entitlement, featureKey: 'doctor_dossier_pdf'), isFalse);
    });

    test('Pro tier allows CGM, Biological Age, and Doctor Dossier', () {
      final entitlement = UserEntitlement(
        id: 'ent-2',
        userId: 'user-pro',
        tier: AppSubscriptionTier.pro,
        source: 'razorpay',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        createdAt: DateTime.now(),
      );

      expect(engine.canAccessFeature(entitlement: entitlement, featureKey: 'cgm_telemetry_graphs'), isTrue);
      expect(engine.canAccessFeature(entitlement: entitlement, featureKey: 'biological_age_calculator'), isTrue);
      expect(engine.canAccessFeature(entitlement: entitlement, featureKey: 'daily_mission'), isTrue);
    });

    test('Expired Pro entitlement falls back to Free tier access only', () {
      final expiredEntitlement = UserEntitlement(
        id: 'ent-3',
        userId: 'user-expired',
        tier: AppSubscriptionTier.pro,
        source: 'revenuecat',
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      );

      expect(engine.canAccessFeature(entitlement: expiredEntitlement, featureKey: 'cgm_telemetry_graphs'), isFalse);
      expect(engine.canAccessFeature(entitlement: expiredEntitlement, featureKey: 'daily_mission'), isTrue);
    });
  });

  group('Monetisation - CoachMarketplaceEngine Tests', () {
    const engine = CoachMarketplaceEngine();

    test('Returns verified Indian coaches list', () {
      final coaches = engine.getAllVerifiedCoaches();
      expect(coaches.length, greaterThanOrEqualTo(4));
      expect(coaches.any((c) => c.specialty == CoachSpecialty.pcosRemission), isTrue);
      expect(coaches.any((c) => c.specialty == CoachSpecialty.ayurvedicStrength), isTrue);
    });

    test('Filters coaches by specialty', () {
      final pcosCoaches = engine.filterCoaches(specialty: CoachSpecialty.pcosRemission);
      expect(pcosCoaches.length, equals(1));
      expect(pcosCoaches.first.name, contains('Ananya'));
    });

    test('Filters coaches by language', () {
      final punjabiCoaches = engine.filterCoaches(language: 'Punjabi');
      expect(punjabiCoaches.length, equals(1));
      expect(punjabiCoaches.first.name, contains('Priya'));
    });
  });

  group('Monetisation - AffiliateEngine Tests', () {
    const engine = AffiliateEngine();

    test('Generates branded Yogi referral code', () {
      final code = engine.generateReferralCode('Raghavendra');
      expect(code, equals('YOGI-RAGH'));
    });

    test('Calculates Pro subscription referral reward', () {
      final referral = engine.processReferral(
        id: 'ref-1',
        referrerId: 'user-1',
        referralCode: 'YOGI-VIKR',
        refereeUserId: 'user-2',
        purchasedTier: AppSubscriptionTier.pro,
      );

      expect(referral.karmaReward, equals(500));
      expect(referral.commissionInr, equals(200));
      expect(referral.referralCode, equals('YOGI-VIKR'));
    });

    test('Calculates Elite subscription referral reward', () {
      final referral = engine.processReferral(
        id: 'ref-2',
        referrerId: 'user-1',
        referralCode: 'YOGI-VIKR',
        refereeUserId: 'user-3',
        purchasedTier: AppSubscriptionTier.elite,
      );

      expect(referral.karmaReward, equals(1500));
      expect(referral.commissionInr, equals(500));
    });
  });

  group('Monetisation - MonetisationRepository Integration Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker outbox;
    late MonetisationRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      outbox = OutboxSyncWorker(db: db, supabaseClient: null);
      repo = MonetisationRepository(
        db: db,
        syncWorker: outbox,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('Saves entitlement and retrieves active entitlement', () async {
      final ent = UserEntitlement(
        id: 'ent-1',
        userId: 'user-1',
        tier: AppSubscriptionTier.pro,
        source: 'revenuecat',
        expiresAt: DateTime.now().add(const Duration(days: 365)),
        isActive: true,
        createdAt: DateTime.now(),
      );

      await repo.saveEntitlement(ent);
      final retrieved = await repo.getActiveEntitlement('user-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.tier, equals('pro'));
      expect(retrieved.isActive, isTrue);
    });

    test('Saves coach profile and books consultation with Outbox sync', () async {
      const coach = CoachProfile(
        id: 'coach_demo',
        name: 'Dr. Ramesh Gupta',
        title: 'Ayurvedic Practitioner',
        specialty: CoachSpecialty.ayurvedicStrength,
        bio: 'Strength and longevity specialist',
        languages: ['Hindi', 'English'],
        rating: 4.90,
        reviewCount: 45,
        hourlyRateInr: 1200,
      );

      await repo.saveCoachProfile(coach);
      final coaches = await repo.getAllCachedCoaches();
      expect(coaches.length, equals(1));
      expect(coaches.first.name, equals('Dr. Ramesh Gupta'));

      final booking = CoachBooking(
        id: 'booking-1',
        userId: 'user-1',
        coachId: 'coach_demo',
        scheduledAt: DateTime.now().add(const Duration(days: 2)),
        status: BookingStatus.confirmed,
        amountInr: 1200,
        createdAt: DateTime.now(),
      );

      await repo.bookCoachConsultation(booking);
      final userBookings = await repo.getUserBookings('user-1');
      expect(userBookings.length, equals(1));
      expect(userBookings.first.amountInr, equals(1200));
      expect(userBookings.first.status, equals('confirmed'));
    });

    test('Saves affiliate referral and queries by referrer', () async {
      final ref = AffiliateReferral(
        id: 'ref-1',
        referrerId: 'user-10',
        referralCode: 'YOGI-TEST',
        refereeUserId: 'user-20',
        karmaReward: 500,
        commissionInr: 200,
        createdAt: DateTime.now(),
      );

      await repo.saveAffiliateReferral(ref);
      final referrals = await repo.getReferralsByReferrer('user-10');
      expect(referrals.length, equals(1));
      expect(referrals.first.commissionInr, equals(200));
      expect(referrals.first.karmaReward, equals(500));
    });
  });
}
