/// §P16-B Vernacular Voice Logging — Unit & Widget Tests

import 'package:fitkarma/features/voice/vernacular_voice_log_screen.dart';
import 'package:fitkarma/features/voice/voice_controller.dart';
import 'package:fitkarma/features/voice/voice_log_service.dart';
import 'package:fitkarma/features/voice/voice_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = VoiceLogService();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: VernacularVoiceLogScreen(),
      ),
    );
  }

  group('§P16-B Azure Speech ASR Locale Mapping Tests', () {
    test('maps preferredInputLanguage to exact Azure ASR locale', () {
      expect(VernacularLanguage.toAzureLocale('hi'), equals('hi-IN'));
      expect(VernacularLanguage.toAzureLocale('ta'), equals('ta-IN'));
      expect(VernacularLanguage.toAzureLocale('te'), equals('te-IN'));
      expect(VernacularLanguage.toAzureLocale('mr'), equals('mr-IN'));
      expect(VernacularLanguage.toAzureLocale('bn'), equals('bn-IN'));
      expect(VernacularLanguage.toAzureLocale('kn'), equals('kn-IN'));
      expect(VernacularLanguage.toAzureLocale('en'), equals('en-IN'));
      expect(VernacularLanguage.toAzureLocale('unknown'), equals('en-IN'));
    });
  });

  group('§P16-B Multi-Language & Code-Mixed Voice ASR Tests', () {
    test('transcribes and parses speech across all 7 supported languages', () async {
      for (final lang in VernacularLanguage.values) {
        final result = await service.logFromVoice(preferredLanguage: lang.code);
        expect(result.azureLocale, equals(lang.azureLocale));
        expect(result.transcript, isNotEmpty);
        expect(result.calories, greaterThan(0));
        expect(result.confidenceScore, greaterThan(0.90));
      }
    });

    test('handles code-mixed Hinglish speech ("2 roti aur 1 katori dal khaya")', () async {
      final result = await service.logFromVoice(
        simulatedAudioText: '2 roti aur 1 katori dal khaya',
        preferredLanguage: 'hi',
      );

      expect(result.category, equals(LogCategory.food));
      expect(result.summary, contains('Roti & Dal'));
      expect(result.calories, equals(380));
      expect(result.proteinG, equals(13.5));
    });

    test('handles code-mixed workout speech ("30 mins gym workout kiya")', () async {
      final result = await service.logFromVoice(
        simulatedAudioText: '30 mins gym workout kiya',
        preferredLanguage: 'hi',
      );

      expect(result.category, equals(LogCategory.workout));
      expect(result.durationMins, equals(30));
      expect(result.calories, equals(210));
    });
  });

  group('§P16-B VoiceLogNotifier Integration Tests', () {
    test('updates language selection and processes voice log', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(voiceLogProvider.notifier);

      notifier.setLanguage(VernacularLanguage.tamil);
      expect(container.read(voiceLogProvider).selectedLanguage, equals(VernacularLanguage.tamil));

      await notifier.processVoiceLog(simulatedAudioText: 'Rendhu dosa matrum sambar saapitten');
      final state = container.read(voiceLogProvider);

      expect(state.lastResult, isNotNull);
      expect(state.lastResult!.summary, contains('Dosa & Sambar'));
      expect(state.logHistory, hasLength(1));
    });
  });

  group('§P16-B VernacularVoiceLogScreen Widget Tests', () {
    testWidgets('renders language selector chips, mic button, and code-mixed samples', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('🎙️ Vernacular Voice Logging'), findsOneWidget);
      expect(find.textContaining('Select Speech Language'), findsOneWidget);
      expect(find.text('Hindi (हिंदी)'), findsOneWidget);
      expect(find.text('Tamil (தமிழ்)'), findsOneWidget);
      expect(find.text('2 roti aur 1 katori dal khaya'), findsOneWidget);
    });

    testWidgets('taps sample code-mixed chip and renders parsed macro result card', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('2 roti aur 1 katori dal khaya'));
      await tester.pumpAndSettle();

      expect(find.text('📊 Parsed Macro & Exercise Log'), findsOneWidget);
      expect(find.text('2 Roti & Dal Bowl'), findsOneWidget);
      expect(find.text('380 kcal'), findsOneWidget);
      expect(find.text('✓ 98% Confidence'), findsOneWidget);
    });
  });
}
