import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final List<ExerciseEntity> exercises;
  final DateTime date;
  final int durationMinutes;

  const WorkoutEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.exercises,
    required this.date,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    exercises,
    date,
    durationMinutes,
  ];
}

class ExerciseEntity extends Equatable {
  final String name;
  final int sets;
  final int reps;
  final double? weight;

  const ExerciseEntity({
    required this.name,
    required this.sets,
    required this.reps,
    this.weight,
  });

  @override
  List<Object?> get props => [name, sets, reps, weight];
}
