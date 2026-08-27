import 'onboarding_flow_step.dart';
import '../../metabolism/domain/adaptive_metabolism_engine.dart';

class OnboardingState {
  final OnboardingFlowStep currentStep;
  final List<String> selectedGoals;
  final double weightKg;
  final double heightCm;
  final int age;
  final BiologicalSex sex;
  final NutritionGoal nutritionGoal;
  final String primaryDosha; // Vata, Pitta, Kapha
  final bool isPcosAware;
  final String selectedBlueprintId;
  final bool isCompleted;

  const OnboardingState({
    this.currentStep = OnboardingFlowStep.welcome,
    this.selectedGoals = const [],
    this.weightKg = 70.0,
    this.heightCm = 172.0,
    this.age = 26,
    this.sex = BiologicalSex.male,
    this.nutritionGoal = NutritionGoal.fatLoss,
    this.primaryDosha = 'Pitta',
    this.isPcosAware = false,
    this.selectedBlueprintId = 'blueprint_full_body_starter',
    this.isCompleted = false,
  });

  // Derived BMI
  double get bmi {
    final heightM = heightCm / 100.0;
    if (heightM <= 0) return 22.0;
    return weightKg / (heightM * heightM);
  }

  OnboardingState copyWith({
    OnboardingFlowStep? currentStep,
    List<String>? selectedGoals,
    double? weightKg,
    double? heightCm,
    int? age,
    BiologicalSex? sex,
    NutritionGoal? nutritionGoal,
    String? primaryDosha,
    bool? isPcosAware,
    String? selectedBlueprintId,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      nutritionGoal: nutritionGoal ?? this.nutritionGoal,
      primaryDosha: primaryDosha ?? this.primaryDosha,
      isPcosAware: isPcosAware ?? this.isPcosAware,
      selectedBlueprintId: selectedBlueprintId ?? this.selectedBlueprintId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedGoals': selectedGoals,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'age': age,
      'sex': sex.name,
      'nutritionGoal': nutritionGoal.name,
      'primaryDosha': primaryDosha,
      'isPcosAware': isPcosAware,
      'selectedBlueprintId': selectedBlueprintId,
      'isCompleted': isCompleted,
      'bmi': bmi,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
