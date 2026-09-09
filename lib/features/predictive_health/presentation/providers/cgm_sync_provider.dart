import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/cgm_sync_engine.dart';
import '../../domain/cgm_sync_models.dart';

final continuousBiomarkerProvider =
    StateNotifierProvider<ContinuousBiomarkerNotifier, ContinuousGlucoseReport>((ref) {
  return ContinuousBiomarkerNotifier();
});

class ContinuousBiomarkerNotifier extends StateNotifier<ContinuousGlucoseReport> {
  ContinuousBiomarkerNotifier() : super(_buildInitialReport());

  static final ContinuousBiomarkerEngine _engine = const ContinuousBiomarkerEngine();

  static ContinuousGlucoseReport _buildInitialReport() {
    return _engine.processCgmTelemetry(
      sensorId: 'CGM_ULTRA_8492',
      sensorModel: 'FreeStyle Libre 3 / Ultrahuman M1',
      currentGlucose: 104.0,
      currentTrend: GlucoseTrendDirection.steady,
      customStream24h: null,
    );
  }

  void syncNewTelemetryPoint({
    required double newGlucoseValue,
    required GlucoseTrendDirection trend,
    String? eventTag,
  }) {
    final newPoint = GlucoseTelemetryPoint(
      timestamp: DateTime.now(),
      glucoseValue: newGlucoseValue,
      trend: trend,
      rangeTier: newGlucoseValue < 70.0
          ? GlucoseRangeTier.hypo
          : (newGlucoseValue <= 140.0
              ? GlucoseRangeTier.inRange
              : (newGlucoseValue <= 180.0 ? GlucoseRangeTier.elevated : GlucoseRangeTier.spikeHigh)),
      eventTag: eventTag,
    );

    final updatedStream = [
      ...state.telemetryStream24h.skip(1),
      newPoint,
    ];

    state = _engine.processCgmTelemetry(
      sensorId: state.sensorId,
      sensorModel: state.sensorModel,
      currentGlucose: newGlucoseValue,
      currentTrend: trend,
      customStream24h: updatedStream,
    );
  }
}
