import 'deepened_longevity_models.dart';
import 'longevity_score_engine.dart';

/// Pure Dart Deterministic Engine for Deepened Longevity Scoring,
/// Hallmarks of Aging Evaluation, and South Asian Phenotype Calibration
class DeepenedLongevityEngine {
  const DeepenedLongevityEngine();

  static const LongevityScoreEngine _baseEngine = LongevityScoreEngine();

  /// Synthesizes complete multi-hallmark deepened longevity report
  DeepenedLongevityReport synthesizeDeepenedLongevity({
    required double chronologicalAge,
    required double restingHeartRate,
    required double hrvRmssd,
    required double vo2MaxEstimate,
    required double fastingGlucose,
    required double systolicBp,
    required double diastolicBp,
    required double dailySteps,
    required double deepSleepMinutes,
    required double skeletalMuscleMassKg,
    double? hsCrpMgL,
    double? triglycerideHdlRatio,
    bool hasElevatedLpA = false,
    double? visceralFatIndex,
  }) {
    // 1. Calculate Base Longevity Report
    final double computedBioAge = chronologicalAge - (vo2MaxEstimate >= 42.0 ? 2.8 : -1.5);
    final double computedHbA1c = double.parse(((fastingGlucose + 46.7) / 28.7).toStringAsFixed(1));
    final double deepSleepPercent = (deepSleepMinutes / 480.0) * 100.0;
    final double computedWaistRatio = visceralFatIndex != null ? (0.40 + (visceralFatIndex * 0.008)) : 0.46;

    final baseReport = _baseEngine.calculateLongevityScore(
      chronologicalAge: chronologicalAge,
      biologicalAge: computedBioAge,
      restingHeartRate: restingHeartRate,
      systolicBloodPressure: systolicBp,
      diastolicBloodPressure: diastolicBp,
      rmssdHeartRateVariability: hrvRmssd,
      waistToHeightRatio: computedWaistRatio,
      fastingGlucoseMgDl: fastingGlucose,
      estimatedHbA1c: computedHbA1c,
      estimatedVo2Max: vo2MaxEstimate,
      dailyStepsAverage: dailySteps,
      weeklyStrengthSessions: 3,
      deepSleepPercentage: deepSleepPercent,
      weeklySleepDebtHours: 0.8,
      antiInflammatoryDietScore: 85.0,
      dailyProteinGramsPerKg: (skeletalMuscleMassKg * 0.045).clamp(1.2, 1.8),
      shatpawaliAdherencePercent: 88.0,
      averageStressScore: 22.0,
    );

    // 2. Evaluate 7 Fundamental Hallmarks of Aging
    final hallmarkEvaluations = _evaluateHallmarks(
      vo2Max: vo2MaxEstimate,
      restingHr: restingHeartRate,
      fastingGlucose: fastingGlucose,
      hrv: hrvRmssd,
      deepSleep: deepSleepMinutes,
      muscleMass: skeletalMuscleMassKg,
      hsCrp: hsCrpMgL,
    );

    // 3. Evaluate South Asian Phenotype Risk
    final southAsianRisk = _evaluateSouthAsianRisk(
      visceralFat: visceralFatIndex ?? 7.0,
      tgHdlRatio: triglycerideHdlRatio ?? 2.2,
      hasLpA: hasElevatedLpA,
      muscleMass: skeletalMuscleMassKg,
      fastingGlucose: fastingGlucose,
    );

    // 4. Compute Composite Cellular Resilience Score (0 to 100)
    double weightedHallmarkSum = 0;
    for (final h in hallmarkEvaluations) {
      weightedHallmarkSum += (h.score * h.hallmark.weight);
    }

    double cellularScore = (baseReport.compositeScore * 0.4) + (weightedHallmarkSum * 0.6);
    if (southAsianRisk.hasElevatedLpA) cellularScore -= 4.0;
    if (southAsianRisk.atherogenicIndexRatio > 3.5) cellularScore -= 5.0;
    cellularScore = cellularScore.clamp(0.0, 100.0);

    // 5. Generate 90-Day Cellular Longevity Roadmap
    final roadmap = _buildCellularRoadmap();

    return DeepenedLongevityReport(
      baseReport: baseReport,
      compositeCellularResilienceScore: double.parse(cellularScore.toStringAsFixed(1)),
      hallmarkEvaluations: hallmarkEvaluations,
      southAsianRisk: southAsianRisk,
      cellularRoadmap: roadmap,
      primaryLongevityPillarSummary: 'Mitochondrial efficiency and glycemic stability are primary drivers of your ${baseReport.tier.projectedHealthspanBonus} projected healthspan trajectory.',
      regionalPrimaryLongevityPillarSummary: 'माइटोकॉन्ड्रिया कार्यक्षमता व शर्करा संतुलन आपकी दीर्घायु संभावना को ${baseReport.tier.regionalProjectedHealthspanBonus} तक बढ़ाते हैं।',
      synthesizedAt: DateTime.now(),
    );
  }

  List<HallmarkEvaluation> _evaluateHallmarks({
    required double vo2Max,
    required double restingHr,
    required double fastingGlucose,
    required double hrv,
    required double deepSleep,
    required double muscleMass,
    double? hsCrp,
  }) {
    final List<HallmarkEvaluation> list = [];

    // 1. Mitochondrial Health (VO2 Max & Aerobic Capacity)
    final double mitoScore = ((vo2Max / 48.0) * 100).clamp(30.0, 100.0);
    final double mitoDelta = mitoScore >= 80 ? -1.8 : (mitoScore >= 60 ? -0.5 : 1.5);
    list.add(
      HallmarkEvaluation(
        hallmark: HallmarkOfAging.mitochondrialHealth,
        score: double.parse(mitoScore.toStringAsFixed(1)),
        biologicalAgeDeltaYears: mitoDelta,
        primaryBiomarker: 'VO2 Max: ${vo2Max.toStringAsFixed(1)} ml/kg/min',
        statusSummary: mitoScore >= 75
            ? 'Optimal electron transport chain ATP production and active mitophagy clearance.'
            : 'Mitochondrial uncoupling recommended via Zone 2 aerobic base conditioning.',
        regionalStatusSummary: mitoScore >= 75
            ? 'माइटोकॉन्ड्रियल ऊर्जा उत्पादन व पुरानी कोशिकाओं का नवीनीकरण उत्कृष्ट स्तर पर है।'
            : 'ज़ोन २ कार्डियो द्वारा माइटोकॉन्ड्रियल क्षमता बढ़ाने की आवश्यकता है।',
      ),
    );

    // 2. Telomere Integrity (Vascular & Cardiorespiratory Reserve)
    final double teloScore = (100.0 - (restingHr - 50) * 1.5).clamp(40.0, 100.0);
    final double teloDelta = teloScore >= 80 ? -1.5 : (teloScore >= 60 ? 0.0 : 1.8);
    list.add(
      HallmarkEvaluation(
        hallmark: HallmarkOfAging.telomereIntegrity,
        score: double.parse(teloScore.toStringAsFixed(1)),
        biologicalAgeDeltaYears: teloDelta,
        primaryBiomarker: 'Resting Pulse: ${restingHr.toInt()} bpm',
        statusSummary: teloScore >= 75
            ? 'Low basal cellular division stress preserving telomeric repeat sequences.'
            : 'Higher sympathetic tone accelerating telomere attrition rate.',
        regionalStatusSummary: teloScore >= 75
            ? 'हृदय गति संतुलित होने से डीएनए टेलोमेयर सुरक्षा मजबूत बनी हुई है।'
            : 'हृदय गति नियंत्रण से टेलोमेयर क्षय को धीमा किया जा सकता है।',
      ),
    );

    // 3. Proteostasis & AGEs (Glycemic Stability)
    final double protoScore = (100.0 - (fastingGlucose - 80) * 1.8).clamp(30.0, 100.0);
    final double protoDelta = protoScore >= 80 ? -2.0 : (protoScore >= 60 ? -0.4 : 2.2);
    list.add(
      HallmarkEvaluation(
        hallmark: HallmarkOfAging.proteostasisAndAges,
        score: double.parse(protoScore.toStringAsFixed(1)),
        biologicalAgeDeltaYears: protoDelta,
        primaryBiomarker: 'Fasting Glucose: ${fastingGlucose.toInt()} mg/dL',
        statusSummary: protoScore >= 75
            ? 'Minimal Advanced Glycation End-product (AGE) accumulation protecting arterial collagen.'
            : 'Elevated post-prandial glycemic spikes accelerating arterial stiffening.',
        regionalStatusSummary: protoScore >= 75
            ? 'रक्त शर्करा नियंत्रित रहने से धमनियों में ग्लाइकेशन व कठोरता का खतरा न्यूनतम है।'
            : 'शर्करा नियंत्रण से धमनियों के लचीलेपन की रक्षा करें।',
      ),
    );

    // 4. Epigenetic Stability (HRV & Parasympathetic Regulation)
    final double epiScore = ((hrv / 65.0) * 100).clamp(30.0, 100.0);
    final double epiDelta = epiScore >= 80 ? -1.4 : (epiScore >= 60 ? -0.2 : 1.6);
    list.add(
      HallmarkEvaluation(
        hallmark: HallmarkOfAging.epigeneticStability,
        score: double.parse(epiScore.toStringAsFixed(1)),
        biologicalAgeDeltaYears: epiDelta,
        primaryBiomarker: 'HRV RMSSD: ${hrv.toInt()} ms',
        statusSummary: epiScore >= 75
            ? 'Robust vagal nerve activity maintaining protective DNA methylation clocks.'
            : 'Chronic autonomic strain accelerating Horvath epigenetic aging clock.',
        regionalStatusSummary: epiScore >= 75
            ? 'स्वायत्त तंत्रिका तंत्र संतुलन से एपिजेनेटिक जैविक घड़ी धीमी गति से चल रही है।'
            : 'प्राणायाम द्वारा स्वायत्त संतुलन सुदृढ़ करें।',
      ),
    );

    // 5. Inflammaging (Systemic Low-Grade Inflammation)
    final double effectiveCrp = hsCrp ?? 1.2;
    final double inflScore = (100.0 - (effectiveCrp * 25.0)).clamp(30.0, 100.0);
    final double inflDelta = inflScore >= 80 ? -1.6 : (inflScore >= 60 ? 0.0 : 2.0);
    list.add(
      HallmarkEvaluation(
        hallmark: HallmarkOfAging.inflammaging,
        score: double.parse(inflScore.toStringAsFixed(1)),
        biologicalAgeDeltaYears: inflDelta,
        primaryBiomarker: 'hs-CRP: ${effectiveCrp.toStringAsFixed(1)} mg/L',
        statusSummary: inflScore >= 75
            ? 'Low systemic cytokine cascade with preserved endothelial nitric oxide production.'
            : 'Micro-vascular low-grade sterile inflammation detected.',
        regionalStatusSummary: inflScore >= 75
            ? 'शरीर में सूजन का स्तर अत्यंत कम है, जिससे रक्त वाहिकाएं स्वस्थ हैं।'
            : 'हल्दी व ओमेगा-३ युक्त आहार से सूजन कम करें।',
      ),
    );

    // 6. Nutrient Sensing & mTOR/AMPK (Skeletal Muscle & Strength)
    final double nutrientScore = ((muscleMass / 32.0) * 100).clamp(40.0, 100.0);
    final double nutrientDelta = nutrientScore >= 80 ? -1.2 : (nutrientScore >= 60 ? 0.0 : 1.4);
    list.add(
      HallmarkEvaluation(
        hallmark: HallmarkOfAging.nutrientSensing,
        score: double.parse(nutrientScore.toStringAsFixed(1)),
        biologicalAgeDeltaYears: nutrientDelta,
        primaryBiomarker: 'Muscle Mass: ${muscleMass.toStringAsFixed(1)} kg',
        statusSummary: nutrientScore >= 75
            ? 'Balanced AMPK/mTOR axis preventing sarcopenic frailty.'
            : 'Progressive resistance training recommended to protect metabolic reservoir.',
        regionalStatusSummary: nutrientScore >= 75
            ? 'मांसपेशी घनत्व मजबूत होने से मेटाबॉलिक क्षमता सुरक्षित है।'
            : 'स्ट्रेंथ ट्रेनिंग द्वारा मांसपेशियों का संरक्षण आवश्यक है।',
      ),
    );

    // 7. Stem Cell Regeneration (Deep NREM Stage 3 Sleep)
    final double stemScore = ((deepSleep / 80.0) * 100).clamp(30.0, 100.0);
    final double stemDelta = stemScore >= 80 ? -1.5 : (stemScore >= 60 ? -0.2 : 1.7);
    list.add(
      HallmarkEvaluation(
        hallmark: HallmarkOfAging.stemCellRegeneration,
        score: double.parse(stemScore.toStringAsFixed(1)),
        biologicalAgeDeltaYears: stemDelta,
        primaryBiomarker: 'Deep Sleep: ${deepSleep.toInt()} min/night',
        statusSummary: stemScore >= 75
            ? 'Sufficient restorative slow-wave sleep facilitating neural glymphatic clearance.'
            : 'Suppressed deep sleep blunting nocturnal tissue repair.',
        regionalStatusSummary: stemScore >= 75
            ? 'गहरी नींद के दौरान कोशिकीय मरम्मत व मस्तिष्क सफाई पूर्ण हो रही है।'
            : 'नींद की गुणवत्ता सुधारने हेतु रात्रि विश्राम दिनचर्या अपनाएं।',
      ),
    );

    return list;
  }

  SouthAsianPhenotypeRisk _evaluateSouthAsianRisk({
    required double visceralFat,
    required double tgHdlRatio,
    required bool hasLpA,
    required double muscleMass,
    required double fastingGlucose,
  }) {
    final bool isElevatedRisk = visceralFat > 9.0 || tgHdlRatio > 3.0 || hasLpA;

    return SouthAsianPhenotypeRisk(
      visceralAdiposityIndex: visceralFat,
      atherogenicIndexRatio: tgHdlRatio,
      hasElevatedLpA: hasLpA,
      sarcopenicRiskIndex: muscleMass < 28.0 ? 65.0 : 25.0,
      clinicalInterpretation: isElevatedRisk
          ? 'Thin-Fat phenotype profile detected: Prioritize visceral fat reduction via 10-min post-meal Shatapadi walks and high-fiber millets.'
          : 'Cardio-metabolic phenotype is well-protected with favorable TG:HDL ratio and lean muscle preservation.',
      regionalClinicalInterpretation: isElevatedRisk
          ? 'दक्षिण एशियाई फेनोटाइप विश्लेषण: भोजनोपरांत शतपावली व मिलेट्स द्वारा विसरल फैट नियंत्रित रखें।'
          : 'कार्डियो-मेटाबॉलिक स्वास्थ्य व मांसपेशी संतुलन उत्तम स्थिति में है।',
    );
  }

  List<LongevityRoadmapPhase> _buildCellularRoadmap() {
    return const [
      LongevityRoadmapPhase(
        phaseNumber: 1,
        title: 'Mitochondrial Mitophagy & Autophagy Priming',
        regionalTitle: 'माइटोकॉन्ड्रियल नवीनीकरण व ऑटोफैगी चरण',
        timeline: 'Weeks 1 – 4',
        cellularActions: [
          '14:10 intermittent circadian fasting to trigger lysosomal cellular cleanup',
          '3x weekly 35-min Zone 2 aerobic heart rate training (fat oxidation zone)',
          'Pomegranate polyphenols & green tea catechins for urolithin A synthesis',
        ],
        regionalCellularActions: [
          '१४:१० घंटे का नियमित उपवास ऑटोफैगी सक्रिय करने हेतु',
          'सप्ताह में ३ दिन ३५-मिनट ज़ोन २ कार्डियो व्यायाम',
          'अनार व ग्रीन टी पॉलीफेनोल्स द्वारा कोशिकीय ऊर्जा वृद्धि',
        ],
        ayurvedicRasayana: 'Shilajit (Fulvic Acid Mineral Complex) & Triphala Churna',
        regionalAyurvedicRasayana: 'शुद्ध शिलाजीत व त्रिफला चूर्ण (पाचन व आंत सुरक्षा)',
      ),
      LongevityRoadmapPhase(
        phaseNumber: 2,
        title: 'Telomerase Protection & Vascular Elasticity',
        regionalTitle: 'टेलोमेयर सुरक्षा व धमनी लचीलापन चरण',
        timeline: 'Weeks 5 – 8',
        cellularActions: [
          'Progressive compound strength training to stimulate osteocalcin & myokines',
          'Cold finish showers (2 min) for norepinephrine and vascular tone stimulation',
          'Nitric oxide boosting diet (beetroot, spinach, pomegranate)',
        ],
        regionalCellularActions: [
          'हड्डियों व मांसपेशियों के लिए कंपाउंड स्ट्रेंथ ट्रेनिंग',
          'रक्त संचार व धमनी संकुचन सुधार हेतु शीतल स्नान',
          'चुकंदर व पालक द्वारा नाइट्रिक ऑक्साइड उत्पादन वृद्धि',
        ],
        ayurvedicRasayana: 'Ashwagandha KSM-66 (Withaferin-A) & Arjuna Bark Kwath',
        regionalAyurvedicRasayana: 'अश्वगंधा (केएसएम-६६) व अर्जुन छाल काढ़ा (हृदय सुरक्षा)',
      ),
      LongevityRoadmapPhase(
        phaseNumber: 3,
        title: 'Epigenetic Consolidation & Sirtuin Activation',
        regionalTitle: 'एपिजेनेटिक स्थिरता व दीर्घायु दृढ़ीकरण चरण',
        timeline: 'Weeks 9 – 12',
        cellularActions: [
          'Evening digital sunset (no blue light post 21:00) for melatonin optimization',
          'Thermal sauna / hot bath therapy (20 min 3x/wk) for heat shock protein (HSP70)',
          'Methylation support: B-complex vitamins, folate, and sprouted legumes',
        ],
        regionalCellularActions: [
          'रात्रि ९ बजे के बाद मेलाटोनिन वृद्धि हेतु स्क्रीन से दूरी',
          'हीट शॉक प्रोटीन वृद्धि हेतु गर्म स्नान व स्टीम थेरेपी',
          'अंकुरित दालों व विटामिन बी द्वारा डीएनए मिथाइलेशन सुदृढ़ीकरण',
        ],
        ayurvedicRasayana: 'Amalaki Rasayana (Chyawanprash) & Brahmi Medhya Rasayana',
        regionalAyurvedicRasayana: 'आमलकी रसायन (च्यवनप्राश) व ब्राह्मी (मस्तिष्क सुरक्षा)',
      ),
    ];
  }
}
