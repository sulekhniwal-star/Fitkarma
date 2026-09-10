import 'package:flutter/widgets.dart';

/// Corporate Enterprise / Employer Profile
@immutable
class CorporateOrganization {
  final String orgId;
  final String companyName;
  final String corporateDomain; // e.g. "infosys.com", "tcs.com"
  final double employerSubsidyPercentage; // e.g. 100% sponsored
  final String activeTier; // "Enterprise Diamond", "Corporate Gold"
  final int totalEnrolledEmployees;
  final double averageOrgHealthScore; // 0 to 100

  const CorporateOrganization({
    required this.orgId,
    required this.companyName,
    required this.corporateDomain,
    required this.employerSubsidyPercentage,
    required this.activeTier,
    required this.totalEnrolledEmployees,
    required this.averageOrgHealthScore,
  });
}

/// Employee Corporate Membership & Verification Status
enum CorporateVerificationStatus {
  unlinked(label: 'Unlinked', regionalLabel: 'कॉर्पोरेट लिंक नहीं है'),
  pendingWorkEmailOtp(label: 'Work Email OTP Pending', regionalLabel: 'कार्य ईमेल ओटीपी लंबित'),
  verifiedEmployee(label: 'Verified Corporate Member', regionalLabel: 'सत्यापित कॉर्पोरेट सदस्य');

  final String label;
  final String regionalLabel;

  const CorporateVerificationStatus({
    required this.label,
    required this.regionalLabel,
  });
}

/// User's Corporate Employee Profile
@immutable
class CorporateEmployeeProfile {
  final String employeeId;
  final String workEmail;
  final String organizationName;
  final String department; // "Engineering", "Sales", "Product", "Operations"
  final CorporateVerificationStatus verificationStatus;
  final int earnedWellnessPoints;
  final int corporateRank;
  final DateTime? joinedAt;

  const CorporateEmployeeProfile({
    required this.employeeId,
    required this.workEmail,
    required this.organizationName,
    required this.department,
    required this.verificationStatus,
    required this.earnedWellnessPoints,
    required this.corporateRank,
    this.joinedAt,
  });

  bool get isVerified => verificationStatus == CorporateVerificationStatus.verifiedEmployee;

  CorporateEmployeeProfile copyWith({
    String? employeeId,
    String? workEmail,
    String? organizationName,
    String? department,
    CorporateVerificationStatus? verificationStatus,
    int? earnedWellnessPoints,
    int? corporateRank,
    DateTime? joinedAt,
  }) {
    return CorporateEmployeeProfile(
      employeeId: employeeId ?? this.employeeId,
      workEmail: workEmail ?? this.workEmail,
      organizationName: organizationName ?? this.organizationName,
      department: department ?? this.department,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      earnedWellnessPoints: earnedWellnessPoints ?? this.earnedWellnessPoints,
      corporateRank: corporateRank ?? this.corporateRank,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

/// Integrated Insurer Partner (IRDAI Compliant)
enum InsurerPartner {
  hdfcErgo(
    name: 'HDFC ERGO Health',
    regionalName: 'एचडीएफसी एर्गो हेल्थ',
    policyPrefix: 'HE-FIT',
    maxDiscountPercent: 25.0,
  ),
  starHealth(
    name: 'Star Health & Allied Insurance',
    regionalName: 'स्टार हेल्थ इंश्योरेंस',
    policyPrefix: 'STAR-FIT',
    maxDiscountPercent: 30.0,
  ),
  iciciLombard(
    name: 'ICICI Lombard Complete Health',
    regionalName: 'आईसीआईसीआई लोम्बार्ड',
    policyPrefix: 'ICICI-FIT',
    maxDiscountPercent: 20.0,
  ),
  adityaBirla(
    name: 'Aditya Birla Activ Health',
    regionalName: 'आदित्य बिड़ला एक्टिव हेल्थ',
    policyPrefix: 'AB-ACTIV',
    maxDiscountPercent: 30.0,
  );

  final String name;
  final String regionalName;
  final String policyPrefix;
  final double maxDiscountPercent;

  const InsurerPartner({
    required this.name,
    required this.regionalName,
    required this.policyPrefix,
    required this.maxDiscountPercent,
  });
}

/// Insurer Risk Tier according to IRDAI guidelines
enum InsurerRiskTier {
  preferredElite(
    label: 'Preferred Elite (Lowest Risk)',
    regionalLabel: 'उत्कृष्ट स्तर (न्यूनतम जोखिम)',
    rebateMultiplier: 1.0,
  ),
  standardPrime(
    label: 'Standard Prime (Moderate Risk)',
    regionalLabel: 'मानक स्तर (संतुलित जोखिम)',
    rebateMultiplier: 0.7,
  ),
  elevatedRisk(
    label: 'Elevated Risk (Optimization Needed)',
    regionalLabel: 'सुधार योग्य (सतर्कता स्तर)',
    rebateMultiplier: 0.3,
  );

  final String label;
  final String regionalLabel;
  final double rebateMultiplier;

  const InsurerRiskTier({
    required this.label,
    required this.regionalLabel,
    required this.rebateMultiplier,
  });
}

/// Dynamic Health Insurance Premium Rebate Calculation
@immutable
class InsurerPremiumRebate {
  final InsurerPartner insurer;
  final String policyNumber;
  final double baseAnnualPremiumInr; // e.g. ₹22,000
  final double calculatedDiscountPercentage; // e.g. 24.5%
  final double annualSavingsInr; // e.g. ₹5,390
  final InsurerRiskTier riskTier;
  final int requiredMonthlyActiveDays;
  final int completedActiveDays;
  final String renewalDiscountCertificateId;

  const InsurerPremiumRebate({
    required this.insurer,
    required this.policyNumber,
    required this.baseAnnualPremiumInr,
    required this.calculatedDiscountPercentage,
    required this.annualSavingsInr,
    required this.riskTier,
    required this.requiredMonthlyActiveDays,
    required this.completedActiveDays,
    required this.renewalDiscountCertificateId,
  });
}

/// Inter-Department / Corporate Team Challenge
@immutable
class CorporateTeamChallenge {
  final String challengeId;
  final String title;
  final String regionalTitle;
  final String targetMetric; // "100,000 Steps", "30 Days Shatapadi Streak"
  final String leadingDepartment;
  final int participantCount;
  final double progressPercentage; // 0.0 to 100.0
  final int prizePoolWellnessPoints;
  final Duration timeRemaining;

  const CorporateTeamChallenge({
    required this.challengeId,
    required this.title,
    required this.regionalTitle,
    required this.targetMetric,
    required this.leadingDepartment,
    required this.participantCount,
    required this.progressPercentage,
    required this.prizePoolWellnessPoints,
    required this.timeRemaining,
  });
}

/// Ergonomic & Desk Strain Alert
@immutable
class ErgonomicAlert {
  final String title;
  final String regionalTitle;
  final String actionPrompt;
  final String regionalActionPrompt;
  final int recommendedBreakSeconds;
  final IconData iconData;

  const ErgonomicAlert({
    required this.title,
    required this.regionalTitle,
    required this.actionPrompt,
    required this.regionalActionPrompt,
    required this.recommendedBreakSeconds,
    this.iconData = const IconData(0xe0af, fontFamily: 'MaterialIcons'),
  });
}
