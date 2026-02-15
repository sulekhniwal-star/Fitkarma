import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../features/auth/application/auth_controller.dart';
import '../data/food_repository.dart';
import '../domain/food_item.dart';
import '../domain/food_log.dart';

part 'food_controller.g.dart';

// Provider for today's food logs
@riverpod
class TodayFoodLogs extends _$TodayFoodLogs {
  @override
  Future<List<FoodLog>> build() async {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return [];

    final repository = ref.watch(foodRepositoryProvider);
    return repository.getFoodLogs(user.id, DateTime.now());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authControllerProvider).value;
      if (user == null) return [];
      final repository = ref.read(foodRepositoryProvider);
      return repository.getFoodLogs(user.id, DateTime.now());
    });
  }

  Future<void> addFoodLog({
    required String foodItemId,
    required String mealType,
    required double servings,
    String? photo,
    String? note,
  }) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    final repository = ref.read(foodRepositoryProvider);
    await repository.addFoodLog(
      userId: user.id,
      foodItemId: foodItemId,
      mealType: mealType,
      servings: servings,
      date: DateTime.now(),
      photo: photo,
      note: note,
    );

    // Refresh the list
    await refresh();
  }

  Future<void> deleteFoodLog(String logId) async {
    final repository = ref.read(foodRepositoryProvider);
    await repository.deleteFoodLog(logId);
    await refresh();
  }
}

// Provider for daily nutrition summary
@riverpod
Future<Map<String, double>> dailyNutrition(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return {};

  final repository = ref.watch(foodRepositoryProvider);
  return repository.getDailyNutrition(user.id, DateTime.now());
}

// Provider for meal-wise logs
@riverpod
Future<Map<String, List<FoodLog>>> mealWiseLogs(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return {};

  final repository = ref.watch(foodRepositoryProvider);
  return repository.getMealWiseLogs(user.id, DateTime.now());
}

// Provider for food search
@riverpod
Future<List<FoodItem>> foodSearch(
  Ref ref, {
  String? query,
  String? category,
  String? cuisineType,
}) async {
  final repository = ref.watch(foodRepositoryProvider);
  return repository.getFoodItems(
    search: query,
    category: category,
    cuisineType: cuisineType,
    limit: 50,
  );
}

// Provider for food item details
@riverpod
Future<FoodItem?> foodItemDetails(Ref ref, String foodItemId) async {
  final repository = ref.watch(foodRepositoryProvider);
  return repository.getFoodItem(foodItemId);
}

// Provider for barcode lookup
@riverpod
Future<FoodItem?> barcodeLookup(Ref ref, String barcode) async {
  final repository = ref.watch(foodRepositoryProvider);
  return repository.getFoodItemByBarcode(barcode);
}

// Controller for food logging operations
@riverpod
class FoodLogController extends _$FoodLogController {
  @override
  FutureOr<void> build() async {
    // Initial state
  }

  Future<bool> logFood({
    required String foodItemId,
    required String mealType,
    required double servings,
    String? photo,
    String? note,
  }) async {
    state = const AsyncLoading();
    
    try {
      final user = ref.read(authControllerProvider).value;
      if (user == null) throw Exception('User not authenticated');

      final repository = ref.read(foodRepositoryProvider);
      await repository.addFoodLog(
        userId: user.id,
        foodItemId: foodItemId,
        mealType: mealType,
        servings: servings,
        date: DateTime.now(),
        photo: photo,
        note: note,
      );

      // Refresh related providers
      ref.invalidate(todayFoodLogsProvider);
      ref.invalidate(dailyNutritionProvider);
      ref.invalidate(mealWiseLogsProvider);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> deleteLog(String logId) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(foodRepositoryProvider);
      await repository.deleteFoodLog(logId);

      // Refresh related providers
      ref.invalidate(todayFoodLogsProvider);
      ref.invalidate(dailyNutritionProvider);
      ref.invalidate(mealWiseLogsProvider);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
