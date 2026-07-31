import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/escalation_service.dart';

/// §P3-D Escalation State
class EscalationState {
  final bool isEscalated;
  final bool isPending;
  final EscalationResult? lastResult;
  final CoachBriefingPackage? briefing;
  final String? errorMessage;

  const EscalationState({
    this.isEscalated = false,
    this.isPending = false,
    this.lastResult,
    this.briefing,
    this.errorMessage,
  });

  EscalationState copyWith({
    bool? isEscalated,
    bool? isPending,
    EscalationResult? lastResult,
    CoachBriefingPackage? briefing,
    String? errorMessage,
  }) {
    return EscalationState(
      isEscalated: isEscalated ?? this.isEscalated,
      isPending: isPending ?? this.isPending,
      lastResult: lastResult ?? this.lastResult,
      briefing: briefing ?? this.briefing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// §P3-D EscalationNotifier — evaluates triggers, builds briefing, fires escalation
class EscalationNotifier extends StateNotifier<EscalationState> {
  final CoachEscalationService _service;

  EscalationNotifier(this._service) : super(const EscalationState());

  /// Check if current user state meets escalation criteria
  bool shouldEscalate(UserEscalationState userState) {
    return _service.shouldEscalate(userState);
  }

  /// Full escalation flow — build briefing + create ticket + notify user
  Future<void> triggerEscalation({
    required UserEscalationState userState,
    required String userId,
    required String userName,
    required String goal,
    required int programWeek,
    required int programTotalWeeks,
    required String programName,
    required double weightChange4wKg,
    required double expectedWeightChange4wKg,
    required int calorieTarget,
    required int adaptiveAdjustmentCount,
    required double nutritionAdherencePct,
    required double trainingAdherencePct,
    required int sleepDeficitDays,
    required List<String> aiLimitationsHit,
    required String aiCoachNotesSummary,
  }) async {
    state = state.copyWith(isPending: true, errorMessage: null);

    try {
      final reason = _service.identifyReason(userState);

      final briefing = _service.buildBriefing(
        userId: userId,
        userName: userName,
        goal: goal,
        programWeek: programWeek,
        programTotalWeeks: programTotalWeeks,
        programName: programName,
        weightChange4wKg: weightChange4wKg,
        expectedWeightChange4wKg: expectedWeightChange4wKg,
        calorieTarget: calorieTarget,
        adaptiveAdjustmentCount: adaptiveAdjustmentCount,
        nutritionAdherencePct: nutritionAdherencePct,
        trainingAdherencePct: trainingAdherencePct,
        sleepDeficitDays: sleepDeficitDays,
        aiLimitationsHit: aiLimitationsHit,
        escalationReason: reason,
        aiCoachNotesSummary: aiCoachNotesSummary,
      );

      // Simulate async API call to coach dashboard (500ms)
      await Future.delayed(const Duration(milliseconds: 500));

      final result = _service.escalate(state: userState, briefing: briefing);

      state = state.copyWith(
        isEscalated: true,
        isPending: false,
        lastResult: result,
        briefing: briefing,
      );
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        errorMessage: 'Escalation failed: ${e.toString()}',
      );
    }
  }

  /// User explicitly requests human coach
  Future<void> requestHumanCoach({required String userId, required String userName}) async {
    final userState = const UserEscalationState(userRequestedHumanCoach: true);

    await triggerEscalation(
      userState: userState,
      userId: userId,
      userName: userName,
      goal: 'User-initiated review',
      programWeek: 1,
      programTotalWeeks: 12,
      programName: 'Current Program',
      weightChange4wKg: 0,
      expectedWeightChange4wKg: -0.5,
      calorieTarget: 1800,
      adaptiveAdjustmentCount: 0,
      nutritionAdherencePct: 70,
      trainingAdherencePct: 65,
      sleepDeficitDays: 0,
      aiLimitationsHit: const ['User requested expert review'],
      aiCoachNotesSummary: 'User initiated escalation for personalized human coaching.',
    );
  }

  void reset() {
    state = const EscalationState();
  }
}

final escalationProvider =
    StateNotifierProvider<EscalationNotifier, EscalationState>(
        (ref) => EscalationNotifier(const CoachEscalationService()));
