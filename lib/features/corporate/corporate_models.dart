/// §P16-D Corporate Wellness & Insurer Tier — Domain Models
///
/// Data models for OrganizationAccounts, EmployeeEnrollments, CorporatePlanTier, and Privacy-Safe Aggregates matching §P16-D spec.
library;

enum AccountType { employer, insurer }

enum CorporatePlanTier {
  corporateBasic('corporate_basic', 'Corporate Basic', 250),
  corporatePlus('corporate_plus', 'Corporate Plus', 1000);

  const CorporatePlanTier(this.code, this.displayName, this.defaultSeats);

  final String code;
  final String displayName;
  final int defaultSeats;
}

class OrganizationAccount {
  const OrganizationAccount({
    required this.localId,
    this.azureId,
    required this.organizationName,
    required this.accountType,
    required this.planTier,
    required this.seatLimit,
    required this.enrollmentCode,
    required this.createdAt,
  });

  final String localId;
  final String? azureId;
  final String organizationName;
  final AccountType accountType;
  final CorporatePlanTier planTier;
  final int seatLimit;
  final String enrollmentCode; // e.g. "TECH-CORP-2026"
  final DateTime createdAt;
}

class EmployeeEnrollment {
  const EmployeeEnrollment({
    required this.localId,
    required this.userId,
    required this.organizationId,
    required this.enrolledAt,
    this.isActive = true,
  });

  final String localId;
  final String userId;
  final String organizationId;
  final DateTime enrolledAt;
  final bool isActive;
}

class CorporateAggregateMetrics {
  const CorporateAggregateMetrics({
    required this.organizationId,
    required this.organizationName,
    required this.totalEnrolled,
    required this.seatLimit,
    required this.enrollmentPercentage,
    required this.activeCohortSize,
    required this.isCohortThresholdMet, // Requires activeCohortSize >= 5 (§P7-F spec)
    required this.adherenceDistribution, // Map of adherence range -> percentage
    required this.avgActivityScore,
    required this.privacyAuditPassed, // True when zero per-user PII is present
  });

  final String organizationId;
  final String organizationName;
  final int totalEnrolled;
  final int seatLimit;
  final double enrollmentPercentage;
  final int activeCohortSize;
  final bool isCohortThresholdMet;
  final Map<String, double> adherenceDistribution;
  final double avgActivityScore;
  final bool privacyAuditPassed;
}
