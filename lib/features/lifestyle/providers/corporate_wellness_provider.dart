// §P16-D Corporate Wellness Provider & State Management
// Cross-reference: §P16-D in Fitkarma_documentation.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/corporate_wellness_engine.dart';

class CorporateWellnessState {
  final OrganizationAccount? selectedOrganization;
  final List<EmployeeEnrollment> enrollments;
  final EmployeeEnrollment? currentEmployeeEnrollment;
  final CorporateAggregateReport? activeReport;

  const CorporateWellnessState({
    this.selectedOrganization,
    this.enrollments = const [],
    this.currentEmployeeEnrollment,
    this.activeReport,
  });

  CorporateWellnessState copyWith({
    OrganizationAccount? selectedOrganization,
    List<EmployeeEnrollment>? enrollments,
    EmployeeEnrollment? currentEmployeeEnrollment,
    CorporateAggregateReport? activeReport,
  }) {
    return CorporateWellnessState(
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      enrollments: enrollments ?? this.enrollments,
      currentEmployeeEnrollment:
          currentEmployeeEnrollment ?? this.currentEmployeeEnrollment,
      activeReport: activeReport ?? this.activeReport,
    );
  }
}

class CorporateWellnessNotifier extends StateNotifier<CorporateWellnessState> {
  final CorporateWellnessEngine _engine;

  CorporateWellnessNotifier([CorporateWellnessEngine? engine])
      : _engine = engine ?? const CorporateWellnessEngine(),
        super(CorporateWellnessState(
          selectedOrganization: OrganizationAccount(
            localId: 'org_infosys_01',
            organizationName: 'Infosys Wellness Program',
            accountType: AccountType.employer,
            planTier: PlanTier.corporatePlus,
            seatLimit: 50,
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
        ));

  /// Enrolls the active user with an organization code
  void enrollUser({
    required String organizationId,
    required String userId,
  }) {
    final newEnrollment = _engine.enrollEmployee(
      organizationId: organizationId,
      userId: userId,
    );

    final updated = [...state.enrollments, newEnrollment];
    state = state.copyWith(
      enrollments: updated,
      currentEmployeeEnrollment: newEnrollment,
    );
    refreshReport();
  }

  /// Sets simulated cohort for dashboard inspection
  void setSimulatedCohort(int activeCount) {
    final org = state.selectedOrganization;
    if (org == null) return;

    final simulated = List.generate(
      activeCount,
      (i) => EmployeeEnrollment(
        localId: 'enroll_sim_$i',
        userId: 'user_$i',
        organizationId: org.localId,
        enrolledAt: DateTime.now().subtract(Duration(days: i)),
        isActive: true,
      ),
    );

    state = state.copyWith(enrollments: simulated);
    refreshReport();
  }

  /// Opts out active user (instantly reversible)
  void optOut() {
    if (state.currentEmployeeEnrollment != null) {
      final updated = state.enrollments.map((e) {
        if (e.localId == state.currentEmployeeEnrollment!.localId) {
          return e.copyWith(isActive: false);
        }
        return e;
      }).toList();

      state = state.copyWith(
        enrollments: updated,
        currentEmployeeEnrollment: null,
      );
      refreshReport();
    }
  }

  /// Recalculates aggregate report applying privacy threshold
  void refreshReport() {
    final org = state.selectedOrganization;
    if (org == null) return;

    final simulatedScores = <String, double>{};
    for (final e in state.enrollments) {
      // Deterministic spread for demo
      final hash = e.userId.hashCode.abs() % 40;
      simulatedScores[e.userId] = 60.0 + hash;
    }

    final report = _engine.generateAggregateReport(
      organization: org,
      enrollments: state.enrollments,
      userAdherenceScores: simulatedScores,
    );

    state = state.copyWith(activeReport: report);
  }
}

final corporateWellnessEngineProvider =
    Provider<CorporateWellnessEngine>((ref) => const CorporateWellnessEngine());

final corporateWellnessProvider =
    StateNotifierProvider<CorporateWellnessNotifier, CorporateWellnessState>(
        (ref) {
  final engine = ref.watch(corporateWellnessEngineProvider);
  final notifier = CorporateWellnessNotifier(engine);
  notifier.setSimulatedCohort(14); // Default to meeting threshold
  return notifier;
});
