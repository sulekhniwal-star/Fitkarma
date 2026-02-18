import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/food_log_entity.dart';

abstract class FoodRepository {
  Future<Either<Failure, List<FoodLogEntity>>> searchFood(String query);
  Future<Either<Failure, void>> logFood(FoodLogEntity log);
  Future<Either<Failure, List<FoodLogEntity>>> getTodayLogs(String userId);
}
