import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/life_event_models.dart';
import '../domain/services/festival_intelligence_engine.dart';
import '../domain/services/wedding_transformation_engine.dart';
import '../domain/services/ai_roast_engine.dart';
import '../domain/services/travel_intelligence_engine.dart';

class LifeEventsRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final FestivalIntelligenceEngine festivalEngine;
  final WeddingTransformationEngine weddingEngine;
  final AIRoastEngine roastEngine;
  final TravelIntelligenceEngine travelEngine;

  LifeEventsRepository({
    required this.db,
    required this.syncWorker,
    this.festivalEngine = const FestivalIntelligenceEngine(),
    this.weddingEngine = const WeddingTransformationEngine(),
    this.roastEngine = const AIRoastEngine(),
    this.travelEngine = const TravelIntelligenceEngine(),
  });

  // ==========================================
  // 1. ACTIVE LIFE EVENTS
  // ==========================================

  Future<void> saveActiveLifeEvent({
    required String id,
    required String userId,
    required LifeEventType eventType,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    Map<String, dynamic>? config,
  }) async {
    await db.into(db.localActiveLifeEvents).insertOnConflictUpdate(
      LocalActiveLifeEventsCompanion(
        id: Value(id),
        userId: Value(userId),
        eventType: Value(eventType.name),
        title: Value(title),
        startDate: Value(startDate),
        endDate: Value(endDate),
        configJson: Value(config != null ? jsonEncode(config) : null),
        createdAt: Value(DateTime.now()),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'active_life_events',
      action: 'INSERT',
      payload: {
        'id': id,
        'user_id': userId,
        'event_type': eventType.name,
        'title': title,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'config': config,
      },
    );
  }

  Future<List<LocalActiveLifeEvent>> getActiveEvents(String userId) async {
    return (db.select(db.localActiveLifeEvents)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .get();
  }

  // ==========================================
  // 2. WEDDING TRANSFORMATION PLANS
  // ==========================================

  Future<void> saveWeddingPlan(WeddingTransformationPlan plan) async {
    await db.into(db.localWeddingPlans).insertOnConflictUpdate(
      LocalWeddingPlansCompanion(
        id: Value(plan.id),
        userId: Value(plan.userId),
        weddingDate: Value(plan.weddingDate),
        targetWeightKg: Value(plan.targetWeightKg),
        targetWaistCm: Value(plan.targetWaistCm),
        currentPhase: Value(plan.currentPhaseName),
        currentPhaseHindi: Value(plan.currentPhaseNameHindi),
        createdAt: Value(DateTime.now()),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'wedding_transformation_plans',
      action: 'INSERT',
      payload: plan.toJson(),
    );
  }

  Future<LocalWeddingPlan?> getLatestWeddingPlan(String userId) async {
    return (db.select(db.localWeddingPlans)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }
}
