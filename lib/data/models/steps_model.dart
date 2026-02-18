import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/steps_entity.dart';
import 'package:hive/hive.dart';

part 'steps_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class StepsModel extends StepsEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String userId;

  @HiveField(2)
  @override
  final int count;

  @HiveField(3)
  @override
  final DateTime date;

  const StepsModel({
    required this.id,
    required this.userId,
    required this.count,
    required this.date,
  }) : super(id: id, userId: userId, count: count, date: date);

  factory StepsModel.fromJson(Map<String, dynamic> json) =>
      _$StepsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StepsModelToJson(this);

  factory StepsModel.fromEntity(StepsEntity entity) {
    return StepsModel(
      id: entity.id,
      userId: entity.userId,
      count: entity.count,
      date: entity.date,
    );
  }
}
