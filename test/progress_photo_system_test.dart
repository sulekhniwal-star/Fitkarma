/// §P11-B Progress Photo System — Unit & Widget Tests

import 'dart:typed_data';
import 'package:fitkarma/features/progress_photo/progress_photo_models.dart';
import 'package:fitkarma/features/progress_photo/progress_photo_notifier.dart';
import 'package:fitkarma/features/progress_photo/progress_photo_screen.dart';
import 'package:fitkarma/features/progress_photo/secure_photo_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const storage = SecurePhotoStorageService();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: ProgressPhotoScreen(),
      ),
    );
  }

  group('§P11-B Secure Local Photo Storage Unit Tests', () {
    test('encrypts and decrypts photo bytes symmetrically', () {
      final rawBytes = Uint8List.fromList([10, 20, 30, 40, 50, 100, 200, 255]);
      final encrypted = storage.encryptBytes(rawBytes);

      expect(encrypted, isNot(equals(rawBytes)));

      final decrypted = storage.decryptBytes(encrypted);
      expect(decrypted, equals(rawBytes));
    });

    test('encodes to and decodes from encrypted base64 correctly', () {
      final rawBytes = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final base64Enc = storage.encryptToBase64(rawBytes);

      expect(base64Enc, isNotEmpty);

      final decrypted = storage.decryptFromBase64(base64Enc);
      expect(decrypted, equals(rawBytes));
    });
  });

  group('§P11-B Progress Photo Models & Metadata Tests', () {
    test('serializes TransformationCheck metadata json correctly', () {
      final entry = ProgressPhotoEntry(
        localId: 'tc_101',
        userId: 'user_1',
        checkDate: DateTime(2026, 7, 25),
        weightKg: 72.5,
        bodyFatPct: 18.0,
        waistCm: 82.0,
        photoTag: 'Front',
        notes: 'Monthly check',
      );

      final json = entry.toTransformationCheckJson();

      expect(json['localId'], equals('tc_101'));
      expect(json['photoPath'], equals('encrypted://tc_101.enc'));
      expect(json['weightKg'], equals(72.5));
      expect(json['photoTag'], equals('Front'));
    });

    test('calculates comparison deltas and elapsed days', () {
      final before = ProgressPhotoEntry(
        localId: 'tc_1',
        userId: 'u1',
        checkDate: DateTime(2026, 6, 25),
        weightKg: 75.0,
        waistCm: 86.0,
        bodyFatPct: 20.0,
      );

      final after = ProgressPhotoEntry(
        localId: 'tc_2',
        userId: 'u1',
        checkDate: DateTime(2026, 7, 25),
        weightKg: 72.0,
        waistCm: 82.0,
        bodyFatPct: 17.5,
      );

      final comp = ProgressPhotoComparison(before: before, after: after);

      expect(comp.weightDeltaKg, equals(-3.0));
      expect(comp.waistDeltaCm, equals(-4.0));
      expect(comp.bodyFatDeltaPct, equals(-2.5));
      expect(comp.elapsedDays, equals(30));
    });
  });

  group('§P11-B ProgressPhotoScreen Widget Tests', () {
    testWidgets('renders vault header, security shield, comparison, and gallery', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('📸 Progress Photo Vault'), findsOneWidget);
      expect(find.textContaining('Secure Local Storage'), findsOneWidget);
      expect(find.textContaining('Side-by-Side Photo Comparison'), findsOneWidget);
      expect(find.textContaining('Transformation Photo Gallery'), findsOneWidget);
    });

    testWidgets('triggers capture dialog and saves encrypted progress photo', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Tap Capture Check-In FAB
      await tester.tap(find.text('Capture Check-In'));
      await tester.pumpAndSettle();

      expect(find.text('Capture Transformation Photo'), findsOneWidget);
      expect(find.text('Photo Captured & Encrypted at Rest 🔒'), findsOneWidget);

      await tester.tap(find.text('Encrypt & Save'));
      await tester.pumpAndSettle();

      expect(find.textContaining('encrypted at rest 🔒 and persisted to TransformationChecks'), findsOneWidget);
    });
  });
}
