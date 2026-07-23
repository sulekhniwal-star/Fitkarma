import 'dart:convert';
import 'package:drift/native.dart';
import 'package:fitkarma/core/brain/program_evolution_engine.dart';
import 'package:fitkarma/core/brain/transformation_memory.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransformationMemoryService memoryService;
  late ProgramEvolutionEngine evolutionEngine;

  setUp(() async {
    db = AppDatabase.executor(NativeDatabase.memory());
    memoryService = TransformationMemoryService(db);
    evolutionEngine = ProgramEvolutionEngine();
  });

  tearDown(() async {
    await db.close();
  });

  test('ProgramEvolutionEngine calculates correct phase transitions', () {
    // 1. Corporate Fat Loss -> Corporate Recomposition
    final progressLow = UserProgress(
      weightLostKg: 3.5,
      consistencyScore: 82.0,
      bodyFatPct: 24.0,
      leanMassGainedKg: 0.2,
      weeksCompleted: 3,
      targetDatePassed: false,
    );
    expect(
      evolutionEngine.checkEvolution(
        currentProgram: 'Corporate Fat Loss',
        progress: progressLow,
      ),
      isNull,
    );

    final progressHigh = UserProgress(
      weightLostKg: 5.2,
      consistencyScore: 84.0,
      bodyFatPct: 22.0,
      leanMassGainedKg: 0.4,
      weeksCompleted: 5,
      targetDatePassed: false,
    );
    expect(
      evolutionEngine.checkEvolution(
        currentProgram: 'Corporate Fat Loss',
        progress: progressHigh,
      ),
      'Corporate Recomposition',
    );

    // 2. Corporate Recomposition -> Athletic Lean Build
    final recompositionHigh = UserProgress(
      weightLostKg: 6.0,
      consistencyScore: 88.0,
      bodyFatPct: 19.5,
      leanMassGainedKg: 1.2,
      weeksCompleted: 8,
      targetDatePassed: false,
    );
    expect(
      evolutionEngine.checkEvolution(
        currentProgram: 'Corporate Recomposition',
        progress: recompositionHigh,
      ),
      'Athletic Lean Build',
    );

    // 3. Student Hostel Fitness -> Intermediate Strength
    final hostelHigh = UserProgress(
      weightLostKg: 1.0,
      consistencyScore: 86.0,
      bodyFatPct: 15.0,
      leanMassGainedKg: 0.8,
      weeksCompleted: 4,
      targetDatePassed: false,
    );
    expect(
      evolutionEngine.checkEvolution(
        currentProgram: 'Student Hostel Fitness',
        progress: hostelHigh,
      ),
      'Intermediate Strength',
    );
  });

  test(
    'TransformationMemoryService seeds default memory and records evolution events',
    () async {
      final userId = 'user_999';

      // 1. Get or create initializes default memory
      final memory = await memoryService.getOrCreateMemory(userId);
      expect(memory.userId, userId);
      expect(memory.primaryPersonality, 'Competitor');
      expect(jsonDecode(memory.successPatterns), isEmpty);

      // 2. Record evolution event appends log to successPatterns list
      await memoryService.recordEvolutionEvent(
        userId,
        'Corporate Fat Loss',
        'Corporate Recomposition',
      );

      final updatedMemory = await memoryService.getOrCreateMemory(userId);
      final List<dynamic> patterns =
          jsonDecode(updatedMemory.successPatterns) as List<dynamic>;

      expect(patterns.length, 1);
      expect(
        patterns.first,
        contains(
          'Program evolved: Advanced from Corporate Fat Loss to Corporate Recomposition',
        ),
      );
      expect(updatedMemory.syncStatus, 'pending');
    },
  );
}
