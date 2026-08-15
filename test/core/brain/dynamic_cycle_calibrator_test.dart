import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/dynamic_cycle_calibrator.dart';

void main() {
  group('DynamicCycleCalibrator Unit Tests', () {
    const calibrator = DynamicCycleCalibrator();

    test(
        'recalibratePhase returns default calendar when symptom logs are empty',
        () {
      final state = calibrator.recalibratePhase(
        symptomLogs: [],
        defaultCycleLengthDays: 28,
      );

      expect(state.currentCycleDay, equals(1));
      expect(state.projectedCycleLength, equals(28));
      expect(state.currentPhase, equals(CyclePhase.follicular));
      expect(state.isIrregularDetected, isFalse);
    });

    test('recalibratePhase detects ovulation via positive LH test', () {
      final now = DateTime.now();
      final cycleStart = now.subtract(const Duration(days: 12));
      final lhTestDate = now.subtract(const Duration(days: 2));

      final logs = [
        MenstrualSymptomLog(
          logDate: cycleStart,
          hasMenstrualFlow: true,
          physicalSymptoms: ['cramps'],
        ),
        MenstrualSymptomLog(
          logDate: lhTestDate,
          hasMenstrualFlow: false,
          positiveLhTest: true,
          physicalSymptoms: ['egg_white_mucus'],
        ),
      ];

      final state = calibrator.recalibratePhase(
        symptomLogs: logs,
        defaultCycleLengthDays: 28,
      );

      expect(state.currentCycleDay, equals(13));
      expect(state.isIrregularDetected, isFalse);
      expect(state.currentPhase, isNotNull);
    });

    test(
        'recalibratePhase detects irregularity when cycle length variance is high',
        () {
      final now = DateTime.now();
      final cycle1 = now.subtract(const Duration(days: 75));
      final cycle2 = now.subtract(const Duration(days: 40)); // 35 day cycle
      final cycle3 = now.subtract(const Duration(days: 15)); // 25 day cycle

      final logs = [
        MenstrualSymptomLog(
            logDate: cycle1, hasMenstrualFlow: true, physicalSymptoms: []),
        MenstrualSymptomLog(
            logDate: cycle2, hasMenstrualFlow: true, physicalSymptoms: []),
        MenstrualSymptomLog(
            logDate: cycle3, hasMenstrualFlow: true, physicalSymptoms: []),
      ];

      final state = calibrator.recalibratePhase(
        symptomLogs: logs,
        defaultCycleLengthDays: 28,
      );

      expect(state.isIrregularDetected, isTrue);
    });
  });
}
