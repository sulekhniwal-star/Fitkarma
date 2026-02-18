import 'package:dartz/dartz.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/workout_entity.dart';
import 'package:fit_karma/domain/repositories/workout_repository.dart';
import '../models/workout_model.dart';
import '../../core/utils/logger.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final PocketBase pb;

  WorkoutRepositoryImpl({required this.pb});

  @override
  Future<Either<Failure, void>> logWorkout(WorkoutEntity workout) async {
    try {
      final model = WorkoutModel.fromEntity(workout);
      final body = {
        "user": model.userId,
        "title": model.title,
        "exercises": model.exercises.map((e) => e.toJson()).toList(),
        "date": model.date.toIso8601String(),
        "duration_minutes": model.durationMinutes,
      };
      await pb.collection('workouts').create(body: body);
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error('Workout logging failed', e, stack);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutEntity>>> getWorkouts(
    String userId,
  ) async {
    try {
      final records = await pb
          .collection('workouts')
          .getList(filter: 'user = "$userId"', sort: '-date');
      final workouts = records.items
          .map((r) => WorkoutModel.fromJson(r.toJson()))
          .toList();
      return Right(workouts);
    } catch (e, stack) {
      AppLogger.error('Fetching workouts failed', e, stack);
      return Left(ServerFailure(e.toString()));
    }
  }
}
