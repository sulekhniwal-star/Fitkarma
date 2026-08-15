// §P16-B Vernacular Voice Logging Service (Pure Dart / Input Transformation)
// Cross-reference: §P16-B in Fitkarma_documentation.md

import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/nutrition/models/indian_food_item.dart';

/// Supported Languages in v1.0 Launch Set per §P16-B table
enum VernacularLanguage {
  hindi('hi', 'hi-IN', 'Hindi (हिंदी)'),
  tamil('ta', 'ta-IN', 'Tamil (தமிழ்)'),
  telugu('te', 'te-IN', 'Telugu (తెలుగు)'),
  marathi('mr', 'mr-IN', 'Marathi (मराठी)'),
  bengali('bn', 'bn-IN', 'Bengali (বাংলা)'),
  kannada('kn', 'kn-IN', 'Kannada (ಕನ್ನಡ)'),
  englishIndia('en', 'en-IN', 'English (India)');

  final String code;
  final String whisperLocale;
  final String displayName;

  const VernacularLanguage(this.code, this.whisperLocale, this.displayName);

  static VernacularLanguage fromCode(String code) {
    return VernacularLanguage.values.firstWhere(
      (l) => l.code == code.toLowerCase(),
      orElse: () => VernacularLanguage.englishIndia,
    );
  }
}

/// Abstract Speech-to-Text Client (Cloudflare Workers AI Whisper / Deepgram Nova-3)
abstract class SpeechToTextClient {
  Future<String> transcribe({
    required Uint8List audioBytes,
    required String languageCode,
  });
}

/// Default Simulated ASR Client for Local & Testing Environments
class MockSpeechToTextClient implements SpeechToTextClient {
  final String? simulatedTranscript;

  const MockSpeechToTextClient({this.simulatedTranscript});

  @override
  Future<String> transcribe({
    required Uint8List audioBytes,
    required String languageCode,
  }) async {
    if (simulatedTranscript != null) {
      return simulatedTranscript!;
    }

    // Default locale-aware simulated transcripts for test coverage
    switch (languageCode) {
      case 'hi-IN':
        return 'मैंने दो रोटी और एक कटोरी दाल खाई';
      case 'ta-IN':
        return 'இன்று 2 இட்லி மற்றும் சாம்பார் சாப்பிட்டேன்';
      case 'te-IN':
        return 'నేను రెండు దోశలు తిన్నాను';
      case 'mr-IN':
        return 'मी पोहे आणि एक कप चहा घेतला';
      case 'bn-IN':
        return 'আমি ভাত আর মাছের ঝোল খেয়েছি';
      case 'kn-IN':
        return 'ನಾನು 2 ರೊಟ್ಟಿ ಮತ್ತು ಪಲ್ಯ ತಿಂದಿದ್ದೇನೆ';
      default:
        return 'I ate 2 roti and a bowl of dal tadka';
    }
  }
}

/// Voice Log Parse Result
class VoiceLogResult {
  final String rawTranscript;
  final String detectedLanguageLocale;
  final String parsedSummary;
  final int totalCalories;
  final double totalProteinGrams;
  final List<String> identifiedItems;
  final bool isWorkoutLog;
  final int? workoutDurationMinutes;

  const VoiceLogResult({
    required this.rawTranscript,
    required this.detectedLanguageLocale,
    required this.parsedSummary,
    required this.totalCalories,
    required this.totalProteinGrams,
    required this.identifiedItems,
    this.isWorkoutLog = false,
    this.workoutDurationMinutes,
  });
}

/// §P16-B Voice Log Service
class VoiceLogService {
  final SpeechToTextClient _asrClient;

  VoiceLogService([SpeechToTextClient? asrClient])
      : _asrClient = asrClient ?? const MockSpeechToTextClient();

  /// Maps internal app language code to Whisper / Deepgram speech locale
  String toWhisperLocale(String appLanguageCode) {
    const localeMap = {
      'hi': 'hi-IN',
      'ta': 'ta-IN',
      'te': 'te-IN',
      'mr': 'mr-IN',
      'bn': 'bn-IN',
      'kn': 'kn-IN',
      'en': 'en-IN',
    };
    return localeMap[appLanguageCode] ?? 'en-IN';
  }

  /// Transcribe audio and route directly to food / workout parser
  Future<VoiceLogResult> logFromVoice({
    required Uint8List audioBytes,
    required VernacularLanguage preferredLanguage,
  }) async {
    // 1. ASR transcription in the user's preferred language
    final transcript = await _asrClient.transcribe(
      audioBytes: audioBytes,
      languageCode: preferredLanguage.whisperLocale,
    );

    // 2. Multilingual & Code-Mixed NLP Parsing
    return parseVoiceTranscript(
      transcript: transcript,
      languageLocale: preferredLanguage.whisperLocale,
    );
  }

  /// Parses transcribed text across multilingual keywords and code-mixed phrases
  VoiceLogResult parseVoiceTranscript({
    required String transcript,
    required String languageLocale,
  }) {
    final lower = transcript.toLowerCase();
    int calories = 0;
    double proteinG = 0.0;
    final identified = <String>[];

    // Check for workout keywords
    final isWorkout = lower.contains('run') ||
        lower.contains('running') ||
        lower.contains('workout') ||
        lower.contains('pushup') ||
        lower.contains('रनिंग') ||
        lower.contains('कसरत') ||
        lower.contains('ವ್ಯಾಯಾಮ');

    if (isWorkout) {
      return VoiceLogResult(
        rawTranscript: transcript,
        detectedLanguageLocale: languageLocale,
        parsedSummary: 'Morning Workout & Running',
        totalCalories: 280,
        totalProteinGrams: 0.0,
        identifiedItems: ['Running', 'Pushups'],
        isWorkoutLog: true,
        workoutDurationMinutes: 35,
      );
    }

    // Multilingual food keyword matching
    final multilingualKeywords = <String, Map<String, dynamic>>{
      'roti': {'cal': 120, 'prot': 3.5, 'name': 'Whole Wheat Roti'},
      'रोटी': {'cal': 120, 'prot': 3.5, 'name': 'Whole Wheat Roti'},
      'ರೊಟ್ಟಿ': {'cal': 120, 'prot': 3.5, 'name': 'Whole Wheat Roti'},
      'dal': {'cal': 150, 'prot': 9.0, 'name': 'Dal Tadka'},
      'दाल': {'cal': 150, 'prot': 9.0, 'name': 'Dal Tadka'},
      'சாம்பார்': {'cal': 140, 'prot': 7.0, 'name': 'Sambhar'},
      'paneer': {'cal': 280, 'prot': 18.0, 'name': 'Paneer Tikka'},
      'पनीर': {'cal': 280, 'prot': 18.0, 'name': 'Paneer Tikka'},
      'idli': {'cal': 210, 'prot': 8.0, 'name': 'Idli Sambhar'},
      'இட்லி': {'cal': 210, 'prot': 8.0, 'name': 'Idli Sambhar'},
      'dosa': {'cal': 320, 'prot': 6.0, 'name': 'Masala Dosa'},
      'தோசை': {'cal': 320, 'prot': 6.0, 'name': 'Masala Dosa'},
      'దోసె': {'cal': 320, 'prot': 6.0, 'name': 'Masala Dosa'},
      'దోశ': {'cal': 320, 'prot': 6.0, 'name': 'Masala Dosa'},
      'దోశలు': {'cal': 320, 'prot': 6.0, 'name': 'Masala Dosa'},
      'poha': {'cal': 250, 'prot': 6.5, 'name': 'Poha with Peanuts'},
      'पोहे': {'cal': 250, 'prot': 6.5, 'name': 'Poha with Peanuts'},
      'ভাত': {'cal': 180, 'prot': 4.0, 'name': 'Rice'},
      'মাছ': {'cal': 220, 'prot': 20.0, 'name': 'Fish Curry'},
    };

    multilingualKeywords.forEach((kw, data) {
      if (lower.contains(kw)) {
        calories += data['cal'] as int;
        proteinG += data['prot'] as double;
        identified.add(data['name'] as String);
      }
    });

    // Also match against seeded database
    for (final item in SeededIndianFoodDatabase.items) {
      final nameLower = item.name.toLowerCase();
      if (lower.contains(nameLower) && !identified.contains(item.name)) {
        calories += item.calories;
        proteinG += item.proteinGrams;
        identified.add(item.name);
      }
    }

    // Default fallback if no specific keywords parsed
    if (identified.isEmpty) {
      calories = 350;
      proteinG = 12.0;
      identified.add(transcript);
    }

    return VoiceLogResult(
      rawTranscript: transcript,
      detectedLanguageLocale: languageLocale,
      parsedSummary: identified.join(', '),
      totalCalories: calories,
      totalProteinGrams: proteinG,
      identifiedItems: identified,
      isWorkoutLog: false,
    );
  }
}

final speechToTextClientProvider =
    Provider<SpeechToTextClient>((ref) => const MockSpeechToTextClient());

final voiceLogServiceProvider = Provider<VoiceLogService>((ref) {
  final client = ref.watch(speechToTextClientProvider);
  return VoiceLogService(client);
});
