import 'dart:math';
import 'body_analytics_models.dart';

/// Pure Dart Deterministic Engine for Anthropometric & Visual Body Composition Analytics
class BodyAnalyticsEngine {
  const BodyAnalyticsEngine();

  /// Computes comprehensive body composition, anthropometrics, and Ayurvedic Dhatu scores
  BodyAnalyticsReport computeBodyAnalytics({
    required double weightKg,
    required double heightCm,
    required AnthropometricSex sex,
    required int chronologicalAge,
    required BodyCircumferences circumferences,
    DateTime? recordedAt,
  }) {
    final now = recordedAt ?? DateTime.now();

    // 1. Calculate Body Fat % using US Navy Anthropometric Formula
    double bodyFatPercent;
    if (sex == AnthropometricSex.male) {
      final diff = max(1.0, circumferences.waistCm - circumferences.neckCm);
      final logDiff = log(diff) / ln10;
      final logHeight = log(heightCm) / ln10;
      final denominator = 1.0324 - (0.19077 * logDiff) + (0.15456 * logHeight);
      if (denominator > 0) {
        bodyFatPercent = (495.0 / denominator) - 450.0;
      } else {
        bodyFatPercent = 18.0;
      }
    } else {
      final sum = max(
          1.0,
          circumferences.waistCm +
              circumferences.hipsCm -
              circumferences.neckCm);
      final logSum = log(sum) / ln10;
      final logHeight = log(heightCm) / ln10;
      final denominator = 1.29579 - (0.35004 * logSum) + (0.22100 * logHeight);
      if (denominator > 0) {
        bodyFatPercent = (495.0 / denominator) - 450.0;
      } else {
        bodyFatPercent = 25.0;
      }
    }

    // Clamp body fat to biological realities
    bodyFatPercent = bodyFatPercent.clamp(4.0, 50.0);

    // 2. Mass Breakdown
    final fatMassKg = weightKg * (bodyFatPercent / 100.0);
    final leanMuscleMassKg = weightKg - fatMassKg;
    final boneMassKg =
        weightKg * (sex == AnthropometricSex.male ? 0.046 : 0.042);
    final totalBodyWaterPercent =
        ((leanMuscleMassKg * 0.73) / weightKg) * 100.0;

    // 3. Basal Metabolic Rate (BMR kcal) - Mifflin-St Jeor Equation
    double bmr;
    if (sex == AnthropometricSex.male) {
      bmr = (10.0 * weightKg) +
          (6.25 * heightCm) -
          (5.0 * chronologicalAge) +
          5.0;
    } else {
      bmr = (10.0 * weightKg) +
          (6.25 * heightCm) -
          (5.0 * chronologicalAge) -
          161.0;
    }

    // 4. Ratios
    final whr = circumferences.hipsCm > 0
        ? circumferences.waistCm / circumferences.hipsCm
        : 0.85;
    final whtr = heightCm > 0 ? circumferences.waistCm / heightCm : 0.48;

    // 5. Visceral Fat Index (1 - 20)
    double visceralIndex = (whtr - 0.40) * 40.0 + (chronologicalAge * 0.05);
    visceralIndex = visceralIndex.clamp(1.0, 20.0);

    // 6. Metabolic Age
    final refFat = sex == AnthropometricSex.male ? 15.0 : 23.0;
    final ageDelta = ((bodyFatPercent - refFat) * 0.5).round();
    final metabolicAge = max(18, chronologicalAge + ageDelta);

    // 7. Left-Right Symmetry Index Score (0 - 100%)
    final bicepDiff =
        (circumferences.bicepLeftCm - circumferences.bicepRightCm).abs();
    final thighDiff =
        (circumferences.thighLeftCm - circumferences.thighRightCm).abs();
    final calfDiff =
        (circumferences.calfLeftCm - circumferences.calfRightCm).abs();
    final symmetryPenalty = (bicepDiff + thighDiff + calfDiff) * 5.0;
    final symmetryScore = (100.0 - symmetryPenalty).clamp(60.0, 100.0);

    // 8. Body Composition Zone
    BodyCompositionZone zone;
    if (sex == AnthropometricSex.male) {
      if (bodyFatPercent < 14.0) {
        zone = BodyCompositionZone.athleticLean;
      } else if (bodyFatPercent <= 21.0 && whtr <= 0.50) {
        zone = BodyCompositionZone.fitHealthy;
      } else if (leanMuscleMassKg / weightKg < 0.68) {
        zone = BodyCompositionZone.sarcopenicRisk;
      } else {
        zone = BodyCompositionZone.elevatedAdiposity;
      }
    } else {
      if (bodyFatPercent < 21.0) {
        zone = BodyCompositionZone.athleticLean;
      } else if (bodyFatPercent <= 28.0 && whtr <= 0.50) {
        zone = BodyCompositionZone.fitHealthy;
      } else if (leanMuscleMassKg / weightKg < 0.62) {
        zone = BodyCompositionZone.sarcopenicRisk;
      } else {
        zone = BodyCompositionZone.elevatedAdiposity;
      }
    }

    // 9. Ayurvedic 7 Dhatu Tissue Quality Profile
    final dhatuProfile = _calculateDhatuProfile(
      bodyFatPercent: bodyFatPercent,
      leanMassKg: leanMuscleMassKg,
      totalBodyWaterPercent: totalBodyWaterPercent,
      symmetryScore: symmetryScore,
      visceralFat: visceralIndex,
    );

    // 10. Recommendations
    final (rec, regRec) =
        _generateRecommendations(zone, bodyFatPercent, whtr, symmetryScore);

    return BodyAnalyticsReport(
      weightKg: double.parse(weightKg.toStringAsFixed(1)),
      heightCm: double.parse(heightCm.toStringAsFixed(1)),
      sex: sex,
      bodyFatPercent: double.parse(bodyFatPercent.toStringAsFixed(1)),
      leanMuscleMassKg: double.parse(leanMuscleMassKg.toStringAsFixed(1)),
      fatMassKg: double.parse(fatMassKg.toStringAsFixed(1)),
      boneMassKg: double.parse(boneMassKg.toStringAsFixed(2)),
      totalBodyWaterPercent:
          double.parse(totalBodyWaterPercent.toStringAsFixed(1)),
      basalMetabolicRateKcal: double.parse(bmr.toStringAsFixed(0)),
      metabolicAge: metabolicAge,
      visceralFatIndex: double.parse(visceralIndex.toStringAsFixed(1)),
      waistToHipRatio: double.parse(whr.toStringAsFixed(2)),
      waistToHeightRatio: double.parse(whtr.toStringAsFixed(2)),
      zone: zone,
      circumferences: circumferences,
      dhatuProfile: dhatuProfile,
      symmetryIndexScore: double.parse(symmetryScore.toStringAsFixed(1)),
      actionableBodyRecommendation: rec,
      regionalBodyRecommendation: regRec,
      recordedAt: now,
    );
  }

  AyurvedicDhatuProfile _calculateDhatuProfile({
    required double bodyFatPercent,
    required double leanMassKg,
    required double totalBodyWaterPercent,
    required double symmetryScore,
    required double visceralFat,
  }) {
    // Rasa Dhatu (Hydration & Lymph)
    final rasa = (totalBodyWaterPercent / 60.0 * 95.0).clamp(40.0, 98.0);

    // Rakta Dhatu (Circulation & Vitality)
    final rakta = (100.0 - (visceralFat * 2.5)).clamp(50.0, 98.0);

    // Mamsa Dhatu (Muscle integrity & density)
    final mamsa = (leanMassKg / 60.0 * 90.0).clamp(45.0, 98.0);

    // Meda Dhatu (Adipose lipid homeostasis)
    final meda =
        (100.0 - (bodyFatPercent - 15.0).abs() * 2.5).clamp(40.0, 98.0);

    // Asthi Dhatu (Bone & structural frame)
    final asthi = 92.0;

    // Majja Dhatu (Neuromuscular symmetry & marrow)
    final majja = symmetryScore;

    // Shukra / Ojas (Deep cellular reserve)
    final shukra =
        ((rasa + rakta + mamsa + meda + asthi + majja) / 6.0).clamp(50.0, 98.0);

    String obs;
    String regObs;
    if (mamsa >= 85.0 && meda >= 80.0) {
      obs =
          'Samadhatu State: Optimal Mamsa (muscle) & Meda (lipid) equilibrium.';
      regObs = 'समधातु अवस्था: मांस व मेद धातु का उत्कृष्ट संतुलन।';
    } else if (meda < 65.0) {
      obs =
          'Meda Dhatu Vriddhi: Elevated lipid accumulation; stimulate Medagni with warming spices.';
      regObs =
          'मेद धातु वृद्धि: दीपन-पाचन औषधियों एवं व्यायाम द्वारा मेद संतुलित करें।';
    } else {
      obs =
          'Mamsa Dhatu Kshaya: Build structural muscle tone with nourishing Ahara.';
      regObs =
          'मांस धातु क्षय: बलवर्धक आहार व शक्ति प्रशिक्षण द्वारा मांसपेशी घनत्व बढ़ाएं।';
    }

    return AyurvedicDhatuProfile(
      rasaQualityScore: double.parse(rasa.toStringAsFixed(1)),
      raktaQualityScore: double.parse(rakta.toStringAsFixed(1)),
      mamsaQualityScore: double.parse(mamsa.toStringAsFixed(1)),
      medaQualityScore: double.parse(meda.toStringAsFixed(1)),
      asthiQualityScore: asthi,
      majjaQualityScore: double.parse(majja.toStringAsFixed(1)),
      shukraQualityScore: double.parse(shukra.toStringAsFixed(1)),
      dominantDhatuObservation: obs,
      regionalDhatuObservation: regObs,
    );
  }

  (String, String) _generateRecommendations(
    BodyCompositionZone zone,
    double bodyFat,
    double whtr,
    double symmetry,
  ) {
    switch (zone) {
      case BodyCompositionZone.athleticLean:
        return (
          'Superb muscular conditioning and low visceral adiposity. Maintain progressive resistance loads and ensure adequate Ojas nourishment with Ashwagandha & Amla.',
          'उत्कृष्ट शारीरिक गठन एवं सुदृढ़ मांसपेशियां। शक्ति प्रशिक्षण जारी रखें तथा अश्वगंधा व आंवला युक्त रसायन आहार से ओजस बनाए रखें।',
        );
      case BodyCompositionZone.fitHealthy:
        return (
          'Harmonious body composition within ideal cardiometabolic thresholds (WHtR < 0.50). Continue balanced macronutrient intake and bilateral compound movements.',
          'संतुलित शारीरिक संरचना व आदर्श कमर-ऊंचाई अनुपात। संतुलित आहार व दोनों पक्षों का समान व्यायाम जारी रखें।',
        );
      case BodyCompositionZone.elevatedAdiposity:
        return (
          'Waist-to-height ratio suggests visceral adipose storage. Implement a mild 300 kcal deficit, 10,000 daily steps, and Shatapadi post-meal walking to reduce visceral fat.',
          'कमर-ऊंचाई अनुपात मेद संचय दर्शाता है। प्रतिदिन १०,००० कदम चलें, भोजन पश्चात शतपदी करें एवं हल्का कैलोरी घाटा रखें।',
        );
      case BodyCompositionZone.sarcopenicRisk:
        return (
          'Muscle-to-fat ratio is sub-optimal. Prioritize 1.6-2.0g/kg protein intake, resistance training 3-4x weekly, and Mamsa Dhatu strengthening nutrition.',
          'मांसपेशी घनत्व कम है। आहार में प्रोटीन की मात्रा बढ़ाएं, सप्ताह में ३-४ बार शक्ति प्रशिक्षण करें व मांस धातु वर्धक आहार लें।',
        );
    }
  }
}
