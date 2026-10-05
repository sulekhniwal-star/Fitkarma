import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported Pan-Indian Languages for FitKarma
enum AppLanguage {
  english(
    code: 'en',
    label: 'English',
    nativeLabel: 'English',
    subLabel: 'Universal English UI',
    region: 'Pan-India',
    flag: '🇬🇧',
  ),
  hindi(
    code: 'hi',
    label: 'Hindi',
    nativeLabel: 'हिन्दी',
    subLabel: 'उत्तर व मध्य भारत',
    region: 'North & Central',
    flag: '🇮🇳',
  ),
  tamil(
    code: 'ta',
    label: 'Tamil',
    nativeLabel: 'தமிழ்',
    subLabel: 'தமிழ்நாடு & புதுச்சேரி',
    region: 'South',
    flag: '🇮🇳',
  ),
  telugu(
    code: 'te',
    label: 'Telugu',
    nativeLabel: 'తెలుగు',
    subLabel: 'ఆంధ్రప్రదేశ్ & తెలంగాణ',
    region: 'South',
    flag: '🇮🇳',
  ),
  kannada(
    code: 'kn',
    label: 'Kannada',
    nativeLabel: 'ಕನ್ನಡ',
    subLabel: 'ಕರ್ನಾಟಕ',
    region: 'South',
    flag: '🇮🇳',
  ),
  malayalam(
    code: 'ml',
    label: 'Malayalam',
    nativeLabel: 'മലയാളം',
    subLabel: 'കേരളം',
    region: 'South',
    flag: '🇮🇳',
  ),
  marathi(
    code: 'mr',
    label: 'Marathi',
    nativeLabel: 'मराठी',
    subLabel: 'महाराष्ट्र व गोवा',
    region: 'West',
    flag: '🇮🇳',
  ),
  bengali(
    code: 'bn',
    label: 'Bengali',
    nativeLabel: 'বাংলা',
    subLabel: 'পশ্চিমবঙ্গ ও ত্রিপুরা',
    region: 'East',
    flag: '🇮🇳',
  ),
  gujarati(
    code: 'gu',
    label: 'Gujarati',
    nativeLabel: 'ગુજરાતી',
    subLabel: 'ગુજરાત',
    region: 'West',
    flag: '🇮🇳',
  ),
  punjabi(
    code: 'pa',
    label: 'Punjabi',
    nativeLabel: 'ਪੰਜਾਬੀ',
    subLabel: 'ਪੰਜਾਬ',
    region: 'North',
    flag: '🇮🇳',
  ),
  hinglish(
    code: 'hi_en',
    label: 'Hinglish',
    nativeLabel: 'हिंग्लिश',
    subLabel: 'Casual Hindi-English mix',
    region: 'Metro & Gen-Z',
    flag: '✨',
  ),
  bilingual(
    code: 'dual',
    label: 'Bilingual',
    nativeLabel: 'English + Regional',
    subLabel: 'Dual language UI display',
    region: 'Pan-India',
    flag: '🌐',
  );

  final String code;
  final String label;
  final String nativeLabel;
  final String subLabel;
  final String region;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.label,
    required this.nativeLabel,
    required this.subLabel,
    required this.region,
    required this.flag,
  });
}

/// Language Notifier for live application-wide language switching
class AppLanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => AppLanguage.english;

  void setLanguage(AppLanguage language) {
    state = language;
  }
}

/// Global Provider for current selected App Language
final appLanguageProvider =
    NotifierProvider<AppLanguageNotifier, AppLanguage>(AppLanguageNotifier.new);
