import 'package:fit_karma/domain/repositories/fitness_repository.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/steps_entity.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hive/hive.dart';
import '../models/steps_model.dart';

class FitnessRepositoryImpl implements FitnessRepository {
  final PocketBase pb;
  final Box<StepsModel> stepsBox;

  FitnessRepositoryImpl({required this.pb, required this.stepsBox});

  @override
  Future<Either<Failure, void>> syncSteps(StepsEntity steps) async {
    try {
      final body = {
        "user": steps.userId,
        "count": steps.count,
        "date": steps.date.toIso8601String(),
      };
      await pb.collection('steps').create(body: body);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StepsEntity>>> getLocalSteps() async {
    try {
      final steps = stepsBox.values.toList();
      return Right(steps);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveLocalSteps(StepsEntity steps) async {
    try {
      final model = StepsModel.fromEntity(steps);
      await stepsBox.put(steps.id, model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
