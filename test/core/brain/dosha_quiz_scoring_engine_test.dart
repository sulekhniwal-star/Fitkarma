import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/dosha_quiz_scoring_engine.dart';

void main() {
  group('DoshaQuizScoringEngine Unit Tests', () {
    const engine = DoshaQuizScoringEngine();

    test('calculateDoshaProfile returns Vata dominant when Vata answers majority', () {
      final answers = [
        const DoshaAnswer(questionId: 'q1', associatedDosha: DoshaType.vata),
        const DoshaAnswer(questionId: 'q2', associatedDosha: DoshaType.vata),
        const DoshaAnswer(questionId: 'q3', associatedDosha: DoshaType.pitta),
      ];

      final result = engine.calculateDoshaProfile(answers);

      expect(result.dominant, equals(DoshaType.vata));
      expect(result.vataPct, closeTo(66.6, 0.1));
      expect(result.pittaPct, closeTo(33.3, 0.1));
      expect(result.kaphaPct, equals(0.0));
      expect(result.guidelines.recommendedSpices, contains('Ginger'));
    });

    test('calculateDoshaProfile returns Pitta dominant when Pitta answers majority', () {
      final answers = [
        const DoshaAnswer(questionId: 'q1', associatedDosha: DoshaType.pitta),
        const DoshaAnswer(questionId: 'q2', associatedDosha: DoshaType.pitta),
        const DoshaAnswer(questionId: 'q3', associatedDosha: DoshaType.kapha),
      ];

      final result = engine.calculateDoshaProfile(answers);

      expect(result.dominant, equals(DoshaType.pitta));
      expect(result.pittaPct, closeTo(66.6, 0.1));
      expect(result.guidelines.recommendedSpices, contains('Fennel'));
    });

    test('calculateDoshaProfile returns Kapha dominant when Kapha answers majority', () {
      final answers = [
        const DoshaAnswer(questionId: 'q1', associatedDosha: DoshaType.kapha),
        const DoshaAnswer(questionId: 'q2', associatedDosha: DoshaType.kapha),
        const DoshaAnswer(questionId: 'q3', associatedDosha: DoshaType.vata),
      ];

      final result = engine.calculateDoshaProfile(answers);

      expect(result.dominant, equals(DoshaType.kapha));
      expect(result.kaphaPct, closeTo(66.6, 0.1));
      expect(result.guidelines.recommendedSpices, contains('Black Pepper'));
    });

    test('calculateDoshaProfile returns equal distribution fallback when empty answers', () {
      final result = engine.calculateDoshaProfile([]);

      expect(result.vataPct, equals(33.3));
      expect(result.pittaPct, equals(33.3));
      expect(result.kaphaPct, equals(33.3));
    });
  });
}
