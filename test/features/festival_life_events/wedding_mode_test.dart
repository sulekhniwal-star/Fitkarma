import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/festival_life_events/domain/wedding_mode_engine.dart';
import 'package:fitkarma/features/festival_life_events/domain/wedding_mode_models.dart';

void main() {
  group('WeddingModeEngine Deterministic Tests', () {
    const engine = WeddingModeEngine();

    test('Generates tailored Bridal plan with Definition phase and Ojas skin protocol', () {
      final now = DateTime(2026, 9, 9, 12, 0);
      final weddingDate = now.add(const Duration(days: 45)); // 6.5 weeks

      final report = engine.generateWeddingPlan(
        role: WeddingRole.bride,
        weddingDate: weddingDate,
        currentWeightKg: 62.0,
        targetWeightKg: 58.0,
        targetBodyFatPercent: 20.0,
        executionTime: now,
      );

      expect(report.role, equals(WeddingRole.bride));
      expect(report.daysUntilWedding, equals(45));
      expect(report.currentPhase, equals(WeddingTimelinePhase.definition));
      expect(report.activePillarActions.length, equals(3));
      expect(report.activePillarActions.any((a) => a.pillar.contains('Bridal Posture')), isTrue);
      expect(report.ojasSkinRadianceProtocol, contains('saffron-turmeric'));
      expect(report.regionalOjasSkinRadianceProtocol, contains('केसर-हल्दी'));
    });

    test('Generates Groom Sherwani V-taper silhouette actions', () {
      final now = DateTime(2026, 9, 9);
      final weddingDate = now.add(const Duration(days: 60)); // Foundation phase

      final report = engine.generateWeddingPlan(
        role: WeddingRole.groom,
        weddingDate: weddingDate,
        currentWeightKg: 82.0,
        targetWeightKg: 76.0,
        targetBodyFatPercent: 14.0,
        executionTime: now,
      );

      expect(report.role, equals(WeddingRole.groom));
      expect(report.currentPhase, equals(WeddingTimelinePhase.foundation));
      expect(report.activePillarActions.any((a) => a.actionTitle.contains('Lateral Deltoids')), isTrue);
    });

    test('Activates Peak Week protocol when wedding is within 7 days', () {
      final now = DateTime(2026, 9, 9);
      final weddingDate = now.add(const Duration(days: 5)); // 5 days left

      final report = engine.generateWeddingPlan(
        role: WeddingRole.bride,
        weddingDate: weddingDate,
        currentWeightKg: 58.5,
        targetWeightKg: 58.0,
        targetBodyFatPercent: 20.0,
        executionTime: now,
      );

      expect(report.currentPhase, equals(WeddingTimelinePhase.peakWeek));
      expect(report.activePillarActions.any((a) => a.pillar.contains('Peak Week Nutrition')), isTrue);
      expect(report.peakWeekDeBloatTip, contains('Final 7 Days Peak Protocol'));
      expect(report.regionalPeakWeekDeBloatTip, contains('पीक वीक नियम'));
    });

    test('All WeddingRole values generate complete valid transformation plans', () {
      final now = DateTime(2026, 9, 9);
      for (final role in WeddingRole.values) {
        final report = engine.generateWeddingPlan(
          role: role,
          weddingDate: now.add(const Duration(days: 20)),
          currentWeightKg: 70.0,
          targetWeightKg: 65.0,
          targetBodyFatPercent: 18.0,
          executionTime: now,
        );

        expect(report.role, equals(role));
        expect(report.activePillarActions, isNotEmpty);
        expect(report.ojasSkinRadianceProtocol, isNotEmpty);
        expect(report.sangeetStaminaRecommendation, isNotEmpty);
      }
    });
  });
}
