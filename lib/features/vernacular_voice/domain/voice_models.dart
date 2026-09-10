import 'package:flutter/foundation.dart';

/// Supported Indian Vernacular Languages & Dialects
enum VernacularLanguage {
  hinglish(
      code: 'hi-Latn',
      name: 'Hinglish',
      nativeName: 'Hinglish',
      flagEmoji: '🇮🇳'),
  hindi(code: 'hi-IN', name: 'Hindi', nativeName: 'हिन्दी', flagEmoji: '🇮🇳'),
  marathi(code: 'mr-IN', name: 'Marathi', nativeName: 'मराठी', flagEmoji: '🚩'),
  tamil(code: 'ta-IN', name: 'Tamil', nativeName: 'தமிழ்', flagEmoji: '🏛️'),
  telugu(code: 'te-IN', name: 'Telugu', nativeName: 'తెలుగు', flagEmoji: '🪷'),
  kannada(code: 'kn-IN', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flagEmoji: '🐘'),
  bengali(code: 'bn-IN', name: 'Bengali', nativeName: 'বাংলা', flagEmoji: '🐅'),
  gujarati(
      code: 'gu-IN', name: 'Gujarati', nativeName: 'ગુજરાતી', flagEmoji: '🦁'),
  punjabi(
      code: 'pa-IN', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flagEmoji: '🌾'),
  english(
      code: 'en-IN',
      name: 'Indian English',
      nativeName: 'English',
      flagEmoji: '🌐');

  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;

  const VernacularLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
  });
}

/// Intent Category extracted from Voice Transcript
enum VoiceIntentType {
  mealNutrition(label: 'Meal & Nutrition', regionalLabel: 'भोजन व पोषण'),
  waterHydration(label: 'Water Hydration', regionalLabel: 'जलयोजन / पानी'),
  workoutPhysicalActivity(
      label: 'Workout & Movement', regionalLabel: 'व्यायाम व सक्रियता'),
  biometricWeight(
      label: 'Biometrics & Weight', regionalLabel: 'वजन व शारीरिक माप'),
  symptomAgni(
      label: 'Symptom & Agni State', regionalLabel: 'लक्षण व जठराग्नि स्थिति'),
  generalQuery(
      label: 'Health Inquiry', regionalLabel: 'सामान्य स्वास्थ्य प्रश्न');

  final String label;
  final String regionalLabel;

  const VoiceIntentType({
    required this.label,
    required this.regionalLabel,
  });
}

/// Recording State Lifecycle
enum VoiceRecordingState { idle, listening, processing, success, error }

/// Structured Entity Extracted from Vernacular Voice Transcript
@immutable
class ParsedVoiceEntity {
  final VoiceIntentType intentType;
  final String primarySummary;
  final String regionalSummary;
  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double fiberGrams;
  final int waterMl;
  final int workoutDurationMinutes;
  final int stepsCount;
  final double weightKg;
  final List<String> detectedFoodItems;
  final String postMealGuidance;
  final String regionalPostMealGuidance;

  const ParsedVoiceEntity({
    required this.intentType,
    required this.primarySummary,
    required this.regionalSummary,
    this.calories = 0.0,
    this.proteinGrams = 0.0,
    this.carbsGrams = 0.0,
    this.fatGrams = 0.0,
    this.fiberGrams = 0.0,
    this.waterMl = 0,
    this.workoutDurationMinutes = 0,
    this.stepsCount = 0,
    this.weightKg = 0.0,
    this.detectedFoodItems = const [],
    this.postMealGuidance = 'Take 100 Shatapadi steps for optimal digestion.',
    this.regionalPostMealGuidance = 'भोजनोपरांत १०० कदम शतपावली अवश्य करें।',
  });
}

/// Raw & Processed Voice Transcript Result
@immutable
class VoiceTranscriptResult {
  final String rawTranscript;
  final VernacularLanguage detectedLanguage;
  final double confidenceScore; // 0.0 to 1.0
  final ParsedVoiceEntity parsedEntity;
  final Duration audioDuration;
  final DateTime recordedAt;

  const VoiceTranscriptResult({
    required this.rawTranscript,
    required this.detectedLanguage,
    required this.confidenceScore,
    required this.parsedEntity,
    required this.audioDuration,
    required this.recordedAt,
  });
}

/// Voice Audio Prompt / Audio Confirmation Script
@immutable
class VoiceAudioPrompt {
  final String spokenText;
  final String regionalSpokenText;
  final VernacularLanguage language;
  final bool shouldPlayAudioHaptic;

  const VoiceAudioPrompt({
    required this.spokenText,
    required this.regionalSpokenText,
    required this.language,
    this.shouldPlayAudioHaptic = true,
  });
}
