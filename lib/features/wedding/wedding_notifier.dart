/// §P12-C Wedding Transformation Notifier & State Management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wedding_program_generator.dart';

class WeddingTransformationState {
  const WeddingTransformationState({
    required this.weddingDate,
    required this.daysRemaining,
    required this.currentPhase,
    required this.programPlan,
    required this.checklist,
    this.isLoading = false,
    this.successMessage,
  });

  final DateTime weddingDate;
  final int daysRemaining;
  final WeddingPhase currentPhase;
  final WeddingProgramPlan programPlan;
  final List<WeddingChecklistItem> checklist;
  final bool isLoading;
  final String? successMessage;

  int get completedChecklistCount =>
      checklist.where((c) => c.isCompleted).length;

  WeddingTransformationState copyWith({
    DateTime? weddingDate,
    int? daysRemaining,
    WeddingPhase? currentPhase,
    WeddingProgramPlan? programPlan,
    List<WeddingChecklistItem>? checklist,
    bool? isLoading,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return WeddingTransformationState(
      weddingDate: weddingDate ?? this.weddingDate,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      currentPhase: currentPhase ?? this.currentPhase,
      programPlan: programPlan ?? this.programPlan,
      checklist: checklist ?? this.checklist,
      isLoading: isLoading ?? this.isLoading,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class WeddingTransformationNotifier
    extends Notifier<WeddingTransformationState> {
  late final WeddingProgramGenerator _generator;

  @override
  WeddingTransformationState build() {
    _generator = const WeddingProgramGenerator();
    final defaultWeddingDate = DateTime.now().add(const Duration(days: 60));
    final plan = _generator.generatePlan(weddingDate: defaultWeddingDate);

    return WeddingTransformationState(
      weddingDate: defaultWeddingDate,
      daysRemaining: plan.daysRemaining,
      currentPhase: plan.phase,
      programPlan: plan,
      checklist: plan.checklist,
    );
  }

  void updateWeddingDate(DateTime newDate) {
    final plan = _generator.generatePlan(weddingDate: newDate);

    state = state.copyWith(
      weddingDate: newDate,
      daysRemaining: plan.daysRemaining,
      currentPhase: plan.phase,
      programPlan: plan,
      checklist: plan.checklist,
      successMessage: '💍 Wedding Date updated! Switched to ${plan.phaseName}',
    );
  }

  void toggleCheckitem(String itemId) {
    final updatedList = state.checklist.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    state = state.copyWith(checklist: updatedList);
  }
}

final weddingTransformationProvider = NotifierProvider<
    WeddingTransformationNotifier, WeddingTransformationState>(
  WeddingTransformationNotifier.new,
);
