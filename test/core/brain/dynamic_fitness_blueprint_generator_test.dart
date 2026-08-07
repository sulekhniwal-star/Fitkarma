import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/dynamic_fitness_blueprint_generator.dart';

void main() {
  group('§P6-D Dynamic Fitness Blueprint Generator Tests', () {
    const generator = DynamicFitnessBlueprintGenerator();

    setUp(() {
      DynamicFitnessBlueprintGenerator.clearCache();
    });

    test('getOrGenerateBlueprint builds Corporate Fat Loss 12-week blueprint per §P6-D spec', () {
      final blueprint = generator.getOrGenerateBlueprint(programName: 'Corporate Fat Loss');

      expect(blueprint.programName, equals('Corporate Fat Loss'));
      expect(blueprint.durationWeeks, equals(12));
      expect(blueprint.daysPerWeek, equals(4));
      expect(blueprint.sessionDuration, equals(45));
      expect(blueprint.phases.length, equals(3));
      expect(blueprint.phases[0].name, equals('Foundation'));
      expect(blueprint.phases[0].weeks, equals('1-3'));
      expect(blueprint.phases[0].intensity, equals('RPE 6-7'));
      expect(blueprint.phases[1].name, equals('Build'));
      expect(blueprint.phases[1].weeks, equals('4-8'));
      expect(blueprint.phases[2].name, equals('Peak'));
      expect(blueprint.phases[2].weeks, equals('9-12'));
      expect(blueprint.deloadWeeks, equals([4, 8, 12]));
      expect(blueprint.isCachedLocally, isTrue);
    });

    test('getOrGenerateBlueprint retrieves locally cached blueprint on subsequent calls without regenerating', () {
      final blueprint1 = generator.getOrGenerateBlueprint(programName: 'Corporate Fat Loss');
      final blueprint2 = generator.getOrGenerateBlueprint(programName: 'Corporate Fat Loss');

      expect(blueprint2.generatedAt, equals(blueprint1.generatedAt));
      expect(blueprint2.toRawJson(), equals(blueprint1.toRawJson()));
    });

    test('triggerProgramEvolutionEvent forces regeneration of blueprint', () {
      final blueprint1 = generator.getOrGenerateBlueprint(programName: 'Corporate Fat Loss');

      // Simulate time passing
      final evolvedBlueprint = generator.triggerProgramEvolutionEvent(
        programName: 'Corporate Fat Loss',
        evolutionReason: 'Phase 1 Completed',
      );

      expect(evolvedBlueprint.programName, equals('Corporate Fat Loss'));
      expect(evolvedBlueprint.durationWeeks, equals(12));
    });
  });
}
