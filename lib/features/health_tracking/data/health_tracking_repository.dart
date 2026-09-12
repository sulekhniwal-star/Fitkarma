import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/health_models.dart';
import '../domain/services/preventive_intelligence_engine.dart';
import '../domain/services/wearable_comparison_engine.dart';

class HealthTrackingRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final PreventiveIntelligenceEngine preventiveEngine;
  final WearableComparisonEngine comparisonEngine;
  final _uuid = const Uuid();

  HealthTrackingRepository({
    required this.db,
    required this.syncWorker,
    this.preventiveEngine = const PreventiveIntelligenceEngine(),
    this.comparisonEngine = const WearableComparisonEngine(),
  });

  /// 1. Record single wearable metric sample (offline-first Drift -> Outbox)
  Future<void> recordWearableSample({
    required String userId,
    required String source,
    required String metric,
    required double value,
    required String unit,
    required DateTime timestamp,
  }) async {
    final sampleId = _uuid.v4();

    await db.into(db.localWearableSamples).insert(
          LocalWearableSamplesCompanion.insert(
            id: sampleId,
            userId: userId,
            source: source,
            metric: metric,
            value: value,
            unit: unit,
            timestamp: timestamp,
          ),
        );

    await syncWorker.enqueueMutation(
      tableName: 'wearable_samples',
      action: 'INSERT',
      payload: {
        'id': sampleId,
        'user_id': userId,
        'source': source,
        'metric': metric,
        'value': value,
        'unit': unit,
        'timestamp': timestamp.toIso8601String(),
      },
    );
  }

  /// 2. Record batch wearable samples
  Future<void> recordWearableSamplesBatch({
    required String userId,
    required List<WearableSample> samples,
  }) async {
    for (final sample in samples) {
      await recordWearableSample(
        userId: userId,
        source: sample.source,
        metric: sample.metric,
        value: sample.value,
        unit: sample.unit,
        timestamp: sample.timestamp,
      );
    }
  }

  /// 3. Get wearable samples from local DB
  Future<List<LocalWearableSample>> getWearableSamples({
    required String userId,
    String? metric,
    DateTime? since,
  }) async {
    final query = db.select(db.localWearableSamples)..where((t) => t.userId.equals(userId));

    if (metric != null) {
      query.where((t) => t.metric.equals(metric));
    }
    if (since != null) {
      query.where((t) => t.timestamp.isBiggerOrEqualValue(since));
    }

    query.orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]);
    return query.get();
  }

  /// 4. Record Biomarker Reading (BP, Glucose, HbA1c, Lipids)
  Future<void> recordBiomarkerReading({
    required String userId,
    required String source,
    required BiomarkerType type,
    required double primaryValue,
    double? secondaryValue,
    required String unit,
    String? note,
    required DateTime measuredAt,
  }) async {
    final biomarkerId = _uuid.v4();

    await db.into(db.localBiomarkers).insert(
          LocalBiomarkersCompanion.insert(
            id: biomarkerId,
            userId: userId,
            source: source,
            type: type.name,
            primaryValue: primaryValue,
            secondaryValue: Value(secondaryValue),
            unit: unit,
            note: Value(note),
            measuredAt: measuredAt,
          ),
        );

    await syncWorker.enqueueMutation(
      tableName: 'biomarkers',
      action: 'INSERT',
      payload: {
        'id': biomarkerId,
        'user_id': userId,
        'source': source,
        'type': type.name,
        'primary_value': primaryValue,
        'secondary_value': secondaryValue,
        'unit': unit,
        'note': note,
        'measured_at': measuredAt.toIso8601String(),
      },
    );
  }

  /// 5. Get Biomarkers from local DB
  Future<List<LocalBiomarker>> getBiomarkers({
    required String userId,
    BiomarkerType? type,
    DateTime? since,
  }) async {
    final query = db.select(db.localBiomarkers)..where((t) => t.userId.equals(userId));

    if (type != null) {
      query.where((t) => t.type.equals(type.name));
    }
    if (since != null) {
      query.where((t) => t.measuredAt.isBiggerOrEqualValue(since));
    }

    query.orderBy([(t) => OrderingTerm(expression: t.measuredAt, mode: OrderingMode.desc)]);
    return query.get();
  }

  /// 6. Record CGM continuous point
  Future<void> recordCgmTelemetryPoint({
    required String userId,
    required double glucoseMgDl,
    required String trendArrow,
    String? associatedMealId,
    required DateTime recordedAt,
  }) async {
    final cgmId = _uuid.v4();

    await db.into(db.localCgmTelemetry).insert(
          LocalCgmTelemetryCompanion.insert(
            id: cgmId,
            userId: userId,
            glucoseMgDl: glucoseMgDl,
            trendArrow: trendArrow,
            associatedMealId: Value(associatedMealId),
            recordedAt: recordedAt,
          ),
        );

    await syncWorker.enqueueMutation(
      tableName: 'cgm_telemetry',
      action: 'INSERT',
      payload: {
        'id': cgmId,
        'user_id': userId,
        'glucose_mg_dl': glucoseMgDl,
        'trend_arrow': trendArrow,
        'associated_meal_id': associatedMealId,
        'recorded_at': recordedAt.toIso8601String(),
      },
    );
  }

  /// 7. Get CGM telemetry points
  Future<List<LocalCgmTelemetryData>> getCgmTelemetry({
    required String userId,
    DateTime? since,
  }) async {
    final query = db.select(db.localCgmTelemetry)..where((t) => t.userId.equals(userId));

    if (since != null) {
      query.where((t) => t.recordedAt.isBiggerOrEqualValue(since));
    }

    query.orderBy([(t) => OrderingTerm(expression: t.recordedAt, mode: OrderingMode.asc)]);
    return query.get();
  }

  /// 8. Reconcile Steps for today
  Future<int> getReconciledDailySteps(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final localSamples = await getWearableSamples(
      userId: userId,
      metric: 'steps',
      since: startOfDay,
    );

    final samples = localSamples
        .map((s) => WearableSample(
              id: s.id,
              source: s.source,
              metric: s.metric,
              value: s.value,
              unit: s.unit,
              timestamp: s.timestamp,
            ))
        .toList();

    return comparisonEngine.calculateReconciledDailySteps(samples);
  }
}
