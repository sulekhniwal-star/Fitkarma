// §P13-B Creator Profile, Matchmaking & Program Schemas (NEW v1)
// Cross-reference: §P13-B in Fitkarma_documentation.md

enum CoachSpecialty {
  pcosManagement,
  muscleBuilding,
  diabeticReversal,
  runningMarathon;

  String get displayName {
    switch (this) {
      case CoachSpecialty.pcosManagement:
        return 'PCOS & Hormonal Health';
      case CoachSpecialty.muscleBuilding:
        return 'Hypertrophy & Strength';
      case CoachSpecialty.diabeticReversal:
        return 'Diabetes & Insulin Reversal';
      case CoachSpecialty.runningMarathon:
        return 'Endurance & Marathon';
    }
  }
}

class CreatorProfile {
  final String creatorId;
  final String name;
  final String bio;
  final List<String> certifications;
  final List<CoachSpecialty> specialties;
  final double averageRating;
  final int activeClientsCount;
  final double monthlyCoachingRateInr; // e.g. 2999.0
  final bool isVerified;
  final String avatarUrl;

  const CreatorProfile({
    required this.creatorId,
    required this.name,
    required this.bio,
    required this.certifications,
    required this.specialties,
    required this.averageRating,
    required this.activeClientsCount,
    required this.monthlyCoachingRateInr,
    this.isVerified = true,
    this.avatarUrl = '',
  });

  String get formattedMonthlyRate =>
      '₹${monthlyCoachingRateInr.toStringAsFixed(0)} / mo';
}

class UserProfile {
  final String userId;
  final String name;
  final List<String> goals;
  final String dietType;

  const UserProfile({
    required this.userId,
    required this.name,
    required this.goals,
    required this.dietType,
  });
}

class CoachClientAssignment {
  final String assignmentId;
  final String coachUserId;
  final String clientUserId;
  final DateTime activeFrom;
  final DateTime? activeUntil;
  final bool hasWritePermission; // Allows the coach to override client's Daily Targets

  const CoachClientAssignment({
    required this.assignmentId,
    required this.coachUserId,
    required this.clientUserId,
    required this.activeFrom,
    this.activeUntil,
    this.hasWritePermission = true,
  });
}

class BlueprintProgram {
  final String programId;
  final String creatorId;
  final String creatorName;
  final String title;
  final int durationWeeks;
  final double priceInr;
  final String description;
  final List<String> tags;
  final bool isPublished;

  const BlueprintProgram({
    required this.programId,
    required this.creatorId,
    required this.creatorName,
    required this.title,
    required this.durationWeeks,
    required this.priceInr,
    required this.description,
    this.tags = const [],
    this.isPublished = true,
  });

  String get formattedPrice => '₹${priceInr.toStringAsFixed(0)}';
}

class DisputeRecord {
  final String disputeId;
  final String txId;
  final String clientUserId;
  final String coachUserId;
  final String disputeReason;
  final DateTime timestamp;
  final bool isRefunded;

  const DisputeRecord({
    required this.disputeId,
    required this.txId,
    required this.clientUserId,
    required this.coachUserId,
    required this.disputeReason,
    required this.timestamp,
    this.isRefunded = false,
  });
}
