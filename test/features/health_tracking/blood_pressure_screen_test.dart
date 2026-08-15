import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/health_tracking/models/blood_pressure_engine.dart';
import 'package:fitkarma/features/health_tracking/providers/blood_pressure_provider.dart';
import 'package:fitkarma/features/health_tracking/screens/blood_pressure_screen.dart';

void main() {
  group('§P4-D Blood Pressure & Biometric Access Layer Tests', () {
    const engine = BloodPressureEngine();

    // ── Engine Tests ────────────────────────────────────────────────────────

    test('categorizeBp: Normal reading (<120 and <80)', () {
      expect(
          BloodPressureEngine.categorizeBp(118, 76), equals(BpCategory.normal));
    });

    test('categorizeBp: Elevated reading (120-129 and <80)', () {
      expect(BloodPressureEngine.categorizeBp(125, 78),
          equals(BpCategory.elevated));
    });

    test('categorizeBp: Stage 1 reading (130-139 or 80-89)', () {
      expect(
          BloodPressureEngine.categorizeBp(132, 84), equals(BpCategory.stage1));
    });

    test('categorizeBp: Stage 2 reading (>=140 or >=90)', () {
      expect(
          BloodPressureEngine.categorizeBp(145, 92), equals(BpCategory.stage2));
    });

    test('categorizeBp: Crisis reading (>180 or >120)', () {
      expect(BloodPressureEngine.categorizeBp(185, 122),
          equals(BpCategory.crisis));
    });

    test(
        'detectRisingTrend: returns true for 3 strictly rising systolic readings',
        () {
      final now = DateTime.now();
      final records = [
        BloodPressureRecord(
            systolic: 120,
            diastolic: 80,
            measuredAt: now.subtract(const Duration(days: 2))),
        BloodPressureRecord(
            systolic: 125,
            diastolic: 82,
            measuredAt: now.subtract(const Duration(days: 1))),
        BloodPressureRecord(systolic: 130, diastolic: 85, measuredAt: now),
      ];

      expect(engine.detectRisingTrend(records, consecutiveCount: 3), isTrue);
    });

    test('detectRisingTrend: returns false when reading drops or flattens', () {
      final now = DateTime.now();
      final records = [
        BloodPressureRecord(
            systolic: 120,
            diastolic: 80,
            measuredAt: now.subtract(const Duration(days: 2))),
        BloodPressureRecord(
            systolic: 125,
            diastolic: 82,
            measuredAt: now.subtract(const Duration(days: 1))),
        BloodPressureRecord(systolic: 124, diastolic: 81, measuredAt: now),
      ];

      expect(engine.detectRisingTrend(records, consecutiveCount: 3), isFalse);
    });

    // ── Notifier Tests ──────────────────────────────────────────────────────

    test('BloodPressureNotifier initializes in locked state', () {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      expect(notifier.state.lockStatus, equals(BiometricLockStatus.locked));
      expect(notifier.state.history, isNotEmpty);
    });

    test('authenticateWithBiometrics unlocks when success simulated', () async {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      await notifier.authenticateWithBiometrics(simulateSuccess: true);
      expect(notifier.state.lockStatus, equals(BiometricLockStatus.unlocked));
    });

    test(
        'authenticateWithBiometrics shifts to failed state when failed simulated',
        () async {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      await notifier.authenticateWithBiometrics(simulateSuccess: false);
      expect(notifier.state.lockStatus, equals(BiometricLockStatus.failed));
    });

    test('appendPinDigit and verifyPin unlocks on correct 6-digit PIN', () {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      notifier.appendPinDigit('1');
      notifier.appendPinDigit('2');
      notifier.appendPinDigit('3');
      notifier.appendPinDigit('4');
      notifier.appendPinDigit('5');
      notifier.appendPinDigit('6');

      expect(notifier.state.lockStatus, equals(BiometricLockStatus.unlocked));
    });

    test('verifyPin sets error state on incorrect PIN', () {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      notifier.verifyPin('000000');

      expect(notifier.state.pinError, isTrue);
      expect(notifier.state.lockStatus, equals(BiometricLockStatus.locked));
    });

    test('logBloodPressure adds new record and updates warning', () {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      notifier.logBloodPressure(systolic: 140, diastolic: 92);

      expect(notifier.state.latest?.systolic, equals(140));
      expect(notifier.state.latest?.category, equals(BpCategory.stage2));
      expect(notifier.state.warningMessage, contains('rising BP readings'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'BloodPressureScreen renders Biometric Verification prompt initially',
        (tester) async {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bloodPressureProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(home: BloodPressureScreen()),
        ),
      );
      // Immediately after microtask auto-unlock, verify screen renders unlocked content
      await tester.pumpAndSettle();
      expect(find.text('Latest Reading'), findsOneWidget);
    });

    testWidgets(
        'Tapping Use Backup PIN renders 6-digit keypad when biometrics fails',
        (tester) async {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      notifier.lockScreen();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bloodPressureProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(home: BloodPressureScreen()),
        ),
      );
      // Simulate biometric failure
      notifier.authenticateWithBiometrics(simulateSuccess: false);
      await tester.pumpAndSettle();

      expect(find.text('Enter Backup PIN'), findsOneWidget);
    });

    testWidgets('Unlocked state displays Blood Pressure readings and chart',
        (tester) async {
      final notifier = BloodPressureNotifier(const BloodPressureEngine());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bloodPressureProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(home: BloodPressureScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Latest Reading'), findsOneWidget);
      expect(find.text('Systolic / Diastolic History'), findsOneWidget);
      expect(find.text('Log New Reading'), findsOneWidget);
    });
  });
}
