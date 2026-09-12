import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/visual_body_analytics/domain/models/body_analytics_models.dart';
import 'package:fitkarma/features/visual_body_analytics/domain/services/body_composition_engine.dart';
import 'package:fitkarma/features/visual_body_analytics/domain/services/visual_comparison_engine.dart';
import 'package:fitkarma/features/visual_body_analytics/data/body_analytics_repository.dart';

void main() {
  group('BodyCompositionEngine Tests', () {
    const engine = BodyCompositionEngine();

    test('Male Navy formula estimates realistic body fat % and lean mass', () {
      final comp = engine.estimateComposition(
        id: 'comp-1',
        userId: 'u1',
        gender: 'male',
        heightCm: 175.0,
        weightKg: 75.0,
        neckCircumferenceCm: 38.0,
        waistCircumferenceCm: 80.0,
        calculatedAt: DateTime.now(),
      );

      expect(comp.bodyFatPercent, greaterThan(10.0));
      expect(comp.bodyFatPercent, lessThan(18.0));
      expect(comp.leanMassKg, greaterThan(60.0));
      expect(comp.waistToHeightRatio, closeTo(0.46, 0.01));
      expect(comp.whtrCategory, equals(WhtrCategory.healthy));
    });

    test('Female Navy formula factors in hip circumference accurately', () {
      final comp = engine.estimateComposition(
        id: 'comp-2',
        userId: 'u2',
        gender: 'female',
        heightCm: 162.0,
        weightKg: 58.0,
        neckCircumferenceCm: 32.0,
        waistCircumferenceCm: 68.0,
        hipCircumferenceCm: 92.0,
        calculatedAt: DateTime.now(),
      );

      expect(comp.bodyFatPercent, greaterThan(18.0));
      expect(comp.bodyFatPercent, lessThan(26.0));
      expect(comp.category, isNot(BodyFatCategory.elevated));
      expect(comp.whtrCategory, equals(WhtrCategory.healthy));
    });

    test('Waist-to-Height Ratio >= 0.50 flags central adiposity risk', () {
      final comp = engine.estimateComposition(
        id: 'comp-3',
        userId: 'u3',
        gender: 'male',
        heightCm: 170.0,
        weightKg: 85.0,
        neckCircumferenceCm: 37.0,
        waistCircumferenceCm: 92.0, // 92 / 170 = 0.54
        calculatedAt: DateTime.now(),
      );

      expect(comp.waistToHeightRatio, greaterThanOrEqualTo(0.50));
      expect(comp.whtrCategory, equals(WhtrCategory.increasedRisk));
      expect(comp.insight, contains('central adiposity'));
    });
  });

  group('VisualComparisonEngine Tests', () {
    const engine = VisualComparisonEngine();

    test('comparePhotos computes deltas and day difference', () {
      final baseline = ProgressPhotoEntry(
        id: 'p1',
        userId: 'u1',
        poseType: PhotoPoseType.front,
        localFilePath: '/path/baseline.jpg',
        poseConfidence: 0.95,
        recordedAt: DateTime(2026, 1, 1),
      );

      final latest = ProgressPhotoEntry(
        id: 'p2',
        userId: 'u1',
        poseType: PhotoPoseType.front,
        localFilePath: '/path/latest.jpg',
        poseConfidence: 0.98,
        recordedAt: DateTime(2026, 3, 2), // 60 days
      );

      final comp = engine.comparePhotos(
        baseline: baseline,
        latest: latest,
        baselineWeightKg: 80.0,
        latestWeightKg: 75.0,
        baselineBodyFatPct: 22.0,
        latestBodyFatPct: 16.5,
        baselineWaistCm: 88.0,
        latestWaistCm: 82.0,
      );

      expect(comp.daysApart, equals(60));
      expect(comp.weightDeltaKg, equals(-5.0));
      expect(comp.bodyFatDeltaPct, equals(-5.5));
      expect(comp.waistDeltaCm, equals(-6.0));
    });
  });

  group('BodyAnalyticsRepository Integration Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late BodyAnalyticsRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db, supabaseClient: null);
      repo = BodyAnalyticsRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveProgressPhoto stores locally & queues outbox mutation', () async {
      final photo = ProgressPhotoEntry(
        id: 'photo-101',
        userId: 'u1',
        poseType: PhotoPoseType.front,
        localFilePath: '/storage/photo1.jpg',
        poseConfidence: 0.94,
        recordedAt: DateTime.now(),
      );

      await repo.saveProgressPhoto(photo);

      final photos = await db.select(db.localProgressPhotos).get();
      expect(photos.length, equals(1));
      expect(photos.first.poseType, equals('front'));

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'progress_photos'), isTrue);
    });

    test('saveBodyCompositionSnapshot stores locally & queues outbox mutation', () async {
      final snapshot = BodyCompositionEstimate(
        id: 'snap-1',
        userId: 'u1',
        bodyFatPercent: 14.5,
        category: BodyFatCategory.fitness,
        leanMassKg: 64.0,
        fatMassKg: 11.0,
        totalWeightKg: 75.0,
        waistToHeightRatio: 0.46,
        whtrCategory: WhtrCategory.healthy,
        ffmi: 21.2,
        insight: 'Great composition',
        insightHindi: 'उत्कृष्ट संरचना',
        calculatedAt: DateTime.now(),
      );

      await repo.saveBodyCompositionSnapshot(snapshot);

      final latest = await repo.getLatestCompositionSnapshot('u1');
      expect(latest, isNotNull);
      expect(latest!.bodyFatPct, equals(14.5));
      expect(latest.ffmi, equals(21.2));

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'body_composition_snapshots'), isTrue);
    });
  });
}
