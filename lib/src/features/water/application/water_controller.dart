import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/application/auth_controller.dart';
import '../data/water_repository.dart';
import '../domain/water_log.dart';

part 'water_controller.g.dart';

// Provider for today's water
@riverpod
Future<WaterLog?> todayWater(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return null;

  final repository = ref.watch(waterRepositoryProvider);
  return repository.getTodayWater(user.id);
}

// Provider for water settings
@riverpod
Future<WaterSettings?> waterSettings(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return null;

  final repository = ref.watch(waterRepositoryProvider);
  return repository.getWaterSettings(user.id);
}

// Provider for weekly water stats
@riverpod
Future<Map<String, dynamic>> weeklyWaterStats(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return {};

  final repository = ref.watch(waterRepositoryProvider);
  return repository.getWeeklyStats(user.id);
}

// Provider for hydration streak
@riverpod
Future<int> hydrationStreak(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return 0;

  final repository = ref.watch(waterRepositoryProvider);
  return repository.getHydrationStreak(user.id);
}

// Controller for water logging operations
@riverpod
class WaterLogController extends _$WaterLogController {
  @override
  FutureOr<void> build() async {
    // Initial state
  }

  Future<bool> addWater(int glasses) async {
    state = const AsyncLoading();
    
    try {
      final user = ref.read(authControllerProvider).value;
      if (user == null) throw Exception('User not authenticated');

      final repository = ref.read(waterRepositoryProvider);
      
      // Add 250ml per glass
      final mlPerGlass = 250;
      await repository.addWater(user.id, glasses * mlPerGlass, 'glass');

      // Refresh related providers
      ref.invalidate(todayWaterProvider);
      ref.invalidate(weeklyWaterStatsProvider);
      ref.invalidate(hydrationStreakProvider);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> addGlass() async {
    return addWater(1);
  }

  Future<bool> addBottle() async {
    state = const AsyncLoading();
    
    try {
      final user = ref.read(authControllerProvider).value;
      if (user == null) throw Exception('User not authenticated');

      final repository = ref.read(waterRepositoryProvider);
      await repository.addBottle(user.id);

      // Refresh related providers
      ref.invalidate(todayWaterProvider);
      ref.invalidate(weeklyWaterStatsProvider);
      ref.invalidate(hydrationStreakProvider);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> addChai() async {
    state = const AsyncLoading();
    
    try {
      final user = ref.read(authControllerProvider).value;
      if (user == null) throw Exception('User not authenticated');

      final repository = ref.read(waterRepositoryProvider);
      await repository.addChai(user.id);

      // Refresh related providers
      ref.invalidate(todayWaterProvider);
      ref.invalidate(weeklyWaterStatsProvider);
      ref.invalidate(hydrationStreakProvider);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
