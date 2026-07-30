import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';
import 'package:fitkarma/core/brain/decision_hierarchy.dart';
import 'package:fitkarma/core/brain/readiness_engine.dart';

void main() {
  group('ReadinessEngine & Decision Hierarchy Tests', () {
    const engine = ReadinessEngine();
    const hierarchy = DecisionHierarchy();

    test('Basic tier computes readiness based on check-in only', () {
      const checkIn = MorningCheckIn(energyLevel: 8, muscleSoreness: 2, moodRating: 9);
      final result = engine.calculateReadiness(checkIn: checkIn);

      expect(result.tier, equals(ReadinessTier.basic));
      expect(result.score, greaterThanOrEqualTo(80));
    });

    test('Enhanced tier incorporates sleep hours sync', () {
      const checkIn = MorningCheckIn(energyLevel: 6, muscleSoreness: 4, moodRating: 6);
      final result = engine.calculateReadiness(checkIn: checkIn, sleepHours: 8.0);

      expect(result.tier, equals(ReadinessTier.enhanced));
    });

    test('Premium tier incorporates HRV ratio', () {
      const checkIn = MorningCheckIn(energyLevel: 8, muscleSoreness: 2, moodRating: 8);
      final result = engine.calculateReadiness(
        checkIn: checkIn,
        sleepHours: 8.0,
        hrvRatio: 1.1,
      );

      expect(result.tier, equals(ReadinessTier.premium));
      expect(result.confidenceLabel, contains('High Confidence'));
    });

    test('Decision Hierarchy enforces Safety Alarm priority over workout progression', () {
      final actions = hierarchy.resolveActions(
        readinessScore: 90,
        illnessAlarmTriggered: true,
      );

      expect(actions.length, equals(1));
      expect(actions.first.priority, equals(ActionPriority.medicalSafety));
      expect(actions.first.isMandatoryRest, isTrue);
    });

    test('Decision Hierarchy resolves Rest Prescription for low readiness score', () {
      final actions = hierarchy.resolveActions(
        readinessScore: 40,
        illnessAlarmTriggered: false,
      );

      expect(actions.any((a) => a.priority == ActionPriority.recoveryPrescription), isTrue);
      expect(actions.first.isMandatoryRest, isTrue);
    });
  });
}
