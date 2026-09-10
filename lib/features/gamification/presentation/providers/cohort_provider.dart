import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/cohort_insights_engine.dart';
import '../../domain/cohort_models.dart';

class DemographicCohortState {
  final IndianCityTier selectedCityTier;
  final ActivityPersonaCluster selectedPersona;
  final DemographicCohortReport report;

  const DemographicCohortState({
    required this.selectedCityTier,
    required this.selectedPersona,
    required this.report,
  });

  DemographicCohortState copyWith({
    IndianCityTier? selectedCityTier,
    ActivityPersonaCluster? selectedPersona,
    DemographicCohortReport? report,
  }) {
    return DemographicCohortState(
      selectedCityTier: selectedCityTier ?? this.selectedCityTier,
      selectedPersona: selectedPersona ?? this.selectedPersona,
      report: report ?? this.report,
    );
  }
}

final demographicCohortProvider =
    StateNotifierProvider<DemographicCohortNotifier, DemographicCohortState>(
        (ref) {
  return DemographicCohortNotifier();
});

class DemographicCohortNotifier extends StateNotifier<DemographicCohortState> {
  DemographicCohortNotifier() : super(_buildInitialState());

  static DemographicCohortState _buildInitialState() {
    const defaultTier = IndianCityTier.tier1;
    const defaultPersona = ActivityPersonaCluster.techSedentary;

    final report = DemographicCohortEngine.evaluateCohortReport(
      userAge: 29,
      biologicalSex: 'Male',
      cityTier: defaultTier,
      persona: defaultPersona,
      userDailySteps: 10450,
      userShatpawaliCompliancePercent: 80.0,
      userProteinGramsPerKg: 1.35,
      userSleepRecoveryPercent: 84.0,
      userWeeklyWorkouts: 4.0,
      userDailyKarmaVelocity: 125.0,
      activeStreakDays: 18,
      userAdherenceScore: 88.5,
    );

    return DemographicCohortState(
      selectedCityTier: defaultTier,
      selectedPersona: defaultPersona,
      report: report,
    );
  }

  void updateCityTier(IndianCityTier tier) {
    final newReport = DemographicCohortEngine.evaluateCohortReport(
      userAge: 29,
      biologicalSex: 'Male',
      cityTier: tier,
      persona: state.selectedPersona,
      userDailySteps: 10450,
      userShatpawaliCompliancePercent: 80.0,
      userProteinGramsPerKg: 1.35,
      userSleepRecoveryPercent: 84.0,
      userWeeklyWorkouts: 4.0,
      userDailyKarmaVelocity: 125.0,
      activeStreakDays: 18,
      userAdherenceScore: 88.5,
    );

    state = state.copyWith(
      selectedCityTier: tier,
      report: newReport,
    );
  }

  void updatePersona(ActivityPersonaCluster persona) {
    final newReport = DemographicCohortEngine.evaluateCohortReport(
      userAge: 29,
      biologicalSex: 'Male',
      cityTier: state.selectedCityTier,
      persona: persona,
      userDailySteps: 10450,
      userShatpawaliCompliancePercent: 80.0,
      userProteinGramsPerKg: 1.35,
      userSleepRecoveryPercent: 84.0,
      userWeeklyWorkouts: 4.0,
      userDailyKarmaVelocity: 125.0,
      activeStreakDays: 18,
      userAdherenceScore: 88.5,
    );

    state = state.copyWith(
      selectedPersona: persona,
      report: newReport,
    );
  }
}
