import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/festival_life_events/domain/life_event_engine.dart';
import 'package:fitkarma/features/festival_life_events/domain/life_event_models.dart';

void main() {
  group('LifeEventEngine Deterministic Tests', () {
    const engine = LifeEventEngine();

    test(
        'Generates acute disruption plan with Grace Streak Freeze and 5,000 steps for Day 3',
        () {
      final report = engine.generateAdaptivePlan(
        event: LifeEventCategory.examCrunch,
        daysElapsed: 3,
      );

      expect(report.activeEvent, equals(LifeEventCategory.examCrunch));
      expect(report.currentPhase, equals(TransitionPhase.acuteDisruption));
      expect(report.isGraceStreakFreezeActive, isTrue);
      expect(report.stepGoalAdjustment, equals(5000));
      expect(report.workoutDurationMinutes, equals(15));
      expect(report.pillarAdjustments, isNotEmpty);
      expect(report.ayurvedicNervineTonic, contains('Brahmi'));
      expect(report.regionalAyurvedicTonic, contains('ब्राह्मी'));
      expect(report.supportiveCoachMessage, contains('Grace Streak Freeze'));
    });

    test(
        'Transitions to stabilization phase for Day 14 with increased movement targets',
        () {
      final report = engine.generateAdaptivePlan(
        event: LifeEventCategory.newParenthood,
        daysElapsed: 14,
      );

      expect(report.currentPhase, equals(TransitionPhase.stabilization));
      expect(report.stepGoalAdjustment, equals(7000));
      expect(report.workoutDurationMinutes, equals(25));
      expect(report.ayurvedicNervineTonic, contains('Shatavari'));
      expect(report.supportiveCoachMessage,
          contains('navigating this transition'));
    });

    test('Transitions to progressive re-entry phase for Day 25', () {
      final report = engine.generateAdaptivePlan(
        event: LifeEventCategory.careerShift,
        daysElapsed: 25,
      );

      expect(report.currentPhase, equals(TransitionPhase.progressiveReEntry));
      expect(report.stepGoalAdjustment, equals(9000));
      expect(report.workoutDurationMinutes, equals(40));
      expect(report.ayurvedicNervineTonic, contains('Ashwagandha'));
    });

    test(
        'All life event categories generate valid adaptations without missing fields',
        () {
      for (final event in LifeEventCategory.values) {
        final report =
            engine.generateAdaptivePlan(event: event, daysElapsed: 5);
        expect(report.activeEvent, equals(event));
        expect(report.pillarAdjustments, isNotEmpty);
        expect(report.ayurvedicNervineTonic, isNotEmpty);
        expect(report.regionalAyurvedicTonic, isNotEmpty);
        expect(report.supportiveCoachMessage, isNotEmpty);
        expect(report.regionalSupportiveCoachMessage, isNotEmpty);
      }
    });
  });
}
