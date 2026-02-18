import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/workout_entity.dart';

part 'workout_model.g.dart';

@JsonSerializable()
class WorkoutModel extends WorkoutEntity {
  @override
  final List<ExerciseModel> exercises;

  const WorkoutModel({
    required super.id,
    required super.userId,
    required super.title,
    required this.exercises,
    required super.date,
    required super.durationMinutes,
  }) : super(exercises: exercises);

  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutModelToJson(this);

  factory WorkoutModel.fromEntity(WorkoutEntity entity) {
    return WorkoutModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      exercises: entity.exercises
          .map((e) => ExerciseModel.fromEntity(e))
          .toList(),
      date: entity.date,
      durationMinutes: entity.durationMinutes,
    );
  }
}

@JsonSerializable()
class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.name,
    required super.sets,
    required super.reps,
    super.weight,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);

  factory ExerciseModel.fromEntity(ExerciseEntity entity) {
    return ExerciseModel(
      name: entity.name,
      sets: entity.sets,
      reps: entity.reps,
      weight: entity.weight,
    );
  }
}
