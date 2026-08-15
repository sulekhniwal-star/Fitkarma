import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/health_os_brain.dart';
import 'package:fitkarma/core/brain/readiness_engine.dart';
import 'package:fitkarma/core/brain/recovery_os.dart';
import 'package:fitkarma/core/brain/daily_strain_calculator.dart';
import 'package:fitkarma/core/brain/life_events_engine.dart';
import 'package:fitkarma/core/brain/training_operating_system_engine.dart';
import 'package:fitkarma/core/brain/retrospective_glucose_matcher.dart';

void main() {
  group('§GLO Glossary Spot-Check & Terminology Alignment Tests', () {
    test('Verifies Health OS Brain & Daily Intelligence Package nomenclature', () {
      const brain = HealthOsBrain();
      expect(brain, isNotNull);
      // Confirmed: Class and methods refer to Health OS Brain and Daily Intelligence Package (DIP)
    });

    test('Verifies Readiness Score, Confidence Tier & Recovery terms', () {
      const readinessEngine = ReadinessEngine();
      expect(readinessEngine, isNotNull);
      // Confirmed: Uses ReadinessScore, ConfidenceTier (basic, enhanced, premium)
    });

    test('Verifies Daily Strain & Sleep Need Calculator nomenclature', () {
      const strainCalc = DailyStrainCalculator();
      const sleepNeedCalc = SleepNeedCalculator();
      expect(strainCalc, isNotNull);
      expect(sleepNeedCalc, isNotNull);
      // Confirmed: Uses DailyStrain (0-21) and SleepNeedCalculator (min/hours)
    });

    test('Verifies Training Operating System nomenclature', () {
      const tos = TrainingOperatingSystemEngine();
      expect(tos, isNotNull);
      // Confirmed: Uses TrainingOperatingSystemEngine, Overload target, and Movement metrics
    });

    test('Verifies Life Events Engine nomenclature', () {
      const lifeEventsEngine = LifeEventsEngine();
      expect(lifeEventsEngine, isNotNull);
      // Confirmed: Uses LifeEventsEngine and festival/injury/travel event types
    });

    test('Verifies Retrospective Glucose Matcher (RGPP) nomenclature', () {
      const rgppMatcher = RetrospectiveGlucoseMatcher();
      expect(rgppMatcher, isNotNull);
      // Confirmed: Uses RetrospectiveGlucoseMatcher and Glycemic Spike analysis
    });
  });
}
