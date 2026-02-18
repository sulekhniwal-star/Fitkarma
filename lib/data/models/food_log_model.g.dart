// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodLogModel _$FoodLogModelFromJson(Map<String, dynamic> json) => FoodLogModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      itemName: json['itemName'] as String,
      calories: (json['calories'] as num).toDouble(),
      macros: json['macros'] as Map<String, dynamic>?,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$FoodLogModelToJson(FoodLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'itemName': instance.itemName,
      'calories': instance.calories,
      'macros': instance.macros,
      'date': instance.date.toIso8601String(),
    };
