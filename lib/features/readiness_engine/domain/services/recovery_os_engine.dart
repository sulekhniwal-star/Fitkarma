import '../models/readiness_input.dart';

class RecoveryPrescriptions {
  final List<String> protocols;
  final List<String> protocolsHindi;

  const RecoveryPrescriptions({
    required this.protocols,
    required this.protocolsHindi,
  });
}

/// RecoveryOSEngine — Generates tailored Ayurvedic & physiological recovery protocols
class RecoveryOSEngine {
  const RecoveryOSEngine();

  RecoveryPrescriptions generatePrescriptions({
    required int readinessScore,
    required List<MuscleSorenessEntry> sorenessList,
    required double sleepDebtHours,
  }) {
    final List<String> english = [];
    final List<String> hindi = [];

    // Soreness-specific prescriptions
    if (sorenessList.isNotEmpty) {
      final highSoreness = sorenessList.where((s) => s.severity >= 3).toList();
      if (highSoreness.isNotEmpty) {
        final muscles = highSoreness.map((s) => s.muscleGroup).join(', ');
        english.add('Targeted foam rolling & dynamic mobility for: $muscles.');
        hindi.add('प्रभावित मांसपेशियों ($muscles) के लिए फोम रोलिंग और स्ट्रेचिंग करें।');
      }
    }

    // Sleep Debt prescriptions
    if (sleepDebtHours > 1.0) {
      english.add('Evening 4-7-8 Pranayama (Anulom Vilom) + Ashwagandha / warm turmeric milk before sleep.');
      hindi.add('सोने से पहले अनुलोम-विलोम प्राणायाम और हल्का हल्दी वाला दूध लें।');
    }

    // Readiness-tiered protocols
    if (readinessScore >= 80) {
      english.add('Contrast shower (30s cold / 1 min warm) post-workout for vascular flush.');
      hindi.add('वर्कआउट के बाद 30 सेकंड ठंडा / 1 मिनट गर्म पानी से स्नान करें।');
    } else if (readinessScore < 60) {
      english.add('20-min Epsom salt bath & 2.5L electrolyte water replenishment.');
      hindi.add('पर्याप्त पानी व ओआरएस / नारियल पानी लें और 20 मिनट गुनगुने पानी से सिकाई करें।');
      english.add('Zone 1 recovery walk (under 100 bpm heart rate) in natural sunlight.');
      hindi.add('धूप में 15-20 मिनट की हल्की वॉक करें।');
    } else {
      english.add('10-min post-training hamstring and thoracic spine decompression.');
      hindi.add('वर्कआउट के बाद 10 मिनट स्ट्रेचिंग और रीढ़ की हड्डी को आराम दें।');
    }

    return RecoveryPrescriptions(
      protocols: english,
      protocolsHindi: hindi,
    );
  }
}
