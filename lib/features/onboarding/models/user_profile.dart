enum Gender { male, female, other }

enum PrimaryGoal { weightLoss, muscleGain, stamina, maintenance }

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive
}

enum DietaryPreference { pureVeg, nonVeg, eggetarian, jain, vegan }

enum DoshaType { vata, pitta, kapha, tridoshic }

/// User Profile Model containing biometrics & local metabolic calculations
class UserProfile {
  final String name;
  final int age;
  final Gender gender;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final PrimaryGoal primaryGoal;
  final ActivityLevel activityLevel;
  final DietaryPreference dietaryPreference;
  final DoshaType doshaType;

  const UserProfile({
    this.name = '',
    this.age = 25,
    this.gender = Gender.male,
    this.heightCm = 170.0,
    this.weightKg = 70.0,
    this.targetWeightKg = 65.0,
    this.primaryGoal = PrimaryGoal.weightLoss,
    this.activityLevel = ActivityLevel.moderatelyActive,
    this.dietaryPreference = DietaryPreference.pureVeg,
    this.doshaType = DoshaType.tridoshic,
  });

  /// Calculate Body Mass Index (BMI)
  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  /// Calculate Basal Metabolic Rate (BMR) using Mifflin-St Jeor Equation
  double get bmr {
    final genderOffset = (gender == Gender.female) ? -161 : 5;
    return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + genderOffset;
  }

  /// Calculate Total Daily Energy Expenditure (TDEE)
  double get tdee {
    double multiplier;
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        multiplier = 1.2;
        break;
      case ActivityLevel.lightlyActive:
        multiplier = 1.375;
        break;
      case ActivityLevel.moderatelyActive:
        multiplier = 1.55;
        break;
      case ActivityLevel.veryActive:
        multiplier = 1.725;
        break;
      case ActivityLevel.extraActive:
        multiplier = 1.9;
        break;
    }
    return bmr * multiplier;
  }

  /// Target Daily Calories based on Goal
  int get targetCalories {
    switch (primaryGoal) {
      case PrimaryGoal.weightLoss:
        return (tdee - 400).round();
      case PrimaryGoal.muscleGain:
        return (tdee + 350).round();
      case PrimaryGoal.stamina:
      case PrimaryGoal.maintenance:
        return tdee.round();
    }
  }

  /// Protein target in grams
  int get targetProteinGrams {
    switch (primaryGoal) {
      case PrimaryGoal.muscleGain:
        return (weightKg * 2.0).round();
      case PrimaryGoal.weightLoss:
        return (weightKg * 1.8).round();
      default:
        return (weightKg * 1.4).round();
    }
  }

  UserProfile copyWith({
    String? name,
    int? age,
    Gender? gender,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    PrimaryGoal? primaryGoal,
    ActivityLevel? activityLevel,
    DietaryPreference? dietaryPreference,
    DoshaType? doshaType,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      doshaType: doshaType ?? this.doshaType,
    );
  }
}
