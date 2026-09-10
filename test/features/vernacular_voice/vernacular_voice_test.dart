import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/vernacular_voice/domain/voice_engine.dart';
import 'package:fitkarma/features/vernacular_voice/domain/voice_models.dart';
import 'package:fitkarma/features/vernacular_voice/providers/voice_provider.dart';

void main() {
  group('VoiceEngine Multilingual Deterministic Tests', () {
    const engine = VoiceEngine();

    test('Parses North Indian Hinglish meal transcripts accurately', () {
      final result = engine.processVoiceTranscript(
        transcript: '2 roti, 1 bowl dal tadka aur cucumber salad',
      );

      expect(result.detectedLanguage, equals(VernacularLanguage.hinglish));
      expect(result.parsedEntity.intentType,
          equals(VoiceIntentType.mealNutrition));
      expect(result.parsedEntity.calories, greaterThan(300.0));
      expect(result.parsedEntity.proteinGrams, greaterThan(10.0));
      expect(result.parsedEntity.detectedFoodItems.length,
          greaterThanOrEqualTo(2));
      expect(result.confidenceScore, greaterThan(0.85));
    });

    test('Parses Marathi regional cuisine (Jowar Bhakri & Pithla)', () {
      final result = engine.processVoiceTranscript(
        transcript: 'दोन ज्वारीची भाकरी आणि पिठलं',
      );

      expect(result.detectedLanguage, equals(VernacularLanguage.marathi));
      expect(result.parsedEntity.intentType,
          equals(VoiceIntentType.mealNutrition));
      expect(result.parsedEntity.calories, greaterThan(200.0));
    });

    test('Parses South Indian Tamil & Telugu staples (Idli & Dosa)', () {
      final resTamil = engine.processVoiceTranscript(
        transcript: 'இரண்டு இட்லி சாம்பார்',
      );
      expect(resTamil.detectedLanguage, equals(VernacularLanguage.tamil));
      expect(resTamil.parsedEntity.intentType,
          equals(VoiceIntentType.mealNutrition));
      expect(resTamil.parsedEntity.carbsGrams, greaterThan(20.0));

      final resTelugu = engine.processVoiceTranscript(
        transcript: 'రెండు దోశలు మరియు పప్పు',
      );
      expect(resTelugu.detectedLanguage, equals(VernacularLanguage.telugu));
      expect(resTelugu.parsedEntity.calories, greaterThan(250.0));
    });

    test('Parses hydration and water voice transcripts', () {
      final res1 =
          engine.processVoiceTranscript(transcript: '500ml water please');
      expect(
          res1.parsedEntity.intentType, equals(VoiceIntentType.waterHydration));
      expect(res1.parsedEntity.waterMl, equals(500));

      final res2 =
          engine.processVoiceTranscript(transcript: '1 glass coconut water');
      expect(
          res2.parsedEntity.intentType, equals(VoiceIntentType.waterHydration));
      expect(res2.parsedEntity.waterMl, equals(300));
    });

    test('Parses workout and physical activity voice logs', () {
      final res = engine.processVoiceTranscript(
        transcript: 'Subah 45 minute walk kiya aur 5500 steps hue',
      );

      expect(res.parsedEntity.intentType,
          equals(VoiceIntentType.workoutPhysicalActivity));
      expect(res.parsedEntity.workoutDurationMinutes, equals(45));
      expect(res.parsedEntity.stepsCount, equals(5500));
      expect(res.parsedEntity.calories, greaterThan(200.0));
    });

    test('Generates audio confirmation prompt for TTS engine', () {
      final result = engine.processVoiceTranscript(
        transcript: '2 roti dal curd',
      );
      final prompt = engine.generateAudioPrompt(result);

      expect(prompt.spokenText, contains('Logged'));
      expect(prompt.spokenText, contains('calories'));
      expect(prompt.regionalSpokenText, contains('दर्ज'));
    });
  });

  group('VernacularVoiceNotifier State Tests', () {
    test(
        'Handles language switching, recording lifecycle, and session processing',
        () {
      final notifier = VernacularVoiceNotifier();
      expect(
          notifier.state.selectedLanguage, equals(VernacularLanguage.hinglish));

      notifier.selectLanguage(VernacularLanguage.marathi);
      expect(
          notifier.state.selectedLanguage, equals(VernacularLanguage.marathi));

      notifier.startListening();
      expect(
          notifier.state.recordingState, equals(VoiceRecordingState.listening));

      notifier.processVoiceInput('1 plate biryani aur 1 glass chaas');
      expect(
          notifier.state.recordingState, equals(VoiceRecordingState.success));
      expect(notifier.state.currentTranscript?.parsedEntity.calories,
          greaterThan(400.0));
      expect(notifier.state.voiceHistory.isNotEmpty, isTrue);

      notifier.resetSession();
      expect(notifier.state.recordingState, equals(VoiceRecordingState.idle));
    });
  });
}
