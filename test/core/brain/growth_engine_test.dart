import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/growth_engine.dart';
import 'package:fitkarma/features/growth/models/growth_model.dart';

void main() {
  group('GrowthEngine Vernacular ASR & Corporate Privacy Tests', () {
    const engine = GrowthEngine();

    test('Vernacular ASR parses Hindi/Tamil voice transcripts correctly', () {
      final hindiRes = engine.parseVernacularVoiceInput(
          'मुझे 200 ग्राम पनीर खाना है', VernacularLanguage.hindi);
      final tamilRes =
          engine.parseVernacularVoiceInput('பனீர்', VernacularLanguage.tamil);

      expect(hindiRes, equals('Paneer Tikka'));
      expect(tamilRes, equals('Paneer Tikka'));
    });

    test(
        'Corporate Wellness Anonymity enforces minimum cohort size threshold (N >= 10)',
        () {
      expect(engine.canRenderCorporateAggregate(8),
          isFalse); // < 10 threshold blocked
      expect(engine.canRenderCorporateAggregate(12), isTrue); // >= 10 allowed
    });
  });
}
