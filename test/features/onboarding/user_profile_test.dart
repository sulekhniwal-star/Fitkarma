import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/onboarding/models/user_profile.dart';

void main() {
  group('UserProfile Local Metabolic Calculations Test', () {
    test('BMI calculation matches standard formula', () {
      const profile = UserProfile(
        heightCm: 170.0,
        weightKg: 70.0,
      );

      // BMI = 70 / (1.7 * 1.7) = 24.2214...
      expect(profile.bmi, closeTo(24.22, 0.01));
    });

    test('BMR calculation matches Mifflin-St Jeor formula for Male', () {
      const profile = UserProfile(
        age: 25,
        gender: Gender.male,
        heightCm: 175.0,
        weightKg: 75.0,
      );

      // BMR = (10 * 75) + (6.25 * 175) - (5 * 25) + 5
      // BMR = 750 + 1093.75 - 125 + 5 = 1723.75
      expect(profile.bmr, equals(1723.75));
    });

    test('BMR calculation matches Mifflin-St Jeor formula for Female', () {
      const profile = UserProfile(
        age: 30,
        gender: Gender.female,
        heightCm: 160.0,
        weightKg: 60.0,
      );

      // BMR = (10 * 60) + (6.25 * 160) - (5 * 30) - 161
      // BMR = 600 + 1000 - 150 - 161 = 1289.0
      expect(profile.bmr, equals(1289.0));
    });

    test('TDEE and Target Calories adjust based on activity level & goal', () {
      const profile = UserProfile(
        age: 25,
        gender: Gender.male,
        heightCm: 175.0,
        weightKg: 75.0,
        activityLevel: ActivityLevel.moderatelyActive, // 1.55 multiplier
        primaryGoal: PrimaryGoal.weightLoss, // TDEE - 400
      );

      // TDEE = 1723.75 * 1.55 = 2671.8125
      expect(profile.tdee, closeTo(2671.81, 0.01));
      // Target Calories = 2672 - 400 = 2272
      expect(profile.targetCalories, equals(2272));
    });
  });
}
