import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/body_analytics_engine.dart';
import '../../domain/body_analytics_models.dart';

final bodyAnalyticsProvider =
    StateNotifierProvider<BodyAnalyticsNotifier, BodyAnalyticsReport>((ref) {
  return BodyAnalyticsNotifier();
});

class BodyAnalyticsNotifier extends StateNotifier<BodyAnalyticsReport> {
  BodyAnalyticsNotifier() : super(_buildInitialReport());

  static final BodyAnalyticsEngine _engine = const BodyAnalyticsEngine();

  static BodyAnalyticsReport _buildInitialReport() {
    return _engine.computeBodyAnalytics(
      weightKg: 74.5,
      heightCm: 178.0,
      sex: AnthropometricSex.male,
      chronologicalAge: 32,
      circumferences: const BodyCircumferences(
        neckCm: 38.0,
        chestCm: 102.0,
        waistCm: 81.0,
        hipsCm: 96.0,
        bicepLeftCm: 35.5,
        bicepRightCm: 35.8,
        thighLeftCm: 56.0,
        thighRightCm: 56.2,
        calfLeftCm: 37.0,
        calfRightCm: 37.0,
      ),
    );
  }

  void updateMetrics({
    required double weightKg,
    required double heightCm,
    required AnthropometricSex sex,
    required int chronologicalAge,
    required BodyCircumferences circumferences,
  }) {
    state = _engine.computeBodyAnalytics(
      weightKg: weightKg,
      heightCm: heightCm,
      sex: sex,
      chronologicalAge: chronologicalAge,
      circumferences: circumferences,
      recordedAt: DateTime.now(),
    );
  }
}
