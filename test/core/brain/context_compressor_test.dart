import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/context_compressor.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';

void main() {
  group('ContextCompressor Tests', () {
    const compressor = ContextCompressor();

    test('compressContext produces token-efficient dictionary', () {
      final dip = DailyIntelligencePackage(
        userId: 'user_123',
        date: DateTime.now(),
        readinessScore: 85,
        readinessTier: ReadinessTier.enhanced,
        primaryFocus: 'Hypertrophy & Active Recovery',
        dailyMissions: const ['10k Steps', '120g Protein'],
      );

      final compressed = compressor.compressContext(
        dip: dip,
        bmr: 1650.0,
        tdee: 2400.0,
        goal: 'weightLoss',
        dietaryPreference: 'pureVeg',
      );

      expect(compressed['r_score'], equals(85));
      expect(compressed['r_tier'], equals('enhanced'));
      expect(compressed['bmr'], equals(1650));
      expect(compressed['tdee'], equals(2400));
    });
  });
}
