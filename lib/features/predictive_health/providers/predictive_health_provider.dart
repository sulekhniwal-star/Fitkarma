import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/predictive_health_engine.dart';
import '../models/medication_model.dart';

class PredictiveHealthState {
  final BiologicalAgeResult bioAge;
  final CgmSpikeResult latestCgmSpike;
  final List<MedicationLog> medications;
  final String? activeDrugWarning;
  final String doctorPortalPasscode;

  const PredictiveHealthState({
    required this.bioAge,
    required this.latestCgmSpike,
    this.medications = const [
      MedicationLog(
          id: 'm1',
          medicationName: 'Metformin',
          dosage: '500mg',
          scheduledTime: '08:00 AM',
          isTaken: true),
      MedicationLog(
          id: 'm2',
          medicationName: 'Omega-3 Fish Oil',
          dosage: '1000mg',
          scheduledTime: '01:00 PM',
          isTaken: false),
    ],
    this.activeDrugWarning =
        'Drug-Nutrient Warning: High-carb meals may delay Metformin absorption. Pair with fiber.',
    this.doctorPortalPasscode = 'FK-8942-DOC',
  });

  PredictiveHealthState copyWith({
    BiologicalAgeResult? bioAge,
    CgmSpikeResult? latestCgmSpike,
    List<MedicationLog>? medications,
    String? activeDrugWarning,
    String? doctorPortalPasscode,
  }) {
    return PredictiveHealthState(
      bioAge: bioAge ?? this.bioAge,
      latestCgmSpike: latestCgmSpike ?? this.latestCgmSpike,
      medications: medications ?? this.medications,
      activeDrugWarning: activeDrugWarning ?? this.activeDrugWarning,
      doctorPortalPasscode: doctorPortalPasscode ?? this.doctorPortalPasscode,
    );
  }
}

class PredictiveHealthNotifier extends StateNotifier<PredictiveHealthState> {
  final PredictiveHealthEngine engine;

  PredictiveHealthNotifier(this.engine)
      : super(
          PredictiveHealthState(
            bioAge: const PredictiveHealthEngine().calculateBiologicalAge(
              chronologicalAge: 28.0,
              restingHeartRateBpm: 56,
              averageSleepScore: 88,
              bmi: 22.5,
            ),
            latestCgmSpike: const PredictiveHealthEngine().detectCgmSpike(
              startGlucoseMgDl: 95.0,
              peakGlucoseMgDl: 142.0,
              windowMinutes: 35,
            ),
          ),
        );
}

final predictiveHealthProvider =
    StateNotifierProvider<PredictiveHealthNotifier, PredictiveHealthState>(
        (ref) {
  return PredictiveHealthNotifier(const PredictiveHealthEngine());
});
