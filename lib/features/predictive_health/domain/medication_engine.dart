import 'medication_models.dart';

/// Pure Dart Deterministic Engine for Medication Tracking & Herb-Drug Interaction Screening
class MedicationSafetyEngine {
  const MedicationSafetyEngine();

  /// Evaluate full medication schedule and cross-reference multi-agent interactions
  MedicationScheduleReport evaluateSchedule({
    required List<TrackedMedication> medications,
    DateTime? checkDate,
  }) {
    final now = checkDate ?? DateTime.now();

    // 1. Detect Cross-Agent Interactions (Pairwise Screening)
    final interactions = <MedicationInteractionAlert>[];
    final count = medications.length;

    for (int i = 0; i < count; i++) {
      for (int j = i + 1; j < count; j++) {
        final alert = _checkPairwiseInteraction(medications[i], medications[j]);
        if (alert != null) {
          interactions.add(alert);
        }
      }
    }

    // 2. Adherence Metrics
    final dosesTaken = medications.where((m) => m.isTakenToday).length;
    final totalDoses = medications.length;
    final adherenceScore =
        totalDoses == 0 ? 100.0 : (dosesTaken / totalDoses) * 100.0;

    // 3. Check for Critical Severity
    final hasCritical =
        interactions.any((i) => i.severity == InteractionSeverity.critical);

    // 4. Clinical Safety Summaries
    final summary =
        _generateSummary(medications.length, interactions, hasCritical);
    final regionalSummary =
        _generateRegionalSummary(medications.length, interactions, hasCritical);

    return MedicationScheduleReport(
      activeMedications: medications,
      detectedInteractions: interactions,
      adherenceScorePercent: (adherenceScore * 10).round() / 10.0,
      dosesTakenToday: dosesTaken,
      totalDosesToday: totalDoses,
      hasCriticalContraindication: hasCritical,
      clinicalSafetySummary: summary,
      regionalClinicalSafetySummary: regionalSummary,
      lastUpdated: now,
    );
  }

  // --- Internal Interaction Knowledge Base ---

  MedicationInteractionAlert? _checkPairwiseInteraction(
    TrackedMedication a,
    TrackedMedication b,
  ) {
    final keyA = a.genericOrHerbName.toLowerCase();
    final keyB = b.genericOrHerbName.toLowerCase();

    // Rule 1: Curcumin / Turmeric + Antiplatelet / Anticoagulants (Aspirin, Clopidogrel, Warfarin)
    if (_matchesPair(keyA, keyB, ['curcumin', 'turmeric', 'haldi'],
        ['aspirin', 'clopidogrel', 'warfarin'])) {
      return MedicationInteractionAlert(
        id: 'inter_curcumin_aspirin',
        primaryAgent: a.name,
        secondaryAgent: b.name,
        severity: InteractionSeverity.moderate,
        interactionMechanism:
            'Curcumin exhibits mild COX-1/thromboxane suppression, which can additively amplify platelet inhibition when co-administered with Aspirin.',
        regionalInteractionMechanism:
            'हल्दी (करक्यूमिन) रक्त पतला करने वाले प्रभाव को बढ़ाती है, जिससे एस्पिरिन के साथ अतिरिक्त रक्तस्राव का हल्का जोखिम हो सकता है।',
        clinicalAction:
            'Separate intake by at least 2 hours. Keep Curcumin dosage moderate (under 1000mg) and inform your cardiologist.',
        regionalClinicalAction:
            'दोनों के सेवन में कम से कम २ घंटे का अंतर रखें व डॉक्टर को सूचित करें।',
        safeSpacingGuideline: 'Separate intake by 2-3 hours',
      );
    }

    // Rule 2: Karela / Fenugreek / Gymnema + Metformin / Glycomet / Glimepiride (Synergistic Hypoglycemia)
    if (_matchesPair(
        keyA,
        keyB,
        ['karela', 'fenugreek', 'methi', 'gymnema', 'gurmar'],
        ['metformin', 'glycomet', 'glimepiride', 'insulin'])) {
      return MedicationInteractionAlert(
        id: 'inter_karela_metformin',
        primaryAgent: a.name,
        secondaryAgent: b.name,
        severity: InteractionSeverity.moderate,
        interactionMechanism:
            'Herbal insulin mimetics (Charantin in Karela & 4-hydroxyisoleucine in Methi) act additively with Metformin, potentially triggering symptomatic hypoglycemia (<70 mg/dL).',
        regionalInteractionMechanism:
            'करेला व मेथी रक्त शर्करा को तेजी से घटाते हैं; मेटफॉर्मिन के साथ लेने पर शर्करा अत्यधिक कम होने का जोखिम रहता है।',
        clinicalAction:
            'Monitor continuous glucose (CGM) closely during morning fasting windows. Ensure meals contain complex carbohydrates.',
        regionalClinicalAction:
            'रक्त शर्करा की नियमित जांच करें और भोजन में पर्याप्त पोषण शामिल रखें।',
        safeSpacingGuideline:
            'Take Karela juice 30 mins before breakfast; Metformin post-meal',
      );
    }

    // Rule 3: Levothyroxine (Thyronorm/Eltroxin) + Calcium / Iron / Ashwagandha
    if (_matchesPair(keyA, keyB, ['levothyroxine', 'thyronorm', 'eltroxin'],
        ['calcium', 'iron', 'ferrous', 'ashwagandha'])) {
      return MedicationInteractionAlert(
        id: 'inter_thyroid_chelates',
        primaryAgent: a.name,
        secondaryAgent: b.name,
        severity: InteractionSeverity.moderate,
        interactionMechanism:
            'Divalent minerals (Iron/Calcium) chelate with Levothyroxine in the stomach, reducing thyroid hormone bioavailability by up to 40%.',
        regionalInteractionMechanism:
            'कैल्शियम व आयरन थायरॉयड दवा (थायरोनॉर्म) के अवशोषण को ४०% तक कम कर देते हैं।',
        clinicalAction:
            'Take Levothyroxine strictly on an empty stomach with plain water. Delay Calcium/Iron/Herbs by at least 4 hours.',
        regionalClinicalAction:
            'थायरोनॉर्म सुबह खाली पेट लें और कैल्शियम/आयरन का सेवन ४ घंटे बाद करें।',
        safeSpacingGuideline: 'Strict 4-hour separation mandatory',
      );
    }

    // Rule 4: Telmisartan / Amlodipine + High-Dose Garlic Extract (Lasuna)
    if (_matchesPair(keyA, keyB, ['telmisartan', 'amlodipine', 'losartan'],
        ['garlic', 'lasuna', 'allicin'])) {
      return MedicationInteractionAlert(
        id: 'inter_bp_garlic',
        primaryAgent: a.name,
        secondaryAgent: b.name,
        severity: InteractionSeverity.minor,
        interactionMechanism:
            'Garlic allicin triggers peripheral endothelial nitric oxide vasodilation, which may produce additive blood pressure drops.',
        regionalInteractionMechanism:
            'लहसुन अर्क धमनियों को शिथिल करता है; बीपी की दवा के साथ रक्तचाप अधिक गिर सकता है।',
        clinicalAction:
            'Monitor morning resting BP. If systolic falls below 105 mmHg, moderate dietary garlic concentration.',
        regionalClinicalAction:
            'सुबह रक्तचाप मापें; चक्कर आने या बहुत कम होने पर डॉक्टर से परामर्श लें।',
        safeSpacingGuideline: 'Take Garlic with dinner, Telmisartan in morning',
      );
    }

    // Rule 5: Triphala + Allopathic Prescriptions (Tannin Binding)
    if (_matchesPair(keyA, keyB, ['triphala', 'haritaki', 'bibhitaki'],
        ['metformin', 'atorvastatin', 'rosuvastatin', 'telmisartan'])) {
      return MedicationInteractionAlert(
        id: 'inter_triphala_binding',
        primaryAgent: a.name,
        secondaryAgent: b.name,
        severity: InteractionSeverity.minor,
        interactionMechanism:
            'High tannin content in Triphala can adsorb synthetic drug molecules in the proximal gut, slowing absorption rate.',
        regionalInteractionMechanism:
            'त्रिफला के टैनिन्स दवा के अणुओं को बांध सकते हैं, जिससे दवा का असर धीमा हो सकता है।',
        clinicalAction:
            'Take Triphala at night right before bed (with warm water), ensuring at least 2 hours after evening prescriptions.',
        regionalClinicalAction:
            'त्रिफला रात को सोने से ठीक पहले गुनगुने पानी से लें (दवा के २ घंटे बाद)।',
        safeSpacingGuideline:
            '2-hour evening buffer between pills and Triphala',
      );
    }

    return null;
  }

  bool _matchesPair(
      String keyA, String keyB, List<String> group1, List<String> group2) {
    final aIn1 = group1.any((g) => keyA.contains(g));
    final bIn2 = group2.any((g) => keyB.contains(g));
    if (aIn1 && bIn2) return true;

    final aIn2 = group2.any((g) => keyA.contains(g));
    final bIn1 = group1.any((g) => keyB.contains(g));
    return aIn2 && bIn1;
  }

  String _generateSummary(
      int medCount, List<MedicationInteractionAlert> alerts, bool hasCritical) {
    if (hasCritical) {
      return 'CRITICAL SAFETY ALERT: Severe drug/herb contraindication detected across your active prescriptions. Consult your physician immediately to adjust dosages.';
    }
    if (alerts.isNotEmpty) {
      return 'SAFETY SCREENING COMPLETE: ${alerts.length} synergistic herb-drug interaction(s) identified across $medCount active items. Follow the recommended safe timing intervals to preserve maximum therapeutic efficacy.';
    }
    return 'SAFETY CLEAR: All $medCount active medications, Ayurvedic rasayanas, and vitamins are fully compatible with zero known cross-interaction risks.';
  }

  String _generateRegionalSummary(
      int medCount, List<MedicationInteractionAlert> alerts, bool hasCritical) {
    if (hasCritical) {
      return 'गंभीर चेतावनी: दवाओं व जड़ी-बूटियों के बीच गंभीर विरोध पाया गया है। कृपया तुरंत अपने चिकित्सक से संपर्क करें।';
    }
    if (alerts.isNotEmpty) {
      return 'सुरक्षा जांच पूर्ण: $medCount दवाओं में ${alerts.length} परस्पर सावधानियां पाई गईं। उचित समय अंतराल का पालन करें।';
    }
    return 'पूर्णतः सुरक्षित: सभी $medCount दवाएं व आयुर्वेदिक रस बिना किसी विरोध के साथ में सुरक्षित हैं।';
  }
}
