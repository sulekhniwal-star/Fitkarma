import 'dart:math' as math;
import '../models/body_analytics_models.dart';

class BodyCompositionEngine {
  const BodyCompositionEngine();

  /// Estimates body fat percentage and body composition using the U.S. Navy Anthropometric Method
  BodyCompositionEstimate estimateComposition({
    required String id,
    required String userId,
    required String gender, // 'male' or 'female'
    required double heightCm,
    required double weightKg,
    required double neckCircumferenceCm,
    required double waistCircumferenceCm,
    double? hipCircumferenceCm, // Required for females
    required DateTime calculatedAt,
  }) {
    final isMale = gender.toLowerCase() == 'male';
    double bodyFat;

    if (isMale) {
      final waistMinusNeck = (waistCircumferenceCm - neckCircumferenceCm).clamp(5.0, 150.0);
      final logWaistNeck = math.log(waistMinusNeck) / math.ln10;
      final logHeight = math.log(heightCm) / math.ln10;

      final denominator = 1.0324 - (0.19077 * logWaistNeck) + (0.15456 * logHeight);
      bodyFat = (495.0 / denominator) - 450.0;
    } else {
      final hips = hipCircumferenceCm ?? (waistCircumferenceCm * 1.15);
      final waistPlusHipMinusNeck = (waistCircumferenceCm + hips - neckCircumferenceCm).clamp(10.0, 250.0);
      final logSum = math.log(waistPlusHipMinusNeck) / math.ln10;
      final logHeight = math.log(heightCm) / math.ln10;

      final denominator = 1.29579 - (0.35004 * logSum) + (0.22100 * logHeight);
      bodyFat = (495.0 / denominator) - 450.0;
    }

    final double clampedBodyFat = double.parse(bodyFat.clamp(3.0, 50.0).toStringAsFixed(1));
    final double fatMass = double.parse((weightKg * (clampedBodyFat / 100.0)).toStringAsFixed(1));
    final double leanMass = double.parse((weightKg - fatMass).toStringAsFixed(1));

    // Waist-to-Height Ratio (WHtR)
    final double whtr = double.parse((waistCircumferenceCm / heightCm).toStringAsFixed(2));

    WhtrCategory whtrCat;
    if (whtr < 0.40) {
      whtrCat = WhtrCategory.takeCare;
    } else if (whtr <= 0.49) {
      whtrCat = WhtrCategory.healthy;
    } else if (whtr <= 0.59) {
      whtrCat = WhtrCategory.increasedRisk;
    } else {
      whtrCat = WhtrCategory.highRisk;
    }

    // Fat-Free Mass Index (FFMI)
    final double heightM = heightCm / 100.0;
    final double rawFfmi = leanMass / (heightM * heightM);
    // Normalized FFMI (normalized to 1.8m height)
    final double normalizedFfmi = double.parse((rawFfmi + (6.1 * (1.8 - heightM))).toStringAsFixed(1));

    // Categorize Body Fat
    BodyFatCategory cat;
    if (isMale) {
      if (clampedBodyFat <= 5.0) {
        cat = BodyFatCategory.essential;
      } else if (clampedBodyFat <= 13.0) {
        cat = BodyFatCategory.athletic;
      } else if (clampedBodyFat <= 17.0) {
        cat = BodyFatCategory.fitness;
      } else if (clampedBodyFat <= 24.0) {
        cat = BodyFatCategory.acceptable;
      } else {
        cat = BodyFatCategory.elevated;
      }
    } else {
      if (clampedBodyFat <= 13.0) {
        cat = BodyFatCategory.essential;
      } else if (clampedBodyFat <= 20.0) {
        cat = BodyFatCategory.athletic;
      } else if (clampedBodyFat <= 24.0) {
        cat = BodyFatCategory.fitness;
      } else if (clampedBodyFat <= 31.0) {
        cat = BodyFatCategory.acceptable;
      } else {
        cat = BodyFatCategory.elevated;
      }
    }

    String insight;
    String insightHi;

    if (whtrCat == WhtrCategory.healthy) {
      insight = 'Excellent body composition. Waist circumference is under half your height, protecting visceral organs.';
      insightHi = 'उत्कृष्ट शारीरिक संरचना। कमर का घेरा आपकी लंबाई के आधे से कम है, जो आंतरिक अंगों की सुरक्षा करता है।';
    } else if (whtrCat == WhtrCategory.increasedRisk) {
      insight = 'Mild central adiposity detected. Prioritize progressive strength training to elevate lean muscle mass (FFMI).';
      insightHi = 'कमर पर हल्का अतिरिक्त फैट दर्ज। लीन मसल मास बढ़ाने के लिए स्ट्रेंथ ट्रेनिंग को प्राथमिकता दें।';
    } else {
      insight = 'Waist-to-Height ratio is elevated. Incorporate daily Shatapawali post-meal walks and calorie deficit protocols.';
      insightHi = 'कमर का अनुपात अधिक है। भोजन के बाद शतपावली टहलने और कैलोरी नियंत्रण पर ध्यान दें।';
    }

    return BodyCompositionEstimate(
      id: id,
      userId: userId,
      bodyFatPercent: clampedBodyFat,
      category: cat,
      leanMassKg: leanMass,
      fatMassKg: fatMass,
      totalWeightKg: weightKg,
      waistToHeightRatio: whtr,
      whtrCategory: whtrCat,
      ffmi: normalizedFfmi,
      insight: insight,
      insightHindi: insightHi,
      calculatedAt: calculatedAt,
    );
  }
}
