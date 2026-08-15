import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/voice_log_service.dart';

void main() {
  group('§P16-B Vernacular Voice Logging Service Tests', () {
    final service = VoiceLogService();

    test('Maps all 7 Indian launch languages to correct Whisper locales', () {
      expect(service.toWhisperLocale('hi'), equals('hi-IN'));
      expect(service.toWhisperLocale('ta'), equals('ta-IN'));
      expect(service.toWhisperLocale('te'), equals('te-IN'));
      expect(service.toWhisperLocale('mr'), equals('mr-IN'));
      expect(service.toWhisperLocale('bn'), equals('bn-IN'));
      expect(service.toWhisperLocale('kn'), equals('kn-IN'));
      expect(service.toWhisperLocale('en'), equals('en-IN'));
    });

    test('Transcribes and parses Hindi voice utterance with code-mixing',
        () async {
      final customClient = MockSpeechToTextClient(
        simulatedTranscript: 'मैंने 2 रोटी और दाल तड़का खाया',
      );
      final voiceService = VoiceLogService(customClient);

      final result = await voiceService.logFromVoice(
        audioBytes: Uint8List(10),
        preferredLanguage: VernacularLanguage.hindi,
      );

      expect(result.detectedLanguageLocale, equals('hi-IN'));
      expect(result.rawTranscript, contains('रोटी'));
      expect(result.parsedSummary, contains('Whole Wheat Roti'));
      expect(result.totalCalories, greaterThan(0));
      expect(result.totalProteinGrams, greaterThan(0));
    });

    test('Transcribes and parses Tamil food voice utterance', () async {
      final customClient = MockSpeechToTextClient(
        simulatedTranscript: 'இன்று 2 இட்லி மற்றும் சாம்பார் சாப்பிட்டேன்',
      );
      final voiceService = VoiceLogService(customClient);

      final result = await voiceService.logFromVoice(
        audioBytes: Uint8List(10),
        preferredLanguage: VernacularLanguage.tamil,
      );

      expect(result.detectedLanguageLocale, equals('ta-IN'));
      expect(result.parsedSummary, contains('Idli Sambhar'));
      expect(result.totalCalories, greaterThan(0));
    });

    test('Transcribes and parses Marathi food voice utterance', () async {
      final customClient = MockSpeechToTextClient(
        simulatedTranscript: 'मी पोहे खाल्ले',
      );
      final voiceService = VoiceLogService(customClient);

      final result = await voiceService.logFromVoice(
        audioBytes: Uint8List(10),
        preferredLanguage: VernacularLanguage.marathi,
      );

      expect(result.detectedLanguageLocale, equals('mr-IN'));
      expect(result.parsedSummary, contains('Poha with Peanuts'));
      expect(result.totalCalories, equals(250));
    });

    test('Transcribes and parses Telugu food voice utterance', () async {
      final customClient = MockSpeechToTextClient(
        simulatedTranscript: 'నేను రెండు దోశలు తిన్నాను',
      );
      final voiceService = VoiceLogService(customClient);

      final result = await voiceService.logFromVoice(
        audioBytes: Uint8List(10),
        preferredLanguage: VernacularLanguage.telugu,
      );

      expect(result.detectedLanguageLocale, equals('te-IN'));
      expect(result.parsedSummary, contains('Masala Dosa'));
    });

    test('Transcribes and parses Bengali fish & rice food voice utterance',
        () async {
      final customClient = MockSpeechToTextClient(
        simulatedTranscript: 'আমি ভাত আর মাছ খেয়েছি',
      );
      final voiceService = VoiceLogService(customClient);

      final result = await voiceService.logFromVoice(
        audioBytes: Uint8List(10),
        preferredLanguage: VernacularLanguage.bengali,
      );

      expect(result.detectedLanguageLocale, equals('bn-IN'));
      expect(result.parsedSummary, contains('Rice'));
      expect(result.parsedSummary, contains('Fish Curry'));
      expect(result.totalCalories, equals(400)); // 180 + 220
    });

    test('Transcribes and parses Kannada food voice utterance', () async {
      final customClient = MockSpeechToTextClient(
        simulatedTranscript: 'ನಾನು ರೊಟ್ಟಿ ತಿಂದಿದ್ದೇನೆ',
      );
      final voiceService = VoiceLogService(customClient);

      final result = await voiceService.logFromVoice(
        audioBytes: Uint8List(10),
        preferredLanguage: VernacularLanguage.kannada,
      );

      expect(result.detectedLanguageLocale, equals('kn-IN'));
      expect(result.parsedSummary, contains('Whole Wheat Roti'));
    });

    test('Transcribes and parses Workout voice utterance', () async {
      final customClient = MockSpeechToTextClient(
        simulatedTranscript:
            'I did a 35 minute morning running and pushup workout',
      );
      final voiceService = VoiceLogService(customClient);

      final result = await voiceService.logFromVoice(
        audioBytes: Uint8List(10),
        preferredLanguage: VernacularLanguage.englishIndia,
      );

      expect(result.isWorkoutLog, isTrue);
      expect(result.parsedSummary, contains('Running'));
      expect(result.workoutDurationMinutes, equals(35));
    });
  });
}
