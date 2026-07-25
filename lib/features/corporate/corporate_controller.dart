/// §P16-D Corporate Wellness Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'corporate_models.dart';
import 'corporate_wellness_service.dart';

class CorporateState {
  const CorporateState({
    this.currentOrg,
    this.userEnrollment,
    this.aggregateMetrics,
    this.availableOrgs = const [],
    this.currentEnrollments = const [],
    this.successMessage,
    this.errorMessage,
  });

  final OrganizationAccount? currentOrg;
  final EmployeeEnrollment? userEnrollment;
  final CorporateAggregateMetrics? aggregateMetrics;
  final List<OrganizationAccount> availableOrgs;
  final List<EmployeeEnrollment> currentEnrollments;
  final String? successMessage;
  final String? errorMessage;

  CorporateState copyWith({
    OrganizationAccount? currentOrg,
    EmployeeEnrollment? userEnrollment,
    CorporateAggregateMetrics? aggregateMetrics,
    List<OrganizationAccount>? availableOrgs,
    List<EmployeeEnrollment>? currentEnrollments,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
    bool clearEnrollment = false,
  }) {
    return CorporateState(
      currentOrg: currentOrg ?? this.currentOrg,
      userEnrollment: clearEnrollment ? null : (userEnrollment ?? this.userEnrollment),
      aggregateMetrics: aggregateMetrics ?? this.aggregateMetrics,
      availableOrgs: availableOrgs ?? this.availableOrgs,
      currentEnrollments: currentEnrollments ?? this.currentEnrollments,
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CorporateNotifier extends Notifier<CorporateState> {
  late final CorporateWellnessService _service;

  @override
  CorporateState build() {
    _service = const CorporateWellnessService();

    final defaultOrg = OrganizationAccount(
      localId: 'org_techcorp_101',
      organizationName: 'TechCorp India Ltd',
      accountType: AccountType.employer,
      planTier: CorporatePlanTier.corporatePlus,
      seatLimit: 500,
      enrollmentCode: 'TECH-CORP-2026',
      createdAt: DateTime.now(),
    );

    // Initial synthetic enrollments (320 employees for valid cohort > 5)
    final syntheticEnrollments = List.generate(
      320,
      (i) => EmployeeEnrollment(
        localId: 'enr_$i',
        userId: 'usr_$i',
        organizationId: defaultOrg.localId,
        enrolledAt: DateTime.now(),
      ),
    );

    final metrics = _service.getOrgAggregateMetrics(
      org: defaultOrg,
      allEnrollments: syntheticEnrollments,
    );

    return CorporateState(
      currentOrg: defaultOrg,
      availableOrgs: [defaultOrg],
      currentEnrollments: syntheticEnrollments,
      aggregateMetrics: metrics,
    );
  }

  Future<void> enrollUserWithCode(String enrollmentCode) async {
    state = state.copyWith(clearMessages: true);
    try {
      final newEnrollment = await _service.linkEmployeeByCode(
        userId: 'usr_current_user',
        enrollmentCode: enrollmentCode,
        availableOrgs: state.availableOrgs,
        currentEnrollments: state.currentEnrollments,
      );

      final updatedEnrollments = [...state.currentEnrollments, newEnrollment];
      final updatedMetrics = _service.getOrgAggregateMetrics(
        org: state.currentOrg!,
        allEnrollments: updatedEnrollments,
      );

      state = state.copyWith(
        userEnrollment: newEnrollment,
        currentEnrollments: updatedEnrollments,
        aggregateMetrics: updatedMetrics,
        successMessage: '🎉 Joined Corporate Wellness program (${state.currentOrg!.organizationName})!',
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void unenrollUser() {
    if (state.userEnrollment == null) return;
    final unlinked = _service.unlinkEmployee(state.userEnrollment!);
    final updatedEnrollments = state.currentEnrollments.where((e) => e.userId != unlinked.userId).toList();

    final updatedMetrics = _service.getOrgAggregateMetrics(
      org: state.currentOrg!,
      allEnrollments: updatedEnrollments,
    );

    state = state.copyWith(
      clearEnrollment: true,
      currentEnrollments: updatedEnrollments,
      aggregateMetrics: updatedMetrics,
      successMessage: 'Successfully opted out of Corporate Wellness program.',
    );
  }

  void updatePlanTier(CorporatePlanTier newTier, int seatLimit) {
    if (state.currentOrg == null) return;
    final updatedOrg = OrganizationAccount(
      localId: state.currentOrg!.localId,
      organizationName: state.currentOrg!.organizationName,
      accountType: state.currentOrg!.accountType,
      planTier: newTier,
      seatLimit: seatLimit,
      enrollmentCode: state.currentOrg!.enrollmentCode,
      createdAt: state.currentOrg!.createdAt,
    );

    final updatedMetrics = _service.getOrgAggregateMetrics(
      org: updatedOrg,
      allEnrollments: state.currentEnrollments,
    );

    state = state.copyWith(
      currentOrg: updatedOrg,
      aggregateMetrics: updatedMetrics,
      successMessage: 'Updated plan to ${newTier.displayName} ($seatLimit seats).',
    );
  }
}

final corporateProvider = NotifierProvider<CorporateNotifier, CorporateState>(
  CorporateNotifier.new,
);
