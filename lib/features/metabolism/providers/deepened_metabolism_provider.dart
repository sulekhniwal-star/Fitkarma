import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/adaptive_metabolism_engine.dart';
import '../domain/deepened_metabolism_engine.dart';
import '../domain/deepened_metabolism_models.dart';

enum ActiveDayType { trainingDay, restDay }

/// State of Deepened Adaptive Metabolism
class DeepenedMetabolismState {
  final DeepenedMetabolismReport report;
  final ActiveDayType dayType;
  final bool isRefeedActive;
  final bool isLoading;
  final String? successMessage;

  const DeepenedMetabolismState({
    required this.report,
    this.dayType = ActiveDayType.trainingDay,
    this.isRefeedActive = false,
    this.isLoading = false,
    this.successMessage,
  });

  DeepenedMetabolismState copyWith({
    DeepenedMetabolismReport? report,
    ActiveDayType? dayType,
    bool? isRefeedActive,
    bool? isLoading,
    String? successMessage,
  }) {
    return DeepenedMetabolismState(
      report: report ?? this.report,
      dayType: dayType ?? this.dayType,
      isRefeedActive: isRefeedActive ?? this.isRefeedActive,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
    );
  }
}

final deepenedMetabolismProvider =
    StateNotifierProvider<DeepenedMetabolismNotifier, DeepenedMetabolismState>((ref) {
  return DeepenedMetabolismNotifier();
});

class DeepenedMetabolismNotifier extends StateNotifier<DeepenedMetabolismState> {
  DeepenedMetabolismNotifier() : super(_buildInitialState());

  static const DeepenedMetabolismEngine _engine = DeepenedMetabolismEngine();

  static DeepenedMetabolismState _buildInitialState() {
    final report = _engine.synthesizeDeepenedMetabolism(
      weightKg: 72.0,
      heightCm: 175.0,
      age: 28,
      sex: BiologicalSex.male,
      goal: NutritionGoal.fatLoss,
      bodyFatPercentage: 16.5,
      avgDailyIntake14Days: 1950.0,
      weightDelta14DaysKg: -0.4,
      dailySteps: 9500,
      workoutMinutesDaily: 50,
      weeksInDeficit: 4,
    );
    return DeepenedMetabolismState(report: report);
  }

  void setDayType(ActiveDayType type) {
    state = state.copyWith(dayType: type);
  }

  void toggleRefeedMode() {
    final willActivate = !state.isRefeedActive;
    state = state.copyWith(
      isRefeedActive: willActivate,
      successMessage: willActivate
          ? 'Refeed protocol activated! Leptin & glycogen restored.'
          : 'Standard deficit resumed.',
    );
  }

  void recompute({
    required double weightKg,
    required double heightCm,
    required int age,
    required BiologicalSex sex,
    required NutritionGoal goal,
    double? bodyFatPercentage,
    double? avgDailyIntake,
    double? weightDelta,
    int dailySteps = 8000,
    int workoutMinutes = 45,
    int weeksInDeficit = 0,
  }) {
    final report = _engine.synthesizeDeepenedMetabolism(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      sex: sex,
      goal: goal,
      bodyFatPercentage: bodyFatPercentage,
      avgDailyIntake14Days: avgDailyIntake,
      weightDelta14DaysKg: weightDelta,
      dailySteps: dailySteps,
      workoutMinutesDaily: workoutMinutes,
      weeksInDeficit: weeksInDeficit,
    );
    state = state.copyWith(report: report);
  }
}
