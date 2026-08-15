import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/health_os_brain.dart';
import 'package:fitkarma/core/brain/ai_router.dart';
import 'package:fitkarma/core/brain/decision_hierarchy.dart';
import 'package:fitkarma/core/brain/readiness_engine.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';

void main() {
  group('Phase 0 Foundation Tests', () {
    late HealthOsBrain brain;
    late AiRouter aiRouter;

    setUp(() {
      brain = const HealthOsBrain();
      aiRouter = const AiRouter();
    });

    test('HealthOsBrain generates Daily Intelligence Package correctly', () {
      final dip = brain.generateDailyPackage(
        userId: 'user_123',
        date: DateTime(2026, 7, 31),
        checkIn: const MorningCheckIn(
            energyLevel: 8, muscleSoreness: 2, moodRating: 8),
        sleepHours: 7.5,
        hrvRatio: 1.05,
        availableMissions: ['Log Morning Meal', '10k Steps', '30m Workout'],
      );

      expect(dip.userId, equals('user_123'));
      expect(dip.readinessScore, greaterThanOrEqualTo(70));
      expect(dip.readinessTier, equals(ReadinessTier.premium));
      expect(dip.dailyMissions.length, equals(3));
    });

    test('AiRouter correctly routes simple, medium, and complex tasks', () {
      expect(aiRouter.routeTask(TaskComplexity.simpleExtraction),
          equals(AiModelTier.tiny));
      expect(aiRouter.routeTask(TaskComplexity.coachingNudge),
          equals(AiModelTier.medium));
      expect(aiRouter.routeTask(TaskComplexity.clinicalAnalysis),
          equals(AiModelTier.large));

      expect(aiRouter.getModelIdentifier(AiModelTier.tiny), contains('8b'));
      expect(aiRouter.getModelIdentifier(AiModelTier.medium), contains('70b'));
    });

    test(
        'Decision Hierarchy prioritizes illness alert over regular progression',
        () {
      const hierarchy = DecisionHierarchy();
      final actions = hierarchy.resolveActions(
        readinessScore: 85,
        illnessAlarmTriggered: true,
      );

      expect(actions.first.title, contains('Illness Alert'));
      expect(actions.first.isMandatoryRest, isTrue);
    });
  });
}
