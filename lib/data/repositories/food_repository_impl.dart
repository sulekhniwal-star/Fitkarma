import 'package:dartz/dartz.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/food_log_entity.dart';
import '../../domain/repositories/food_repository.dart';
import '../models/food_log_model.dart';
import '../../core/utils/logger.dart';

class FoodRepositoryImpl implements FoodRepository {
  final PocketBase pb;

  FoodRepositoryImpl({required this.pb});

  @override
  Future<Either<Failure, List<FoodLogEntity>>> searchFood(String query) async {
    try {
      final ProductSearchQueryConfiguration configuration =
          ProductSearchQueryConfiguration(
            parametersList: <Parameter>[
              SearchTerms(terms: <String>[query]),
            ],
            language: OpenFoodFactsLanguage.ENGLISH,
            fields: [ProductField.ALL],
            version: ProductQueryVersion.v3,
          );

      final SearchResult result = await OpenFoodAPIClient.searchProducts(
        null,
        configuration,
      );

      final List<FoodLogEntity> foods =
          result.products?.map((product) {
            return FoodLogEntity(
              id: product.barcode ?? DateTime.now().toString(),
              userId: '',
              itemName: product.productName ?? 'Unknown Food',
              calories: product.nutriments?.energyKcal ?? 0.0,
              macros: {
                'proteins': product.nutriments?.getValue(
                  Nutrient.proteins,
                  PerSize.oneHundredGrams,
                ),
                'carbs': product.nutriments?.getValue(
                  Nutrient.carbohydrates,
                  PerSize.oneHundredGrams,
                ),
                'fats': product.nutriments?.getValue(
                  Nutrient.fat,
                  PerSize.oneHundredGrams,
                ),
              },
              date: DateTime.now(),
            );
          }).toList() ??
          [];

      return Right(foods);
    } catch (e, stack) {
      AppLogger.error('Food search failed', e, stack);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logFood(FoodLogEntity log) async {
    try {
      final body = {
        "user": log.userId,
        "item_name": log.itemName,
        "calories": log.calories,
        "macros": log.macros,
        "date": log.date.toIso8601String(),
      };
      await pb.collection('food_logs').create(body: body);
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error('Food logging failed', e, stack);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodLogEntity>>> getTodayLogs(
    String userId,
  ) async {
    try {
      final today = DateTime.now();
      final dateString =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      final records = await pb
          .collection('food_logs')
          .getList(
            filter: 'user = "$userId" && date >= "$dateString 00:00:00"',
            sort: '-date',
          );

      final logs = records.items
          .map((record) => FoodLogModel.fromJson(record.toJson()))
          .toList();
      return Right(logs);
    } catch (e, stack) {
      AppLogger.error('Fetching food logs failed', e, stack);
      return Left(ServerFailure(e.toString()));
    }
  }
}
