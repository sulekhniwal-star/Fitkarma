import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/food_log_entity.dart';

part 'food_log_model.g.dart';

@JsonSerializable()
class FoodLogModel extends FoodLogEntity {
  const FoodLogModel({
    required super.id,
    required super.userId,
    required super.itemName,
    required super.calories,
    super.macros,
    required super.date,
  });

  factory FoodLogModel.fromJson(Map<String, dynamic> json) =>
      _$FoodLogModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodLogModelToJson(this);

  factory FoodLogModel.fromEntity(FoodLogEntity entity) {
    return FoodLogModel(
      id: entity.id,
      userId: entity.userId,
      itemName: entity.itemName,
      calories: entity.calories,
      macros: entity.macros,
      date: entity.date,
    );
  }
}
