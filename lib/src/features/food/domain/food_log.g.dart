// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodLog _$FoodLogFromJson(Map<String, dynamic> json) => _FoodLog(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  foodItemId: json['food_item_id'] as String,
  foodItemName: json['food_item_name'] as String?,
  mealType: json['meal_type'] as String,
  servings: (json['servings'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  photo: json['photo'] as String?,
  note: json['note'] as String?,
  calories: (json['calories'] as num?)?.toDouble(),
  protein: (json['protein'] as num?)?.toDouble(),
  carbs: (json['carbs'] as num?)?.toDouble(),
  fats: (json['fats'] as num?)?.toDouble(),
  fiber: (json['fiber'] as num?)?.toDouble(),
  sugar: (json['sugar'] as num?)?.toDouble(),
  sodium: (json['sodium'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FoodLogToJson(_FoodLog instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'food_item_id': instance.foodItemId,
  'food_item_name': instance.foodItemName,
  'meal_type': instance.mealType,
  'servings': instance.servings,
  'date': instance.date.toIso8601String(),
  'photo': instance.photo,
  'note': instance.note,
  'calories': instance.calories,
  'protein': instance.protein,
  'carbs': instance.carbs,
  'fats': instance.fats,
  'fiber': instance.fiber,
  'sugar': instance.sugar,
  'sodium': instance.sodium,
};
