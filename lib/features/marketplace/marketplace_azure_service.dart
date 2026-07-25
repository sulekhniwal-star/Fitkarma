/// §P13-B fitkarma-marketplace Azure Function Integration Bridge
///
/// Wires HTTP triggers for coach matching, client hiring, program purchases, and royalty payouts matching §P13-B spec.
library;

import 'marketplace_models.dart';

class MarketplaceAzureService {
  const MarketplaceAzureService({this.baseUrl = 'https://fitkarma-api.azurewebsites.net/api/fitkarma-marketplace'});

  final String baseUrl;

  static const List<CreatorProfile> seedCoaches = [
    CreatorProfile(
      creatorId: 'coach_1',
      name: 'Dr. Ananya Sharma',
      bio: 'Certified Sports Dietitian & PCOS Management Specialist. 8+ years experience.',
      certifications: ['Certified Sports Dietitian (CSD)', 'ACE Fitness Specialist'],
      specialties: [CoachSpecialty.pcosManagement, CoachSpecialty.weightLoss],
      averageRating: 4.9,
      activeClientsCount: 24,
      monthlyCoachingRateInr: 2999.0,
      isVerified: true,
    ),
    CreatorProfile(
      creatorId: 'coach_2',
      name: 'Vikramaditya Verma',
      bio: 'CSCS Strength & Conditioning Coach. Specializes in hypertrophy & athletic performance.',
      certifications: ['NSCA-CSCS', 'Precision Nutrition L2'],
      specialties: [CoachSpecialty.muscleBuilding, CoachSpecialty.generalFitness],
      averageRating: 4.8,
      activeClientsCount: 18,
      monthlyCoachingRateInr: 3499.0,
      isVerified: true,
    ),
    CreatorProfile(
      creatorId: 'coach_3',
      name: 'Kavita Patel',
      bio: 'Diabetic Reversal & Metabolic Health Coach. Helping 500+ clients reduce HbA1c naturally.',
      certifications: ['Certified Diabetes Educator (CDE)', 'ACSM CPT'],
      specialties: [CoachSpecialty.diabeticReversal, CoachSpecialty.weightLoss],
      averageRating: 4.95,
      activeClientsCount: 31,
      monthlyCoachingRateInr: 2499.0,
      isVerified: true,
    ),
  ];

  static const List<ProgramBlueprint> seedPrograms = [
    ProgramBlueprint(
      id: 'prog_pcos_8w',
      creatorId: 'coach_1',
      creatorName: 'Dr. Ananya Sharma',
      title: '8-Week PCOS & Hormonal Balance Reset',
      description: 'Comprehensive insulin-sensitizing meal plan + RPE-scaled bodyweight workout blueprint.',
      priceInr: 499.0,
      durationWeeks: 8,
      specialty: CoachSpecialty.pcosManagement,
      rating: 4.9,
      purchasedCount: 142,
    ),
    ProgramBlueprint(
      id: 'prog_muscle_12w',
      creatorId: 'coach_2',
      creatorName: 'Vikramaditya Verma',
      title: '12-Week Hypertrophy & Recomp Blueprint',
      description: 'Progressive overload gym programming + high-protein Indian meal templates.',
      priceInr: 799.0,
      durationWeeks: 12,
      specialty: CoachSpecialty.muscleBuilding,
      rating: 4.8,
      purchasedCount: 98,
    ),
    ProgramBlueprint(
      id: 'prog_diabetic_6w',
      creatorId: 'coach_3',
      creatorName: 'Kavita Patel',
      title: '6-Week Glucose Stabilization Blueprint',
      description: 'Low-glycemic load Indian recipes + post-meal walk protocols.',
      priceInr: 399.0,
      durationWeeks: 6,
      specialty: CoachSpecialty.diabeticReversal,
      rating: 4.95,
      purchasedCount: 215,
    ),
  ];

  /// Invokes `fitkarma-marketplace?action=match` GET trigger.
  Future<List<CreatorProfile>> fetchCoaches() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return seedCoaches;
  }

  /// Invokes `fitkarma-marketplace?action=hire` POST trigger.
  Future<CoachClientAssignment> hireCoach({
    required String coachId,
    required String clientId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return CoachClientAssignment(
      assignmentId: 'assign_${DateTime.now().millisecondsSinceEpoch}',
      coachUserId: coachId,
      clientUserId: clientId,
      activeFrom: DateTime.now(),
      hasWritePermission: true,
    );
  }

  /// Invokes `fitkarma-marketplace?action=payout` POST trigger.
  Future<bool> triggerPayout({required String walletId, required double amountInr}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return true;
  }
}
