import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/daily_intelligence_package.dart';
import '../../../core/brain/decision_hierarchy.dart';
import '../../../core/brain/health_os_brain.dart';
import '../../../core/brain/readiness_engine.dart';

class DailyMissionState {
  final MorningCheckIn checkIn;
  final ReadinessResult readiness;
  final double dailyStrain; // 0.0 to 21.0
  final double sleepHours;
  final List<DecisionAction> activeActions;
  final DailyIntelligencePackage dip;
  final String userName;
  final int healthScore;
  final int healthScoreTrend;
  final int sleepDebtMin;
  final int streakDays;
  final int karmaXpTarget;
  final bool medicalRiskActive;

  DailyMissionState({
    this.checkIn = const MorningCheckIn(),
    required this.readiness,
    this.dailyStrain = 8.5,
    this.sleepHours = 7.5,
    this.activeActions = const [],
    required this.dip,
    this.userName = 'Arjun',
    this.healthScore = 82,
    this.healthScoreTrend = 4,
    this.sleepDebtMin = -45,
    this.streakDays = 12,
    this.karmaXpTarget = 45,
    this.medicalRiskActive = false,
  });

  DailyMissionState copyWith({
    MorningCheckIn? checkIn,
    ReadinessResult? readiness,
    double? dailyStrain,
    double? sleepHours,
    List<DecisionAction>? activeActions,
    DailyIntelligencePackage? dip,
    String? userName,
    int? healthScore,
    int? healthScoreTrend,
    int? sleepDebtMin,
    int? streakDays,
    int? karmaXpTarget,
    bool? medicalRiskActive,
  }) {
    return DailyMissionState(
      checkIn: checkIn ?? this.checkIn,
      readiness: readiness ?? this.readiness,
      dailyStrain: dailyStrain ?? this.dailyStrain,
      sleepHours: sleepHours ?? this.sleepHours,
      activeActions: activeActions ?? this.activeActions,
      dip: dip ?? this.dip,
      userName: userName ?? this.userName,
      healthScore: healthScore ?? this.healthScore,
      healthScoreTrend: healthScoreTrend ?? this.healthScoreTrend,
      sleepDebtMin: sleepDebtMin ?? this.sleepDebtMin,
      streakDays: streakDays ?? this.streakDays,
      karmaXpTarget: karmaXpTarget ?? this.karmaXpTarget,
      medicalRiskActive: medicalRiskActive ?? this.medicalRiskActive,
    );
  }
}

class DailyMissionNotifier extends StateNotifier<DailyMissionState> {
  final ReadinessEngine _engine;
  final DecisionHierarchy _hierarchy;
  final HealthOsBrain _brain;

  DailyMissionNotifier(
    this._engine,
    this._hierarchy, {
    HealthOsBrain brain = const HealthOsBrain(),
  })  : _brain = brain,
        super(
          DailyMissionState(
            readiness: _engine.calculateReadiness(
              checkIn: const MorningCheckIn(),
              sleepHours: 7.5,
            ),
            dip: brain.generateDailyPackage(
              userId: 'user_1',
              date: DateTime.now(),
              checkIn: const MorningCheckIn(),
              sleepHours: 7.5,
              availableMissions: const [
                'Hit 110g protein target today',
                'Complete 45-min strength training',
                'Reach 8,000 step target',
              ],
            ),
          ),
        ) {
    _recalculateState();
  }

  void submitCheckIn(int energy, int soreness, int mood) {
    final updatedCheckIn = MorningCheckIn(
      energyLevel: energy,
      muscleSoreness: soreness,
      moodRating: mood,
      isCompleted: true,
    );

    state = state.copyWith(checkIn: updatedCheckIn);
    _recalculateState();
  }

  void setMedicalRiskActive(bool active) {
    state = state.copyWith(medicalRiskActive: active);
    _recalculateState();
  }

  void _recalculateState() {
    final readinessResult = _engine.calculateReadiness(
      checkIn: state.checkIn,
      sleepHours: state.sleepHours,
      dailyStrain: state.dailyStrain,
    );

    final dip = _brain.generateDailyPackage(
      userId: 'user_1',
      date: DateTime.now(),
      checkIn: state.checkIn,
      sleepHours: state.sleepHours,
      illnessAlarmTriggered: state.medicalRiskActive,
      availableMissions: const [
        'Hit 110g protein target today',
        'Complete 45-min strength training',
        'Reach 8,000 step target',
      ],
    );

    final resolvedActions = _hierarchy.resolveActions(
      readinessScore: readinessResult.score,
      dailyStrain: state.dailyStrain,
      illnessAlarmTriggered: state.medicalRiskActive,
    );

    state = state.copyWith(
      readiness: readinessResult,
      dip: dip,
      activeActions: resolvedActions,
    );
  }
}

final dailyMissionProvider =
    StateNotifierProvider<DailyMissionNotifier, DailyMissionState>((ref) {
  return DailyMissionNotifier(
    const ReadinessEngine(),
    const DecisionHierarchy(),
  );
});

