import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/monetisation_models.dart';
import '../domain/services/entitlement_engine.dart';
import '../domain/services/coach_marketplace_engine.dart';
import '../domain/services/affiliate_engine.dart';

class MonetisationRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final EntitlementEngine entitlementEngine;
  final CoachMarketplaceEngine coachEngine;
  final AffiliateEngine affiliateEngine;

  MonetisationRepository({
    required this.db,
    required this.syncWorker,
    this.entitlementEngine = const EntitlementEngine(),
    this.coachEngine = const CoachMarketplaceEngine(),
    this.affiliateEngine = const AffiliateEngine(),
  });

  // ==========================================
  // 1. ENTITLEMENTS
  // ==========================================

  Future<void> saveEntitlement(UserEntitlement entitlement) async {
    await db.into(db.localEntitlements).insertOnConflictUpdate(
      LocalEntitlementsCompanion(
        id: Value(entitlement.id),
        userId: Value(entitlement.userId),
        tier: Value(entitlement.tier.name),
        source: Value(entitlement.source),
        expiresAt: Value(entitlement.expiresAt),
        isActive: Value(entitlement.isActive),
        createdAt: Value(entitlement.createdAt),
      ),
    );
  }

  Future<LocalEntitlement?> getActiveEntitlement(String userId) async {
    return (db.select(db.localEntitlements)
          ..where((t) => t.userId.equals(userId) & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  // ==========================================
  // 2. COACH MARKETPLACE
  // ==========================================

  Future<void> saveCoachProfile(CoachProfile coach) async {
    await db.into(db.localCoachProfiles).insertOnConflictUpdate(
      LocalCoachProfilesCompanion(
        id: Value(coach.id),
        name: Value(coach.name),
        title: Value(coach.title),
        specialty: Value(coach.specialty.name),
        bio: Value(coach.bio),
        languagesJson: Value(jsonEncode(coach.languages)),
        rating: Value(coach.rating),
        reviewCount: Value(coach.reviewCount),
        hourlyRateInr: Value(coach.hourlyRateInr),
        avatarUrl: Value(coach.avatarUrl),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<LocalCoachProfile>> getAllCachedCoaches() async {
    return (db.select(db.localCoachProfiles)
          ..orderBy([(t) => OrderingTerm.desc(t.rating)]))
        .get();
  }

  Future<void> bookCoachConsultation(CoachBooking booking) async {
    await db.into(db.localCoachBookings).insertOnConflictUpdate(
      LocalCoachBookingsCompanion(
        id: Value(booking.id),
        userId: Value(booking.userId),
        coachId: Value(booking.coachId),
        scheduledAt: Value(booking.scheduledAt),
        status: Value(booking.status.name),
        amountInr: Value(booking.amountInr),
        createdAt: Value(booking.createdAt),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'coach_bookings',
      action: 'INSERT',
      payload: booking.toJson(),
    );
  }

  Future<List<LocalCoachBooking>> getUserBookings(String userId) async {
    return (db.select(db.localCoachBookings)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
        .get();
  }

  // ==========================================
  // 3. AFFILIATES
  // ==========================================

  Future<void> saveAffiliateReferral(AffiliateReferral referral) async {
    await db.into(db.localAffiliateReferrals).insertOnConflictUpdate(
      LocalAffiliateReferralsCompanion(
        id: Value(referral.id),
        referrerId: Value(referral.referrerId),
        referralCode: Value(referral.referralCode),
        refereeUserId: Value(referral.refereeUserId),
        karmaReward: Value(referral.karmaReward),
        commissionInr: Value(referral.commissionInr),
        createdAt: Value(referral.createdAt),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'affiliate_referrals',
      action: 'INSERT',
      payload: referral.toJson(),
    );
  }

  Future<List<LocalAffiliateReferral>> getReferralsByReferrer(String referrerId) async {
    return (db.select(db.localAffiliateReferrals)
          ..where((t) => t.referrerId.equals(referrerId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }
}
