import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/workout_entity.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, void>> logWorkout(WorkoutEntity workout);
  Future<Either<Failure, List<WorkoutEntity>>> getWorkouts(String userId);
}
