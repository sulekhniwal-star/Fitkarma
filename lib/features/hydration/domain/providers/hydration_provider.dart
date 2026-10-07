import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hydration_models.dart';

/// State for today's hydration session
class HydrationState {
  final double consumedMl;
  final double goalMl;
  final List<HydrationLog> logs;
  final bool isLoading;

  const HydrationState({
    this.consumedMl = 0,
    this.goalMl = 2500,
    this.logs = const [],
    this.isLoading = false,
  });

  double get progressFraction => (consumedMl / goalMl).clamp(0.0, 1.0);
  double get remainingMl => (goalMl - consumedMl).clamp(0, goalMl);
  bool get isGoalMet => consumedMl >= goalMl;

  HydrationState copyWith({
    double? consumedMl,
    double? goalMl,
    List<HydrationLog>? logs,
    bool? isLoading,
  }) =>
      HydrationState(
        consumedMl: consumedMl ?? this.consumedMl,
        goalMl: goalMl ?? this.goalMl,
        logs: logs ?? this.logs,
        isLoading: isLoading ?? this.isLoading,
      );
}

class HydrationNotifier extends Notifier<HydrationState> {
  final _engine = const HydrationGoalEngine();

  @override
  HydrationState build() {
    // Calculate goal on build
    final goal = _engine.calculateDailyGoalMl(
      weightKg: 70, // Will be replaced by profile data
      isHighActivityDay: false,
      aqiLevel: 80,
      temperatureC: 32,
    );
    return HydrationState(goalMl: goal);
  }

  void logWater({
    required double amountMl,
    HydrationSource source = HydrationSource.water,
  }) {
    final log = HydrationLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'local',
      loggedAt: DateTime.now(),
      amountMl: amountMl,
      source: source,
    );
    final newLogs = [...state.logs, log];
    final newConsumed = newLogs.fold(0.0, (sum, l) => sum + l.amountMl);
    state = state.copyWith(consumedMl: newConsumed, logs: newLogs);
  }

  void removeLastLog() {
    if (state.logs.isEmpty) return;
    final newLogs = List<HydrationLog>.from(state.logs)..removeLast();
    final newConsumed = newLogs.fold(0.0, (sum, l) => sum + l.amountMl);
    state = state.copyWith(consumedMl: newConsumed, logs: newLogs);
  }

  void updateGoal(double goalMl) {
    state = state.copyWith(goalMl: goalMl);
  }

  String get hydrationTip => _engine.getHydrationTip(
        consumedMl: state.consumedMl,
        goalMl: state.goalMl,
        temperatureC: 32,
      );
}

final hydrationProvider =
    NotifierProvider<HydrationNotifier, HydrationState>(HydrationNotifier.new);
