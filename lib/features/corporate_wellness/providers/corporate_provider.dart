import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/corporate_engine.dart';
import '../domain/corporate_models.dart';

@immutable
class CorporateState {
  final CorporateEmployeeProfile employeeProfile;
  final CorporateOrganization organization;
  final InsurerPremiumRebate insurerRebate;
  final List<CorporateTeamChallenge> teamChallenges;
  final List<ErgonomicAlert> ergonomicAlerts;
  final String? pendingOtp;
  final String? statusMessage;

  const CorporateState({
    required this.employeeProfile,
    required this.organization,
    required this.insurerRebate,
    required this.teamChallenges,
    required this.ergonomicAlerts,
    this.pendingOtp,
    this.statusMessage,
  });

  CorporateState copyWith({
    CorporateEmployeeProfile? employeeProfile,
    CorporateOrganization? organization,
    InsurerPremiumRebate? insurerRebate,
    List<CorporateTeamChallenge>? teamChallenges,
    List<ErgonomicAlert>? ergonomicAlerts,
    String? pendingOtp,
    String? statusMessage,
  }) {
    return CorporateState(
      employeeProfile: employeeProfile ?? this.employeeProfile,
      organization: organization ?? this.organization,
      insurerRebate: insurerRebate ?? this.insurerRebate,
      teamChallenges: teamChallenges ?? this.teamChallenges,
      ergonomicAlerts: ergonomicAlerts ?? this.ergonomicAlerts,
      pendingOtp: pendingOtp ?? this.pendingOtp,
      statusMessage: statusMessage,
    );
  }
}

final corporateWellnessProvider =
    StateNotifierProvider<CorporateWellnessNotifier, CorporateState>((ref) {
  return CorporateWellnessNotifier();
});

class CorporateWellnessNotifier extends StateNotifier<CorporateState> {
  CorporateWellnessNotifier() : super(_buildInitialState());

  static const CorporateEngine _engine = CorporateEngine();

  static CorporateState _buildInitialState() {
    const org = CorporateOrganization(
      orgId: 'org_tcs_blr',
      companyName: 'Tata Consultancy Services',
      corporateDomain: 'tcs.com',
      employerSubsidyPercentage: 100.0,
      activeTier: 'Enterprise Platinum',
      totalEnrolledEmployees: 14200,
      averageOrgHealthScore: 84.2,
    );

    const employee = CorporateEmployeeProfile(
      employeeId: 'TCS-BLR-89421',
      workEmail: 'rahul.s@tcs.com',
      organizationName: 'Tata Consultancy Services',
      department: 'Cloud & AI Engineering',
      verificationStatus: CorporateVerificationStatus.verifiedEmployee,
      earnedWellnessPoints: 4850,
      corporateRank: 14,
    );

    final rebate = _engine.calculateInsurerRebate(
      insurer: InsurerPartner.hdfcErgo,
      policyNumber: 'HE-FIT-884920-BLR',
      baseAnnualPremiumInr: 24000.0,
      averageDailySteps: 10850.0,
      longevityScore: 88.5,
      shatapadiAdherencePercentage: 85.0,
      monthlyActiveDays: 22,
    );

    const challenges = [
      CorporateTeamChallenge(
        challengeId: 'ch_step_01',
        title: 'Inter-Department 100K Steps Challenge',
        regionalTitle: 'विभाग-स्तरीय १ लाख कदम प्रतियोगिता',
        targetMetric: '100,000 Steps / Month',
        leadingDepartment: 'Cloud & AI Engineering',
        participantCount: 420,
        progressPercentage: 88.5,
        prizePoolWellnessPoints: 50000,
        timeRemaining: Duration(days: 6),
      ),
      CorporateTeamChallenge(
        challengeId: 'ch_shatapadi_02',
        title: 'Post-Lunch Office Shatapadi Sprint',
        regionalTitle: 'कार्यालय शतपावली स्प्रिंट',
        targetMetric: '21-Day Streak (100 Steps Post-Lunch)',
        leadingDepartment: 'Product & Design',
        participantCount: 310,
        progressPercentage: 74.0,
        prizePoolWellnessPoints: 25000,
        timeRemaining: Duration(days: 12),
      ),
    ];

    final alerts = _engine.evaluateWorkplaceErgonomics(
      continuousDeskMinutes: 65,
      dailyScreenTimeHours: 6,
    );

    return CorporateState(
      employeeProfile: employee,
      organization: org,
      insurerRebate: rebate,
      teamChallenges: challenges,
      ergonomicAlerts: alerts,
    );
  }

  void initiateWorkEmailVerification(String workEmail, String orgName, String dept) {
    final otp = _engine.generateWorkEmailOtp(workEmail);
    state = state.copyWith(
      pendingOtp: otp,
      statusMessage: 'Verification OTP sent to $workEmail: $otp (Demo Simulation)',
      employeeProfile: state.employeeProfile.copyWith(
        workEmail: workEmail,
        organizationName: orgName,
        department: dept,
        verificationStatus: CorporateVerificationStatus.pendingWorkEmailOtp,
      ),
    );
  }

  bool verifyOtp(String enteredOtp) {
    if (state.pendingOtp == null) return false;

    final isValid = _engine.verifyWorkEmailOtp(
      enteredOtp: enteredOtp,
      expectedOtp: state.pendingOtp!,
    );

    if (isValid) {
      state = state.copyWith(
        pendingOtp: null,
        employeeProfile: state.employeeProfile.copyWith(
          verificationStatus: CorporateVerificationStatus.verifiedEmployee,
          joinedAt: DateTime.now(),
        ),
        statusMessage: 'Corporate membership verified successfully! 🏢',
      );
      return true;
    } else {
      state = state.copyWith(statusMessage: 'Incorrect OTP. Please check your work email.');
      return false;
    }
  }

  void linkInsurerPolicy({
    required InsurerPartner insurer,
    required String policyNumber,
    required double baseAnnualPremium,
  }) {
    final updatedRebate = _engine.calculateInsurerRebate(
      insurer: insurer,
      policyNumber: policyNumber,
      baseAnnualPremiumInr: baseAnnualPremium,
      averageDailySteps: 10850.0,
      longevityScore: 88.5,
      shatapadiAdherencePercentage: 85.0,
      monthlyActiveDays: 22,
    );

    state = state.copyWith(
      insurerRebate: updatedRebate,
      statusMessage: '${insurer.name} policy linked! Dynamic rebate applied. 🛡️',
    );
  }

  void unlinkCorporate() {
    state = state.copyWith(
      employeeProfile: state.employeeProfile.copyWith(
        verificationStatus: CorporateVerificationStatus.unlinked,
      ),
      statusMessage: 'Corporate membership unlinked.',
    );
  }
}
