import 'package:fitkarma/features/growth/models/growth_model.dart';

/// Core India Growth & Trust Engine
class GrowthEngine {
  const GrowthEngine();

  /// Parse Vernacular ASR voice transcript into structured meal item name
  String parseVernacularVoiceInput(
      String rawTranscript, VernacularLanguage lang) {
    final lower = rawTranscript.toLowerCase();
    if (lower.contains('paneer') ||
        lower.contains('पनीर') ||
        lower.contains('பனீர்')) {
      return 'Paneer Tikka';
    } else if (lower.contains('dal') ||
        lower.contains('दाल') ||
        lower.contains('பருப்பு')) {
      return 'Dal Tadka';
    } else {
      return 'Indian Meal Log';
    }
  }

  /// Corporate Wellness Anonymity Rule: Enforces minimum cohort size threshold (N >= 10)
  bool canRenderCorporateAggregate(int totalCohortSize) {
    return totalCohortSize >= 10;
  }
}
