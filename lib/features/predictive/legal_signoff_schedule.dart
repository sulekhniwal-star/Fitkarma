/// §P10-M Legal & Regulatory Sign-Off Scheduling Engine
///
/// Schedules pre-launch legal review for medication copy, interaction warning templates,
/// and Doctor Sharing Portal PDF templates prior to General Availability (GA).
library;

enum LegalReviewStatus {
  pendingReview('Pending Review', '⏳'),
  scheduled('Scheduled', '📅'),
  approved('Approved for GA', '✅'),
  rejected('Action Required', '❌');

  const LegalReviewStatus(this.displayName, this.iconSymbol);

  final String displayName;
  final String iconSymbol;
}

class LegalReviewScheduleEntry {
  const LegalReviewScheduleEntry({
    required this.reviewId,
    required this.featureModule,
    required this.scheduledDate,
    required this.status,
    this.reviewerName,
    this.approvalToken,
    this.notes,
  });

  final String reviewId;
  final String featureModule;
  final DateTime scheduledDate;
  final LegalReviewStatus status;
  final String? reviewerName;
  final String? approvalToken;
  final String? notes;

  LegalReviewScheduleEntry approve({
    required String reviewer,
    required String token,
  }) {
    return LegalReviewScheduleEntry(
      reviewId: reviewId,
      featureModule: featureModule,
      scheduledDate: scheduledDate,
      status: LegalReviewStatus.approved,
      reviewerName: reviewer,
      approvalToken: token,
      notes: 'Legal sign-off verified for General Availability',
    );
  }
}

class LegalSignoffScheduler {
  const LegalSignoffScheduler();

  /// Default pre-launch legal review schedule matching §P10-M specification.
  List<LegalReviewScheduleEntry> createPreLaunchSchedule({
    required DateTime targetGaDate,
  }) {
    final reviewDate = targetGaDate.subtract(const Duration(days: 14));

    return [
      LegalReviewScheduleEntry(
        reviewId: 'legal-001',
        featureModule: 'Medication Interaction Warnings (§P10-I)',
        scheduledDate: reviewDate,
        status: LegalReviewStatus.scheduled,
        notes: 'Review directive linter rules and RxNorm interaction warning copy',
      ),
      LegalReviewScheduleEntry(
        reviewId: 'legal-002',
        featureModule: 'Doctor Sharing Portal PDF & FHIR Template (§P10-J)',
        scheduledDate: reviewDate,
        status: LegalReviewStatus.scheduled,
        notes: 'Review passcode-protected export format and non-diagnostic disclaimers',
      ),
      LegalReviewScheduleEntry(
        reviewId: 'legal-003',
        featureModule: 'Non-Diagnostic Shield Disclaimer Component (§P10-K)',
        scheduledDate: reviewDate,
        status: LegalReviewStatus.scheduled,
        notes: 'Verify banner compliance across all clinical & predictive UI screens',
      ),
    ];
  }

  /// Returns true if all scheduled legal reviews are approved for General Availability.
  bool isClearedForGeneralAvailability(List<LegalReviewScheduleEntry> schedule) {
    if (schedule.isEmpty) return false;
    return schedule.every((entry) => entry.status == LegalReviewStatus.approved);
  }
}
