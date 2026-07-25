/// §P16-B Vernacular Voice Logging — Domain Models
///
/// Supported language locales, voice transcript results, and voice log results matching §P16-B spec.
library;

enum VernacularLanguage {
  hindi('hi', 'hi-IN', 'Hindi (हिंदी)'),
  tamil('ta', 'ta-IN', 'Tamil (தமிழ்)'),
  telugu('te', 'te-IN', 'Telugu (తెలుగు)'),
  marathi('mr', 'mr-IN', 'Marathi (मराठी)'),
  bengali('bn', 'bn-IN', 'Bengali (বাংলা)'),
  kannada('kn', 'kn-IN', 'Kannada (ಕನ್ನಡ)'),
  englishIndia('en', 'en-IN', 'English (India)');

  const VernacularLanguage(this.code, this.azureLocale, this.displayName);

  final String code;
  final String azureLocale;
  final String displayName;

  static String toAzureLocale(String appLanguageCode) {
    for (final lang in VernacularLanguage.values) {
      if (lang.code == appLanguageCode) return lang.azureLocale;
    }
    return 'en-IN';
  }
}

enum LogCategory { food, workout }

class VoiceLogResult {
  const VoiceLogResult({
    required this.transcript,
    required this.languageCode,
    required this.azureLocale,
    required this.category,
    required this.summary,
    required this.calories,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.durationMins = 0,
    required this.confidenceScore,
  });

  final String transcript;
  final String languageCode;
  final String azureLocale;
  final LogCategory category;
  final String summary;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int durationMins;
  final double confidenceScore;
}
