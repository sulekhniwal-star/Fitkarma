import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/pocketbase/pocketbase_provider.dart';
import '../domain/food_item.dart';
import '../domain/food_log.dart';

part 'food_repository.g.dart';

class FoodRepository {
  final PocketBase pb;
  FoodRepository(this.pb);

  // Get food items with optional filters
  Future<List<FoodItem>> getFoodItems({
    String? search,
    String? category,
    String? cuisineType,
    bool? isVegetarian,
    int limit = 50,
  }) async {
    final filters = <String>[];

    if (search != null && search.isNotEmpty) {
      filters.add('name ~ "$search" || name_hindi ~ "$search"');
    }
    if (category != null) {
      filters.add('category = "$category"');
    }
    if (cuisineType != null) {
      filters.add('cuisine_type = "$cuisineType"');
    }
    if (isVegetarian != null) {
      filters.add('is_vegetarian = $isVegetarian');
    }

    final filterString = filters.isNotEmpty ? filters.join(' && ') : null;

    final records = await pb.collection('food_items').getList(
          page: 1,
          perPage: limit,
          filter: filterString,
          sort: '-verified,name',
        );

    return records.items
        .map((record) => FoodItem.fromJson(record.toJson()))
        .toList();
  }

  // Get food item by ID
  Future<FoodItem?> getFoodItem(String id) async {
    try {
      final record = await pb.collection('food_items').getOne(id);
      return FoodItem.fromJson(record.toJson());
    } catch (e) {
      return null;
    }
  }

  // Get food item by barcode
  Future<FoodItem?> getFoodItemByBarcode(String barcode) async {
    try {
      final records = await pb.collection('food_items').getList(
            filter: 'barcode = "$barcode"',
            perPage: 1,
          );
      if (records.items.isNotEmpty) {
        return FoodItem.fromJson(records.items.first.toJson());
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get user's food logs for a specific date
  Future<List<FoodLog>> getFoodLogs(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final records = await pb.collection('food_logs').getFullList(
          filter:
              'user = "$userId" && date >= "${startOfDay.toUtc().toIso8601String()}" && date < "${endOfDay.toUtc().toIso8601String()}"',
          sort: 'date',
          expand: 'food_item',
        );

    return records.map((record) {
      final json = record.toJson();
      // If expanded, include food item name
      final foodItem = record.get<RecordModel>('expand.food_item');
      json['food_item_name'] = foodItem.getStringValue('name');
          return FoodLog.fromJson(json);
    }).toList();

  }

  // Add a food log
  Future<FoodLog> addFoodLog({
    required String userId,
    required String foodItemId,
    required String mealType,
    required double servings,
    required DateTime date,
    String? photo,
    String? note,
  }) async {
    // Get food item to cache nutrition values
    final foodItem = await getFoodItem(foodItemId);

    final record = await pb.collection('food_logs').create(body: {
      'user': userId,
      'food_item': foodItemId,
      'meal_type': mealType,
      'servings': servings,
      'date': date.toUtc().toIso8601String(),
      'photo': photo,
      'note': note,
      // Cache nutrition values
      'calories': foodItem?.calories ?? 0,
      'protein': foodItem?.protein ?? 0,
      'carbs': foodItem?.carbs ?? 0,
      'fats': foodItem?.fats ?? 0,
      'fiber': foodItem?.fiber ?? 0,
      'sugar': foodItem?.sugar ?? 0,
      'sodium': foodItem?.sodium ?? 0,
    });

    final json = record.toJson();
    if (foodItem != null) {
      json['food_item_name'] = foodItem.name;
    }

    return FoodLog.fromJson(json);
  }

  // Delete a food log
  Future<void> deleteFoodLog(String logId) async {
    await pb.collection('food_logs').delete(logId);
  }

  // Update a food log
  Future<FoodLog> updateFoodLog({
    required String logId,
    double? servings,
    String? mealType,
    String? note,
  }) async {
    final body = <String, dynamic>{};
    if (servings != null) body['servings'] = servings;
    if (mealType != null) body['meal_type'] = mealType;
    if (note != null) body['note'] = note;

    final record = await pb.collection('food_logs').update(logId, body: body);
    return FoodLog.fromJson(record.toJson());
  }

  // Get daily nutrition summary
  Future<Map<String, double>> getDailyNutrition(String userId, DateTime date) async {
    final logs = await getFoodLogs(userId, date);

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;
    double totalFiber = 0;
    double totalSugar = 0;

    for (final log in logs) {
      final nutrition = log.totalNutrition;
      totalCalories += nutrition['calories'] ?? 0;
      totalProtein += nutrition['protein'] ?? 0;
      totalCarbs += nutrition['carbs'] ?? 0;
      totalFats += nutrition['fats'] ?? 0;
      totalFiber += nutrition['fiber'] ?? 0;
      totalSugar += nutrition['sugar'] ?? 0;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fats': totalFats,
      'fiber': totalFiber,
      'sugar': totalSugar,
    };
  }

  // Get meal-wise breakdown
  Future<Map<String, List<FoodLog>>> getMealWiseLogs(
      String userId, DateTime date) async {
    final logs = await getFoodLogs(userId, date);

    final Map<String, List<FoodLog>> mealLogs = {
      'breakfast': [],
      'lunch': [],
      'dinner': [],
      'snack': [],
    };

    for (final log in logs) {
      final mealType = log.mealType.toLowerCase();
      if (mealLogs.containsKey(mealType)) {
        mealLogs[mealType]!.add(log);
      }
    }

    return mealLogs;
  }
}

@Riverpod(keepAlive: true)
FoodRepository foodRepository(Ref ref) {
  return FoodRepository(ref.watch(pocketBaseProvider));
}
