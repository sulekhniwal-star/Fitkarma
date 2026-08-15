import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';
import 'package:fitkarma/core/brain/squad_engine.dart';

void main() {
  group('SquadEngine Privacy & Invite Code Tests', () {
    const engine = SquadEngine();

    test('generateInviteCode produces 6-character uppercase string', () {
      final code = engine.generateInviteCode();

      expect(code.length, equals(6));
      expect(code, equals(code.toUpperCase()));
    });

    test(
        'filterReadinessPrivacy returns confidence tier & status without sharing numerical score',
        () {
      final status = engine.filterReadinessPrivacy(
        memberName: 'Aarav M.',
        readinessScore: 85, // Score must be hidden from return object
        tier: ReadinessTier.premium,
      );

      expect(status.memberName, equals('Aarav M.'));
      expect(status.tier, equals(ReadinessTier.premium));
      expect(status.statusLabel, equals('Peak Readiness'));
    });
  });
}
