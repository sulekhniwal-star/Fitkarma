/// §P8-B Transformation Timeline Screen — Notifier & State Management
///
/// Holds transformation journey timeline metrics, 90-day weight forecast bounds,
/// milestone tracking, and biometric photo security state matching §P8-B spec.
library;

import 'package:fitkarma/features/transformation/transformation_journey_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

class TransformationMilestone {
  const TransformationMilestone({
    required this.id,
    required this.title,
    required this.date,
    required this.iconSymbol,
    required this.isAchieved,
  });

  final String id;
  final String title;
  final DateTime date;
  final String iconSymbol;
  final bool isAchieved;
}

class TransformationTimelineState {
  const TransformationTimelineState({
    required this.journeyStage,
    required this.daysActive,
    required this.currentWeightKg,
    required this.projectedWeightMinKg,
    required this.projectedWeightMaxKg,
    required this.projectedBodyFatMin,
    required this.projectedBodyFatMax,
    required this.programWeekCurrent,
    required this.programWeekTotal,
    required this.arePhotosUnlocked,
    required this.milestones,
  });

  final JourneyStage journeyStage;
  final int daysActive;
  final double currentWeightKg;
  final double projectedWeightMinKg;
  final double projectedWeightMaxKg;
  final double projectedBodyFatMin;
  final double projectedBodyFatMax;
  final int programWeekCurrent;
  final int programWeekTotal;
  final bool arePhotosUnlocked;
  final List<TransformationMilestone> milestones;

  TransformationTimelineState copyWith({
    JourneyStage? journeyStage,
    int? daysActive,
    double? currentWeightKg,
    double? projectedWeightMinKg,
    double? projectedWeightMaxKg,
    double? projectedBodyFatMin,
    double? projectedBodyFatMax,
    int? programWeekCurrent,
    int? programWeekTotal,
    bool? arePhotosUnlocked,
    List<TransformationMilestone>? milestones,
  }) {
    return TransformationTimelineState(
      journeyStage: journeyStage ?? this.journeyStage,
      daysActive: daysActive ?? this.daysActive,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      projectedWeightMinKg: projectedWeightMinKg ?? this.projectedWeightMinKg,
      projectedWeightMaxKg: projectedWeightMaxKg ?? this.projectedWeightMaxKg,
      projectedBodyFatMin: projectedBodyFatMin ?? this.projectedBodyFatMin,
      projectedBodyFatMax: projectedBodyFatMax ?? this.projectedBodyFatMax,
      programWeekCurrent: programWeekCurrent ?? this.programWeekCurrent,
      programWeekTotal: programWeekTotal ?? this.programWeekTotal,
      arePhotosUnlocked: arePhotosUnlocked ?? this.arePhotosUnlocked,
      milestones: milestones ?? this.milestones,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class TransformationTimelineNotifier extends Notifier<TransformationTimelineState> {
  @override
  TransformationTimelineState build() {
    const engine = TransformationJourneyEngine();
    const currentWeight = 72.0;
    const daysActive = 75;

    final forecast = engine.calculateForecast(
      currentWeightKg: currentWeight,
      adherenceScorePercent: 85.0,
    );

    final sampleMilestones = [
      TransformationMilestone(
        id: '1',
        title: 'First 5k Steps Streak',
        date: DateTime.now().subtract(const Duration(days: 60)),
        iconSymbol: '👟',
        isAchieved: true,
      ),
      TransformationMilestone(
        id: '2',
        title: '5kg Weight Milestone',
        date: DateTime.now().subtract(const Duration(days: 30)),
        iconSymbol: '⚖️',
        isAchieved: true,
      ),
      TransformationMilestone(
        id: '3',
        title: '12-Week Program Completion',
        date: DateTime.now().add(const Duration(days: 7)),
        iconSymbol: '🏆',
        isAchieved: false,
      ),
    ];

    return TransformationTimelineState(
      journeyStage: engine.detectStage(daysActive),
      daysActive: daysActive,
      currentWeightKg: currentWeight,
      projectedWeightMinKg: forecast.projectedMinKg,
      projectedWeightMaxKg: forecast.projectedMaxKg,
      projectedBodyFatMin: 17.5,
      projectedBodyFatMax: 19.0,
      programWeekCurrent: 11,
      programWeekTotal: 12,
      arePhotosUnlocked: false,
      milestones: sampleMilestones,
    );
  }

  /// Toggles biometric unlock state for progress photos
  void togglePhotosUnlocked() {
    state = state.copyWith(arePhotosUnlocked: !state.arePhotosUnlocked);
  }
}

final transformationTimelineProvider = NotifierProvider<
    TransformationTimelineNotifier,
    TransformationTimelineState>(TransformationTimelineNotifier.new);
