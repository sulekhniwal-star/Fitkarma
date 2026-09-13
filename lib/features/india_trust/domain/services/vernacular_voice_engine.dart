import '../models/india_trust_models.dart';

class VernacularVoiceEngine {
  const VernacularVoiceEngine();

  /// Parses Hinglish, Tanglish, and Hindi speech-to-text transcripts
  ParsedVernacularEntry parseTranscript(String transcript) {
    final lower = transcript.toLowerCase();

    // Check for meal keywords
    if (lower.contains('khaya') ||
        lower.contains('roti') ||
        lower.contains('dal') ||
        lower.contains('chawal') ||
        lower.contains('dosa') ||
        lower.contains('idli') ||
        lower.contains('paneer') ||
        lower.contains('ate') ||
        lower.contains('lunch') ||
        lower.contains('dinner')) {
      final entities = <String, dynamic>{};

      // Extract rotis
      final rotiMatch = RegExp(r'(\d+)\s*(roti|rotis|phulka|chapati)').firstMatch(lower);
      if (rotiMatch != null) {
        entities['roti_count'] = int.tryParse(rotiMatch.group(1) ?? '2') ?? 2;
      }

      // Extract dal / sabzi katori
      if (lower.contains('dal') || lower.contains('daal')) {
        entities['dal_katori'] = 1;
      }
      if (lower.contains('paneer')) {
        entities['paneer_g'] = 100;
      }
      if (lower.contains('dahi') || lower.contains('curd')) {
        entities['dahi_katori'] = 1;
      }

      return ParsedVernacularEntry(
        rawText: transcript,
        detectedLanguage: lower.contains('khaya') ? 'hinglish' : 'english',
        entryType: 'meal',
        extractedEntities: entities,
        confidencePct: 94,
      );
    }

    // Check for workout keywords
    if (lower.contains('dand') ||
        lower.contains('baithak') ||
        lower.contains('surya namaskar') ||
        lower.contains('pushup') ||
        lower.contains('workout') ||
        lower.contains('walk') ||
        lower.contains('chala') ||
        lower.contains('pranayama')) {
      final entities = <String, dynamic>{};

      final repsMatch = RegExp(r'(\d+)\s*(dand|baithak|pushups|squats|surya namaskar)').firstMatch(lower);
      if (repsMatch != null) {
        entities['exercise'] = repsMatch.group(2);
        entities['reps'] = int.tryParse(repsMatch.group(1) ?? '25') ?? 25;
      }

      return ParsedVernacularEntry(
        rawText: transcript,
        detectedLanguage: 'hinglish',
        entryType: 'workout',
        extractedEntities: entities,
        confidencePct: 92,
      );
    }

    return ParsedVernacularEntry(
      rawText: transcript,
      detectedLanguage: 'unknown',
      entryType: 'general_note',
      extractedEntities: {'note': transcript},
      confidencePct: 70,
    );
  }
}
