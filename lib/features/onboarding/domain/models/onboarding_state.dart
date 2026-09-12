import '../../../metabolism/services/metabolism_engine.dart';
import '../services/dosha_scoring_engine.dart';
import '../services/womens_health_engine.dart';

enum ProgramBlueprint {
  strengthPower,
  hypertrophyAesthetics,
  metabolicConditioning,
  mobilityLongevity,
}

/// Immutable Onboarding State
class OnboardingState {
  final int currentStep;
  final Goal? goal;
  final Gender gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activityLevel;
  final DoshaProfile? doshaProfile;
  final ProgramBlueprint? selectedBlueprint;
  final bool enableWomensHealth;
  final CycleProfile? cycleProfile;
  final bool isSubmitting;

  const OnboardingState({
    this.currentStep = 0,
    this.goal = Goal.fatLoss,
    this.gender = Gender.male,
    this.age = 26,
    this.heightCm = 172.0,
    this.weightKg = 70.0,
    this.activityLevel = ActivityLevel.moderate,
    this.doshaProfile,
    this.selectedBlueprint = ProgramBlueprint.hypertrophyAesthetics,
    this.enableWomensHealth = false,
    this.cycleProfile,
    this.isSubmitting = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    Goal? goal,
    Gender? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    ActivityLevel? activityLevel,
    DoshaProfile? doshaProfile,
    ProgramBlueprint? selectedBlueprint,
    bool? enableWomensHealth,
    CycleProfile? cycleProfile,
    bool? isSubmitting,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      goal: goal ?? this.goal,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      doshaProfile: doshaProfile ?? this.doshaProfile,
      selectedBlueprint: selectedBlueprint ?? this.selectedBlueprint,
      enableWomensHealth: enableWomensHealth ?? this.enableWomensHealth,
      cycleProfile: cycleProfile ?? this.cycleProfile,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
