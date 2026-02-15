import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_log.freezed.dart';
part 'weight_log.g.dart';

@freezed
abstract class WeightLog with _$WeightLog {
  const factory WeightLog({
    required String id,
    required String userId,
    required DateTime date,
    required double weight, // in kg
    String? note,
    String? photo,
    double? bodyFatPercentage,
    double? muscleMass,
    BodyMeasurements? measurements,
    String? mood, // happy, neutral, sad, motivated, frustrated
    @Default(false) bool isSynced,
  }) = _WeightLog;

  const WeightLog._();

  factory WeightLog.fromJson(Map<String, dynamic> json) =>
      _$WeightLogFromJson(json);


  // Get weight in pounds
  double get weightInLbs => weight * 2.20462;

  // Format weight display
  String get weightDisplay => '${weight.toStringAsFixed(1)} kg';

  // Format weight in lbs display
  String get weightInLbsDisplay => '${weightInLbs.toStringAsFixed(1)} lbs';

  // Calculate BMI (requires height from user profile)
  double calculateBMI(double heightCm) {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100;
    return weight / (heightM * heightM);
  }

  // Get BMI category
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // Get mood emoji
  String? get moodEmoji {
    return switch (mood?.toLowerCase()) {
      'happy' => '😊',
      'neutral' => '😐',
      'sad' => '😢',
      'motivated' => '💪',
      'frustrated' => '😤',
      _ => null,
    };
  }
}

@freezed
abstract class WeightGoals with _$WeightGoals {
  const factory WeightGoals({
    required String id,
    required String userId,
    double? startWeight,
    double? currentWeight,
    double? goalWeight,
    @Default('maintain') String goalType, // lose, maintain, gain
    @Default(0.5) double weeklyGoalKg,
    @Default(true) bool reminderEnabled,
    @Default('weekly') String reminderDay, // daily, weekly
    @Default('08:00') String reminderTime,
    @Default(true) bool photoReminders,
    @Default(true) bool notificationsEnabled,
  }) = _WeightGoals;

  const WeightGoals._();

  factory WeightGoals.fromJson(Map<String, dynamic> json) =>
      _$WeightGoalsFromJson(json);


  // Calculate progress towards goal
  double? get progressPercentage {
    if (startWeight == null || goalWeight == null || currentWeight == null) {
      return null;
    }
    
    final totalChange = (goalWeight! - startWeight!).abs();
    if (totalChange == 0) return 1.0;
    
    final currentChange = (currentWeight! - startWeight!).abs();
    return (currentChange / totalChange).clamp(0.0, 1.0);
  }

  // Calculate remaining weight to lose/gain
  double? get remainingWeight {
    if (currentWeight == null || goalWeight == null) return null;
    return (goalWeight! - currentWeight!).abs();
  }

  // Get goal display text
  String get goalDisplay {
    return switch (goalType.toLowerCase()) {
      'lose' => 'Lose ${weeklyGoalKg}kg/week',
      'gain' => 'Gain ${weeklyGoalKg}kg/week',
      _ => 'Maintain weight',
    };
  }

  // Estimate weeks to reach goal
  int? get estimatedWeeksToGoal {
    if (remainingWeight == null || weeklyGoalKg == 0) return null;
    return (remainingWeight! / weeklyGoalKg).ceil();
  }
}

@freezed
abstract class BodyMeasurements with _$BodyMeasurements {
  const factory BodyMeasurements({
    double? chest,
    double? waist,
    double? hips,
    double? arms,
    double? thighs,
  }) = _BodyMeasurements;

  const BodyMeasurements._();

  factory BodyMeasurements.fromJson(Map<String, dynamic> json) =>
      _$BodyMeasurementsFromJson(json);


  // Check if any measurements exist
  bool get hasMeasurements =>
      chest != null ||
      waist != null ||
      hips != null ||
      arms != null ||
      thighs != null;

  // Get measurement summary
  String get summary {
    final parts = <String>[];
    if (chest != null) parts.add('Chest: ${chest!.toStringAsFixed(1)}cm');
    if (waist != null) parts.add('Waist: ${waist!.toStringAsFixed(1)}cm');
    if (hips != null) parts.add('Hips: ${hips!.toStringAsFixed(1)}cm');
    return parts.join(', ');
  }
}

// Weight trend data for charts
@freezed
abstract class WeightTrend with _$WeightTrend {
  const factory WeightTrend({
    required DateTime date,
    required double weight,
    double? movingAverage,
    double? changeFromPrevious,
  }) = _WeightTrend;

  factory WeightTrend.fromJson(Map<String, dynamic> json) =>
      _$WeightTrendFromJson(json);
}
