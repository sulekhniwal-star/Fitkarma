import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/advanced_intelligence_models.dart';
import '../domain/services/adaptive_metabolism_engine.dart';
import '../domain/services/longevity_score_engine.dart';
import '../domain/services/environmental_intelligence_engine.dart';

class AdvancedIntelligenceRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final AdaptiveMetabolismEngine metabolismEngine;
  final LongevityScoreEngine longevityEngine;
  final EnvironmentalIntelligenceEngine environmentalEngine;

  AdvancedIntelligenceRepository({
    required this.db,
    required this.syncWorker,
    this.metabolismEngine = const AdaptiveMetabolismEngine(),
    this.longevityEngine = const LongevityScoreEngine(),
    this.environmentalEngine = const EnvironmentalIntelligenceEngine(),
  });

  // ==========================================
  // 1. ADAPTIVE METABOLISM
  // ==========================================

  Future<void> saveMetabolicReport(AdaptiveMetabolismReport report) async {
    await db.into(db.localMetabolicProfiles).insertOnConflictUpdate(
      LocalMetabolicProfilesCompanion(
        id: Value(report.id),
        userId: Value(report.userId),
        baselineBmr: Value(report.baselineBmr),
        estimatedTdee: Value(report.estimatedTdee),
        currentCalorieTarget: Value(report.currentCalorieTarget),
        adaptationFactor: Value(report.metabolicAdaptationFactor),
        plateauStatus: Value(report.plateauStatus.name),
        weeksStalled: Value(report.weeksStalled),
        strategy: Value(report.strategyDescription),
        calculatedAt: Value(report.calculatedAt),
        createdAt: Value(DateTime.now()),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'metabolic_profiles',
      action: 'INSERT',
      payload: report.toJson(),
    );
  }

  Future<LocalMetabolicProfile?> getLatestMetabolicReport(String userId) async {
    return (db.select(db.localMetabolicProfiles)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.calculatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  // ==========================================
  // 2. LONGEVITY ASSESSMENTS
  // ==========================================

  Future<void> saveLongevityAssessment(LongevityAssessment assessment) async {
    await db.into(db.localLongevityScores).insertOnConflictUpdate(
      LocalLongevityScoresCompanion(
        id: Value(assessment.id),
        userId: Value(assessment.userId),
        overallScore: Value(assessment.overallLongevityScore),
        cardiometabolicScore: Value(assessment.pillars.cardiometabolic),
        cellularRecoveryScore: Value(assessment.pillars.cellularRecovery),
        functionalStrengthScore: Value(assessment.pillars.functionalStrength),
        lifestyleScore: Value(assessment.pillars.lifestyleHabits),
        projectedLifespanGainYears: Value(assessment.projectedLifespanGainYears),
        primaryLever: Value(assessment.primaryLongevityLever),
        assessedAt: Value(assessment.assessedAt),
        createdAt: Value(DateTime.now()),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'longevity_assessments',
      action: 'INSERT',
      payload: assessment.toJson(),
    );
  }

  Future<LocalLongevityScore?> getLatestLongevityAssessment(String userId) async {
    return (db.select(db.localLongevityScores)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.assessedAt)])
          ..limit(1))
        .getSingleOrNull();
  }
}
