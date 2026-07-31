import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/analytics_engine.dart';
import '../../onboarding/models/user_profile.dart';
import '../models/body_measurement.dart';

class AnalyticsState {
  final double currentWeightKg;
  final LeanMassResult leanMassInfo;
  final List<BodyMeasurementLog> measurementsHistory;

  const AnalyticsState({
    this.currentWeightKg = 75.0,
    required this.leanMassInfo,
    this.measurementsHistory = const [],
  });

  AnalyticsState copyWith({
    double? currentWeightKg,
    LeanMassResult? leanMassInfo,
    List<BodyMeasurementLog>? measurementsHistory,
  }) {
    return AnalyticsState(
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      leanMassInfo: leanMassInfo ?? this.leanMassInfo,
      measurementsHistory: measurementsHistory ?? this.measurementsHistory,
    );
  }
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AnalyticsEngine engine;

  AnalyticsNotifier(this.engine)
      : super(
          AnalyticsState(
            leanMassInfo: const AnalyticsEngine().calculateLeanMass(
              weightKg: 75.0,
              heightCm: 175.0,
              gender: Gender.male,
            ),
          ),
        );

  void logMeasurement(double waist, double chest, double arms, double thighs) {
    final entry = BodyMeasurementLog(
      date: DateTime.now(),
      waistCm: waist,
      chestCm: chest,
      armsCm: arms,
      thighsCm: thighs,
    );
    state = state.copyWith(
      measurementsHistory: [...state.measurementsHistory, entry],
    );
  }
}

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  return AnalyticsNotifier(const AnalyticsEngine());
});
