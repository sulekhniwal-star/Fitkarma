import 'nutrition_models.dart';

enum QualityScoreTier {
  goldSattvic(
    label: 'Optimal / Sattvic Gold',
    regionalLabel: 'सर्वोत्तम पोषण / सात्विक गोल्ड',
    colorCode: 0xff22C55E, // Karma Green
    grade: 'A+',
    minScore: 85,
  ),
  nourishing(
    label: 'Balanced / Nourishing',
    regionalLabel: 'संतुलित एवं पौष्टिक',
    colorCode: 0xff3B82F6, // Focus Blue
    grade: 'A',
    minScore: 70,
  ),
  moderate(
    label: 'Moderate / Needs Optimization',
    regionalLabel: 'मध्यम / सुधार योग्य',
    colorCode: 0xffEAB308, // Gold / Warning
    grade: 'B',
    minScore: 50,
  ),
  suboptimal(
    label: 'Sub-optimal / Unbalanced',
    regionalLabel: 'असंतुलित एवं कम गुणवत्ता',
    colorCode: 0xffEF4444, // Crimson
    grade: 'C',
    minScore: 0,
  );

  final String label;
  final String regionalLabel;
  final int colorCode;
  final String grade;
  final int minScore;

  const QualityScoreTier({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
    required this.grade,
    required this.minScore,
  });
}

class QualityDimension {
  final String id;
  final String name;
  final String regionalName;
  final double score; // 0.0 to 100.0
  final double weight; // 0.0 to 1.0 (sums to 1.0)
  final String status;
  final String insight;
  final String actionableOptimization;

  const QualityDimension({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.score,
    required this.weight,
    required this.status,
    required this.insight,
    required this.actionableOptimization,
  });

  double get weightedContribution => score * weight;
}

class MealQualityReport {
  final int compositeScore; // 0 to 100
  final QualityScoreTier tier;
  final List<QualityDimension> dimensions;
  final List<String> topStrengths;
  final List<String> improvementPriorities;
  final String executiveSummary;
  final String ayurvedicSynergyNote;

  const MealQualityReport({
    required this.compositeScore,
    required this.tier,
    required this.dimensions,
    required this.topStrengths,
    required this.improvementPriorities,
    required this.executiveSummary,
    required this.ayurvedicSynergyNote,
  });
}

class MultiDimensionalQualityEngine {
  /// Pure Dart deterministic calculation of the 5-Dimensional Meal Quality Score
  /// Dimensions:
  /// 1. Protein Bioavailability & Completeness (30%)
  /// 2. Glycemic & Insulin Load (25%)
  /// 3. Micronutrient Density (20%)
  /// 4. Satiety & Caloric Density (15%)
  /// 5. Anti-Inflammatory & Processing Index (10%)
  static MealQualityReport evaluateMealQuality({
    required List<LoggedMealEntry> entries,
  }) {
    if (entries.isEmpty) {
      return _buildEmptyMealReport();
    }

    final totalCalories = entries.fold<int>(0, (sum, e) => sum + e.totalCalories);
    final totalProtein = entries.fold<double>(0.0, (sum, e) => sum + e.totalProtein);
    final totalCarbs = entries.fold<double>(0.0, (sum, e) => sum + e.totalCarbs);
    final totalFats = entries.fold<double>(0.0, (sum, e) => sum + e.totalFats);
    final totalFiber = entries.fold<double>(0.0, (sum, e) => sum + e.totalFiber);

    final categories = entries.map((e) => e.food.category.toLowerCase()).toSet();
    final names = entries.map((e) => e.food.name.toLowerCase()).toList();

    // -------------------------------------------------------------
    // Dimension 1: Protein Bioavailability & Completeness (30% weight)
    // -------------------------------------------------------------
    double proteinScore = 40.0;
    String proteinInsight = '';
    String proteinOpt = '';

    final hasCompleteProtein = categories.contains('dairy') ||
        categories.contains('non-veg') ||
        names.any((n) => n.contains('paneer') || n.contains('egg') || n.contains('chicken') || n.contains('soya') || n.contains('tofu') || n.contains('whey') || n.contains('fish') || n.contains('curd') || n.contains('dahi'));

    final hasComplementaryPair = (categories.contains('daal') || names.any((n) => n.contains('daal') || n.contains('dal') || n.contains('rajma') || n.contains('chole') || n.contains('chana'))) &&
        (categories.contains('roti/bread') || names.any((n) => n.contains('roti') || n.contains('rice') || n.contains('chawal') || n.contains('chapati')));

    if (totalProtein >= 30.0) {
      proteinScore = 95.0;
    } else if (totalProtein >= 22.0) {
      proteinScore = 80.0;
    } else if (totalProtein >= 14.0) {
      proteinScore = 65.0;
    } else {
      proteinScore = (totalProtein / 14.0 * 50.0).clamp(20.0, 50.0);
    }

    if (hasCompleteProtein) {
      proteinScore = (proteinScore + 10.0).clamp(0.0, 100.0);
      proteinInsight = 'Complete amino acid profile detected with high DIAAS bioavailability (${totalProtein.toStringAsFixed(1)}g protein).';
      proteinOpt = 'Maintain current quality source (dairy/eggs/meat/soya).';
    } else if (hasComplementaryPair) {
      proteinScore = (proteinScore + 5.0).clamp(0.0, 100.0);
      proteinInsight = 'Complementary plant amino acids paired (Methionine in grain + Lysine in pulses).';
      proteinOpt = 'Add 1 katori curd (dahi) or 1 scoop sattu/whey to elevate leucine threshold.';
    } else {
      proteinScore = (proteinScore - 10.0).clamp(10.0, 100.0);
      proteinInsight = 'Incomplete amino acid spectrum; missing complementary grain-pulse pairing or high DIAAS protein.';
      proteinOpt = 'Pair Dal with Roti/Rice or add Paneer/Eggs to complete the limiting amino acid pool.';
    }

    // -------------------------------------------------------------
    // Dimension 2: Glycemic & Insulin Load (25% weight)
    // -------------------------------------------------------------
    double glycemicScore = 70.0;
    String glycemicInsight = '';
    String glycemicOpt = '';

    final double fiberRatio = totalCarbs > 0 ? (totalFiber / totalCarbs) : 0.2;
    final double rawGl = (60.0 * totalCarbs) / 100.0;

    if (fiberRatio >= 0.20 && totalProtein >= 15.0) {
      glycemicScore = 92.0;
      glycemicInsight = 'Optimal glycemic buffering: Fiber-to-carb ratio (${(fiberRatio * 100).toStringAsFixed(0)}%) and co-ingested protein prevent postprandial glucose surges.';
      glycemicOpt = 'Keep eating salad/fiber first before starch.';
    } else if (fiberRatio >= 0.12) {
      glycemicScore = 75.0;
      glycemicInsight = 'Moderate glycemic load ($rawGl). Sufficient dietary fiber prevents steep glycemic peaks.';
      glycemicOpt = 'Add raw salad (kakdi/kheera/tomatoes) or take a 10-min Shatpawali walk.';
    } else {
      glycemicScore = (40.0 - (rawGl * 0.4)).clamp(15.0, 55.0);
      glycemicInsight = 'High glycemic vulnerability: Low fiber-to-carb ratio (${(fiberRatio * 100).toStringAsFixed(0)}%) with rapid starch conversion.';
      glycemicOpt = 'Replace refined grains with multi-millet rotis or add 1 katori green salad first.';
    }

    // -------------------------------------------------------------
    // Dimension 3: Micronutrient Density (20% weight)
    // -------------------------------------------------------------
    double micronutrientScore = 50.0;
    String microInsight = '';
    String microOpt = '';

    int nutrientRichFoods = 0;
    if (categories.contains('sabzi') || names.any((n) => n.contains('palak') || n.contains('bhindi') || n.contains('gobhi') || n.contains('methi') || n.contains('salad'))) {
      nutrientRichFoods += 2;
    }
    if (categories.contains('daal') || names.any((n) => n.contains('dal') || n.contains('sprouts') || n.contains('chana'))) {
      nutrientRichFoods += 1;
    }
    if (categories.contains('dairy') || names.any((n) => n.contains('curd') || n.contains('dahi') || n.contains('paneer'))) {
      nutrientRichFoods += 1;
    }
    if (names.any((n) => n.contains('egg') || n.contains('chicken') || n.contains('fish'))) {
      nutrientRichFoods += 1;
    }

    if (nutrientRichFoods >= 4) {
      micronutrientScore = 95.0;
      microInsight = 'High micronutrient density with diverse bioavailable Iron, B12, Calcium, and Folate.';
      microOpt = 'Excellent micronutrient coverage; maintain colorful food variety.';
    } else if (nutrientRichFoods >= 2) {
      micronutrientScore = 75.0;
      microInsight = 'Moderate micronutrient yield. Provides baseline minerals with room for antioxidant enhancement.';
      microOpt = 'Squeeze fresh lemon (Vitamin C) over dal to boost non-heme Iron absorption by 300%.';
    } else {
      micronutrientScore = 40.0;
      microInsight = 'Low micronutrient density: Calorie-dense but mineral-sparse profile.';
      microOpt = 'Include dark leafy greens (Palak/Methi/Sarson) or sprouted moong.';
    }

    // -------------------------------------------------------------
    // Dimension 4: Satiety & Caloric Density (15% weight)
    // -------------------------------------------------------------
    double satietyScore = 60.0;
    String satietyInsight = '';
    String satietyOpt = '';

    final double caloricDensityIndex = totalCalories > 0 ? (totalProtein * 2.0 + totalFiber * 3.0) / (totalCalories / 100.0) : 10.0;

    if (caloricDensityIndex >= 14.0) {
      satietyScore = 95.0;
      satietyInsight = 'High satiety volume: Protein-fiber mechanical stretch triggers sustained PYY and GLP-1 fullness hormones.';
      satietyOpt = 'Promotes 4-5 hours of sustained mental clarity without hunger crashes.';
    } else if (caloricDensityIndex >= 8.0) {
      satietyScore = 74.0;
      satietyInsight = 'Balanced satiety index. Provides steady fullness for 3-4 hours.';
      satietyOpt = 'Add 1 glass warm spiced chaas (buttermilk) to increase gastric volume without excess calories.';
    } else {
      satietyScore = 45.0;
      satietyInsight = 'Low satiety index: Rapid gastric emptying expected within 90 minutes due to low protein-fiber matrix.';
      satietyOpt = 'Add fiber-rich vegetable salads or roasted chana to prolong gastric clearance.';
    }

    // -------------------------------------------------------------
    // Dimension 5: Anti-Inflammatory & Processing Index (10% weight)
    // -------------------------------------------------------------
    double inflammatoryScore = 80.0;
    String inflInsight = '';
    String inflOpt = '';

    final isDeepFried = names.any((n) => n.contains('puri') || n.contains('bhature') || n.contains('pakora') || n.contains('samosa') || n.contains('fried'));
    final hasHighSugar = names.any((n) => n.contains('sweet') || n.contains('halwa') || n.contains('gulab') || n.contains('sugar') || n.contains('jalebi'));

    if (isDeepFried) {
      inflammatoryScore -= 35.0;
    }
    if (hasHighSugar) {
      inflammatoryScore -= 20.0;
    }
    if (totalFats > 25.0 && totalProtein < 10.0) {
      inflammatoryScore -= 15.0;
    }

    inflammatoryScore = inflammatoryScore.clamp(20.0, 100.0);

    if (inflammatoryScore >= 80.0) {
      inflInsight = 'Whole-food anti-inflammatory profile with minimal thermal oxidation or saturated lipid degradation.';
      inflOpt = 'Garnish with pinch of haldi (turmeric) and black pepper for curcuminoid bioavailability.';
    } else if (inflammatoryScore >= 50.0) {
      inflInsight = 'Mild inflammatory load detected from cooking fats or moderate refined sugars.';
      inflOpt = 'Cook with cold-pressed mustard/groundnut oil or pure A2 desi ghee instead of refined vegetable oils.';
    } else {
      inflInsight = 'Elevated inflammatory index: High thermal lipid oxidation / fried matrix triggers transient endothelial stiffness.';
      inflOpt = 'Limit deep-fried items; balance with ginger-turmeric tea and green sabzi.';
    }

    // -------------------------------------------------------------
    // Composite Calculation (30%, 25%, 20%, 15%, 10%)
    // -------------------------------------------------------------
    final dimensions = [
      QualityDimension(
        id: 'protein',
        name: 'Protein Bioavailability',
        regionalName: 'प्रोटीन जैवउपलब्धता एवं गुणवत्ता',
        score: double.parse(proteinScore.toStringAsFixed(1)),
        weight: 0.30,
        status: _getStatusForScore(proteinScore),
        insight: proteinInsight,
        actionableOptimization: proteinOpt,
      ),
      QualityDimension(
        id: 'glycemic',
        name: 'Glycemic & Insulin Control',
        regionalName: 'ग्लाइसेमिक एवं इंसुलिन नियंत्रण',
        score: double.parse(glycemicScore.toStringAsFixed(1)),
        weight: 0.25,
        status: _getStatusForScore(glycemicScore),
        insight: glycemicInsight,
        actionableOptimization: glycemicOpt,
      ),
      QualityDimension(
        id: 'micronutrients',
        name: 'Micronutrient Density',
        regionalName: 'सूक्ष्म पोषक तत्व (विटामिन/खनिज)',
        score: double.parse(micronutrientScore.toStringAsFixed(1)),
        weight: 0.20,
        status: _getStatusForScore(micronutrientScore),
        insight: microInsight,
        actionableOptimization: microOpt,
      ),
      QualityDimension(
        id: 'satiety',
        name: 'Satiety & Volume Index',
        regionalName: 'तृप्ति एवं भूख नियंत्रण सूचकांक',
        score: double.parse(satietyScore.toStringAsFixed(1)),
        weight: 0.15,
        status: _getStatusForScore(satietyScore),
        insight: satietyInsight,
        actionableOptimization: satietyOpt,
      ),
      QualityDimension(
        id: 'anti_inflammatory',
        name: 'Anti-Inflammatory Purity',
        regionalName: 'एंटी-इंफ्लेमेटरी एवं शुद्धता स्तर',
        score: double.parse(inflammatoryScore.toStringAsFixed(1)),
        weight: 0.10,
        status: _getStatusForScore(inflammatoryScore),
        insight: inflInsight,
        actionableOptimization: inflOpt,
      ),
    ];

    final double compositeRaw = dimensions.fold<double>(0.0, (sum, d) => sum + d.weightedContribution);
    final int composite = compositeRaw.round().clamp(0, 100);

    final tier = _getTier(composite);

    final strengths = dimensions.where((d) => d.score >= 75.0).map((d) => '${d.name}: ${d.insight}').toList();
    final improvements = dimensions.where((d) => d.score < 75.0).map((d) => '${d.name}: ${d.actionableOptimization}').toList();

    return MealQualityReport(
      compositeScore: composite,
      tier: tier,
      dimensions: dimensions,
      topStrengths: strengths.isEmpty ? ['Baseline calories provided for energy requirements.'] : strengths,
      improvementPriorities: improvements.isEmpty ? ['Meal is optimally balanced across all 5 dimensions.'] : improvements,
      executiveSummary: 'This meal scored $composite/100 (${tier.grade}) on the Multi-Dimensional Indian Quality Index. '
          'Weighted heavily on protein DIAAS completeness (30%) and glycemic buffering (25%).',
      ayurvedicSynergyNote: 'Ayurvedic Shad-Rasa Balance: Combine with digestive cumin/ginger water (Deepana) to optimize nutrient assimilation.',
    );
  }

  static QualityScoreTier _getTier(int score) {
    if (score >= QualityScoreTier.goldSattvic.minScore) {
      return QualityScoreTier.goldSattvic;
    } else if (score >= QualityScoreTier.nourishing.minScore) {
      return QualityScoreTier.nourishing;
    } else if (score >= QualityScoreTier.moderate.minScore) {
      return QualityScoreTier.moderate;
    } else {
      return QualityScoreTier.suboptimal;
    }
  }

  static String _getStatusForScore(double score) {
    if (score >= 85.0) return 'Optimal (उत्कृष्ट)';
    if (score >= 70.0) return 'Good (अच्छा)';
    if (score >= 50.0) return 'Moderate (मध्यम)';
    return 'Low (कम)';
  }

  static MealQualityReport _buildEmptyMealReport() {
    return const MealQualityReport(
      compositeScore: 0,
      tier: QualityScoreTier.suboptimal,
      dimensions: [
        QualityDimension(
          id: 'protein',
          name: 'Protein Bioavailability',
          regionalName: 'प्रोटीन जैवउपलब्धता एवं गुणवत्ता',
          score: 0.0,
          weight: 0.30,
          status: 'No Data',
          insight: 'Log meal items to calculate amino acid completeness.',
          actionableOptimization: 'Add protein rich Indian foods (Paneer, Dal, Eggs).',
        ),
        QualityDimension(
          id: 'glycemic',
          name: 'Glycemic & Insulin Control',
          regionalName: 'ग्लाइसेमिक एवं इंसुलिन नियंत्रण',
          score: 0.0,
          weight: 0.25,
          status: 'No Data',
          insight: 'Fiber-to-carb buffering will be evaluated once food is logged.',
          actionableOptimization: 'Ensure adequate fiber and protein co-ingestion.',
        ),
        QualityDimension(
          id: 'micronutrients',
          name: 'Micronutrient Density',
          regionalName: 'सूक्ष्म पोषक तत्व (विटामिन/खनिज)',
          score: 0.0,
          weight: 0.20,
          status: 'No Data',
          insight: 'Micronutrient abundance is calculated per 100 kcal of logged meal.',
          actionableOptimization: 'Include colorful sabzi and green salads.',
        ),
        QualityDimension(
          id: 'satiety',
          name: 'Satiety & Volume Index',
          regionalName: 'तृप्ति एवं भूख नियंत्रण सूचकांक',
          score: 0.0,
          weight: 0.15,
          status: 'No Data',
          insight: 'Satiety hormone stimulation index based on protein-fiber volume.',
          actionableOptimization: 'Target high-volume, low caloric-density whole foods.',
        ),
        QualityDimension(
          id: 'anti_inflammatory',
          name: 'Anti-Inflammatory Purity',
          regionalName: 'एंटी-इंफ्लेमेटरी एवं शुद्धता स्तर',
          score: 0.0,
          weight: 0.10,
          status: 'No Data',
          insight: 'Evaluates whole food processing vs deep fried palm oil cooking.',
          actionableOptimization: 'Favor traditional Indian unrefined oils & digestive spices.',
        ),
      ],
      topStrengths: ['No meal logged yet.'],
      improvementPriorities: ['Log your meal to view your 5-dimensional Indian quality score.'],
      executiveSummary: 'No food items logged for this meal phase yet.',
      ayurvedicSynergyNote: 'Eat in a calm state with awareness (Sattvic mindset).',
    );
  }
}
