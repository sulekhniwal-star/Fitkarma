import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/body_analytics_models.dart';
import '../domain/services/body_composition_engine.dart';
import '../domain/services/visual_comparison_engine.dart';

class BodyAnalyticsRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final BodyCompositionEngine compositionEngine;
  final VisualComparisonEngine comparisonEngine;

  BodyAnalyticsRepository({
    required this.db,
    required this.syncWorker,
    this.compositionEngine = const BodyCompositionEngine(),
    this.comparisonEngine = const VisualComparisonEngine(),
  });

  // ==========================================
  // 1. PROGRESS PHOTOS
  // ==========================================

  Future<void> saveProgressPhoto(ProgressPhotoEntry photo) async {
    await db.into(db.localProgressPhotos).insertOnConflictUpdate(
      LocalProgressPhotosCompanion(
        id: Value(photo.id),
        userId: Value(photo.userId),
        poseType: Value(photo.poseType.name),
        localFilePath: Value(photo.localFilePath),
        poseConfidence: Value(photo.poseConfidence),
        recordedAt: Value(photo.recordedAt),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'progress_photos',
      action: 'INSERT',
      payload: photo.toJson(),
    );
  }

  Stream<List<ProgressPhotoEntry>> watchProgressPhotos(String userId) {
    return (db.select(db.localProgressPhotos)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .watch()
        .map((rows) => rows
            .map((r) => ProgressPhotoEntry(
                  id: r.id,
                  userId: r.userId,
                  poseType: PhotoPoseType.values.firstWhere(
                    (p) => p.name == r.poseType,
                    orElse: () => PhotoPoseType.front,
                  ),
                  localFilePath: r.localFilePath,
                  poseConfidence: r.poseConfidence,
                  recordedAt: r.recordedAt,
                ))
            .toList());
  }

  // ==========================================
  // 2. BODY COMPOSITION SNAPSHOTS
  // ==========================================

  Future<void> saveBodyCompositionSnapshot(BodyCompositionEstimate snapshot) async {
    await db.into(db.localBodyCompositionSnapshots).insertOnConflictUpdate(
      LocalBodyCompositionSnapshotsCompanion(
        id: Value(snapshot.id),
        userId: Value(snapshot.userId),
        bodyFatPct: Value(snapshot.bodyFatPercent),
        leanMassKg: Value(snapshot.leanMassKg),
        fatMassKg: Value(snapshot.fatMassKg),
        totalWeightKg: Value(snapshot.totalWeightKg),
        waistToHeightRatio: Value(snapshot.waistToHeightRatio),
        ffmi: Value(snapshot.ffmi),
        insight: Value(snapshot.insight),
        insightHindi: Value(snapshot.insightHindi),
        calculatedAt: Value(snapshot.calculatedAt),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'body_composition_snapshots',
      action: 'INSERT',
      payload: snapshot.toJson(),
    );
  }

  Future<LocalBodyCompositionSnapshot?> getLatestCompositionSnapshot(String userId) async {
    return (db.select(db.localBodyCompositionSnapshots)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.calculatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<BodyCompositionEstimate>> watchCompositionSnapshots(String userId) {
    return (db.select(db.localBodyCompositionSnapshots)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.calculatedAt)]))
        .watch()
        .map((rows) => rows.map((r) {
              WhtrCategory whtrCat;
              if (r.waistToHeightRatio < 0.40) {
                whtrCat = WhtrCategory.takeCare;
              } else if (r.waistToHeightRatio <= 0.49) {
                whtrCat = WhtrCategory.healthy;
              } else if (r.waistToHeightRatio <= 0.59) {
                whtrCat = WhtrCategory.increasedRisk;
              } else {
                whtrCat = WhtrCategory.highRisk;
              }

              BodyFatCategory fatCat;
              if (r.bodyFatPct <= 13.0) {
                fatCat = BodyFatCategory.athletic;
              } else if (r.bodyFatPct <= 17.0) {
                fatCat = BodyFatCategory.fitness;
              } else if (r.bodyFatPct <= 24.0) {
                fatCat = BodyFatCategory.acceptable;
              } else {
                fatCat = BodyFatCategory.elevated;
              }

              return BodyCompositionEstimate(
                id: r.id,
                userId: r.userId,
                bodyFatPercent: r.bodyFatPct,
                category: fatCat,
                leanMassKg: r.leanMassKg,
                fatMassKg: r.fatMassKg,
                totalWeightKg: r.totalWeightKg,
                waistToHeightRatio: r.waistToHeightRatio,
                whtrCategory: whtrCat,
                ffmi: r.ffmi,
                insight: r.insight,
                insightHindi: r.insightHindi,
                calculatedAt: r.calculatedAt,
              );
            }).toList());
  }
}
