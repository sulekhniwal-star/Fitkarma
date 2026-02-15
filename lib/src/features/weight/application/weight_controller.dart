import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/application/auth_controller.dart';
import '../data/weight_repository.dart';
import '../domain/weight_log.dart';

part 'weight_controller.g.dart';

// Provider for all weight logs
@riverpod
Future<List<WeightLog>> weightLogs(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return [];

  final repository = ref.watch(weightRepositoryProvider);
  return repository.getWeightLogs(user.id);
}

// Provider for today's weight entry
@riverpod
Future<WeightLog?> todayWeight(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return null;

  final repository = ref.watch(weightRepositoryProvider);
  return repository.getLatestWeight(user.id);
}

// Provider for weight stats
@riverpod
Future<Map<String, dynamic>> weightStats(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return {};

  final repository = ref.watch(weightRepositoryProvider);
  return repository.getWeightStats(user.id);
}

// Provider for weight trends
@riverpod
Future<List<WeightTrend>> weightTrends(Ref ref, {int days = 30}) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return [];

  final repository = ref.watch(weightRepositoryProvider);
  return repository.calculateTrends(user.id, days: days);
}

// Controller for weight logging operations
@riverpod
class WeightLogController extends _$WeightLogController {
  @override
  FutureOr<void> build() async {
    // Initial state
  }

  Future<bool> logWeight(double weight, {String? note}) async {
    state = const AsyncLoading();
    
    try {
      final user = ref.read(authControllerProvider).value;
      if (user == null) throw Exception('User not authenticated');

      final repository = ref.read(weightRepositoryProvider);
      
      final weightLog = WeightLog(
        id: '',
        userId: user.id,
        date: DateTime.now(),
        weight: weight,
        note: note,
      );

      await repository.createWeightLog(weightLog);

      // Refresh related providers
      ref.invalidate(weightLogsProvider);
      ref.invalidate(todayWeightProvider);
      ref.invalidate(weightStatsProvider);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> deleteWeightLog(String logId) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(weightRepositoryProvider);
      await repository.deleteWeightLog(logId);

      // Refresh related providers
      ref.invalidate(weightLogsProvider);
      ref.invalidate(todayWeightProvider);
      ref.invalidate(weightStatsProvider);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
