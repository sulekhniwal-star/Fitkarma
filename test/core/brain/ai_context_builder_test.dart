import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/ai_context_builder.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';

void main() {
  group('§P3-B AI Context Builder Tests', () {
    const builder = AIContextBuilder();

    test(
        'buildCompressed compiles profile, DIP, snapshot trends, and environmental context',
        () {
      final dip = DailyIntelligencePackage(
        userId: 'user_456',
        date: DateTime.now(),
        readinessScore: 82,
        readinessTier: ReadinessTier.enhanced,
        primaryFocus: 'Hypertrophy & Recovery',
        dailyMissions: const ['10k Steps', '110g Protein'],
      );

      final aiContext = builder.buildCompressed(
        userId: 'user_456',
        name: 'Arjun',
        goals: const ['Muscle Gain', 'Fat Loss'],
        program: 'Corporate Recomp',
        dietType: 'Vegetarian',
        dip: dip,
        weather: 'AQI 220 (Very Poor)',
        festival: 'Diwali',
      );

      expect(aiContext.userId, equals('user_456'));
      expect(aiContext.name, equals('Arjun'));
      expect(aiContext.readinessScore, equals(82));
      expect(aiContext.readinessTier, equals('enhanced'));
      expect(aiContext.weather, equals('AQI 220 (Very Poor)'));
      expect(aiContext.festival, equals('Diwali'));

      final json = aiContext.toJson();
      expect(json['user_id'], equals('user_456'));
      expect(json['goals'], contains('Muscle Gain'));

      final promptString = aiContext.toCompressedPromptString();
      expect(promptString, contains('Profile: Arjun'));
      expect(promptString, contains('Readiness 82'));
      expect(promptString, contains('Diwali'));
    });
  });
}
