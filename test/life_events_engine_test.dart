/// §P12-B Life Events Engine — Unit & Integration Tests

import 'package:fitkarma/features/life_events/life_events_engine.dart';
import 'package:fitkarma/features/life_events/life_events_models.dart';
import 'package:fitkarma/features/life_events/life_events_notifier.dart';
import 'package:fitkarma/features/transformation/transformation_memory_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = LifeEventsEngine();

  group('§P12-B LifeEventsEngine Adaptations Tests', () {
    test('injury event generates RPE cap 5 and restricted exercise tags', () {
      final record = LifeEventRecord(
        localId: 'le_1',
        userId: 'u1',
        eventType: LifeEventType.injury,
        eventData: {'injuredRegion': 'Knee'},
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      final adaptation = engine.adapt(record);

      expect(adaptation.rpeCap, equals(5));
      expect(adaptation.restrictedExerciseTags, contains('knee'));
      expect(adaptation.recoveryFirst, isTrue);
      expect(adaptation.adaptationSummary, contains('Knee'));
    });

    test('travelAbroad event generates 20-min workouts and +150 kcal buffer', () {
      final record = LifeEventRecord(
        localId: 'le_2',
        userId: 'u1',
        eventType: LifeEventType.travelAbroad,
        eventData: {'destination': 'London'},
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      final adaptation = engine.adapt(record);

      expect(adaptation.reducedWorkoutDurationMin, equals(20));
      expect(adaptation.calorieAdjustment, equals(150));
      expect(adaptation.workoutBrief, isTrue);
    });

    test('officeDeadline event generates stress management and 20-min express workouts', () {
      final record = LifeEventRecord(
        localId: 'le_3',
        userId: 'u1',
        eventType: LifeEventType.officeDeadline,
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      final adaptation = engine.adapt(record);

      expect(adaptation.workoutBrief, isTrue);
      expect(adaptation.stressManagement, isTrue);
      expect(adaptation.reducedWorkoutDurationMin, equals(20));
    });

    test('newBaby event lowers sleep readiness expectations & sets 15-min workouts', () {
      final record = LifeEventRecord(
        localId: 'le_4',
        userId: 'u1',
        eventType: LifeEventType.newBaby,
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      final adaptation = engine.adapt(record);

      expect(adaptation.sleepReadinessLowered, isTrue);
      expect(adaptation.reducedWorkoutDurationMin, equals(15));
      expect(adaptation.recoveryFirst, isTrue);
    });
  });

  group('§P12-B Drift Table Serialization Tests', () {
    test('serializes LifeEventRecord to LifeEvents JSON map correctly', () {
      final record = LifeEventRecord(
        localId: 'le_100',
        userId: 'u_test',
        eventType: LifeEventType.wedding,
        eventData: {'weddingDate': '2026-12-15'},
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      final json = record.toLifeEventsJson();

      expect(json['localId'], equals('le_100'));
      expect(json['eventType'], equals('wedding'));
      expect(json['isActive'], isTrue);
      expect(json['eventData'], contains('2026-12-15'));
    });
  });

  group('§P12-B Transformation Memory Wiring Integration Tests', () {
    test('wires injury event into Transformation Memory injuries list', () {
      final repo = TransformationMemoryRepository();
      final record = LifeEventRecord(
        localId: 'le_1',
        userId: 'u1',
        eventType: LifeEventType.injury,
        eventData: {'injuredRegion': 'Lower Back'},
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      engine.wireIntoTransformationMemory(record, repo);

      expect(repo.memory.injuries.any((i) => i.contains('Lower Back')), isTrue);
    });

    test('wires wedding event into Transformation Memory motivation triggers', () {
      final repo = TransformationMemoryRepository();
      final record = LifeEventRecord(
        localId: 'le_2',
        userId: 'u1',
        eventType: LifeEventType.wedding,
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      engine.wireIntoTransformationMemory(record, repo);

      expect(repo.memory.motivationTriggers.any((m) => m.contains('Wedding Transformation')), isTrue);
    });

    test('wires officeDeadline event into Transformation Memory major struggles', () {
      final repo = TransformationMemoryRepository();
      final record = LifeEventRecord(
        localId: 'le_3',
        userId: 'u1',
        eventType: LifeEventType.officeDeadline,
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      engine.wireIntoTransformationMemory(record, repo);

      expect(repo.memory.majorStruggles.any((s) => s.contains('officeDeadline')), isTrue);
    });

    test('LifeEventsNotifier logs event and updates state and Transformation Memory', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final memoryRepo = container.read(transformationMemoryRepositoryProvider);
      final notifier = container.read(lifeEventsProvider.notifier);

      final record = LifeEventRecord(
        localId: 'le_notifier_1',
        userId: 'u1',
        eventType: LifeEventType.travelAbroad,
        eventData: {'destination': 'Tokyo'},
        startDate: DateTime(2026, 7, 25),
        createdAt: DateTime(2026, 7, 25),
      );

      notifier.logLifeEvent(record, memoryRepo);
      final state = container.read(lifeEventsProvider);

      expect(state.activeEvents.length, equals(1));
      expect(state.activeAdaptation, isNotNull);
      expect(state.successMessage, contains('wired into Transformation Memory'));
      expect(memoryRepo.memory.successPatterns.any((p) => p.contains('Tokyo')), isTrue);
    });
  });
}
