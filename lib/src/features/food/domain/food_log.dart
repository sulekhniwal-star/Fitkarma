import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_log.freezed.dart';
part 'food_log.g.dart';

@freezed
abstract class FoodLog with _$FoodLog {
  const factory FoodLog({
    required String id,
    required String userId,
    required String foodItemId,
    String? foodItemName, // Cached for display
    required String mealType, // breakfast, lunch, dinner, snack
    required double servings,
    required DateTime date,
    String? photo,
    String? note,
    // Cached nutrition values (in case food item changes later)
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? fiber,
    double? sugar,
    double? sodium,
  }) = _FoodLog;

  const FoodLog._();

  factory FoodLog.fromJson(Map<String, dynamic> json) =>
      _$FoodLogFromJson(json);

  // Get total nutrition for this log entry
  Map<String, double> get totalNutrition {
    final multiplier = servings;
    return {
      'calories': (calories ?? 0) * multiplier,
      'protein': (protein ?? 0) * multiplier,
      'carbs': (carbs ?? 0) * multiplier,
      'fats': (fats ?? 0) * multiplier,
      'fiber': (fiber ?? 0) * multiplier,
      'sugar': (sugar ?? 0) * multiplier,
      'sodium': (sodium ?? 0) * multiplier,
    };
  }
}
