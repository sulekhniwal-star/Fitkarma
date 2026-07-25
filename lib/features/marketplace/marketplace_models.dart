/// §P13-B Creator & Coach Marketplace — Domain Models
///
/// Models for CreatorProfile, CoachSpecialty, ProgramBlueprint, CoachClientAssignment, and WalletLedger matching §P13-B spec.
library;

enum CoachSpecialty {
  pcosManagement,
  muscleBuilding,
  diabeticReversal,
  runningMarathon,
  weightLoss,
  generalFitness;

  String get displayName => switch (this) {
        pcosManagement => 'PCOS Management',
        muscleBuilding => 'Muscle Building',
        diabeticReversal => 'Diabetic Reversal',
        runningMarathon => 'Marathon Running',
        weightLoss => 'Weight Loss',
        generalFitness => 'General Fitness',
      };
}

class CreatorProfile {
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
  });

  final String creatorId;
  final String name;
  final String bio;
  final List<String> certifications;
  final List<CoachSpecialty> specialties;
  final double averageRating;
  final int activeClientsCount;
  final double monthlyCoachingRateInr;
  final bool isVerified;
}

class ProgramBlueprint {
  const ProgramBlueprint({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.title,
    required this.description,
    required this.priceInr,
    required this.durationWeeks,
    required this.specialty,
    required this.rating,
    required this.purchasedCount,
  });

  final String id;
  final String creatorId;
  final String creatorName;
  final String title;
  final String description;
  final double priceInr;
  final int durationWeeks;
  final CoachSpecialty specialty;
  final double rating;
  final int purchasedCount;
}

class CoachClientAssignment {
  const CoachClientAssignment({
    required this.assignmentId,
    required this.coachUserId,
    required this.clientUserId,
    required this.activeFrom,
    this.activeUntil,
    this.hasWritePermission = true,
  });

  final String assignmentId;
  final String coachUserId;
  final String clientUserId;
  final DateTime activeFrom;
  final DateTime? activeUntil;
  final bool hasWritePermission;
}

class LedgerEntry {
  const LedgerEntry({
    required this.entryId,
    required this.transactionType,
    required this.grossAmountInr,
    required this.creatorEarningsInr,
    required this.platformFeeInr,
    required this.timestamp,
  });

  final String entryId;
  final String transactionType; // 'program_sale' or 'coaching_subscription'
  final double grossAmountInr;
  final double creatorEarningsInr; // 80%
  final double platformFeeInr; // 20%
  final DateTime timestamp;
}

class WalletLedger {
  const WalletLedger({
    required this.walletId,
    required this.creatorId,
    required this.balanceInr,
    required this.totalEarningsInr,
    required this.pendingPayoutInr,
    required this.entries,
  });

  final String walletId;
  final String creatorId;
  final double balanceInr;
  final double totalEarningsInr;
  final double pendingPayoutInr;
  final List<LedgerEntry> entries;
}
