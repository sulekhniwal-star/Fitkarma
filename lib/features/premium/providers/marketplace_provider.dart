// §P13-B Creator & Coach Marketplace Riverpod Notifier
// Cross-reference: §P13-B in Fitkarma_documentation.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/double_entry_ledger_engine.dart';
import '../models/creator_marketplace_models.dart';

class MarketplaceState {
  final List<CreatorProfile> coaches;
  final List<BlueprintProgram> blueprints;
  final List<CoachClientAssignment> activeAssignments;
  final UserProfile clientProfile;
  final int selectedTab; // 0 = Coaches, 1 = Blueprints
  final DoubleEntryLedgerEngine ledger;
  final String? purchaseStatusMessage;

  const MarketplaceState({
    required this.coaches,
    required this.blueprints,
    required this.activeAssignments,
    required this.clientProfile,
    this.selectedTab = 0,
    required this.ledger,
    this.purchaseStatusMessage,
  });

  List<CreatorProfile> get matchedCoaches {
    const matcher = CoachMatchingEngine();
    return matcher.match(client: clientProfile, allCoaches: coaches);
  }

  MarketplaceState copyWith({
    List<CreatorProfile>? coaches,
    List<BlueprintProgram>? blueprints,
    List<CoachClientAssignment>? activeAssignments,
    UserProfile? clientProfile,
    int? selectedTab,
    DoubleEntryLedgerEngine? ledger,
    String? purchaseStatusMessage,
  }) {
    return MarketplaceState(
      coaches: coaches ?? this.coaches,
      blueprints: blueprints ?? this.blueprints,
      activeAssignments: activeAssignments ?? this.activeAssignments,
      clientProfile: clientProfile ?? this.clientProfile,
      selectedTab: selectedTab ?? this.selectedTab,
      ledger: ledger ?? this.ledger,
      purchaseStatusMessage:
          purchaseStatusMessage ?? this.purchaseStatusMessage,
    );
  }
}

class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  MarketplaceNotifier()
      : super(
          MarketplaceState(
            coaches: _seedCoaches,
            blueprints: _seedBlueprints,
            activeAssignments: const [],
            clientProfile: const UserProfile(
              userId: 'user_current',
              name: 'Aarav Sharma',
              goals: ['weight_loss', 'pcos'],
              dietType: 'Vegetarian',
            ),
            ledger: DoubleEntryLedgerEngine(),
          ),
        );

  static final List<CreatorProfile> _seedCoaches = [
    const CreatorProfile(
      creatorId: 'coach_ananya',
      name: 'Dr. Ananya Iyer',
      bio:
          'Clinical Nutritionist & CSCS Coach specializing in Indian PCOS & hormonal reset protocols.',
      certifications: ['CSCS', 'M.Sc Clinical Nutrition', 'ACE Certified'],
      specialties: [
        CoachSpecialty.pcosManagement,
        CoachSpecialty.muscleBuilding
      ],
      averageRating: 4.95,
      activeClientsCount: 42,
      monthlyCoachingRateInr: 2999.0,
      isVerified: true,
    ),
    const CreatorProfile(
      creatorId: 'coach_rohit',
      name: 'Rohit Deshmukh',
      bio:
          'Hypertrophy and strength specialist. 10+ years coaching national powerlifters and desk athletes.',
      certifications: ['ACSM-CPT', 'NSCA Strength Specialist'],
      specialties: [CoachSpecialty.muscleBuilding],
      averageRating: 4.88,
      activeClientsCount: 65,
      monthlyCoachingRateInr: 2499.0,
      isVerified: true,
    ),
    const CreatorProfile(
      creatorId: 'coach_simran',
      name: 'Simran Kaur',
      bio:
          'Endurance athlete & certified marathon coach. Specialized in sub-4hr marathon preparation.',
      certifications: ['RRCA Marathon Coach', 'Precision Nutrition L2'],
      specialties: [CoachSpecialty.runningMarathon],
      averageRating: 4.92,
      activeClientsCount: 28,
      monthlyCoachingRateInr: 1999.0,
      isVerified: true,
    ),
    const CreatorProfile(
      creatorId: 'coach_vijay',
      name: 'Dr. Vijay Kulkarni',
      bio:
          'Metabolic physician & lifestyle coach specializing in Type-2 diabetes reversal and insulin resistance.',
      certifications: ['MBBS', 'Fellowship in Diabetology'],
      specialties: [
        CoachSpecialty.diabeticReversal,
        CoachSpecialty.pcosManagement
      ],
      averageRating: 4.98,
      activeClientsCount: 50,
      monthlyCoachingRateInr: 3499.0,
      isVerified: true,
    ),
  ];

  static final List<BlueprintProgram> _seedBlueprints = [
    const BlueprintProgram(
      programId: 'bp_navratri_90',
      creatorId: 'coach_ananya',
      creatorName: 'Dr. Ananya Iyer',
      title: 'Navratri Fasting & Fat Loss Blueprint',
      durationWeeks: 6,
      priceInr: 499.0,
      description:
          'Structured 6-week progressive program maintaining protein goals through traditional Indian fasting dishes.',
      tags: ['Fasting', 'PCOS', 'Vegetarian'],
    ),
    const BlueprintProgram(
      programId: 'bp_desk_to_5k',
      creatorId: 'coach_simran',
      creatorName: 'Simran Kaur',
      title: 'Desk Athlete to 10K Blueprint',
      durationWeeks: 8,
      priceInr: 699.0,
      description:
          'Postural correction + gradual cardiovascular base building designed for Indian corporate professionals.',
      tags: ['Running', 'Cardio', 'Mobility'],
    ),
    const BlueprintProgram(
      programId: 'bp_hypertrophy_pure',
      creatorId: 'coach_rohit',
      creatorName: 'Rohit Deshmukh',
      title: '12-Week Desi Gym Hypertrophy Matrix',
      durationWeeks: 12,
      priceInr: 999.0,
      description:
          'Periodized RPE progression with vegetarian protein substitution guides for standard commercial gym setups.',
      tags: ['Strength', 'Hypertrophy', 'Gym'],
    ),
  ];

  void selectTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  /// Purchases a monthly 1:1 coaching package and writes balanced journal entries to ledger
  void purchaseCoaching(CreatorProfile coach) {
    final txId = 'tx_coach_${DateTime.now().millisecondsSinceEpoch}';
    state.ledger.recordCoachingPurchase(
      txId: txId,
      grossAmountInr: coach.monthlyCoachingRateInr,
      creatorId: coach.creatorId,
    );

    final assignment = CoachClientAssignment(
      assignmentId: 'assign_${DateTime.now().millisecondsSinceEpoch}',
      coachUserId: coach.creatorId,
      clientUserId: state.clientProfile.userId,
      activeFrom: DateTime.now(),
      activeUntil: DateTime.now().add(const Duration(days: 30)),
      hasWritePermission: true,
    );

    state = state.copyWith(
      activeAssignments: [...state.activeAssignments, assignment],
      purchaseStatusMessage:
          '🎉 Assigned to ${coach.name}! Escrow secured for 7 days.',
    );
  }

  /// Purchases a user-generated blueprint program
  void purchaseBlueprint(BlueprintProgram blueprint) {
    final txId = 'tx_bp_${DateTime.now().millisecondsSinceEpoch}';
    state.ledger.recordCoachingPurchase(
      txId: txId,
      grossAmountInr: blueprint.priceInr,
      creatorId: blueprint.creatorId,
    );

    state = state.copyWith(
      purchaseStatusMessage:
          'Unlocked "${blueprint.title}"! Added to your workouts.',
    );
  }
}

final marketplaceProvider =
    StateNotifierProvider<MarketplaceNotifier, MarketplaceState>((ref) {
  return MarketplaceNotifier();
});
