import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/cgm_sync_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/cgm_sync_models.dart';

void main() {
  group('ContinuousBiomarkerEngine Tests', () {
    const engine = ContinuousBiomarkerEngine();

    test('Processes CGM telemetry stream and calculates valid TIR and GMI', () {
      final report = engine.processCgmTelemetry(
        sensorId: 'CGM_TEST_01',
        sensorModel: 'FreeStyle Libre 3',
        currentGlucose: 102.0,
        currentTrend: GlucoseTrendDirection.steady,
        customStream24h: null,
      );

      expect(report.timeInRangePercent, greaterThanOrEqualTo(80.0));
      expect(report.meanGlucose24h, inInclusiveRange(70.0, 140.0));
      expect(report.estimatedGmiHbA1c, inInclusiveRange(4.5, 6.5));
      expect(report.telemetryStream24h.length, equals(48));
      expect(report.detectedMealSpikes.isNotEmpty, isTrue);
      expect(report.activeProtocols.isNotEmpty, isTrue);
    });

    test('Correctly identifies high glycemic variability and excursions', () {
      final spikeStream = List.generate(48, (index) {
        final val = index % 2 == 0 ? 190.0 : 60.0;
        return GlucoseTelemetryPoint(
          timestamp: DateTime.now().subtract(Duration(minutes: index * 30)),
          glucoseValue: val,
          trend: GlucoseTrendDirection.rapidlyRising,
          rangeTier: val > 140 ? GlucoseRangeTier.spikeHigh : GlucoseRangeTier.hypo,
        );
      });

      final report = engine.processCgmTelemetry(
        sensorId: 'CGM_SPIKE_TEST',
        sensorModel: 'Ultrahuman M1',
        currentGlucose: 190.0,
        currentTrend: GlucoseTrendDirection.rapidlyRising,
        customStream24h: spikeStream,
      );

      expect(report.timeInRangePercent, equals(0.0));
      expect(report.timeAboveRangePercent, equals(50.0));
      expect(report.timeBelowRangePercent, equals(50.0));
      expect(report.glycemicVariabilityCvPercent, greaterThan(25.0));
    });
  });
}
