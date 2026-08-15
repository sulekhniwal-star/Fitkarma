import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/squad_system_engine.dart';

void main() {
  group('§P9-B Squad System Engine Tests', () {
    const engine = SquadSystemEngine();

    test('validateSquadSize enforces ADR-022 size boundaries (3 to 8 members)',
        () {
      expect(engine.validateSquadSize(2), isFalse); // < 3 invalid
      expect(engine.validateSquadSize(3), isTrue); // Min valid
      expect(engine.validateSquadSize(5), isTrue); // Optimal
      expect(engine.validateSquadSize(8), isTrue); // Max valid
      expect(engine.validateSquadSize(9),
          isFalse); // > 8 invalid (reduces accountability)
    });

    test(
        'evaluateSquad anonymizes raw readiness score into tier labels only (Privacy Safeguard)',
        () {
      final eval = engine.evaluateSquad(
        squadId: 'sq_101',
        squadName: 'Noida Fitness Warriors',
        memberReadinessScores: [85.0, 72.0, 45.0, 88.0, 90.0],
        memberLoggedTodayList: [true, true, false, true, true],
        memberNames: ['Rahul', 'Priya', 'Sneha', 'Amit', 'Ananya'],
        streakDays: 14,
        currentCollectiveXp: 3500,
      );

      expect(eval.isSizeValid, isTrue);
      expect(eval.memberCount, equals(5));
      expect(eval.members.first.name, equals('Rahul'));
      expect(eval.members.first.readinessTierLabel, equals('High'));
      expect(eval.members[2].name, equals('Sneha'));
      expect(eval.members[2].readinessTierLabel, equals('Low'));

      // Verify 3 out of 5 are High (60%) => challenge eligible
      expect(eval.isSquadChallengeEligible, isTrue);
      expect(eval.squadLevel, equals(4)); // 3500 XP / 1000 = Level 4
    });

    test('evaluateSquad triggers rest pause when team average recovery is < 50',
        () {
      final eval = engine.evaluateSquad(
        squadId: 'sq_102',
        squadName: 'Recovery Squad',
        memberReadinessScores: [40.0, 45.0, 52.0, 38.0],
        memberLoggedTodayList: [true, false, true, false],
        memberNames: ['M1', 'M2', 'M3', 'M4'],
        streakDays: 5,
        currentCollectiveXp: 1200,
      );

      expect(eval.teamAverageRecoveryScore, lessThan(50.0));
      expect(eval.isRestPaused, isTrue);
      expect(eval.activeMission.type, equals(SquadMissionType.readinessBoost));
      expect(eval.activeMission.title, contains('Active Recovery Sprint'));
    });

    test('generateInviteCode produces 6-character uppercase string', () {
      final code = engine.generateInviteCode();
      expect(code.length, equals(6));
      expect(code, equals(code.toUpperCase()));
    });
  });
}
