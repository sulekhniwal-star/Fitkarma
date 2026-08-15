// §P16-D Corporate Wellness & Insurer Tier Engine (Pure Dart)
// Cross-reference: §P16-D, §P7-F in Fitkarma_documentation.md

enum AccountType { employer, insurer }

enum PlanTier { corporateBasic, corporatePlus }

/// Organization Account Model per §P16-D schema
class OrganizationAccount {
  final String localId;
  final String? authProviderId;
  final String organizationName;
  final AccountType accountType;
  final PlanTier planTier;
  final int seatLimit;
  final DateTime createdAt;

  const OrganizationAccount({
    required this.localId,
    this.authProviderId,
    required this.organizationName,
    required this.accountType,
    required this.planTier,
    required this.seatLimit,
    required this.createdAt,
  });
}

/// Employee Enrollment Model per §P16-D schema
class EmployeeEnrollment {
  final String localId;
  final String userId;
  final String organizationId;
  final DateTime enrolledAt;
  final bool isActive;

  const EmployeeEnrollment({
    required this.localId,
    required this.userId,
    required this.organizationId,
    required this.enrolledAt,
    this.isActive = true,
  });

  EmployeeEnrollment copyWith({
    String? localId,
    String? userId,
    String? organizationId,
    DateTime? enrolledAt,
    bool? isActive,
  }) {
    return EmployeeEnrollment(
      localId: localId ?? this.localId,
      userId: userId ?? this.userId,
      organizationId: organizationId ?? this.organizationId,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Anonymized Aggregate Wellness Report for HR / Insurers
class CorporateAggregateReport {
  final String organizationId;
  final String organizationName;
  final int totalSeats;
  final int enrolledActiveCount;
  final double enrollmentRatePct;
  final bool isPrivacyThresholdMet;
  final String privacyStatusMessage;
  final double? averageAdherenceScore; // Masked if threshold not met
  final double? weeklyActivePct; // Masked if threshold not met
  final Map<String, double>? adherenceDistribution; // Masked if threshold not met

  const CorporateAggregateReport({
    required this.organizationId,
    required this.organizationName,
    required this.totalSeats,
    required this.enrolledActiveCount,
    required this.enrollmentRatePct,
    required this.isPrivacyThresholdMet,
    required this.privacyStatusMessage,
    this.averageAdherenceScore,
    this.weeklyActivePct,
    this.adherenceDistribution,
  });
}

/// Pure Dart Corporate Wellness Reporting Engine with §P7-F Privacy Boundary
class CorporateWellnessEngine {
  /// Minimum cohort size threshold required before revealing any computed metrics (§P16-D & §P7-F)
  static const int minimumCohortThreshold = 10;

  const CorporateWellnessEngine();

  /// Enrolls an employee into an organization account
  EmployeeEnrollment enrollEmployee({
    required String organizationId,
    required String userId,
  }) {
    final now = DateTime.now();
    return EmployeeEnrollment(
      localId: 'enroll_${organizationId}_${userId}_${now.millisecondsSinceEpoch}',
      userId: userId,
      organizationId: organizationId,
      enrolledAt: now,
      isActive: true,
    );
  }

  /// Evaluates and generates an anonymized aggregate report with strict privacy enforcement
  CorporateAggregateReport generateAggregateReport({
    required OrganizationAccount organization,
    required List<EmployeeEnrollment> enrollments,
    required Map<String, double> userAdherenceScores, // userId -> score (0-100)
  }) {
    final activeEnrollments = enrollments.where((e) => e.isActive).toList();
    final activeCount = activeEnrollments.length;
    final enrollmentRate = organization.seatLimit > 0
        ? (activeCount / organization.seatLimit) * 100
        : 0.0;

    // ── Privacy Boundary Check (§P16-D & §P7-F) ──────────────────────────
    if (activeCount < minimumCohortThreshold) {
      return CorporateAggregateReport(
        organizationId: organization.localId,
        organizationName: organization.organizationName,
        totalSeats: organization.seatLimit,
        enrolledActiveCount: activeCount,
        enrollmentRatePct: double.parse(enrollmentRate.toStringAsFixed(1)),
        isPrivacyThresholdMet: false,
        privacyStatusMessage:
            'Not enough participants yet. Minimum $minimumCohortThreshold active participants required to protect employee anonymity.',
        averageAdherenceScore: null,
        weeklyActivePct: null,
        adherenceDistribution: null,
      );
    }

    // ── Compute Aggregate Metrics (Only when threshold is met) ───────────
    final scores = activeEnrollments
        .map((e) => userAdherenceScores[e.userId] ?? 70.0)
        .toList();

    final averageScore = scores.reduce((a, b) => a + b) / scores.length;
    final activeUsers = scores.where((s) => s >= 50.0).length;
    final weeklyActivePct = (activeUsers / scores.length) * 100;

    final highCount = scores.where((s) => s >= 80.0).length;
    final modCount = scores.where((s) => s >= 60.0 && s < 80.0).length;
    final devCount = scores.where((s) => s < 60.0).length;

    final total = scores.length.toDouble();
    final distribution = {
      'High Adherence (80%+)': double.parse(((highCount / total) * 100).toStringAsFixed(1)),
      'Moderate Adherence (60-79%)': double.parse(((modCount / total) * 100).toStringAsFixed(1)),
      'Developing (Under 60%)': double.parse(((devCount / total) * 100).toStringAsFixed(1)),
    };

    return CorporateAggregateReport(
      organizationId: organization.localId,
      organizationName: organization.organizationName,
      totalSeats: organization.seatLimit,
      enrolledActiveCount: activeCount,
      enrollmentRatePct: double.parse(enrollmentRate.toStringAsFixed(1)),
      isPrivacyThresholdMet: true,
      privacyStatusMessage: 'Privacy threshold satisfied (Cohort >= $minimumCohortThreshold)',
      averageAdherenceScore: double.parse(averageScore.toStringAsFixed(1)),
      weeklyActivePct: double.parse(weeklyActivePct.toStringAsFixed(1)),
      adherenceDistribution: distribution,
    );
  }
}
