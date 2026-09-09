import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/stress_detection_engine.dart';
import '../../domain/stress_detection_models.dart';

final stressDetectionProvider =
    StateNotifierProvider<StressDetectionNotifier, InferredStressReport>((ref) {
  return StressDetectionNotifier();
});

class StressDetectionNotifier extends StateNotifier<InferredStressReport> {
  StressDetectionNotifier() : super(_buildInitialReport());

  static final StressDetectionEngine _engine = const StressDetectionEngine();

  static InferredStressReport _buildInitialReport() {
    return _engine.inferStressState(
      currentRmssd: 48.0,
      baselineRmssd: 54.0,
      currentRestingHeartRate: 63.0,
      baselineRestingHeartRate: 59.0,
      currentRespirationRate: 14.5,
      baselineRespirationRate: 13.5,
      nocturnalRestlessnessCount: 3,
      daytimeSedentaryPulseSpikes: 1,
    );
  }

  void refreshWithLiveTelemetry({
    required double currentRmssd,
    required double baselineRmssd,
    required double currentRestingHeartRate,
    required double baselineRestingHeartRate,
    required double currentRespirationRate,
    required double baselineRespirationRate,
    required int nocturnalRestlessnessCount,
    required int daytimeSedentaryPulseSpikes,
  }) {
    state = _engine.inferStressState(
      currentRmssd: currentRmssd,
      baselineRmssd: baselineRmssd,
      currentRestingHeartRate: currentRestingHeartRate,
      baselineRestingHeartRate: baselineRestingHeartRate,
      currentRespirationRate: currentRespirationRate,
      baselineRespirationRate: baselineRespirationRate,
      nocturnalRestlessnessCount: nocturnalRestlessnessCount,
      daytimeSedentaryPulseSpikes: daytimeSedentaryPulseSpikes,
    );
  }
}
