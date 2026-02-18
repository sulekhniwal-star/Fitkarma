import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/steps_entity.dart';

abstract class FitnessRepository {
  Future<Either<Failure, void>> syncSteps(StepsEntity steps);
  Future<Either<Failure, List<StepsEntity>>> getLocalSteps();
  Future<Either<Failure, void>> saveLocalSteps(StepsEntity steps);
}
