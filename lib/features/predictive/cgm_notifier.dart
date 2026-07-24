/// §P10-H Continuous Biomarker Tracking (CGM Sync) — Riverpod Notifier
///
/// Riverpod state management for holding live glucose stream readings,
/// sensor status, and detected spike events matching §P10-H & §P10-L specs.
library;

import 'package:fitkarma/features/predictive/cgm_sync_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CgmState {
  const CgmState({
    required this.currentReading,
    required this.recentReadings,
    required this.detectedSpikes,
    required this.sensorStatus,
    required this.lastSyncedAt,
  });

  final GlucoseReading currentReading;
  final List<GlucoseReading> recentReadings;
  final List<CgmSpikeEvent> detectedSpikes;
  final SensorStatus sensorStatus;
  final DateTime lastSyncedAt;
}

class CgmNotifier extends Notifier<CgmState> {
  final CgmSyncEngine _engine = const CgmSyncEngine();

  @override
  CgmState build() {
    final now = DateTime.now();

    final readings = [
      GlucoseReading(
        readingId: 'g1',
        timestamp: now.subtract(const Duration(minutes: 75)),
        glucoseValueMgDl: 120.0,
        trendDirection: GlucoseTrend.flat,
        status: SensorStatus.active,
      ),
      GlucoseReading(
        readingId: 'g2',
        timestamp: now.subtract(const Duration(minutes: 15)),
        glucoseValueMgDl: 172.0,
        trendDirection: GlucoseTrend.rapidlyRising,
        status: SensorStatus.active,
      ),
      GlucoseReading(
        readingId: 'g3',
        timestamp: now,
        glucoseValueMgDl: 124.0,
        trendDirection: GlucoseTrend.rising,
        status: SensorStatus.active,
      ),
    ];

    final meals = [
      CorrelatedMealEntry(
        foodName: 'White Rice (Thali)',
        consumeTime: now.subtract(const Duration(minutes: 45)),
        carbsGrams: 65.0,
      ),
    ];

    final spikes = _engine.detectSpikesAndCorrelate(readings: readings, mealLogs: meals);

    return CgmState(
      currentReading: readings.last,
      recentReadings: readings,
      detectedSpikes: spikes,
      sensorStatus: SensorStatus.active,
      lastSyncedAt: now,
    );
  }

  void syncLatest() {
    state = build();
  }
}

final cgmProvider = NotifierProvider<CgmNotifier, CgmState>(CgmNotifier.new);
