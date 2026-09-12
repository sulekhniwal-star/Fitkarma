import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum BMICategory {
  underweight,
  normal,
  overweight,
  obeseClass1,
  obeseClass2,
}

class BMIResult {
  final double bmi;
  final BMICategory category;
  final String label;
  final String labelHindi;
  final Color badgeColor;
  final double idealWeightMinKg;
  final double idealWeightMaxKg;
  final String healthRiskInsight;

  const BMIResult({
    required this.bmi,
    required this.category,
    required this.label,
    required this.labelHindi,
    required this.badgeColor,
    required this.idealWeightMinKg,
    required this.idealWeightMaxKg,
    required this.healthRiskInsight,
  });
}

/// BMICalculator — Asian-Indian Specific WHO Guidelines
/// Adjusts thresholds for the Asian-Indian "Thin-Fat" phenotype (higher visceral adiposity at lower BMI).
class BMICalculator {
  const BMICalculator();

  BMIResult calculate({
    required double heightCm,
    required double weightKg,
  }) {
    final heightM = heightCm / 100.0;
    final bmi = weightKg / (heightM * heightM);

    // Asian-Indian ideal BMI range: 18.5 to 22.9
    final idealMin = 18.5 * (heightM * heightM);
    final idealMax = 22.9 * (heightM * heightM);

    BMICategory category;
    String label;
    String labelHindi;
    Color color;
    String riskInsight;

    if (bmi < 18.5) {
      category = BMICategory.underweight;
      label = 'Underweight';
      labelHindi = 'कम वज़न';
      color = AppColors.primaryCyan;
      riskInsight = 'Focus on nutrient-dense calorie surplus and strength building.';
    } else if (bmi <= 22.9) {
      category = BMICategory.normal;
      label = 'Optimal (Asian-Indian Standard)';
      labelHindi = 'आदर्श वज़न (भारतीय मानक)';
      color = AppColors.primaryEmerald;
      riskInsight = 'Metabolically healthy range. Maintain balanced nutrition.';
    } else if (bmi <= 24.9) {
      category = BMICategory.overweight;
      label = 'Overweight';
      labelHindi = 'अधिक वज़न';
      color = AppColors.accentAmber;
      riskInsight = 'Elevated visceral fat risk for Indian phenotype. Moderate deficit advised.';
    } else if (bmi <= 29.9) {
      category = BMICategory.obeseClass1;
      label = 'Obese (Class I)';
      labelHindi = 'मोटापा (श्रेणी १)';
      color = AppColors.accentCoral;
      riskInsight = 'High metabolic strain. Prioritize blood glucose and resistance training.';
    } else {
      category = BMICategory.obeseClass2;
      label = 'Obese (Class II)';
      labelHindi = 'मोटापा (श्रेणी २)';
      color = AppColors.accentCoral;
      riskInsight = 'Critical cardiovascular and insulin resistance risk.';
    }

    return BMIResult(
      bmi: double.parse(bmi.toStringAsFixed(1)),
      category: category,
      label: label,
      labelHindi: labelHindi,
      badgeColor: color,
      idealWeightMinKg: double.parse(idealMin.toStringAsFixed(1)),
      idealWeightMaxKg: double.parse(idealMax.toStringAsFixed(1)),
      healthRiskInsight: riskInsight,
    );
  }
}
