import 'dart:math' as math;
import 'deepened_environmental_models.dart';
import 'environmental_health_engine.dart';

/// Pure Dart Deterministic Engine for Deepened Environmental Health,
/// Multi-Pollutant Speciation, Ayurvedic Ritu-Charya, and Cardiopulmonary Strain.
class DeepenedEnvironmentalEngine {
  const DeepenedEnvironmentalEngine();

  /// Synthesizes complete deepened environmental health evaluation
  DeepenedEnvironmentalReport synthesizeReport({
    required int aqi,
    required double uvIndex,
    required double temperatureC,
    required double humidityPercent,
    double? pm25,
    double? pm10,
    double? no2Ppb,
    double? so2Ppb,
    double? coPpm,
    double? ozonePpb,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? DateTime.now();

    // 1. Evaluate Base Environmental Snapshot
    final baseSnapshot = EnvironmentalHealthEngine.evaluate(
      aqi: aqi,
      uvIndex: uvIndex,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
    );

    // 2. Multi-Pollutant Speciation (estimated or exact)
    final double computedPm25 = pm25 ?? _estimatePm25FromAqi(aqi);
    final double computedPm10 = pm10 ?? (computedPm25 * 1.65);
    final double computedNo2 = no2Ppb ?? (aqi * 0.28).clamp(5.0, 150.0);
    final double computedSo2 = so2Ppb ?? (aqi * 0.12).clamp(2.0, 80.0);
    final double computedCo = coPpm ?? (aqi * 0.015).clamp(0.2, 12.0);
    final double computedO3 = ozonePpb ?? (aqi * 0.35).clamp(10.0, 180.0);

    final pollutants = PollutantBreakdown(
      pm25: double.parse(computedPm25.toStringAsFixed(1)),
      pm10: double.parse(computedPm10.toStringAsFixed(1)),
      no2: double.parse(computedNo2.toStringAsFixed(1)),
      so2: double.parse(computedSo2.toStringAsFixed(1)),
      co: double.parse(computedCo.toStringAsFixed(2)),
      o3: double.parse(computedO3.toStringAsFixed(1)),
    );

    // 3. Evaluate Cardiopulmonary Exercise Stress & Inhaled Particulates
    final pulmonaryStress = _evaluateCardiopulmonaryStress(
      aqi: aqi,
      pm25: computedPm25,
      tempC: temperatureC,
      humidity: humidityPercent,
      hourOfDay: now.hour,
      month: now.month,
    );

    // 4. Evaluate Wet-Bulb Globe Temperature & Thermal Strain
    final thermalStrain = _evaluateThermalStrain(
      tempC: temperatureC,
      humidity: humidityPercent,
    );

    // 5. Map Ayurvedic Ritu-Charya Bioclimatic Season
    final rituCharya =
        _mapRituCharya(month: now.month, aqi: aqi, tempC: temperatureC);

    // 6. Calculate Composite Environmental Safety Index (0 to 100)
    double safetyScore = 100.0;
    // AQI deduction
    safetyScore -= (aqi * 0.18);
    // PM2.5 penalty
    if (computedPm25 > 60.0) {
      safetyScore -= ((computedPm25 - 60.0) * 0.25);
    }
    // Heat penalty
    if (thermalStrain.wbgtCelsius > 28.0) {
      safetyScore -= ((thermalStrain.wbgtCelsius - 28.0) * 4.0);
    }
    // UV penalty
    if (uvIndex > 8.0) {
      safetyScore -= ((uvIndex - 8.0) * 3.0);
    }
    safetyScore = safetyScore.clamp(5.0, 100.0);

    // 7. Primary Action Advisory
    final (primaryAdvisory, regionalAdvisory) = _buildActionAdvisories(
      pulmonary: pulmonaryStress,
      thermal: thermalStrain,
      ritu: rituCharya,
    );

    return DeepenedEnvironmentalReport(
      baseSnapshot: baseSnapshot,
      pollutants: pollutants,
      rituCharya: rituCharya,
      pulmonaryStress: pulmonaryStress,
      thermalStrain: thermalStrain,
      environmentalSafetyIndex: double.parse(safetyScore.toStringAsFixed(1)),
      primaryActionAdvisory: primaryAdvisory,
      regionalPrimaryActionAdvisory: regionalAdvisory,
      evaluatedAt: now,
    );
  }

  double _estimatePm25FromAqi(int aqi) {
    if (aqi <= 50) return (aqi * 0.6);
    if (aqi <= 100) return 30.0 + (aqi - 50) * 0.6;
    if (aqi <= 200) return 60.0 + (aqi - 100) * 0.6;
    if (aqi <= 300) return 120.0 + (aqi - 200) * 0.9;
    if (aqi <= 400) return 210.0 + (aqi - 300) * 0.9;
    return 300.0 + (aqi - 400) * 1.5;
  }

  CardioPulmonaryStressIndex _evaluateCardiopulmonaryStress({
    required int aqi,
    required double pm25,
    required double tempC,
    required double humidity,
    required int hourOfDay,
    required int month,
  }) {
    // Minute ventilation during moderate running ~ 45 L/min = 2.7 m3/hour
    // Pulmonary alveolar deposition fraction ~ 0.75
    final double inhaledPm25 =
        double.parse((2.7 * pm25 * 0.75).toStringAsFixed(1));

    // Temperature inversion trap detection: Winter months (Nov-Feb) + early morning (05:00 - 09:00) + cold/humid
    final bool isWinter =
        month == 11 || month == 12 || month == 1 || month == 2;
    final bool isEarlyMorning = hourOfDay >= 5 && hourOfDay <= 9;
    final bool hasThermalInversion =
        isWinter && isEarlyMorning && tempC <= 18.0 && humidity >= 60.0;

    double stress = (aqi * 0.22) + (pm25 * 0.15);
    if (hasThermalInversion) stress += 15.0;
    stress = stress.clamp(5.0, 100.0);

    final TrainingEnvironmentMode mode;
    final ProtectiveMaskTier maskTier;
    final String rationale;
    final String regionalRationale;

    if (aqi >= 300 || pm25 >= 180.0) {
      mode = TrainingEnvironmentMode.hazardousHalt;
      maskTier = ProtectiveMaskTier.n99Mandatory;
      rationale =
          'Severe toxic particulate load (${pm25.toStringAsFixed(0)} µg/m³). Inhaling >$inhaledPm25 µg PM2.5/hr triggers acute systemic endothelial inflammation.';
      regionalRationale =
          'अत्यंत विषैला वायु प्रदूषण स्तर (${pm25.toStringAsFixed(0)} µg/m³)। बाहर व्यायाम से बचें व N99 मास्क पहनें।';
    } else if (aqi >= 180 || pm25 >= 90.0 || hasThermalInversion) {
      mode = TrainingEnvironmentMode.indoorAirPurifiedOnly;
      maskTier = ProtectiveMaskTier.n95Recommended;
      rationale = hasThermalInversion
          ? 'Morning winter ground-level smog inversion trap. Shift workout to HEPA-purified indoor facility.'
          : 'High alveolar particulate deposit (${inhaledPm25.toStringAsFixed(0)} µg/hr). Avoid outdoor strenuous cardio.';
      regionalRationale = hasThermalInversion
          ? 'शीतकालीन स्मॉग इन्वर्जन: प्रदूषक नीचे फंसे हैं। हेपा प्यूरीफायर युक्त इनडोर में ही कसरत करें।'
          : 'फेफड़ों में सूक्ष्म कण जमाव का खतरा। खुली हवा में भारी कार्डियो न करें।';
    } else if (aqi >= 100 || pm25 >= 45.0) {
      mode = TrainingEnvironmentMode.outdoorLowIntensityOnly;
      maskTier = ProtectiveMaskTier.none;
      rationale =
          'Moderate air quality. Low-intensity Zone 1-2 aerobic activity permitted; postpone VO2 Max intervals.';
      regionalRationale =
          'मध्यम वायु गुणवत्ता। हल्का एरोबिक व्यायाम व पैदल चलना सुरक्षित है।';
    } else {
      mode = TrainingEnvironmentMode.outdoorUnrestricted;
      maskTier = ProtectiveMaskTier.none;
      rationale =
          'Clean ambient air. Pristine conditions for outdoor interval training, running, and cycling.';
      regionalRationale =
          'स्वच्छ वायुमंडल। दौड़, साइकलिंग व गहन कसरत के लिए सर्वोत्तम परिस्थिति।';
    }

    return CardioPulmonaryStressIndex(
      stressScore: double.parse(stress.toStringAsFixed(1)),
      inhaledPm25MicrogramsPerHour: inhaledPm25,
      recommendedMode: mode,
      maskTier: maskTier,
      hasThermalInversionWarning: hasThermalInversion,
      clinicalRationale: rationale,
      regionalClinicalRationale: regionalRationale,
    );
  }

  ThermalStrainIndex _evaluateThermalStrain({
    required double tempC,
    required double humidity,
  }) {
    // Australian Bureau of Meteorology simplified Wet-Bulb Globe Temperature approximation:
    // Vapor pressure e (hPa)
    final double e = (humidity / 100.0) *
        6.105 *
        math.exp((17.27 * tempC) / (237.7 + tempC));
    final double wbgt = (0.567 * tempC) + (0.393 * e) + 3.94;

    // Sweat rate estimation: 500 ml/hr base + 75 ml per °C WBGT above 24°C
    double sweatLoss = 500.0;
    if (wbgt > 24.0) {
      sweatLoss += (wbgt - 24.0) * 85.0;
    }
    sweatLoss = sweatLoss.clamp(400.0, 2400.0);

    // Sweat contains ~ 900 mg Na+ and ~ 200 mg K+ per liter
    final int sodiumLoss = (sweatLoss * 0.90).round();
    final int potassiumLoss = (sweatLoss * 0.20).round();

    final String risk;
    final String regionalRisk;
    if (wbgt >= 32.0) {
      risk =
          'Extreme Heat Stroke Danger: Immediate core temperature elevation risk during exertion.';
      regionalRisk =
          'अत्यधिक लू व हीट स्ट्रोक का गंभीर खतरा: खुले में व्यायाम तुरंत रोकें।';
    } else if (wbgt >= 28.0) {
      risk =
          'High Thermal Strain: Heavy fluid & electrolyte deficit expected. Mandatory mineral replenishment.';
      regionalRisk =
          'उच्च तापीय तनाव: पसीने से भारी लवण ह्रास। नारियल पानी या इलेक्ट्रोल अनिवार्य।';
    } else if (wbgt >= 24.0) {
      risk =
          'Moderate Heat Strain: Hydrate with 300 ml extra water per 30 minutes of physical activity.';
      regionalRisk =
          'मध्यम तापीय प्रभाव: प्रत्येक ३० मिनट में अतिरिक्त जल ग्रहण करें।';
    } else {
      risk =
          'Low Thermal Stress: Comfortable thermal balance for endurance output.';
      regionalRisk = 'अनुकूल तापमान: सहनशक्ति प्रशिक्षण हेतु सुखद मौसम।';
    }

    return ThermalStrainIndex(
      wbgtCelsius: double.parse(wbgt.toStringAsFixed(1)),
      estimatedSweatLossPerHourMl: double.parse(sweatLoss.toStringAsFixed(0)),
      sodiumLossMg: sodiumLoss,
      potassiumLossMg: potassiumLoss,
      heatIllnessRisk: risk,
      regionalHeatIllnessRisk: regionalRisk,
    );
  }

  RituSeason _determineRituSeason(int month) {
    switch (month) {
      case 1:
      case 2:
        return RituSeason.shishira;
      case 3:
      case 4:
        return RituSeason.vasanta;
      case 5:
      case 6:
        return RituSeason.grishma;
      case 7:
      case 8:
        return RituSeason.varsha;
      case 9:
      case 10:
        return RituSeason.sharad;
      case 11:
      case 12:
      default:
        return RituSeason.hemanta;
    }
  }

  RituCharyaGuidance _mapRituCharya({
    required int month,
    required int aqi,
    required double tempC,
  }) {
    final season = _determineRituSeason(month);

    switch (season) {
      case RituSeason.shishira:
        return const RituCharyaGuidance(
          season: RituSeason.shishira,
          recommendedWorkoutWindow:
              '11:00 AM – 3:30 PM (Post-inversion smog dispersion)',
          regionalRecommendedWorkoutWindow:
              'पूर्वाह्न ११:०० से अपराह्न ३:३० (धूप व स्मॉग हटने पर)',
          herbalRespiratoryShield:
              'Tulsi, Pippali, & Sunthi (Ginger) decoction with raw honey for alveolar defense.',
          regionalHerbalRespiratoryShield:
              'तुलसी, पिप्पली व सौंठ काढ़ा शहद के साथ फेफड़ों की सुरक्षा हेतु।',
          hydrationElectrolyteFormula:
              'Warm water infused with Saunf & Ajwain with Himalayan pink salt.',
          regionalHydrationElectrolyteFormula:
              'सौंफ-अजवाइन युक्त गुनगुना पानी व सेंधा नमक।',
          postExposureAirwayCare:
              'Jal Neti nasal flush followed by 2 drops of Anu Taila in each nostril (Pratimarsa Nasya).',
          regionalPostExposureAirwayCare:
              'जल नेति शुद्धि व अणु तैल की २ बूंदें नासिका में प्रतिमर्श नस्य।',
        );
      case RituSeason.vasanta:
        return const RituCharyaGuidance(
          season: RituSeason.vasanta,
          recommendedWorkoutWindow:
              '06:30 AM – 09:00 AM (Early morning Kapha pacification)',
          regionalRecommendedWorkoutWindow:
              'प्रातः ६:३० से ९:०० (कफ शमन व स्फूर्ति हेतु)',
          herbalRespiratoryShield:
              'Sitopaladi Churna with Vasa (Adhatoda vasica) for bronchial airway dilation.',
          regionalHerbalRespiratoryShield:
              'सितोपलादि चूर्ण व वासा रस श्वास नली विस्तारण व बलगम मुक्ति हेतु।',
          hydrationElectrolyteFormula:
              'Warm water with Honey, Lemon, and a pinch of Turmeric.',
          regionalHydrationElectrolyteFormula:
              'गुनगुना पानी, शहद, नींबू व चुटकी भर हल्दी।',
          postExposureAirwayCare:
              'Steam inhalation with Eucalyptus oil & Tulsi leaves to clear pollen allergens.',
          regionalPostExposureAirwayCare:
              'नीलगिरी तेल व तुलसी की भाप परागकण एलर्जी निवारण हेतु।',
        );
      case RituSeason.grishma:
        return const RituCharyaGuidance(
          season: RituSeason.grishma,
          recommendedWorkoutWindow:
              '05:30 AM – 07:00 AM or 07:30 PM – 09:00 PM (Avoid peak solar irradiation)',
          regionalRecommendedWorkoutWindow:
              'प्रातः ५:३० से ७:०० अथवा सायं ७:३० से ९:०० (धूप से बचाव)',
          herbalRespiratoryShield:
              'Yashtimadhu (Licorice) & Chandan cold infusion for mucosal hydration.',
          regionalHerbalRespiratoryShield:
              'यष्टिमधु (मुलेठी) व शीतल चंदन जल श्वासनली की नमी बनाए रखने हेतु।',
          hydrationElectrolyteFormula:
              'Tender Coconut Water, Kokum Sharbat, or Nimbu Pani with rock salt & jaggery.',
          regionalHydrationElectrolyteFormula:
              'ताजा नारियल पानी, कोकम शर्बत या नींबू पानी सेंधा नमक व गुड़ के साथ।',
          postExposureAirwayCare:
              'Rose water eye wash & cooling Sheetali / Sheetkari Pranayama.',
          regionalPostExposureAirwayCare:
              'गुलाब जल से नेत्र प्रक्षालन व शीतली/शीतकारी प्राणायाम।',
        );
      case RituSeason.varsha:
        return const RituCharyaGuidance(
          season: RituSeason.varsha,
          recommendedWorkoutWindow:
              '07:00 AM – 10:00 AM (Well-ventilated dry space)',
          regionalRecommendedWorkoutWindow:
              'प्रातः ७:०० से १०:०० (हवादार व सूखे स्थान में)',
          herbalRespiratoryShield:
              'Trikatu Churna (Black Pepper, Long Pepper, Ginger) to stimulate sluggish metabolic Agni.',
          regionalHerbalRespiratoryShield:
              'त्रिकटु चूर्ण जठराग्नि व रोग प्रतिरोधक क्षमता बढ़ाने हेतु।',
          hydrationElectrolyteFormula:
              'Boiled and cooled copper-vessel water with cumin (Jira Jal).',
          regionalHydrationElectrolyteFormula:
              'तांबे के बर्तन में रखा उबला जीरा जल।',
          postExposureAirwayCare:
              'Warm salt-water gargling & dry towel friction bath (Udvartana).',
          regionalPostExposureAirwayCare:
              'गुनगुने नमक के पानी से गरारे व शुष्क उद्वर्तन।',
        );
      case RituSeason.sharad:
        return const RituCharyaGuidance(
          season: RituSeason.sharad,
          recommendedWorkoutWindow:
              '06:00 AM – 08:30 AM (Moderate temperature window)',
          regionalRecommendedWorkoutWindow:
              'प्रातः ६:०० से ८:३० (संतुलित तापमान समय)',
          herbalRespiratoryShield:
              'Amalaki (Amla) juice & Shankhpushpi for Pitta detoxification & cellular resilience.',
          regionalHerbalRespiratoryShield:
              'आंवला रस व शंखपुष्पी पित्त शमन व कोशिकीय शक्ति हेतु।',
          hydrationElectrolyteFormula:
              'Vetiver (Ushira) infused drinking water & Mint electrolyte lemonade.',
          regionalHydrationElectrolyteFormula:
              'खस (उशीर) सुगंधित जल व पुदीना शिकंजी।',
          postExposureAirwayCare:
              'Evening Chandra Bhedana Pranayama & cooling head massage with Brahmi oil.',
          regionalPostExposureAirwayCare:
              'चंद्र भेदन प्राणायाम व ब्राह्मी तैल शिरो अभ्यंग।',
        );
      case RituSeason.hemanta:
        return const RituCharyaGuidance(
          season: RituSeason.hemanta,
          recommendedWorkoutWindow:
              '09:30 AM – 03:00 PM (After fog & cold air dispersion)',
          regionalRecommendedWorkoutWindow:
              'पूर्वाह्न ९:३० से अपराह्न ३:०० (कोहरा व स्मॉग हटने पर)',
          herbalRespiratoryShield:
              'Chyawanprash (2 tsp) with warm milk / water and Pippali for deep alveolar protection.',
          regionalHerbalRespiratoryShield:
              'च्यवनप्राश (२ चम्मच) गुनगुने दूध/जल के साथ फेफड़ों की गहन सुरक्षा हेतु।',
          hydrationElectrolyteFormula:
              'Warm Ginger-Coriander infusion with organic Jaggery.',
          regionalHydrationElectrolyteFormula:
              'सोंठ व धनिए का गुनगुना पेय गुड़ के साथ।',
          postExposureAirwayCare:
              'Nasal Jal Neti with warm saline followed by Sesame oil Nasya before sleep.',
          regionalPostExposureAirwayCare:
              'रात्रि विश्राम पूर्व गुनगुने जल से नेति व तिल तैल नस्य।',
        );
    }
  }

  (String, String) _buildActionAdvisories({
    required CardioPulmonaryStressIndex pulmonary,
    required ThermalStrainIndex thermal,
    required RituCharyaGuidance ritu,
  }) {
    if (pulmonary.recommendedMode == TrainingEnvironmentMode.hazardousHalt) {
      return (
        'Hazardous air quality. Suspend outdoor workouts; train indoors with air purification and consume ${ritu.herbalRespiratoryShield}',
        'वायु गुणवत्ता अत्यंत खतरनाक है। बाहर कसरत रोकें; एयर-प्यूरिफायर युक्त इनडोर में अभ्यास करें तथा ${ritu.regionalHerbalRespiratoryShield}',
      );
    }

    if (pulmonary.recommendedMode ==
        TrainingEnvironmentMode.indoorAirPurifiedOnly) {
      return (
        'Smog/pollution alert: Move sessions indoors. Hydrate with ${ritu.hydrationElectrolyteFormula} and apply ${ritu.postExposureAirwayCare}',
        'प्रदूषण चेतावनी: इनडोर व्यायाम करें। ${ritu.regionalHydrationElectrolyteFormula} से जलयोजन बनाए रखें तथा ${ritu.regionalPostExposureAirwayCare}',
      );
    }

    if (thermal.wbgtCelsius >= 28.0) {
      return (
        'High heat strain (${thermal.wbgtCelsius}°C WBGT). Expected sweat loss: ${thermal.estimatedSweatLossPerHourMl.toInt()} mL/hr. Replenish with ${ritu.hydrationElectrolyteFormula}',
        'तीव्र गर्मी (${thermal.wbgtCelsius}°C)। पसीना नुकसान: ${thermal.estimatedSweatLossPerHourMl.toInt()} mL/घंटा। ${ritu.regionalHydrationElectrolyteFormula} द्वारा लवण पूर्ति करें।',
      );
    }

    return (
      'Optimal conditions in ${ritu.season.name}. Recommended workout window: ${ritu.recommendedWorkoutWindow}',
      '${ritu.season.regionalName} में अनुकूल मौसम। व्यायाम समय: ${ritu.regionalRecommendedWorkoutWindow}',
    );
  }
}
