/// §P10-M Clinical Phase 10 Opt-in Cohort Feature Flag
///
/// Gates Phase 10 predictive features (§P10-F through §P10-L) behind an opt-in feature flag
/// for controlled initial cohort rollout matching §P10-M specification.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Phase10FeatureFlagState {
  const Phase10FeatureFlagState({
    this.isEnabled = false,
    this.allowedCohorts = const ['beta-cohort-001', 'internal-alpha'],
    this.activeUserCohort,
  });

  final bool isEnabled;
  final List<String> allowedCohorts;
  final String? activeUserCohort;

  bool get canAccessPhase10 {
    if (!isEnabled) return false;
    if (activeUserCohort == null) return true; // Global opt-in if cohort is unspecified
    return allowedCohorts.contains(activeUserCohort);
  }

  Phase10FeatureFlagState copyWith({
    bool? isEnabled,
    List<String>? allowedCohorts,
    String? activeUserCohort,
  }) {
    return Phase10FeatureFlagState(
      isEnabled: isEnabled ?? this.isEnabled,
      allowedCohorts: allowedCohorts ?? this.allowedCohorts,
      activeUserCohort: activeUserCohort ?? this.activeUserCohort,
    );
  }
}

class Phase10FeatureFlagNotifier extends Notifier<Phase10FeatureFlagState> {
  @override
  Phase10FeatureFlagState build() {
    return const Phase10FeatureFlagState(
      isEnabled: true, // Enabled for initial opt-in cohort
      activeUserCohort: 'beta-cohort-001',
    );
  }

  void enableForCohort(String cohortId) {
    state = state.copyWith(
      isEnabled: true,
      activeUserCohort: cohortId,
    );
  }

  void disable() {
    state = state.copyWith(isEnabled: false);
  }

  void setGlobalEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
  }
}

final phase10FeatureFlagProvider =
    NotifierProvider<Phase10FeatureFlagNotifier, Phase10FeatureFlagState>(
  Phase10FeatureFlagNotifier.new,
);
