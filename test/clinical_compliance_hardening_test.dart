/// §P10-M Clinical Compliance Hardening 🔒 — Unit Tests

import 'package:fitkarma/features/predictive/clinical_copy_linter.dart';
import 'package:fitkarma/features/predictive/legal_signoff_schedule.dart';
import 'package:fitkarma/features/predictive/phase10_feature_flag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const linter = ClinicalCopyLinter();

  group('§P10-M ClinicalCopyLinter Banned Directive Pattern Tests', () {
    test('detects "stop taking" directive violation', () {
      const copy = 'Stop taking your blood pressure medication immediately.';
      final violations = linter.lint(copy);

      expect(violations, isNotEmpty);
      expect(violations.first, contains('stop taking'));
      expect(linter.isCompliant(copy), isFalse);
    });

    test('detects "avoid" without "consult" directive violation', () {
      const copy = 'Avoid eating grapefruit while on statins.';
      final violations = linter.lint(copy);

      expect(violations, isNotEmpty);
      expect(violations.first, contains('avoid'));
      expect(linter.isCompliant(copy), isFalse);
    });

    test('allows "avoid" when "consult" is present nearby', () {
      const copy = 'Consult your physician before attempting to avoid prescribed supplements.';
      final violations = linter.lint(copy);

      expect(violations, isEmpty);
      expect(linter.isCompliant(copy), isTrue);
    });

    test('detects "reduce your dose" and "switch to" directive violations', () {
      expect(linter.isCompliant('Reduce your dose if side effects occur.'), isFalse);
      expect(linter.isCompliant('Do not take with milk.'), isFalse);
      expect(linter.isCompliant('Switch to a low-sodium diet.'), isFalse);
    });

    test('sanitizes prohibited terms into compliant non-diagnostic copy', () {
      const raw = 'You are diagnosed with hypertension and this treatment cures it.';
      final sanitized = linter.lintAndSanitize(raw);

      expect(sanitized, isNot(contains('diagnosed with')));
      expect(sanitized, isNot(contains('cures')));
      expect(sanitized, contains('observations indicate potential markers for'));
      expect(sanitized, contains('Informational only'));
    });
  });

  group('§P10-M Phase 10 Feature Flag Gating Tests', () {
    test('gates Phase 10 behind feature flag and opt-in cohort', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(phase10FeatureFlagProvider);
      expect(state.isEnabled, isTrue);
      expect(state.canAccessPhase10, isTrue);

      // Disable Phase 10
      container.read(phase10FeatureFlagProvider.notifier).disable();
      expect(container.read(phase10FeatureFlagProvider).canAccessPhase10, isFalse);

      // Enable for specific cohort
      container.read(phase10FeatureFlagProvider.notifier).enableForCohort('beta-cohort-001');
      expect(container.read(phase10FeatureFlagProvider).canAccessPhase10, isTrue);
    });
  });

  group('§P10-M Legal Sign-Off Review Scheduler Tests', () {
    test('schedules pre-launch legal review items 14 days before GA date', () {
      const scheduler = LegalSignoffScheduler();
      final targetGa = DateTime(2026, 8, 15);
      final schedule = scheduler.createPreLaunchSchedule(targetGaDate: targetGa);

      expect(schedule, hasLength(3));
      expect(schedule.first.scheduledDate, equals(DateTime(2026, 8, 1)));
      expect(scheduler.isClearedForGeneralAvailability(schedule), isFalse);

      // Approve all reviews
      final approvedSchedule = schedule.map((item) {
        return item.approve(reviewer: 'Compliance Counsel', token: 'legal-token-99');
      }).toList();

      expect(scheduler.isClearedForGeneralAvailability(approvedSchedule), isTrue);
    });
  });
}
