import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/application/auth_controller.dart';
import '../data/steps_repository.dart';
import '../domain/step_log.dart';

part 'steps_controller.g.dart';

// Provider for today's step log
@riverpod
class TodaySteps extends _$TodaySteps {
  @override
  Future<StepLog?> build() async {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return null;

    final repository = ref.watch(stepsRepositoryProvider);
    return repository.getTodaySteps(user.id);
  }

  Future<void> addSteps(int steps, {String source = 'manual'}) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    final repository = ref.read(stepsRepositoryProvider);
    await repository.addSteps(user.id, steps, source: source);
    
    // Refresh
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(stepsRepositoryProvider);
      return repo.getTodaySteps(user.id);
    });
  }
}

// Provider for step settings
@riverpod
Future<StepSettings?> stepSettings(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return null;

  final repository = ref.watch(stepsRepositoryProvider);
  return repository.getStepSettings(user.id);
}

// Provider for weekly steps
@riverpod
Future<List<StepLog>> weeklySteps(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return [];

  final repository = ref.watch(stepsRepositoryProvider);
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  return repository.getStepsForDateRange(user.id, weekAgo, now);
}

// Provider for weekly stats
@riverpod
Future<Map<String, dynamic>> weeklyStepsStats(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return {};

  final repository = ref.watch(stepsRepositoryProvider);
  return repository.getWeeklyStats(user.id);
}
