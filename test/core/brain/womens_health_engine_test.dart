import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/womens_health_engine.dart';

void main() {
  group('WomensHealthEngine Tests', () {
    const engine = WomensHealthEngine();

    test('Follicular phase boosts strength target by +5%', () {
      final res =
          engine.calculatePrescription(phase: MenstrualPhase.follicular);
      expect(res.strengthTargetMultiplier, equals(1.05));
      expect(res.nutritionAdvice, contains('High energy phase'));
    });

    test('Luteal phase adjusts strength target to 95%', () {
      final res = engine.calculatePrescription(phase: MenstrualPhase.luteal);
      expect(res.strengthTargetMultiplier, equals(0.95));
      expect(res.nutritionAdvice.toLowerCase(), contains('fluid retention'));
    });

    test('Menstrual phase adjusts strength target to 90%', () {
      final res = engine.calculatePrescription(phase: MenstrualPhase.menstrual);
      expect(res.strengthTargetMultiplier, equals(0.90));
      expect(res.nutritionAdvice, contains('iron-rich foods'));
    });
  });
}
