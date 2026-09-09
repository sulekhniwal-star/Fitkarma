import 'clinical_lab_models.dart';

/// Pure Dart Deterministic Engine for Clinical Lab Report Parsing & Metabolic Intelligence
class ClinicalLabEngine {
  const ClinicalLabEngine();

  /// Parse and synthesize structured lab data into actionable clinical intelligence
  ClinicalReportIntelligence parseAndAnalyzeReport({
    required String reportId,
    required String labProviderName,
    required DateTime testDate,
    required double fastingGlucoseMgDl, // e.g. 92.0
    required double hba1cPercent, // e.g. 5.3
    required double totalCholesterolMgDl, // e.g. 182.0
    required double triglyceridesMgDl, // e.g. 138.0
    required double hdlCholesterolMgDl, // e.g. 48.0
    required double ldlCholesterolMgDl, // e.g. 106.0
    required double hsCrpMgL, // e.g. 0.8
    required double altSgptUnitsL, // e.g. 24.0
    required double astSgotUnitsL, // e.g. 22.0
    required double serumCreatinineMgDl, // e.g. 0.95
    required double serumUricAcidMgDl, // e.g. 5.4
    required double vitaminD3NgMl, // e.g. 44.0
    required double vitaminB12PgMl, // e.g. 460.0
    required double hemoglobinGDl, // e.g. 14.8
    required double tshUiuMl, // e.g. 2.1
  }) {
    final biomarkers = <ParsedLabBiomarker>[];

    // --- 1. Lipid & Glycemic Panel ---
    // HbA1c
    final hba1cStatus = _evaluateStatus(hba1cPercent, 4.0, 5.6, 4.5, 5.3, highIsBad: true, criticalHigh: 8.0);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'HBA1C',
        name: 'Glycated Hemoglobin (HbA1c)',
        regionalName: 'ग्लाइकेटेड हीमोग्लोबिन (HbA1c)',
        category: LabBiomarkerCategory.lipidMetabolic,
        measuredValue: hba1cPercent,
        unit: '%',
        referenceMin: 4.0,
        referenceMax: 5.6,
        optimalMin: 4.5,
        optimalMax: 5.3,
        status: hba1cStatus,
        clinicalInterpretation: hba1cStatus == LabBiomarkerStatus.optimal
            ? 'Optimal 90-day glycemic stability with minimal cellular glycation.'
            : 'Pre-diabetic glycemic range; insulin resistance intervention indicated.',
        regionalClinicalInterpretation: hba1cStatus == LabBiomarkerStatus.optimal
            ? 'पिछले ९० दिनों का शर्करा स्तर उत्तम व सुरक्षित सीमा में है।'
            : 'शर्करा स्तर में वृद्धि; इंसुलिन संवेदनशीलता बढ़ाने की आवश्यकता।',
        lifestylePrescription: 'Maintain Shatpawali post-meal walks and 35g+ daily dietary fiber.',
        regionalLifestylePrescription: 'भोजनोपरांत शतपावली (१०० कदम) व उच्च फाइबर आहार जारी रखें।',
      ),
    );

    // Fasting Blood Glucose
    final fbgStatus = _evaluateStatus(fastingGlucoseMgDl, 70.0, 99.0, 75.0, 90.0, highIsBad: true, criticalHigh: 140.0);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'FBG',
        name: 'Fasting Blood Glucose',
        regionalName: 'फास्टिंग ब्लड ग्लूकोज (खाली पेट शर्करा)',
        category: LabBiomarkerCategory.lipidMetabolic,
        measuredValue: fastingGlucoseMgDl,
        unit: 'mg/dL',
        referenceMin: 70.0,
        referenceMax: 99.0,
        optimalMin: 75.0,
        optimalMax: 90.0,
        status: fbgStatus,
        clinicalInterpretation: fbgStatus == LabBiomarkerStatus.optimal
            ? 'Healthy hepatic gluconeogenesis and fasting insulin sensitivity.'
            : 'Elevated morning hepatic glucose output.',
        regionalClinicalInterpretation: fbgStatus == LabBiomarkerStatus.optimal
            ? 'यकृत व इंसुलिन संवेदनशीलता पूर्णतः सामान्य है।'
            : 'प्रातःकाल यकृत द्वारा शर्करा स्राव में हल्की वृद्धि।',
        lifestylePrescription: '12-hour overnight digestive rest window (Dinner by 8:00 PM).',
        regionalLifestylePrescription: 'रात्रि भोजन ८ बजे तक पूर्ण कर १२ घंटे का उपवास रखें।',
      ),
    );

    // Triglycerides
    final tgStatus = _evaluateStatus(triglyceridesMgDl, 50.0, 150.0, 60.0, 110.0, highIsBad: true, criticalHigh: 300.0);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'LIPID_TG',
        name: 'Serum Triglycerides (TG)',
        regionalName: 'ट्राइग्लिसराइड्स (रक्त वसा)',
        category: LabBiomarkerCategory.lipidMetabolic,
        measuredValue: triglyceridesMgDl,
        unit: 'mg/dL',
        referenceMin: 50.0,
        referenceMax: 150.0,
        optimalMin: 60.0,
        optimalMax: 110.0,
        status: tgStatus,
        clinicalInterpretation: tgStatus == LabBiomarkerStatus.optimal
            ? 'Low circulating VLDL particle load; optimal lipid clearance.'
            : 'Elevated circulating neutral fats indicating refined carb excess.',
        regionalClinicalInterpretation: tgStatus == LabBiomarkerStatus.optimal
            ? 'रक्त में वसा की मात्रा सुरक्षित व संतुलित है।'
            : 'रिफाइंड कार्बोहाइड्रेट के कारण रक्त वसा में वृद्धि।',
        lifestylePrescription: 'Incorporate 1 tbsp flaxseeds / chia seeds and eliminate refined seed oils.',
        regionalLifestylePrescription: 'अलसी/चिया बीज का सेवन करें और रिफाइंड तेल से बचें।',
      ),
    );

    // HDL Cholesterol
    final hdlStatus = _evaluateStatus(hdlCholesterolMgDl, 40.0, 80.0, 50.0, 75.0, highIsBad: false);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'LIPID_HDL',
        name: 'HDL-C (Protective Cholesterol)',
        regionalName: 'HDL कोलेस्ट्रॉल (सुरक्षात्मक वसा)',
        category: LabBiomarkerCategory.lipidMetabolic,
        measuredValue: hdlCholesterolMgDl,
        unit: 'mg/dL',
        referenceMin: 40.0,
        referenceMax: 80.0,
        optimalMin: 50.0,
        optimalMax: 75.0,
        status: hdlStatus,
        clinicalInterpretation: hdlStatus == LabBiomarkerStatus.optimal
            ? 'Robust reverse cholesterol transport and endothelial protection.'
            : 'Sub-optimal HDL concentration; increase aerobic zone 2 cardio.',
        regionalClinicalInterpretation: hdlStatus == LabBiomarkerStatus.optimal
            ? 'धमनियों की सुरक्षात्मक प्रणाली उत्कृष्ट अवस्था में है।'
            : 'HDL स्तर कम है; नियमित एरोबिक कार्डियो से इसे बढ़ाएं।',
        lifestylePrescription: '3x weekly Zone 2 aerobic cardio and healthy dietary monounsaturated fats.',
        regionalLifestylePrescription: 'सप्ताह में ३ बार ज़ोन २ कार्डियो व स्वस्थ वसा (घी, अखरोट) लें।',
      ),
    );

    // LDL Cholesterol
    final ldlStatus = _evaluateStatus(ldlCholesterolMgDl, 50.0, 129.0, 60.0, 99.0, highIsBad: true, criticalHigh: 190.0);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'LIPID_LDL',
        name: 'LDL-C (Atherogenic Particle Proxy)',
        regionalName: 'LDL कोलेस्ट्रॉल',
        category: LabBiomarkerCategory.lipidMetabolic,
        measuredValue: ldlCholesterolMgDl,
        unit: 'mg/dL',
        referenceMin: 50.0,
        referenceMax: 129.0,
        optimalMin: 60.0,
        optimalMax: 99.0,
        status: ldlStatus,
        clinicalInterpretation: ldlStatus == LabBiomarkerStatus.optimal
            ? 'Atherogenic lipoprotein burden is within protective longevity range.'
            : 'Moderate atherogenic particle count; increase soluble fiber intake.',
        regionalClinicalInterpretation: ldlStatus == LabBiomarkerStatus.optimal
            ? 'हृदय धमनियों के लिए सुरक्षित सीमा में है।'
            : 'घुलनशील फाइबर (ओट्स, ईसबगोल) का सेवन बढ़ाएं।',
        lifestylePrescription: 'Add 5g psyllium husk (Isabgol) daily to promote bile acid excretion.',
        regionalLifestylePrescription: 'प्रतिदिन ५ ग्राम ईसबगोल लें जो कोलेस्ट्रॉल घटाने में सहायक है।',
      ),
    );

    // --- 2. Hepatic (Liver LFT) Panel ---
    final altStatus = _evaluateStatus(altSgptUnitsL, 10.0, 45.0, 12.0, 28.0, highIsBad: true, criticalHigh: 80.0);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'LFT_ALT',
        name: 'SGPT / Alanine Aminotransferase (ALT)',
        regionalName: 'SGPT / ALT (यकृत एंजाइम)',
        category: LabBiomarkerCategory.hepaticLiver,
        measuredValue: altSgptUnitsL,
        unit: 'U/L',
        referenceMin: 10.0,
        referenceMax: 45.0,
        optimalMin: 12.0,
        optimalMax: 28.0,
        status: altStatus,
        clinicalInterpretation: altStatus == LabBiomarkerStatus.optimal
            ? 'No hepatocyte inflammation or hepatic steatosis (MASLD).'
            : 'Elevated ALT indicating early hepatocyte stress or visceral fat deposition.',
        regionalClinicalInterpretation: altStatus == LabBiomarkerStatus.optimal
            ? 'यकृत में कोई सूजन या फैटी लिवर का संकेत नहीं है।'
            : 'यकृत पर प्रारंभिक सूजन अथवा विसरल चर्बी का संकेत।',
        lifestylePrescription: 'Cruciferous vegetables (Broccoli/Cauliflower) and reduce late-night snacking.',
        regionalLifestylePrescription: 'पत्तागोभी/ब्रोकोली का सेवन करें और देर रात खाने से बचें।',
      ),
    );

    // --- 3. Renal & Electrolytes (KFT) Panel ---
    final creatStatus = _evaluateStatus(serumCreatinineMgDl, 0.6, 1.2, 0.7, 1.05, highIsBad: true, criticalHigh: 1.6);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'KFT_CREAT',
        name: 'Serum Creatinine',
        regionalName: 'सीरम क्रिएटिनिन (गुर्दा कार्यक्षमता)',
        category: LabBiomarkerCategory.renalKidney,
        measuredValue: serumCreatinineMgDl,
        unit: 'mg/dL',
        referenceMin: 0.6,
        referenceMax: 1.2,
        optimalMin: 0.7,
        optimalMax: 1.05,
        status: creatStatus,
        clinicalInterpretation: creatStatus == LabBiomarkerStatus.optimal
            ? 'Optimal glomerular filtration reserve and renal clearance.'
            : 'Creatinine elevation; ensure adequate hydration and repeat test.',
        regionalClinicalInterpretation: creatStatus == LabBiomarkerStatus.optimal
            ? 'गुर्दों की रक्त शोधन क्षमता पूर्णतः सामान्य है।'
            : 'पर्याप्त मात्रा में पानी पिएं और पुनः जांच कराएं।',
        lifestylePrescription: 'Maintain 3.0L daily hydration with electrolyte balance.',
        regionalLifestylePrescription: 'प्रतिदिन ३ लीटर जल व इलेक्ट्रोलाइट्स का सेवन बनाए रखें।',
      ),
    );

    // Serum Uric Acid
    final uricStatus = _evaluateStatus(serumUricAcidMgDl, 3.5, 7.2, 4.0, 6.0, highIsBad: true, criticalHigh: 9.0);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'KFT_URIC',
        name: 'Serum Uric Acid',
        regionalName: 'सीरम यूरिक एसिड',
        category: LabBiomarkerCategory.renalKidney,
        measuredValue: serumUricAcidMgDl,
        unit: 'mg/dL',
        referenceMin: 3.5,
        referenceMax: 7.2,
        optimalMin: 4.0,
        optimalMax: 6.0,
        status: uricStatus,
        clinicalInterpretation: uricStatus == LabBiomarkerStatus.optimal
            ? 'Purine metabolism is well-balanced with no hyperuricemia risk.'
            : 'Elevated uric acid; reduce high-fructose corn syrups and alcohol.',
        regionalClinicalInterpretation: uricStatus == LabBiomarkerStatus.optimal
            ? 'प्यूरीन उपापचय सामान्य है व यूरिक एसिड का स्तर संतुलित है।'
            : 'मीठे पेय पदार्थों से बचें और जल सेवन बढ़ाएं।',
        lifestylePrescription: 'Tart cherry extract or lemon water in the morning.',
        regionalLifestylePrescription: 'सुबह गुनगुने पानी में नींबू का रस लें।',
      ),
    );

    // --- 4. Micronutrients & Endocrine Panel ---
    final vitDStatus = _evaluateStatus(vitaminD3NgMl, 30.0, 100.0, 40.0, 70.0, highIsBad: false);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'VIT_D3',
        name: 'Vitamin D3 (25-OH Cholecalciferol)',
        regionalName: 'विटामिन D3 (धूप व अस्थि स्वास्थ्य)',
        category: LabBiomarkerCategory.micronutrientsEndocrine,
        measuredValue: vitaminD3NgMl,
        unit: 'ng/mL',
        referenceMin: 30.0,
        referenceMax: 100.0,
        optimalMin: 40.0,
        optimalMax: 70.0,
        status: vitDStatus,
        clinicalInterpretation: vitDStatus == LabBiomarkerStatus.optimal
            ? 'Robust immunomodulatory and bone mineral density support.'
            : 'Sub-optimal Vitamin D3 common in South Asia; supplementation indicated.',
        regionalClinicalInterpretation: vitDStatus == LabBiomarkerStatus.optimal
            ? 'प्रतिरक्षा प्रणाली व हड्डियों की मजबूती के लिए आदर्श स्तर।'
            : 'विटामिन D3 की कमी; धूप व अनुपूरक की आवश्यकता।',
        lifestylePrescription: '20 minutes morning sun exposure & Vitamin D3 + K2 protocol.',
        regionalLifestylePrescription: 'प्रातःकाल २० मिनट धूप लें व विटामिन D3+K2 का सेवन करें।',
      ),
    );

    final vitB12Status = _evaluateStatus(vitaminB12PgMl, 211.0, 911.0, 400.0, 800.0, highIsBad: false);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'VIT_B12',
        name: 'Vitamin B12 (Cobalamin)',
        regionalName: 'विटामिन B12 (तंत्रिका व ऊर्जा स्वास्थ्य)',
        category: LabBiomarkerCategory.micronutrientsEndocrine,
        measuredValue: vitaminB12PgMl,
        unit: 'pg/mL',
        referenceMin: 211.0,
        referenceMax: 911.0,
        optimalMin: 400.0,
        optimalMax: 800.0,
        status: vitB12Status,
        clinicalInterpretation: vitB12Status == LabBiomarkerStatus.optimal
            ? 'Optimal myelin sheath protection and methylation reserve.'
            : 'Borderline low B12 frequently observed in vegetarian diets.',
        regionalClinicalInterpretation: vitB12Status == LabBiomarkerStatus.optimal
            ? 'तंत्रिका तंत्र व लाल रक्त कोशिकाओं के लिए उत्तम स्तर।'
            : 'शाकाहारी आहार में B12 की कमी आम है; अनुपूरक लें।',
        lifestylePrescription: 'Methylcobalamin supplement or fortified nutritional yeast.',
        regionalLifestylePrescription: 'मेथिलकोबालामिन अथवा बी१२ फोर्टिफाइड खाद्य पदार्थों का सेवन करें।',
      ),
    );

    final tshStatus = _evaluateStatus(tshUiuMl, 0.4, 4.5, 1.0, 2.5, highIsBad: true, criticalHigh: 8.0);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'ENDO_TSH',
        name: 'Thyroid Stimulating Hormone (TSH)',
        regionalName: 'थायरॉयड प्रेरक हार्मोन (TSH)',
        category: LabBiomarkerCategory.micronutrientsEndocrine,
        measuredValue: tshUiuMl,
        unit: 'uIU/mL',
        referenceMin: 0.4,
        referenceMax: 4.5,
        optimalMin: 1.0,
        optimalMax: 2.5,
        status: tshStatus,
        clinicalInterpretation: tshStatus == LabBiomarkerStatus.optimal
            ? 'Euthyroid state; optimal metabolic basal metabolic rate.'
            : 'Subclinical thyroid variability.',
        regionalClinicalInterpretation: tshStatus == LabBiomarkerStatus.optimal
            ? 'थायरॉयड व उपापचय दर पूर्णतः संतुलित है।'
            : 'थायरॉयड कार्यप्रणाली में हल्का उतार-चढ़ाव।',
        lifestylePrescription: 'Adequate selenium (2 Brazil nuts/day) and iodized salt.',
        regionalLifestylePrescription: 'सेलेनियम (ब्राजील नट्स) व आयोडीन युक्त आहार लें।',
      ),
    );

    // --- 5. Hematology & Inflammation Panel ---
    final hscrpStatus = _evaluateStatus(hsCrpMgL, 0.0, 3.0, 0.1, 1.0, highIsBad: true, criticalHigh: 6.0);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'CARDIO_HSCRP',
        name: 'High-Sensitivity C-Reactive Protein (hs-CRP)',
        regionalName: 'hs-CRP (सूक्ष्म संवहनी सूजन स्तर)',
        category: LabBiomarkerCategory.hematologyCbc,
        measuredValue: hsCrpMgL,
        unit: 'mg/L',
        referenceMin: 0.0,
        referenceMax: 3.0,
        optimalMin: 0.1,
        optimalMax: 1.0,
        status: hscrpStatus,
        clinicalInterpretation: hscrpStatus == LabBiomarkerStatus.optimal
            ? 'Minimal systemic vascular inflammation and low cardiovascular plaque risk.'
            : 'Elevated systemic micro-inflammation.',
        regionalClinicalInterpretation: hscrpStatus == LabBiomarkerStatus.optimal
            ? 'धमनियों में सूक्ष्म सूजन का स्तर अत्यंत कम व सुरक्षित है।'
            : 'शरीर में सूजन का संकेत; सूजन-रोधी आहार लें।',
        lifestylePrescription: 'Curcumin with black pepper (Haldi doodh) & cold-pressed virgin oils.',
        regionalLifestylePrescription: 'हल्दी वाला दूध (काली मिर्च युक्त) व एंटीऑक्सीडेंट्स लें।',
      ),
    );

    final hbStatus = _evaluateStatus(hemoglobinGDl, 12.0, 17.0, 13.5, 16.5, highIsBad: false);
    biomarkers.add(
      ParsedLabBiomarker(
        code: 'CBC_HB',
        name: 'Hemoglobin (Hb)',
        regionalName: 'हीमोग्लोबिन (रक्त ऑक्सीजन वाहक)',
        category: LabBiomarkerCategory.hematologyCbc,
        measuredValue: hemoglobinGDl,
        unit: 'g/dL',
        referenceMin: 12.0,
        referenceMax: 17.0,
        optimalMin: 13.5,
        optimalMax: 16.5,
        status: hbStatus,
        clinicalInterpretation: hbStatus == LabBiomarkerStatus.optimal
            ? 'Excellent oxygen carrying capacity and aerobic endurance foundation.'
            : 'Mild anemia tendency; increase bioavailable iron and Vitamin C.',
        regionalClinicalInterpretation: hbStatus == LabBiomarkerStatus.optimal
            ? 'रक्त में ऑक्सीजन वहन क्षमता उत्कृष्ट है।'
            : 'आयरन व विटामिन सी युक्त आहार (आंवला, पालक) बढ़ाएं।',
        lifestylePrescription: 'Amla juice and green leafy vegetables cooked in iron cookware.',
        regionalLifestylePrescription: 'आंवला रस व लोहे के बर्तन में पकी हरी पत्तेदार सब्जियां खाएं।',
      ),
    );

    // Calculate Panel Summaries
    final panelSummaries = <LabPanelSummary>[];
    for (final cat in LabBiomarkerCategory.values) {
      final catBiomarkers = biomarkers.where((b) => b.category == cat).toList();
      if (catBiomarkers.isNotEmpty) {
        final optimalCount = catBiomarkers.where((b) => b.status == LabBiomarkerStatus.optimal).length;
        final abnormalCount = catBiomarkers.where((b) => b.status == LabBiomarkerStatus.abnormal || b.status == LabBiomarkerStatus.critical).length;
        final score = (optimalCount / catBiomarkers.length) * 100.0;

        panelSummaries.add(
          LabPanelSummary(
            category: cat,
            healthScore: _round(score),
            totalBiomarkers: catBiomarkers.length,
            optimalCount: optimalCount,
            abnormalCount: abnormalCount,
            keyObservation: abnormalCount == 0
                ? 'All $optimalCount biomarkers within optimal physiological range.'
                : '$abnormalCount biomarker(s) require proactive lifestyle optimization.',
            regionalKeyObservation: abnormalCount == 0
                ? 'सभी $optimalCount बायोमार्कर्स उत्कृष्ट सीमा में हैं।'
                : '$abnormalCount बायोमार्कर में सक्रिय सुधार की आवश्यकता है।',
          ),
        );
      }
    }

    // Overall Score
    final totalOptimal = biomarkers.where((b) => b.status == LabBiomarkerStatus.optimal).length;
    final totalBorderline = biomarkers.where((b) => b.status == LabBiomarkerStatus.borderline).length;
    final overallScore = _round(((totalOptimal * 1.0 + totalBorderline * 0.5) / biomarkers.length) * 100.0);

    // Check for Critical Physician Escalations
    final criticalBiomarkers = biomarkers.where((b) => b.status == LabBiomarkerStatus.critical).toList();
    final requiresConsult = criticalBiomarkers.isNotEmpty;
    final escalationReason = requiresConsult
        ? 'Critical threshold breached in: ${criticalBiomarkers.map((b) => "${b.name} (${b.measuredValue} ${b.unit})").join(", ")}'
        : 'All biomarker results are within manageable non-pharmaceutical ranges.';
    final regionalEscalationReason = requiresConsult
        ? 'निम्नलिखित जांच में गंभीर स्तर पार हुआ: ${criticalBiomarkers.map((b) => b.regionalName).join(", ")}'
        : 'सभी बायोमार्कर्स सामान्य व प्रबंधनीय सीमा में हैं।';

    // Generate Actionable Protocols
    final protocols = _generateOptimizationProtocols(biomarkers);

    final execSynthesis =
        'Your comprehensive laboratory panel from $labProviderName scored an overall metabolic health grade of ${overallScore.toInt()}/100. Of the ${biomarkers.length} evaluated clinical parameters, $totalOptimal are in the optimal longevity range and $totalBorderline are borderline. Key cardiovascular and liver integrity markers reflect robust physiological resilience.';

    final regionalExecSynthesis =
        '$labProviderName की जांच रिपोर्ट का समग्र स्वास्थ्य स्कोर ${overallScore.toInt()}/100 रहा। कुल ${biomarkers.length} में से $totalOptimal बायोमार्कर्स दीर्घायु की दृष्टि से उत्कृष्ट हैं। हृदय व यकृत स्वास्थ्य मजबूत स्थिति में है।';

    return ClinicalReportIntelligence(
      reportId: reportId,
      labProviderName: labProviderName,
      testDate: testDate,
      overallMetabolicGradeScore: overallScore,
      parsedBiomarkers: biomarkers,
      panelSummaries: panelSummaries,
      optimizationProtocols: protocols,
      requiresPhysicianConsult: requiresConsult,
      physicianEscalationRationale: escalationReason,
      regionalPhysicianEscalationRationale: regionalEscalationReason,
      executiveSynthesis: execSynthesis,
      regionalExecutiveSynthesis: regionalExecSynthesis,
    );
  }

  // --- Internal Status Evaluation Helpers ---

  LabBiomarkerStatus _evaluateStatus(
    double val,
    double refMin,
    double refMax,
    double optMin,
    double optMax, {
    required bool highIsBad,
    double? criticalHigh,
  }) {
    if (criticalHigh != null && val >= criticalHigh) {
      return LabBiomarkerStatus.critical;
    }

    if (val >= optMin && val <= optMax) {
      return LabBiomarkerStatus.optimal;
    }

    if (val >= refMin && val <= refMax) {
      return LabBiomarkerStatus.borderline;
    }

    return LabBiomarkerStatus.abnormal;
  }

  List<LabOptimizationProtocol> _generateOptimizationProtocols(List<ParsedLabBiomarker> biomarkers) {
    final protocols = <LabOptimizationProtocol>[];

    final nonOptimal = biomarkers.where((b) => b.status != LabBiomarkerStatus.optimal).toList();
    for (final b in nonOptimal.take(3)) {
      protocols.add(
        LabOptimizationProtocol(
          id: 'opt_${b.code.toLowerCase()}',
          title: '${b.name} Optimization Protocol',
          regionalTitle: '${b.regionalName} सुधार योजना',
          targetBiomarker: '${b.name} (${b.measuredValue} ${b.unit})',
          actionPlan: b.lifestylePrescription,
          regionalActionPlan: b.regionalLifestylePrescription,
          expectedChange: 'Normalized within 6-8 weeks',
          karmaReward: 60,
        ),
      );
    }

    if (protocols.isEmpty) {
      protocols.add(
        const LabOptimizationProtocol(
          id: 'opt_maintenance',
          title: 'Longevity Biomarker Maintenance',
          regionalTitle: 'दीर्घायु बायोमार्कर संतुलन संरक्षण',
          targetBiomarker: 'All Biomarkers Optimal',
          actionPlan: 'Continue current anti-inflammatory nutrition and daily Zone 2 exercise routine.',
          regionalActionPlan: 'वर्तमान स्वस्थ खान-पान व दैनिक व्यायाम की दिनचर्या जारी रखें।',
          expectedChange: 'Sustained optimal longevity status',
          karmaReward: 50,
        ),
      );
    }

    return protocols;
  }

  double _round(double val) {
    return (val * 10).round() / 10.0;
  }
}
